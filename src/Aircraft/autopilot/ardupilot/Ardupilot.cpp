#include "Ardupilot.h"


Ardupilot::Ardupilot() {}

Ardupilot *Ardupilot::instance()
{
	static Ardupilot self;
	return &self;
}

void Ardupilot::init()
{
	mavlink_message_t message {};

	mavlink_msg_autopilot_version_request_pack(MAVLink::instance()->getGCSSysID(),
			MAVLink::instance()->getGCSCompID(),
			&message,
			MAVLink::instance()->getAircraftSysID(),
			MAVLink::instance()->getAircraftCompID());

	MAVLink::instance()->write(message);
}

void Ardupilot::read(const mavlink_message_t &message)
{
	if (message.msgid == MAVLINK_MSG_ID_COMMAND_ACK) {
		mavlink_command_ack_t command_ack;
		mavlink_msg_command_ack_decode(&message, &command_ack);

		switch (command_ack.command) {
		case MAV_CMD::MAV_CMD_PREFLIGHT_CALIBRATION:
		case MAV_CMD::MAV_CMD_DO_START_MAG_CAL:
		case MAV_CMD::MAV_CMD_DO_CANCEL_MAG_CAL:
		case MAV_CMD::MAV_CMD_PREFLIGHT_STORAGE:
			ArdupilotCalibrationHelper::instance()->readCommandAck(command_ack);
			break;

		case MAV_CMD::MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN:
			Link::instance()->disconnectAll();
			toast.info(tr("دستگاه مجددا راه اندازی شد"), 5000);
			break;

		case MAV_CMD::MAV_CMD_COMPONENT_ARM_DISARM:
		case MAV_CMD::MAV_CMD_NAV_TAKEOFF:
			ArdupilotNavigationHelper::instance()->readCommandAck(command_ack);
			break;

		default:
			break;
		}

	} else if (message.msgid == MAVLINK_MSG_ID_COMMAND_LONG) {
		mavlink_command_long_t command_long;
		mavlink_msg_command_long_decode(&message, &command_long);

		switch (command_long.command) {
		case MAV_CMD::MAV_CMD_ACCELCAL_VEHICLE_POS:
			ArdupilotCalibrationHelper::instance()->readCommandLong(command_long);
			break;

		default:
			break;
		}

	} else if (message.msgid == MAVLINK_MSG_ID_MAG_CAL_PROGRESS) {
		mavlink_mag_cal_progress_t mag_cal_progress;
		mavlink_msg_mag_cal_progress_decode(&message, &mag_cal_progress);
		ArdupilotCalibrationHelper::instance()->compassCalibrationProgress(mag_cal_progress);

	} else if (message.msgid == MAVLINK_MSG_ID_MAG_CAL_REPORT) {
		mavlink_mag_cal_report_t mag_cal_report;
		mavlink_msg_mag_cal_report_decode(&message, &mag_cal_report);
		ArdupilotCalibrationHelper::instance()->compassCalibrationReport(mag_cal_report);

	} else if (message.msgid == MAVLINK_MSG_ID_RC_CHANNELS) {
		mavlink_msg_rc_channels_decode(&message, &rc_channels);
		ArdupilotCalibrationHelper::instance()->remoteControllerCalibrationProgress(rc_channels);
	}
}

QList<QString> Ardupilot::getAllFlightModes()
{
	return ArdupilotModeHelper::instance()->getAll();
}

QString Ardupilot::getFlightMode(uint8_t index)
{
	return ArdupilotModeHelper::instance()->get(index);
}

bool Ardupilot::setFlightMode(uint8_t index, QString mode)
{
	return ArdupilotModeHelper::instance()->set(index, mode);
}

QList<QString> Ardupilot::getAvailableFlightModeChannels()
{
	return ArdupilotModeHelper::instance()->getAvailableChannels();
}

int8_t Ardupilot::getFlightModeChannel()
{
	return ArdupilotModeHelper::instance()->getChannel();
}

bool Ardupilot::setFlightModeChannel(uint8_t channel)
{
	return ArdupilotModeHelper::instance()->setChannel(channel);
}

QString Ardupilot::getFlightMode()
{
	return ArdupilotModeHelper::instance()->get();
}

bool Ardupilot::setFlightMode(QString mode)
{
	return ArdupilotModeHelper::instance()->set(mode);
}

QString Ardupilot::getFrameClass()
{
	return ArdupilotFrameHelper::instance()->getClass();
}

QString Ardupilot::getFrameType()
{
	return ArdupilotFrameHelper::instance()->getType();
}

bool Ardupilot::setFrame(QString class_name, QString type_name)
{
	return ArdupilotFrameHelper::instance()->set(class_name, type_name);
}

void Ardupilot::requestLevelCalibration()
{
	ArdupilotCalibrationHelper::instance()->request(CALIBRATION_TYPE::CALIBRATION_TYPE_LEVEL);
}

void Ardupilot::requestAccelCalibration()
{
	ArdupilotCalibrationHelper::instance()->request(CALIBRATION_TYPE::CALIBRATION_TYPE_ACCEL);
}

void Ardupilot::requestNextAccelCalibrationSide()
{
	ArdupilotCalibrationHelper::instance()->requestNextAccelCalibrationSide();
}

void Ardupilot::requestCompassCalibration()
{
	ArdupilotCalibrationHelper::instance()->request(CALIBRATION_TYPE::CALIBRATION_TYPE_COMPASS);
}

void Ardupilot::requestCancelCompassCalibration()
{
	ArdupilotCalibrationHelper::instance()->request(CALIBRATION_TYPE::CALIBRATION_TYPE_CANCEL_COMPASS);
}

void Ardupilot::requestRemoteControllerCalibration()
{
	ArdupilotCalibrationHelper::instance()->request(CALIBRATION_TYPE::CALIBRATION_TYPE_REMOTE_CONTROLLER);
}

void Ardupilot::writeRemoteControllerTrims()
{
	ArdupilotCalibrationHelper::instance()->writeRemoteControllerTrims(rc_channels);
}

void Ardupilot::resetCalibrationProgress()
{
	ArdupilotCalibrationHelper::instance()->resetProgress();
}

void Ardupilot::handleConnectionFailure()
{
	ArdupilotCalibrationHelper::instance()->handleFailure();
}

void Ardupilot::navArmDisarm(bool status, bool force)
{
	ArdupilotNavigationHelper::instance()->ArmDisarm(status, force);
}

void Ardupilot::takeoff()
{
	ArdupilotNavigationHelper::instance()->takeoff();
}

void Ardupilot::mission(QString command)
{
	ArdupilotNavigationHelper::instance()->mission(command);
}

void Ardupilot::setCurrentWaypoint(uint16_t seq)
{
	ArdupilotNavigationHelper::instance()->setCurrentWaypoint(seq);
}

void Ardupilot::reboot()
{
	MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN, 0, 1, 0, 0, 0, 0, 0, 0);
}

double Ardupilot::getLowVoltageThreshold()
{
	return ArdupilotNavigationHelper::instance()->getLowVoltageThreshold();
}

void Ardupilot::setLowVoltageThreshold(double threshold)
{
	ArdupilotNavigationHelper::instance()->setLowVoltageThreshold(threshold);
}

bool Ardupilot::isLowVoltageActionEnable()
{
	return ArdupilotNavigationHelper::instance()->isLowVoltageActionEnable();
}

QString Ardupilot::getLowVoltageAction()
{
	return ArdupilotNavigationHelper::instance()->getLowVoltageAction();
}

QList<QString> Ardupilot::getAllLowVoltageActions()
{
	return ArdupilotNavigationHelper::instance()->getAllLowVoltageActions();
}

void Ardupilot::setLowVoltageAction(QString action)
{
	ArdupilotNavigationHelper::instance()->setLowVoltageAction(action);
}

double Ardupilot::getCriticalVoltageThreshold()
{
	return ArdupilotNavigationHelper::instance()->getCriticalVoltageThreshold();
}

void Ardupilot::setCriticalVoltageThreshold(double threshold)
{
	ArdupilotNavigationHelper::instance()->setCriticalVoltageThreshold(threshold);
}

bool Ardupilot::isCriticalVoltageActionEnable()
{
	return ArdupilotNavigationHelper::instance()->isCriticalVoltageActionEnable();
}

QString Ardupilot::getCriticalVoltageAction()
{
	return ArdupilotNavigationHelper::instance()->getCriticalVoltageAction();
}

QList<QString> Ardupilot::getAllCriticalVoltageActions()
{
	return ArdupilotNavigationHelper::instance()->getAllCriticalVoltageActions();
}

void Ardupilot::setCriticalVoltageAction(QString action)
{
	ArdupilotNavigationHelper::instance()->setCriticalVoltageAction(action);
}

bool Ardupilot::isFenceEnabled()
{
	return ArdupilotNavigationHelper::instance()->isFenceEnabled();
}

void Ardupilot::enableFence(bool enable)
{
	ArdupilotNavigationHelper::instance()->enableFence(enable);
}

QString Ardupilot::getFenceType()
{
	return ArdupilotNavigationHelper::instance()->getFenceType();
}

QList<QString> Ardupilot::getAllFenceTypes()
{
	return ArdupilotNavigationHelper::instance()->getAllFenceTypes();
}

void Ardupilot::setFenceType(QString type)
{
	ArdupilotNavigationHelper::instance()->setFenceType(type);
}

QString Ardupilot::getFenceAction()
{
	return ArdupilotNavigationHelper::instance()->getFenceAction();
}

QList<QString> Ardupilot::getAllFenceActions()
{
	return ArdupilotNavigationHelper::instance()->getAllFenceActions();
}

void Ardupilot::setFenceAction(QString action)
{
	ArdupilotNavigationHelper::instance()->setFenceAction(action);
}

qint16 Ardupilot::getFenceAltitudeMax()
{
	return ArdupilotNavigationHelper::instance()->getFenceAltitudeMax();
}

void Ardupilot::setFenceAltitudeMax(qint16 alt)
{
	ArdupilotNavigationHelper::instance()->setFenceAltitudeMax(alt);
}

qint16 Ardupilot::getFenceRadiusMax()
{
	return ArdupilotNavigationHelper::instance()->getFenceRadiusMax();
}

void Ardupilot::setFenceRadiusMax(qint16 radius)
{
	ArdupilotNavigationHelper::instance()->setFenceRadiusMax(radius);
}

QString Ardupilot::getRemoteControlOption(uint8_t channel)
{
	return ArdupilotNavigationHelper::instance()->getRemoteControlOption(channel);
}

QList<QString> Ardupilot::getAllRemoteControlOptions()
{
	return ArdupilotNavigationHelper::instance()->getAllRemoteControlOptions();
}

bool Ardupilot::setRemoteControlOption(uint8_t channel, QString option)
{
	return ArdupilotNavigationHelper::instance()->setRemoteControlOption(channel, option);
}

QString Ardupilot::getTelemProtocol(uint8_t number)
{
	return ArdupilotNavigationHelper::instance()->getTelemProtocol(number);
}

QList<QString> Ardupilot::getAllTelemProtocols()
{
	return ArdupilotNavigationHelper::instance()->getAllTelemProtocols();
}

bool Ardupilot::setTelemProtocol(uint8_t number, QString protocol)
{
	return ArdupilotNavigationHelper::instance()->setTelemProtocol(number, protocol);
}

QString Ardupilot::getTelemBaudRate(uint8_t number)
{
	return ArdupilotNavigationHelper::instance()->getTelemBaudRate(number);
}

QList<QString> Ardupilot::getAllTelemBaudRates()
{
	return ArdupilotNavigationHelper::instance()->getAllTelemBaudRates();
}

bool Ardupilot::setTelemBaudRate(uint8_t number, QString protocol)
{
	return ArdupilotNavigationHelper::instance()->setTelemBaudRate(number, protocol);
}

QString Ardupilot::getBoardSafety()
{
	return ArdupilotNavigationHelper::instance()->getBoardSafety();
}

QList<QString> Ardupilot::getAllBoardSafeties()
{
	return ArdupilotNavigationHelper::instance()->getAllBoardSafeties();
}

bool Ardupilot::setBoardSafety(QString status)
{
	return ArdupilotNavigationHelper::instance()->setBoardSafety(status);
}

int16_t Ardupilot::getOutputRate()
{
	return ArdupilotOutputHelper::instance()->getRate();
}

void Ardupilot::setOutputRate(uint16_t rate)
{
	ArdupilotOutputHelper::instance()->setRate(rate);
}

int16_t Ardupilot::getOutputMin(uint8_t channel)
{
	return ArdupilotOutputHelper::instance()->getMin(channel);
}

void Ardupilot::setOutputMin(uint8_t channel, uint16_t min)
{
	ArdupilotOutputHelper::instance()->setMin(channel, min);
}

int16_t Ardupilot::getOutputMax(uint8_t channel)
{
	return ArdupilotOutputHelper::instance()->getMax(channel);
}

void Ardupilot::setOutputMax(uint8_t channel, uint16_t max)
{
	ArdupilotOutputHelper::instance()->setMax(channel, max);
}

int16_t Ardupilot::getOutputTrim(uint8_t channel)
{
	return ArdupilotOutputHelper::instance()->getTrim(channel);
}

void Ardupilot::setOutputTrim(uint8_t channel, uint16_t trim)
{
	ArdupilotOutputHelper::instance()->setTrim(channel, trim);
}

bool Ardupilot::isOutputReversed(uint8_t channel)
{
	return ArdupilotOutputHelper::instance()->isReversed(channel);
}

void Ardupilot::setOutputReversed(uint8_t channel, bool reversed)
{
	ArdupilotOutputHelper::instance()->setReversed(channel, reversed);
}

QString Ardupilot::getOutputFunction(uint8_t channel)
{
	return ArdupilotOutputHelper::instance()->getFunction(channel);
}

QList<QString> Ardupilot::getAllOutputFunctions()
{
	return ArdupilotOutputHelper::instance()->getAllFunctions();
}

void Ardupilot::setOutputFunction(uint8_t channel, QString function)
{
	ArdupilotOutputHelper::instance()->setFunction(channel, function);
}

QString Ardupilot::getCameraTriggerType()
{
	return ArdupilotOutputHelper::instance()->getCameraTriggerType();
}

QList<QString> Ardupilot::getAllCameraTriggerTypes()
{
	return ArdupilotOutputHelper::instance()->getAllCameraTriggerTypes();
}

void Ardupilot::setCameraTriggerType(QString type)
{
	ArdupilotOutputHelper::instance()->setCameraTriggerType(type);
}

QString Ardupilot::getCameraTriggerPin()
{
	return ArdupilotOutputHelper::instance()->getCameraTriggerPin();
}

QList<QString> Ardupilot::getAllCameraTriggerPins()
{
	return  ArdupilotOutputHelper::instance()->getAllCameraTriggerPins();
}

void Ardupilot::setCameraTriggerPin(QString pin)
{
	ArdupilotOutputHelper::instance()->setCameraTriggerPin(pin);
}

void Ardupilot::triggerCamera()
{
	MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_DO_DIGICAM_CONTROL, 0, 0, 0, 0, 0, 1, 0, 0);
}

bool Ardupilot::isBatteryMonitorEnabled(const quint8 &id)
{
	return ArdupilotBatteryHelper::instance()->isBatteryMonitorEnabled(id);
}

QString Ardupilot::getBatteryMonitorOption(const quint8 &id)
{
	return ArdupilotBatteryHelper::instance()->getBatteryMonitorOption(id);
}

QList<QString> Ardupilot::getBatteryMonitorOptions()
{
	return ArdupilotBatteryHelper::instance()->getBatteryMonitorOptions();
}

void Ardupilot::setBatteryMonitorOption(const quint8 &id, const QString &option)
{
	ArdupilotBatteryHelper::instance()->setBatteryMonitorOption(id, option);
}
