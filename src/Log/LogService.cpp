#include "LogService.h"


LogService::LogService()
	: model(new LogModel(this))
	, timer(new QTimer(this))
{
	qmlRegisterUncreatableType<LogItem>("LogItem", 1, 0, "LogItem", "Reference only");
	qmlRegisterUncreatableType<LogAckCode>("LogAckCode", 1, 0, "LogAckCode", "Reference only");

	QObject::connect(timer, &QTimer::timeout, this, [ = ]() {
		if (logEntryInProgress()) {
			findMissingLogEntry();

		} else if (logDataInProgress()) {
			findMissingLogData();
		}
	});

	QObject::connect(MAVLink::instance(), &MAVLink::notifyRead, this, [ = ](const mavlink_message_t &message) {
		switch (message.msgid) {
		case MAVLINK_MSG_ID_LOG_ENTRY: {
				mavlink_log_entry_t log_entry {};
				mavlink_msg_log_entry_decode(&message, &log_entry);
				logEntry(log_entry);
				break;
			}

		case MAVLINK_MSG_ID_LOG_DATA: {
				mavlink_log_data_t log_data {};
				mavlink_msg_log_data_decode(&message, &log_data);
				logData(log_data);
				break;
			}
		}
	});

	QObject::connect(Link::instance(), &Link::connectionChanged, this, [ = ](const bool & connected) {
		if (connected) {
			cancel();
			model->clear();

		} else {
			timer->stop();

			for (LogItem *i : model->objects()) {
				if (i && (!i->getReceived() || i->getSelected())) {
					i->setAck(LogAckCode::Enum::Error);
					i->setSelected(false);
				}
			}

			if (meta_data) {
				meta_data->item->setAck(LogAckCode::Enum::Error);

				if (meta_data->file.exists()) {
					meta_data->file.remove();
				}

				delete meta_data;
				meta_data = nullptr;
			}

			setLogDataStatus(false);
		}
	});
}

LogService::~LogService()
{
	delete meta_data;
	delete model;
	delete timer;
}

LogService *LogService::instance()
{
	static LogService self;
	return &self;
}

LogModel *LogService::getModel()
{
	return model;
}

bool LogService::logEntryInProgress() const
{
	return request_log_entry;
}

bool LogService::logDataInProgress() const
{
	return request_log_data;
}

void LogService::refresh()
{
	model->clear();
	requestLogList(0, 49);
}

void LogService::download()
{
	QString user_path;

#ifdef Q_OS_WIN
	user_path = QFileDialog::getExistingDirectory(nullptr,
			QObject::tr("ذخیره لاگ پرواز"),
			QStandardPaths::writableLocation(QStandardPaths::DesktopLocation));

	if (user_path.isEmpty()) {
		return;
	}

#else
	user_path = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
#endif

	receiveAllLogEntry();

	delete meta_data;
	meta_data = nullptr;

	download_path = user_path;

	if (!download_path.endsWith(QDir::separator())) {
		download_path += QDir::separator();
	}

	for (LogItem *i : model->objects()) {
		if (i && i->getSelected()) {
			i->setAck(LogAckCode::Enum::Waiting);
		}
	}

	setLogDataStatus(true);
	receiveAllLogData();
}

void LogService::erase()
{
	mavlink_message_t message {};
	MAVLink *mavlink = MAVLink::instance();
	mavlink_msg_log_erase_pack(mavlink->getGCSSysID(),
				   mavlink->getGCSCompID(),
				   &message,
				   mavlink->getAircraftSysID(),
				   mavlink->getAircraftCompID());
	mavlink->write(message);
	refresh();
}

void LogService::cancel()
{
	receiveAllLogEntry();

	for (LogItem *i : model->objects()) {
		if (i) {
			i->setProgress(0);
			i->setRate("0/s");
		}
	}

	if (meta_data) {
		meta_data->item->setAck(LogAckCode::Enum::Cancel);

		if (meta_data->file.exists()) {
			meta_data->file.remove();
		}

		delete meta_data;
		meta_data = nullptr;
	}

	resetSelected(true);
	setLogDataStatus(false);
}

void LogService::logEntry(mavlink_log_entry_t log_entry)
{
	if (!request_log_entry) {
		return;
	}

	if (!model->size() && log_entry.num_logs) {
		if (true) {//_vehicle->firmwareType() == MAV_AUTOPILOT_ARDUPILOTMEGA) {
			ardupilot_one_based = 1;
		}

		for (quint16 i = 0 ; i < log_entry.num_logs ; ++i) {
			LogItem *entry = new LogItem(model);
			entry->setID(i);
			model->append(entry);
		}
	}

	if (log_entry.num_logs) {
		if (log_entry.size || false) {//_vehicle->firmwareType() != MAV_AUTOPILOT_ARDUPILOTMEGA) {
			log_entry.id -= ardupilot_one_based;

			if (log_entry.id < model->size()) {
				LogItem *entry = model->get(log_entry.id);
				entry->setSize(log_entry.size);
				entry->setSizeString(Global::sizeToString(log_entry.size));
				entry->setTime(QDateTime::fromTime_t(log_entry.time_utc));
				entry->setReceived(true);
				entry->setAck(LogAckCode::Enum::Available);

			} else {
				// qWarning() << "received out of bound index:" << log_entry.id;
			}
		}

	} else {
		receiveAllLogEntry();
	}

	retry = 0;

	if (isLogEntryComplete()) {
		receiveAllLogEntry();

	} else {
		timer->start(LogService::kTimeout);
	}
}

void LogService::logData(mavlink_log_data_t log_data)
{
	if (!meta_data) {
		return;
	}

	log_data.id -= ardupilot_one_based;

	if (log_data.id != meta_data->item->getID()) {
		// qWarning() << "received wrong log";
		return;
	}

	if ((log_data.ofs % MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN) != 0) {
		// qWarning() << "ignored misaligned incoming packet @" << log_data.ofs;
		return;
	}

	bool result = false;

	if (log_data.ofs <= meta_data->item->getSize()) {
		const uint32_t chunk = log_data.ofs / LogMetaData::kChunkSize;

		if (chunk != meta_data->current_chunk) {
			// qWarning() << "ignored packet for out of order chunk actual:expected" << chunk << meta_data->current_chunk;
			return;
		}

		const uint32_t bin = (log_data.ofs - (chunk * LogMetaData::kChunkSize)) / MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN;

		if (bin >= uint32_t(meta_data->chunk_table.size())) {
			// qWarning() << "out of range bin received";

		} else {
			meta_data->chunk_table.setBit(int(bin));
		}

		if (meta_data->file.pos() != log_data.ofs) {
			if (!meta_data->file.seek(log_data.ofs)) {
				// qCritical() << "error while seeking log file offset";
				return;
			}
		}

		if (meta_data->file.write(reinterpret_cast<const char *>(log_data.data), log_data.count)) {
			meta_data->written += log_data.count;
			meta_data->rate_bytes += log_data.count;
			meta_data->item->setProgress(double(meta_data->written) / meta_data->item->getSize());
			updateLogDataRate();
			result = true;
			retry = 0;
			timer->start(LogService::kTimeout);

			if (isLogDataComplete()) {
				meta_data->item->setAck(LogAckCode::Enum::Download);
				receiveAllLogData();

			} else if (isChunkComplete()) {
				meta_data->advanceChunk();
				requestLogData(meta_data->item->getID(), meta_data->current_chunk * LogMetaData::kChunkSize,
					       uint32_t(meta_data->chunk_table.size() * MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN));

			} else if (bin < uint32_t(meta_data->chunk_table.size() - 1) && meta_data->chunk_table.at(int(bin + 1))) {
				findMissingLogData();
			}

		} else {
			// qWarning() << "error while writing log file chunk";
		}

	} else {
		// qWarning() << "received log offset greater than expected";
	}

	if (!result) {
		meta_data->item->setAck(LogAckCode::Enum::Error);
	}
}

bool LogService::isLogEntryComplete()
{
	for (const LogItem *i : model->objects()) {
		if (i && !i->getReceived()) {
			return false;
		}
	}

	return true;
}

bool LogService::isChunkComplete() const
{
	return meta_data->isChunkEquals(true);
}

bool LogService::isLogDataComplete() const
{
	return isChunkComplete() && (meta_data->current_chunk + 1) == quint32(meta_data->getChunkSize());
}

void LogService::findMissingLogEntry()
{
	const int size = model->size();

	int start = -1;
	int end = -1;

	for (int i = 0 ; i < size ; ++i) {
		LogItem *item = model->get(i);

		if (item) {
			if (!item->getReceived()) {
				if (start < 0) {
					start = i;

				} else {
					end = i;
				}

			} else if (start >= 0) {
				break;
			}
		}
	}

	if (start >= 0) {
		if (retry++ > 2) {
			for (LogItem *i : model->objects()) {
				if (i && !i->getReceived()) {
					i->setAck(LogAckCode::Enum::Error);
				}
			}

			receiveAllLogEntry();

			// qCritical() << "too many errors retreiving log list. abort.";
			return;
		}

		if (end < 0) {
			end = start;
		}

		start += ardupilot_one_based;
		end += ardupilot_one_based;

		requestLogList(uint16_t(start), uint16_t(end));

	} else {
		receiveAllLogEntry();
	}
}

void LogService::receiveAllLogEntry()
{
	timer->stop();
	setLogEntryStatus(false);
}

void LogService::findMissingLogData()
{
	if (isLogDataComplete()) {
		receiveAllLogData();
		return;

	} else if (isChunkComplete()) {
		meta_data->advanceChunk();
	}

	++retry;

#if 1
	// Trying the change to infinite log download. This way if retries hit 100% failure the data rate will
	// slowly fall to 0 and the user can Cancel. This should work better on really crappy links.

	if (retry > LogService::kMaxRetry) {
		// qCritical() << "too many errors retreiving log list. abort.";

		retry = 0;
		meta_data->item->setAck(LogAckCode::Enum::Error);
		receiveAllLogData();
		return;
	}

#endif

	meta_data->item->setProgress(double(meta_data->written) / meta_data->item->getSize());

	updateLogDataRate();

	uint16_t start = 0;
	uint16_t end = 0;

	const int size = meta_data->chunk_table.size();

	for (/* empty */ ; start < size ; ++start) {
		if (!meta_data->chunk_table.testBit(start)) {
			break;
		}
	}

	for (end = start ; end < size ; ++end) {
		if (meta_data->chunk_table.testBit(end)) {
			break;
		}
	}

	const uint32_t pos = meta_data->current_chunk * LogMetaData::kChunkSize + start * MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN;
	const uint32_t len = (end - start) * MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN;

	requestLogData(meta_data->item->getID(), pos, len, retry);
}

void LogService::receiveAllLogData()
{
	timer->stop();

	if (prepareLogFile()) {
		requestLogData(meta_data->item->getID(), 0, uint32_t(meta_data->chunk_table.size() * MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN));
		timer->start(LogService::kTimeout);

	} else {
		resetSelected(false);
		setLogDataStatus(false);
	}
}

void LogService::updateLogDataRate()
{
	if (meta_data->elapsed.elapsed() >= LogService::kGUIRate) {
		const double rate = meta_data->rate_bytes / (meta_data->elapsed.elapsed() / 1000.0);
		meta_data->rate_avg = (meta_data->rate_avg * 0.95) + (rate * 0.05);
		meta_data->rate_bytes = 0;
		meta_data->item->setRate(QString("%1/s").arg(Global::sizeToString(quint64(meta_data->rate_avg))));
		meta_data->elapsed.start();
	}
}

void LogService::resetSelected(const bool &cancel)
{
	for (LogItem *i : model->objects()) {
		if (i && i->getSelected()) {
			if (cancel) {
				i->setAck(LogAckCode::Enum::Cancel);
			}

			i->setSelected(false);
		}
	}

	emit selectedChanged();
}

void LogService::requestLogList(const uint16_t &start, const uint16_t &end)
{
	// qDebug() << "request log entry list (" << start << "through" << end << ")";

	setLogEntryStatus(true);

	mavlink_message_t message {};
	MAVLink *mavlink = MAVLink::instance();
	mavlink_msg_log_request_list_pack(mavlink->getGCSSysID(),
					  mavlink->getGCSCompID(),
					  &message,
					  mavlink->getAircraftSysID(),
					  mavlink->getAircraftCompID(),
					  start,
					  end);
	mavlink->write(message);

	timer->start(LogService::kTimeout);
}

void LogService::requestLogData(const uint16_t &id, const uint32_t &ofs, const uint32_t &count, const uint8_t &retry)
{
	// qDebug() << "request log data id:" << id + ardupilot_one_based << "ofs:" << ofs << "size:" << count << "retry" << retry;

	Q_UNUSED(retry)

	meta_data->item->setAck(LogAckCode::Enum::InProgress);

	mavlink_message_t message {};
	MAVLink *mavlink = MAVLink::instance();
	mavlink_msg_log_request_data_pack(mavlink->getGCSSysID(),
					  mavlink->getGCSCompID(),
					  &message,
					  mavlink->getAircraftSysID(),
					  mavlink->getAircraftCompID(),
					  uint16_t(id + ardupilot_one_based), ofs, count);
	mavlink->write(message);
}

bool LogService::prepareLogFile()
{
	delete meta_data;
	meta_data = nullptr;

	LogItem *item = getNextSelected();

	if (!item) {
		return false;
	}

	item->setSelected(false);
	emit selectedChanged();

	QString time;

	// TODO
	//    if(item->getTime().date().year() < 2010) {
	//        time = tr("UnknownDate");

	//    } else {
	time = item->getTime().toString(QStringLiteral("yyyy-M-d_hh-mm-ss"));
	//    }

	meta_data = new LogMetaData(item);
	meta_data->file_name = QString("agcs_flight_log_") + QString::number(item->getID() + 1) + "_" + time;

	//    if (_vehicle->firmwareType() == MAV_AUTOPILOT_PX4) {
	//        QString loggerParam = QStringLiteral("SYS_LOGGER");
	//        if (_vehicle->parameterManager()->parameterExists(FactSystem::defaultComponentId, loggerParam) &&
	//                _vehicle->parameterManager()->getParameter(FactSystem::defaultComponentId, loggerParam)->rawValue().toInt() == 0) {
	//            meta_data->filename += ".px4log";
	//        } else {
	//            meta_data->filename += ".ulg";
	//        }
	//    } else {
	meta_data->file_name += ".bin";
	//    }

	meta_data->file.setFileName(download_path + meta_data->file_name);

	if (meta_data->file.exists()) {
		uint num_dups = 0;

		const QStringList file_name = meta_data->file_name.split('.');

		do {
			++num_dups;
			meta_data->file.setFileName(file_name.at(0) + '_' + QString::number(num_dups) + '.' + file_name.at(1));
		} while (meta_data->file.exists());
	}

	bool result = false;

	if (!meta_data->file.open(QIODevice::WriteOnly)) {
		// qCritical() << "failed to create log file:" <<  meta_data->file_name;

	} else {
		if (!meta_data->file.resize(item->getSize())) {
			// qCritical() << "failed to allocate space for log file:" <<  meta_data->file_name;

		} else {
			meta_data->current_chunk = 0;
			meta_data->chunk_table = QBitArray(meta_data->getChunkBins(), false);
			meta_data->elapsed.start();
			result = true;
		}
	}

	if (!result) {
		if (meta_data->file.exists()) {
			meta_data->file.remove();
		}

		meta_data->item->setAck(LogAckCode::Enum::Error);
		delete meta_data;
		meta_data = nullptr;
	}

	return result;
}

void LogService::setLogEntryStatus(const bool &status)
{
	if (request_log_entry != status) {
		request_log_entry = status;
		emit requestLogEntryChanged();
	}
}

void LogService::setLogDataStatus(const bool &status)
{
	if (request_log_data != status) {
		request_log_data = status;
		emit requestLogDataChanged();
	}
}

LogItem *LogService::getNextSelected()
{
	for (LogItem *i : model->objects()) {
		if (i) {
			if (i->getSelected()) {
				return i;
			}
		}
	}

	return nullptr;
}
