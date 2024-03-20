#include "ArdupilotNavigationHelper.h"


ArdupilotNavigationHelper::ArdupilotNavigationHelper() :
	arm_disarm_opn(ARM_DISARM_OPERATION::ARM_DISARM_FAILED),
	takeoff_opn(TAKEOFF_OPERATION::PENDING_REQUEST),
	mission_opn(MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST)
{
	for (const QString &key : low_voltage_action.keys()) {
		low_voltage_action_param_base.insert(low_voltage_action.value(key), key);
	}

	for (const QString &key : critical_voltage_action.keys()) {
		critical_voltage_action_param_base.insert(critical_voltage_action.value(key), key);
	}

	for (const QString &key : fence_type.keys()) {
		fence_type_param_base.insert(fence_type.value(key), key);
	}

	for (const QString &key : fence_action.keys()) {
		fence_action_param_base.insert(fence_action.value(key), key);
	}

	for (const QString &key : remote_control_option.keys()) {
		remote_control_option_param_base.insert(remote_control_option.value(key), key);
	}

	for (const QString &key : telem_protocol.keys()) {
		telem_protocol_param_base.insert(telem_protocol.value(key), key);
	}

	for (const QString &key : telem_baudrate.keys()) {
		telem_baudrate_param_base.insert(telem_baudrate.value(key), key);
	}

	for (const QString &key : board_safety.keys()) {
		board_safety_param_base.insert(board_safety.value(key), key);
	}
}

ArdupilotNavigationHelper *ArdupilotNavigationHelper::instance()
{
	static ArdupilotNavigationHelper self;
	return &self;
}

void ArdupilotNavigationHelper::ArmDisarm(bool status, bool force)
{
	arm_disarm_opn = status ? ARM_DISARM_OPERATION::REQUEST_ARMING : ARM_DISARM_OPERATION::ARM_DISARM_FAILED;
	MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_COMPONENT_ARM_DISARM, 0, status, force ? 21196 : 0, 0, 0, 0, 0,
					      0);
}

void ArdupilotNavigationHelper::readCommandAck(const mavlink_command_ack_t &command_ack)
{
	if (command_ack.result == MAV_RESULT::MAV_RESULT_ACCEPTED) {
		if (command_ack.command == MAV_CMD::MAV_CMD_COMPONENT_ARM_DISARM) {
			toast.info(QString("دستگاه %1 شد").arg(arm_disarm_opn == ARM_DISARM_OPERATION::REQUEST_ARMING ? ("فعال")
					: ("غیرفعال")), 5000);
			arm_disarm_opn = ARM_DISARM_OPERATION::ARM_DISARM_ACCEPTED;

			if (takeoff_opn == TAKEOFF_OPERATION::REQUEST_TAKEOFF) {
				takeoff_opn = TAKEOFF_OPERATION::TAKEOFF_ACCEPTED;
				takeoff();
			}
		}

	} else {
		if (command_ack.command == MAV_CMD::MAV_CMD_COMPONENT_ARM_DISARM) {
			toast.error(QString("دستگاه %1 نشد").arg(arm_disarm_opn == ARM_DISARM_OPERATION::REQUEST_ARMING ? ("فعال")
					: ("غیرفعال")), 5000);
			arm_disarm_opn = ARM_DISARM_OPERATION::ARM_DISARM_FAILED;

			if (takeoff_opn == TAKEOFF_OPERATION::REQUEST_TAKEOFF) {
				takeoff_opn = TAKEOFF_OPERATION::TAKEOFF_FAILED;
				takeoff();
			}
		}
	}
}

void ArdupilotNavigationHelper::takeoff()
{
	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		if (takeoff_opn == TAKEOFF_OPERATION::PENDING_REQUEST) {
			if (!int(variable.getValue("ARM_STATUS"))) {
				ArdupilotModeHelper::instance()->set("GUIDED");
				takeoff_opn = TAKEOFF_OPERATION::REQUEST_TAKEOFF;
				ArmDisarm(true, false);

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED;
				mission("START");
			}

		} else if (takeoff_opn == TAKEOFF_OPERATION::TAKEOFF_ACCEPTED) {
			ArdupilotModeHelper::instance()->set("TAKEOFF");
			takeoff_opn = TAKEOFF_OPERATION::PENDING_REQUEST;
			toast.info(tr("در حال برخاستن"), 5000);

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED;
				mission("START");
			}

		} else if (takeoff_opn == TAKEOFF_OPERATION::TAKEOFF_FAILED) {
			takeoff_opn = TAKEOFF_OPERATION::PENDING_REQUEST;
			toast.error(tr("خطا در برخاستن"), 5000);

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_FAILED;
				mission("START");
			}
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		if (takeoff_opn == TAKEOFF_OPERATION::PENDING_REQUEST) {
			if (!int(variable.getValue("ARM_STATUS"))) {
				ArdupilotModeHelper::instance()->set("GUIDED");
				takeoff_opn = TAKEOFF_OPERATION::REQUEST_TAKEOFF;
				ArmDisarm(true, false);

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED;
				mission("START");
			}

		} else if (takeoff_opn == TAKEOFF_OPERATION::TAKEOFF_ACCEPTED) {
			MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_NAV_TAKEOFF, 0, 0, 0, 0, 0, 0, 0, 1.5);
			takeoff_opn = TAKEOFF_OPERATION::PENDING_REQUEST;
			toast.info(tr("در حال برخاستن"), 5000);

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED;
				mission("START");
			}

		} else if (takeoff_opn == TAKEOFF_OPERATION::TAKEOFF_FAILED) {
			takeoff_opn = TAKEOFF_OPERATION::PENDING_REQUEST;
			toast.error(tr("خطا در برخاستن"), 5000);

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_REQUEST_START) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_START_FAILED;
				mission("START");
			}
		}

		break;

	default:
		takeoff_opn = TAKEOFF_OPERATION::PENDING_REQUEST;
		break;
	}
}

void ArdupilotNavigationHelper::mission(QString command)
{
	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		if (command == "START") {
			if (MissionService::instance()->size() < 2) {
				toast.error(tr("ابتدا ماموریت خود را تعریف کنید"), 5000);
				return;
			}

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_REQUEST_START;
				takeoff();

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED) {
				ArdupilotModeHelper::instance()->set("AUTO");
				emit MissionService::instance()->notifyMissionStart();
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST;
				toast.info(tr("در حال اجرای ماموریت"), 5000);

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_START_FAILED) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST;
				toast.error(tr("خطا در اجرای ماموریت"), 5000);
			}

		} else if (command == "PAUSE") {
			ArdupilotModeHelper::instance()->set("LOITER");

		} else if (command == "RESUME") {
			ArdupilotModeHelper::instance()->set("AUTO");

		} else if (command == "END") {
			ArdupilotModeHelper::instance()->set("RTL");
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		if (command == "START") {
			if (MissionService::instance()->size() < 2) {
				toast.error(tr("ابتدا ماموریت خود را تعریف کنید"), 5000);
				return;
			}

			if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_REQUEST_START;
				takeoff();

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_START_ACCEPTED) {
				ArdupilotModeHelper::instance()->set("AUTO");
				emit MissionService::instance()->notifyMissionStart();
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST;
				toast.info(tr("در حال اجرای ماموریت"), 5000);

			} else if (mission_opn == MISSION_OPERATION::MISSION_OPERATION_START_FAILED) {
				mission_opn = MISSION_OPERATION::MISSION_OPERATION_PENDING_REQUEST;
				toast.error(tr("خطا در اجرای ماموریت"), 5000);
			}

		} else if (command == "PAUSE") {
			ArdupilotModeHelper::instance()->set("BRAKE");

		} else if (command == "RESUME") {
			ArdupilotModeHelper::instance()->set("AUTO");

		} else if (command == "END") {
			ArdupilotModeHelper::instance()->set("BRAKE");
		}

		break;

	default:
		break;
	}
}

void ArdupilotNavigationHelper::setCurrentWaypoint(uint16_t seq)
{
	mavlink_message_t message;
	mavlink_msg_mission_set_current_pack(MAVLink::instance()->getGCSSysID(),
					     MAVLink::instance()->getGCSCompID(),
					     &message,
					     MAVLink::instance()->getAircraftSysID(),
					     MAVLink::instance()->getAircraftCompID(),
					     seq);
	MAVLink::instance()->write(message);
}

double ArdupilotNavigationHelper::getLowVoltageThreshold()
{
	const QVariant param = ParamService::instance()->get("BATT_LOW_VOLT")->getValue();
	return param == QVariant::Invalid ? -1 : param.toDouble();
}

void ArdupilotNavigationHelper::setLowVoltageThreshold(double threshold)
{
	emit ParamService::instance()->notifyUpload("BATT_LOW_VOLT", threshold);
}

bool ArdupilotNavigationHelper::isLowVoltageActionEnable()
{
	const QVariant param = ParamService::instance()->get("BATT_FS_LOW_ACT")->getValue();
	return param != QVariant::Invalid && param.toInt() != 0;
}

QString ArdupilotNavigationHelper::getLowVoltageAction()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("BATT_FS_LOW_ACT")->getValue();

	if (param != QVariant::Invalid && low_voltage_action_param_base.contains(uint8_t(param.toUInt()))) {
		ret = low_voltage_action_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllLowVoltageActions()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : low_voltage_action.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotNavigationHelper::setLowVoltageAction(QString action)
{
	if (low_voltage_action.contains(action)) {
		emit ParamService::instance()->notifyUpload("BATT_FS_LOW_ACT", low_voltage_action.value(action));
	}
}

double ArdupilotNavigationHelper::getCriticalVoltageThreshold()
{
	const QVariant param = ParamService::instance()->get("BATT_CRT_VOLT")->getValue();
	return param == QVariant::Invalid ? -1 : param.toDouble();
}

void ArdupilotNavigationHelper::setCriticalVoltageThreshold(double threshold)
{
	emit ParamService::instance()->notifyUpload("BATT_CRT_VOLT", threshold);
}

bool ArdupilotNavigationHelper::isCriticalVoltageActionEnable()
{
	const QVariant param = ParamService::instance()->get("BATT_FS_CRT_ACT")->getValue();
	return param != QVariant::Invalid && param.toInt() != 0;
}

QString ArdupilotNavigationHelper::getCriticalVoltageAction()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("BATT_FS_CRT_ACT")->getValue();

	if (param != QVariant::Invalid && critical_voltage_action_param_base.contains(uint8_t(param.toUInt()))) {
		ret = critical_voltage_action_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllCriticalVoltageActions()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : critical_voltage_action.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotNavigationHelper::setCriticalVoltageAction(QString action)
{
	if (critical_voltage_action.contains(action)) {
		emit ParamService::instance()->notifyUpload("BATT_FS_CRT_ACT", critical_voltage_action.value(action));
	}
}

bool ArdupilotNavigationHelper::isFenceEnabled()
{
	const QVariant param = ParamService::instance()->get("FENCE_ENABLE")->getValue();
	return param != QVariant::Invalid && param.toInt() != 0;
}

void ArdupilotNavigationHelper::enableFence(bool enable)
{
	emit ParamService::instance()->notifyUpload("FENCE_ENABLE", enable);
}

QString ArdupilotNavigationHelper::getFenceType()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("FENCE_TYPE")->getValue();

	if (param != QVariant::Invalid && fence_type_param_base.contains(uint8_t(param.toUInt()))) {
		ret = fence_type_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllFenceTypes()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : fence_type.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotNavigationHelper::setFenceType(QString type)
{
	if (fence_type.contains(type)) {
		emit ParamService::instance()->notifyUpload("FENCE_TYPE", fence_type.value(type));
	}
}

QString ArdupilotNavigationHelper::getFenceAction()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("FENCE_ACTION")->getValue();

	if (param != QVariant::Invalid && fence_action_param_base.contains(uint8_t(param.toUInt()))) {
		ret = fence_action_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllFenceActions()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : fence_action.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotNavigationHelper::setFenceAction(QString action)
{
	if (fence_action.contains(action)) {
		emit ParamService::instance()->notifyUpload("FENCE_ACTION", fence_action.value(action));
	}
}

qint16 ArdupilotNavigationHelper::getFenceAltitudeMax()
{
	const QVariant param = ParamService::instance()->get("FENCE_ALT_MAX")->getValue();
	return param == QVariant::Invalid ? -1 : qint16(param.toInt());
}

void ArdupilotNavigationHelper::setFenceAltitudeMax(qint16 altitude_max)
{
	emit ParamService::instance()->notifyUpload("FENCE_ALT_MAX", altitude_max < 10 ? 10 : (altitude_max > 1000 ? 1000 : altitude_max));
}

qint16 ArdupilotNavigationHelper::getFenceRadiusMax()
{
	const QVariant param = ParamService::instance()->get("FENCE_RADIUS")->getValue();
	return param == QVariant::Invalid ? -1 : qint16(param.toInt());
}

void ArdupilotNavigationHelper::setFenceRadiusMax(qint16 radius)
{
	emit ParamService::instance()->notifyUpload("FENCE_RADIUS", radius < 30 ? 30 : (radius > 10000 ? 10000 : radius));
}

QString ArdupilotNavigationHelper::getRemoteControlOption(uint8_t channel)
{
	QString ret = "N/A";

	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("RC%1_OPTION").arg(channel))->getValue();

		if (param != QVariant::Invalid && remote_control_option_param_base.contains(uint16_t(param.toUInt()))) {
			ret = remote_control_option_param_base.value(uint16_t(param.toUInt()));
		}
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllRemoteControlOptions()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : remote_control_option.keys()) {
		list.append(key);
	}

	return list;
}

bool ArdupilotNavigationHelper::setRemoteControlOption(uint8_t channel, QString option)
{
	bool ret = false;

	if (channel != 0 && channel <= 16) {
		if (remote_control_option.contains(option)) {
			emit ParamService::instance()->notifyUpload(QString("RC%1_OPTION").arg(channel), remote_control_option.value(option));
			ret = true;
		}
	}

	return ret;
}

QString ArdupilotNavigationHelper::getTelemProtocol(uint8_t number)
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get(QString("SERIAL%1_PROTOCOL").arg(number))->getValue();

	if (param != QVariant::Invalid && telem_protocol_param_base.contains(int8_t(param.toInt()))) {
		ret = telem_protocol_param_base.value(int8_t(param.toInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllTelemProtocols()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : telem_protocol.keys()) {
		list.append(key);
	}

	return list;
}

bool ArdupilotNavigationHelper::setTelemProtocol(uint8_t number, QString protocol)
{
	bool ret = false;

	if (ParamService::instance()->isExist(QString("SERIAL%1_PROTOCOL").arg(number)) && telem_protocol.contains(protocol)) {
		emit ParamService::instance()->notifyUpload(QString("SERIAL%1_PROTOCOL").arg(number), telem_protocol.value(protocol));
		ret = true;
	}

	return ret;
}

QString ArdupilotNavigationHelper::getTelemBaudRate(uint8_t number)
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get(QString("SERIAL%1_BAUD").arg(number))->getValue();

	if (param != QVariant::Invalid && telem_baudrate_param_base.contains(uint8_t(param.toUInt()))) {
		ret = telem_baudrate_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllTelemBaudRates()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : telem_baudrate.keys()) {
		list.append(key);
	}

	std::sort(list.begin(), list.end(), ArdupilotNavigationHelper::comparison);

	return list;
}

bool ArdupilotNavigationHelper::setTelemBaudRate(uint8_t number, QString baudrate)
{
	bool ret = false;

	if (ParamService::instance()->isExist(QString("SERIAL%1_BAUD").arg(number)) && telem_baudrate.contains(baudrate)) {
		emit ParamService::instance()->notifyUpload(QString("SERIAL%1_BAUD").arg(number), telem_baudrate.value(baudrate));
		ret = true;
	}

	return ret;
}

QString ArdupilotNavigationHelper::getBoardSafety()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("BRD_SAFETYENABLE")->getValue();

	if (param != QVariant::Invalid && board_safety_param_base.contains(uint8_t(param.toUInt()))) {
		ret = board_safety_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotNavigationHelper::getAllBoardSafeties()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : board_safety.keys()) {
		list.append(key);
	}

	return list;
}

bool ArdupilotNavigationHelper::setBoardSafety(QString status)
{
	bool ret = false;

	if (ParamService::instance()->isExist("BRD_SAFETYENABLE") && board_safety.contains(status)) {
		emit ParamService::instance()->notifyUpload("BRD_SAFETYENABLE", board_safety.value(status));
		ret = true;
	}

	return ret;
}
