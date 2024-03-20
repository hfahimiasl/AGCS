#include "Mission.h"


Mission::Mission(MAVLink *mavlink) :
	AbstractHandler(mavlink),
	download_timer(new QTimer(this)),
	upload_timer(new QTimer(this))
{
	QObject::connect(MissionService::instance(), &MissionService::notifyClear,
	this, [ = ]() {
		if (downloadInProgress()) {
			toast.warn(QObject::tr("در حال بارگیری ماموریت"), 5000);
			return;
		}

		if (uploadInProgress()) {
			toast.warn(QObject::tr("در حال بارگذاری ماموریت"), 5000);
			return;
		}

		MissionService::instance()->clear();
	});

	QObject::connect(MissionService::instance(), &MissionService::notifyDownload,
			 this, &Mission::download);

	QObject::connect(download_timer, &QTimer::timeout,
			 this, QOverload<>::of(&Mission::downloadTimeout));

	QObject::connect(MissionService::instance(), &MissionService::notifyUpload,
			 this, &Mission::upload);

	QObject::connect(upload_timer, &QTimer::timeout,
			 this, QOverload<>::of(&Mission::uploadTimeout));

	QObject::connect(Link::instance(), &Link::connectionChanged,
	this, [ = ](const bool & connected) {
		if (!connected) {
			if (downloadInProgress()) {
				download_timer->stop();
				downloadResult(false);
			}

			if (uploadInProgress()) {
				upload_timer->stop();
				uploadResult(false);
			}
		}
	});

	variable.add("MISSION_CURRENT_ITEM");
	variable.add("MISSION_ITEM_REACHED");
}

Mission::~Mission()
{
	delete download_timer;
	delete upload_timer;
}

void Mission::handle(const mavlink_message_t &message)
{
	switch (message.msgid) {
	case MAVLINK_MSG_ID_MISSION_COUNT:
		handleCount(message);
		break;

	case MAVLINK_MSG_ID_MISSION_ITEM_INT:
		handleItem(message);
		break;

	case MAVLINK_MSG_ID_MISSION_REQUEST:
		handleRequest(message);
		break;

	case MAVLINK_MSG_ID_MISSION_ACK:
		handleACK(message);
		break;

	case MAVLINK_MSG_ID_MISSION_CURRENT:
		handleCurrent(message);
		break;

	case MAVLINK_MSG_ID_MISSION_ITEM_REACHED:
		handleItemReached(message);
		break;

	default:
		break;
	}
}

void Mission::download()
{
	if (uploadInProgress()) {
		toast.warn(QObject::tr("در حال بارگذاری ماموریت"), 5000);
		return;
	}

	if (downloadInProgress()) {
		toast.warn(QObject::tr("در حال بارگیری ماموریت"), 5000);

	} else {
		requestList();
	}
}

bool Mission::downloadInProgress() const
{
	return download_operation != MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_DOWNLOAD;
}

void Mission::requestList()
{
	mavlink_message_t message {};

	mavlink_msg_mission_request_list_pack(mavlink->getGCSSysID(),
					      mavlink->getGCSCompID(),
					      &message,
					      mavlink->getAircraftSysID(),
					      mavlink->getAircraftCompID(),
					      MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION);

	mavlink->write(message);

	download_operation = MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_LIST;

	download_timer->start(Mission::kDownloadTimeout);
}

void Mission::handleCount(const mavlink_message_t &message)
{
	if (download_operation != MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_LIST) {
		return;
	}

	download_timer->stop();

	mavlink_msg_mission_count_decode(&message, &mission_count);

	if (mission_count.count) {
		MissionService::instance()->clear();
		requestItem(0);

	} else {
		download_retries = 0;
		download_operation = MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_DOWNLOAD;
		toast.warn(QObject::tr("ماموریتی جهت بارگیری وجود ندارد"), 5000);
	}

	emit MissionService::instance()->notifyDownloadSize(quint16(mission_count.count));
}

void Mission::requestItem(const quint16 &seq)
{
	if (seq != last_seq) {
		last_seq = seq;
		download_retries = 0;
	}

	mavlink_message_t message {};

	mavlink_msg_mission_request_int_pack(mavlink->getGCSSysID(),
					     mavlink->getGCSCompID(),
					     &message,
					     mavlink->getAircraftSysID(),
					     mavlink->getAircraftCompID(),
					     seq,
					     MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION);

	mavlink->write(message);

	download_operation = MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_ITEM;

	download_timer->start(Mission::kDownloadTimeout);
}

void Mission::handleItem(const mavlink_message_t &message)
{
	if (download_operation != MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_ITEM) {
		return;
	}

	download_timer->stop();

	mavlink_mission_item_int_t mission_item_int {};
	mavlink_msg_mission_item_int_decode(&message, &mission_item_int);

	MissionItem item;

	item.setSequence(mission_item_int.seq);
	item.setCoordinate(QGeoCoordinate(decodeLatLon(mission_item_int.x), decodeLatLon(mission_item_int.y), double(mission_item_int.z)));
	item.setCommand(mission_item_int.command);
	item.setFrame(mission_item_int.frame);
	item.setCurrent(mission_item_int.current);
	item.setAutoContinue(mission_item_int.autocontinue);
	item.setType(mission_item_int.mission_type);
	item.setParam1(double(mission_item_int.param1));
	item.setParam2(double(mission_item_int.param2));
	item.setParam3(double(mission_item_int.param3));
	item.setParam4(double(mission_item_int.param4));
	item.setVisible(false);

	MissionService::instance()->insert(&item);

	emit MissionService::instance()->notifyProgress((mission_item_int.seq + 1) / double(mission_count.count));

	if (MissionService::instance()->size() == mission_count.count) {
		mavlink_message_t message {};

		mavlink_msg_mission_ack_pack(mavlink->getGCSSysID(),
					     mavlink->getGCSCompID(),
					     &message,
					     mavlink->getAircraftSysID(),
					     mavlink->getAircraftCompID(),
					     MAV_MISSION_RESULT::MAV_MISSION_ACCEPTED,
					     MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION);

		mavlink->write(message);

		downloadResult(true);

	} else {
		requestItem(mission_item_int.seq + 1);
	}
}

void Mission::downloadTimeout()
{
	download_timer->stop();

	switch (download_operation) {
	case MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_LIST:
		if (download_retries < 5) {
			download_retries ++;
			requestList();

		} else {
			downloadResult(false);
		}

		break;

	case MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_ITEM:
		if (download_retries < 5) {
			download_retries ++;
			requestItem(last_seq);

		} else {
			downloadResult(false);
		}

		break;

	default:
		break;
	}
}

void Mission::downloadResult(const bool &status)
{
	last_seq = -1;
	download_retries = 0;
	download_operation = MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_DOWNLOAD;

	if (status) {
		emit MissionService::instance()->notifyDownloadComplete();
		toast.info(QObject::tr("ماموریت بارگیری شد"), 5000);

	} else {
		emit MissionService::instance()->notifyProgress(0);
		emit MissionService::instance()->notifyDownloadFailed();
		toast.error(QObject::tr("خطا در بارگیری ماموریت"), 5000);
	}
}

void Mission::upload()
{
	if (downloadInProgress()) {
		toast.warn(QObject::tr("در حال بارگیری ماموریت"), 5000);
		return;
	}

	if (uploadInProgress()) {
		toast.warn(QObject::tr("در حال بارگذاری ماموریت"), 5000);
		return;
	}

	const quint16 size = quint16(MissionService::instance()->size());

	emit MissionService::instance()->notifyUploadSize(size);

	if (!size) {
		toast.warn(QObject::tr("ماموریتی جهت بارگذاری وجود ندارد"), 5000);
		return;
	}

	sendCount();
}

bool Mission::uploadInProgress() const
{
	return upload_operation != MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_REQUEST_UPLOAD;
}

void Mission::sendCount()
{
	mavlink_message_t message {};

	mavlink_msg_mission_count_pack(mavlink->getGCSSysID(),
				       mavlink->getGCSCompID(),
				       &message,
				       mavlink->getAircraftSysID(),
				       mavlink->getAircraftCompID(),
				       uint16_t(MissionService::instance()->size()),
				       MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION);

	mavlink->write(message);

	upload_operation = MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_SEND_COUNT;

	upload_timer->start(Mission::kUploadTimeout);
}

void Mission::handleRequest(const mavlink_message_t &message)
{
	if (upload_operation != MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_SEND_COUNT
	    && upload_operation != MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_PEND_REQUEST) {
		return;
	}

	upload_timer->stop();

	upload_operation = MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_SEND_ITEM;

	mavlink_mission_request_t mission_request {};
	mavlink_msg_mission_request_decode(&message, &mission_request);
	sendItem(mission_request.seq);
}

void Mission::sendItem(const quint16 &seq)
{
	if (upload_operation != MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_SEND_ITEM) {
		return;
	}

	if (!MissionService::instance()->isExist(seq)) {
		qCritical() << "internal error." << seq << "not found!";
		uploadResult(false);
		return;
	}

	mavlink_message_t message {};

	const MissionItem *item = MissionService::instance()->get(seq);

	mavlink_msg_mission_item_int_pack(mavlink->getGCSSysID(),
					  mavlink->getGCSCompID(),
					  &message,
					  mavlink->getAircraftSysID(),
					  mavlink->getAircraftCompID(),
					  item->getSequence(),
					  item->getFrame(),
					  item->getCommand(),
					  item->getCurrent(),
					  item->getAutoContinue(),
					  float(item->getParam1()),
					  float(item->getParam2()),
					  float(item->getParam3()),
					  float(item->getParam4()),
					  int32_t(item->getCoordinate().latitude() * 1.0e7),
					  int32_t(item->getCoordinate().longitude() * 1.0e7),
					  float(item->getCoordinate().altitude()),
					  MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION);

	mavlink->write(message);

	upload_operation = MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_PEND_REQUEST;

	upload_timer->start(Mission::kUploadTimeout);

	emit MissionService::instance()->notifyProgress(double(seq) / MissionService::instance()->size());
}

void Mission::handleACK(const mavlink_message_t &message)
{
	mavlink_mission_ack_t mission_ack {};
	mavlink_msg_mission_ack_decode(&message, &mission_ack);

	const bool accepted = MAV_MISSION_RESULT(mission_ack.type) == MAV_MISSION_RESULT::MAV_MISSION_ACCEPTED;

	if (!accepted) {
		toast.error(resultToString(MAV_MISSION_RESULT(mission_ack.type)), 5000);
	}

	if (uploadInProgress()) {
		upload_timer->stop();
		uploadResult(accepted);
	}
}

void Mission::uploadTimeout()
{
	upload_timer->stop();

	switch (upload_operation) {
	case MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_SEND_COUNT:
		if (upload_retries < 5) {
			upload_retries ++;
			sendCount();

		} else {
			uploadResult(false);
		}

		break;

	case MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_PEND_REQUEST:
		uploadResult(false);
		break;

	default:
		break;
	}
}

void Mission::uploadResult(const bool &status)
{
	upload_retries = 0;
	upload_operation = MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_REQUEST_UPLOAD;

	if (status) {
		setCurrentWaypoint(0);
		emit MissionService::instance()->notifyProgress(1);
		emit MissionService::instance()->notifyUploadComplete();
		toast.info(QObject::tr("ماموریت بارگذاری شد"), 5000);

	} else {
		emit MissionService::instance()->notifyProgress(0);
		emit MissionService::instance()->notifyUploadFailed();
		toast.error(QObject::tr("خطا در بارگذاری ماموریت"), 5000);
	}
}

QString Mission::resultToString(const MAV_MISSION_RESULT &result)
{
	QString string;

	switch (result) {
	case MAV_MISSION_RESULT::MAV_MISSION_ACCEPTED:
		// To keep away from errors
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_ERROR:
		string = QObject::tr("خطای عمومی");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_UNSUPPORTED_FRAME:
		string = QObject::tr("عدم پشتیبانی مختصات");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_UNSUPPORTED:
		string = QObject::tr("عدم پشتیبانی فرمان");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_NO_SPACE:
		string = QObject::tr("عدم وجود فضای کافی");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر ها");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM1:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 1");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM2:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 2");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM3:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 3");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM4:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 4");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM5_X:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 5");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM6_Y:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 6");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_PARAM7:
		string = QObject::tr("خطا در اعتبارسنجی پارامتر 7");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_INVALID_SEQUENCE:
		string = QObject::tr("خطا در توالی");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_DENIED:
		string = QObject::tr("عدم پذیرش فرامین");
		break;

	case MAV_MISSION_RESULT::MAV_MISSION_OPERATION_CANCELLED:
		string = QObject::tr("لغو عملیات");
		break;

	default:
		string = QObject::tr("خطای ناشناخته");
		break;
	}

	return string;
}

void Mission::handleCurrent(const mavlink_message_t &message)
{
	mavlink_mission_current_t mission_current {};
	mavlink_msg_mission_current_decode(&message, &mission_current);
	variable.setValue("MISSION_CURRENT_ITEM", mission_current.seq, true);
}

void Mission::handleItemReached(const mavlink_message_t &message)
{
	mavlink_mission_item_reached_t mission_item_reached {};
	mavlink_msg_mission_item_reached_decode(&message, &mission_item_reached);
	variable.setValue("MISSION_ITEM_REACHED", mission_item_reached.seq, true);

	if (mission_item_reached.seq == mission_count.count - 1) {
		emit MissionService::instance()->notifyMissionComplete();
		toast.info(QObject::tr("ماموریت انجام شد"), 5000);
	}
}

void Mission::setCurrentWaypoint(const quint16 &seq)
{
	mavlink_message_t message {};

	mavlink_msg_mission_set_current_pack(mavlink->getGCSSysID(),
					     mavlink->getGCSCompID(),
					     &message,
					     mavlink->getAircraftSysID(),
					     mavlink->getAircraftCompID(),
					     seq);

	mavlink->write(message);
}
