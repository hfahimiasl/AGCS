#include "Param.h"


Param::Param(MAVLink *mavlink) :
	AbstractHandler(mavlink),
	timer(new QTimer(this)),
	crypto(new CryptoGraphy(0xa85e8e92130d839d))
{
	QObject::connect(timer, &QTimer::timeout,
			 this, QOverload<>::of(&Param::timeout));

	QObject::connect(Link::instance(), &Link::connectionChanged,
	this, [ = ](const bool & connected) {
		if (connected) {
			QTimer::singleShot(kInitTimeout, this, &Param::init);

		} else {
			deinit();
		}
	});
}

Param::~Param()
{
	delete timer;
	delete crypto;
}

void Param::handle(const mavlink_message_t &message)
{
	if (message.msgid == MAVLINK_MSG_ID_COMMAND_ACK) {
		mavlink_command_ack_t command_ack {};
		mavlink_msg_command_ack_decode(&message, &command_ack);

		if (restore_request && command_ack.command == MAV_CMD::MAV_CMD_PREFLIGHT_STORAGE) {
			if (command_ack.result == MAV_RESULT::MAV_RESULT_ACCEPTED) {
				Autopilot::instance()->reboot();
				toast.info(tr("بازنشانی پارامتر ها انجام شد"), 5000);

			} else {
				toast.error(tr("خطا در بازنشانی پارامتر ها"), 5000);
			}

			restore_request = false;
		}

		return;
	}

	if (message.msgid != MAVLINK_MSG_ID_PARAM_VALUE) {
		return;
	}

	mavlink_param_value_t param_value {};
	mavlink_msg_param_value_decode(&message, &param_value);

	const QString id = QByteArray(param_value.param_id, MAVLINK_MSG_PARAM_VALUE_FIELD_PARAM_ID_LEN).trimmed();

	ParamService::instance()->insert(id, param_value.param_index, param_value.param_type, static_cast<double>(param_value.param_value));

	if (download_complete) {
		return;
	}

	emit ParamService::instance()->notifyProgress(ParamService::instance()->count() / double(param_value.param_count));

	if (missing_list.contains(param_value.param_index)) {
		missing_list.removeAt(missing_list.indexOf(param_value.param_index));
	}

	if (ParamService::instance()->count() == param_value.param_count) {
		timer->stop();
		missing_list.clear();
		download_complete = true;
		toast.info(tr("بارگیری پارامتر ها انجام شد"), 5000);
		emit ParamService::instance()->notifyDownloadComplete();

	} else {
		if (id != "_HASH_CHECK" && param_value.param_index != 65535 && param_value.param_index > last_insert_index) {
			for (uint16_t i = uint16_t(last_insert_index) + 1 ; i < param_value.param_index ; i++) {
				if (missing_list.indexOf(i) == -1) {
					missing_list.append(i);
				}
			}

			missing_list.append(param_value.param_index + 1);
			last_insert_index = param_value.param_index;
		}

		timer->start(kMissingTimeout);
	}
}

void Param::init()
{
	QObject::connect(ParamService::instance(), &ParamService::notifyDownload,
			 this, &Param::download);

	QObject::connect(ParamService::instance(), &ParamService::notifyUpload,
			 this, &Param::paramSet);

	QObject::connect(ParamService::instance(), &ParamService::notifyRestoreDefault,
			 this, &Param::restoreDefault);

	QObject::connect(ParamService::instance(), &ParamService::notifySaveToFile,
			 this, &Param::saveToFile);

	QObject::connect(ParamService::instance(), &ParamService::notifyLoadFromFile,
			 this, &Param::loadFromFile);

	download();
}

void Param::deinit()
{
	timer->stop();
	missing_list.clear();
	ParamService::instance()->clear();
	restore_request = false;

	QObject::disconnect(ParamService::instance(), &ParamService::notifyDownload,
			    this, &Param::download);

	QObject::disconnect(ParamService::instance(), &ParamService::notifyUpload,
			    this, &Param::paramSet);

	QObject::disconnect(ParamService::instance(), &ParamService::notifyRestoreDefault,
			    this, &Param::restoreDefault);

	QObject::disconnect(ParamService::instance(), &ParamService::notifySaveToFile,
			    this, &Param::saveToFile);

	QObject::disconnect(ParamService::instance(), &ParamService::notifyLoadFromFile,
			    this, &Param::loadFromFile);
}

void Param::download()
{
	ParamService::instance()->clear();
	download_complete = false;
	last_insert_index = -1;
	requestList();
	missing_list.clear();
	missing_list.append(0);
	timer->start(kMissingTimeout);
}

void Param::requestList()
{
	mavlink_message_t message {};
	mavlink_msg_param_request_list_pack(mavlink->getGCSSysID(),
					    mavlink->getGCSCompID(),
					    &message,
					    mavlink->getAircraftSysID(),
					    mavlink->getAircraftCompID());
	mavlink->write(message);
}

void Param::requestRead(const uint16_t &index)
{
	mavlink_message_t message {};
	mavlink_msg_param_request_read_pack(mavlink->getGCSSysID(),
					    mavlink->getGCSCompID(),
					    &message,
					    mavlink->getAircraftSysID(),
					    mavlink->getAircraftCompID(),
					    "",
					    static_cast<int16_t>(index));
	mavlink->write(message);
}

void Param::paramSet(const QString &id, const double &value)
{
	mavlink_message_t message {};
	mavlink_msg_param_set_pack(mavlink->getGCSSysID(),
				   mavlink->getGCSCompID(),
				   &message,
				   mavlink->getAircraftSysID(),
				   mavlink->getAircraftCompID(),
				   id.toUtf8(),
				   float(value),
				   ParamService::instance()->get(id)->getType());
	mavlink->write(message);
}

void Param::restoreDefault()
{
	if (static_cast<bool>(variable.getValue("ARM_STATUS"))) {
		toast.error(tr("دستگاه را غیرفعال کنید"), 5000);

	} else {
		mavlink->writeCommandLong(MAV_CMD::MAV_CMD_PREFLIGHT_STORAGE, 0, 2, 0, 0, 0, 0, 0, 0);
		restore_request = true;
	}
}

void Param::saveToFile()
{
	if (!download_complete) {
		toast.warn(QObject::tr("پارامتر ها را بارگیری کنید"), 5000);
		return;
	}

	QUrl user_path = QFileDialog::getSaveFileName(nullptr,
			 QObject::tr("ذخیره پارامتر ها"),
			 QStandardPaths::writableLocation(QStandardPaths::DesktopLocation),
			 QString("Parameter Files (*%1)").arg(kFileExtension));

	if (user_path.isEmpty() || !user_path.isValid()) {
		return;
	}

	QString absolute_path = user_path.toString();

	if (absolute_path.split("/").last().indexOf(kFileExtension) == -1) {
		absolute_path += kFileExtension;
	}

	if (QFile::exists(absolute_path)) {
		QFile::remove(absolute_path);
	}

	QFile param_file(absolute_path);

	if (!param_file.open(QIODevice::WriteOnly)) {
		toast.error(QObject::tr("خطا در ایجاد فایل"), 5000);
		return;
	}

	QTextStream param_stream(&param_file);

	const QString firmware_info = QString("%1,%2,%3,%4")
				      .arg(variable.getText("AIRCRAFT_TYPE"))
				      .arg(variable.getText("AUTOPILOT_VERSION_NUMBER"))
				      .arg(variable.getText("AUTOPILOT_VERSION_TYPE"))
				      .arg(variable.getText("AUTOPILOT_VERSION_GIT_HASH"));

	param_stream << QString::fromLatin1(crypto->encrypt(firmware_info).toByteArray().toHex()) << "\r\n";

	for (int i = 0 ; i < ParamService::instance()->count() ; i++) {
		const ParamItem *param = ParamService::instance()->get(i);

		if (!param) {
			qCritical() << "param" << i << "fact not found";
			continue;
		}

		QString fact = QString("%1,").arg(param->getID());

		const QVariant param_value = param->getValue();

		if (param_value != QVariant::Invalid && !qIsNaN(param_value.toDouble())) {
			fact.append(QString("%1").arg(param_value.toDouble(), 0, 'f', 12));

		} else {
			fact.append("NaN");
		}

		param_stream << QString::fromLatin1(crypto->encrypt(fact).toByteArray().toHex()) << "\r\n";
	}

	param_stream.flush();
	param_file.close();

	toast.info(QObject::tr("ذخیره سازی پارامتر ها انجام شد"), 5000);
}

void Param::loadFromFile()
{
	if (!download_complete) {
		toast.warn(QObject::tr("پارامتر ها را بارگیری کنید"), 5000);
		return;
	}

	const QUrl user_path = QFileDialog::getOpenFileName(nullptr,
			       QObject::tr("بارگیری پارامتر ها"),
			       QStandardPaths::writableLocation(QStandardPaths::DesktopLocation),
			       QString("Parameter Files (*%1)").arg(kFileExtension));

	if (user_path.isEmpty() || !user_path.isValid()) {
		return;
	}

	QFile param_file(user_path.toString());

	if (!param_file.open(QIODevice::ReadOnly)) {
		toast.error(QObject::tr("خطا در بارگیری فایل"), 5000);
		return;
	}

	QStringList fact {};

	QTextStream param_stream(&param_file);

	while (!param_stream.atEnd()) {
		const QVariant decrypt = crypto->decrypt(QByteArray::fromHex(param_stream.readLine().trimmed().toLatin1()));

		if (decrypt == QVariant::Invalid) {
			toast.error(QObject::tr("خطا در بارگیری فایل"), 5000);
			return;
		}

		fact.append(decrypt.toString());
	}

	if (fact.isEmpty()) {
		toast.error(QObject::tr("خطا در بارگیری فایل"), 5000);
		return;
	}

	if (fact.first().split(',').first() != variable.getText("AIRCRAFT_TYPE")) {
		toast.error(QObject::tr("عدم تطابق فایل با نوع دستگاه"), 5000);
		return;
	}

	fact.removeFirst();

	bool update = false;

	for (const QString &i : fact) {
		const QStringList param_fact = i.split(',');
		const QString id = param_fact.at(0);
		bool ok = false;
		const double value = param_fact.at(1).toDouble(&ok);

		if (ParamService::instance()->isExist(id)) {
			const ParamItem *param = ParamService::instance()->get(id);

			if (id != "STAT_RUNTIME" && ok && !qFuzzyCompare(value, QString("%1").arg(param->getValue().toDouble(), 0, 'f', 12).toDouble())) {
				paramSet(id, value);
				update = true;
			}
		}
	}

	if (update) {
		toast.info(QObject::tr("بروزرسانی پارامتر ها انجام شد"), 5000);

	} else {
		toast.warn(QObject::tr("موردی برای بروزرسانی وجود ندارد"), 5000);
	}
}

void Param::timeout()
{
	for (const uint16_t &i : missing_list) {
		requestRead(i);
	}
}
