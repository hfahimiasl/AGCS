#include "Autopilot.h"


Autopilot::Autopilot() :
	last_autopilot_type(MAV_AUTOPILOT::MAV_AUTOPILOT_ENUM_END)
{
	autopilot_map.insert(MAV_AUTOPILOT::MAV_AUTOPILOT_ARDUPILOTMEGA, Ardupilot::instance());

	QObject::connect(Link::instance(), &Link::connectionChanged,
			 this, &Autopilot::connectionChanged);

	QObject::connect(&variable, &Variable::notifyChanges,
			 this, &Autopilot::variableChanges);

	QObject::connect(MissionService::instance(), &MissionService::notifyMissionComplete,
			 this, &Autopilot::missionComplete);
}

Autopilot *Autopilot::instance()
{
	static Autopilot self;
	return &self;
}

void Autopilot::connectionChanged(bool connected)
{
	for (const uint8_t &key : autopilot_map.keys()) {
		if (connected) {
			autopilot_map[key]->resetCalibrationProgress();
			last_autopilot_type = MAV_AUTOPILOT::MAV_AUTOPILOT_ENUM_END;

		} else {
			autopilot_map[key]->handleConnectionFailure();

			QObject::disconnect(MAVLink::instance(), &MAVLink::notifyRead,
					    autopilot_map[key], &AbstractAutopilot::read);
		}
	}
}

void Autopilot::variableChanges(QString id)
{
	if (id == "AUTOPILOT_TYPE") {
		autopilot_type = int8_t(variable.getValue(id));

		if (autopilot_type != last_autopilot_type) {
			last_autopilot_type = autopilot_type;

			connectionChanged(false);

			if (autopilot_map.contains(autopilot_type)) {
				QObject::connect(MAVLink::instance(), &MAVLink::notifyRead,
						 autopilot_map[autopilot_type], &AbstractAutopilot::read);

				autopilot_map[autopilot_type]->init();

			} else {
				if (autopilot_type != -1) {
					toast.error(tr("دستگاه پشتیبانی نمی شود"), 5000);
				}

				Link::instance()->disconnectAll();
			}
		}
	}
}

QList<QString> Autopilot::getAllFlightModes()
{
	QList<QString> flight_modes = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		flight_modes = autopilot_map[autopilot_type]->getAllFlightModes();
	}

	return flight_modes;
}

QString Autopilot::getFlightMode(quint8 index)
{
	QString flight_mode = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		flight_mode = autopilot_map[autopilot_type]->getFlightMode(index);
	}

	return flight_mode;
}

bool Autopilot::setFlightMode(quint8 index, QString mode)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setFlightMode(index, mode);
	}

	return ret;
}

QString Autopilot::getFlightMode()
{
	QString flight_mode = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		flight_mode = autopilot_map[autopilot_type]->getFlightMode();
	}

	return flight_mode;
}

bool Autopilot::setFlightMode(QString mode)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setFlightMode(mode);
	}

	return ret;
}

QList<QString> Autopilot::getAvailableFlightModeChannels()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getAvailableFlightModeChannels();
	}

	return ret;
}

int Autopilot::getFlightModeChannel()
{
	int ret = -1;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getFlightModeChannel();
	}

	return ret;
}

bool Autopilot::setFlightModeChannel(quint8 channel)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setFlightModeChannel(channel);
	}

	return ret;
}

QString Autopilot::getFrameClass()
{
	QString frame_class = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		frame_class = autopilot_map[autopilot_type]->getFrameClass();
	}

	return frame_class;
}

QString Autopilot::getFrameType()
{
	QString frame_type = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		frame_type = autopilot_map[autopilot_type]->getFrameType();
	}

	return frame_type;
}

bool Autopilot::setFrame(QString class_name, QString type_name)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setFrame(class_name, type_name);
	}

	return ret;
}

void Autopilot::requestLevelCalibration()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestLevelCalibration();
	}
}

void Autopilot::requestAccelCalibration()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestAccelCalibration();
	}
}

void Autopilot::requestNextAccelCalibrationSide()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestNextAccelCalibrationSide();
	}
}

void Autopilot::requestCompassCalibration()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestCompassCalibration();
	}
}

void Autopilot::requestCancelCompassCalibration()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestCancelCompassCalibration();
	}
}

void Autopilot::requestRemoteControllerCalibration()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->requestRemoteControllerCalibration();
	}
}

void Autopilot::writeRemoteControllerTrims()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->writeRemoteControllerTrims();
	}
}

void Autopilot::resetCalibrationProgress()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->resetCalibrationProgress();
	}
}

void Autopilot::navArmDisarm(bool status, bool force)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->navArmDisarm(status, force);
	}
}

void Autopilot::takeoff()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->takeoff();
	}
}

void Autopilot::mission(QString command)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->mission(command);
	}
}

void Autopilot::setCurrentWaypoint(quint16 seq)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setCurrentWaypoint(seq);
	}
}

void Autopilot::reboot()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->reboot();
	}
}

void Autopilot::missionComplete()
{
	mission("END");
}

double Autopilot::getLowVoltageThreshold()
{
	double ret = qQNaN();

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getLowVoltageThreshold();
	}

	return ret;
}

void Autopilot::setLowVoltageThreshold(double threshold)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setLowVoltageThreshold(threshold);
	}
}

bool Autopilot::isLowVoltageActionEnable()
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->isLowVoltageActionEnable();
	}

	return ret;
}

QString Autopilot::getLowVoltageAction()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getLowVoltageAction();
	}

	return ret;
}

QList<QString> Autopilot::getAllLowVoltageActions()
{
	QList<QString> low_voltage_actions = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		low_voltage_actions = autopilot_map[autopilot_type]->getAllLowVoltageActions();
	}

	return low_voltage_actions;
}

void Autopilot::setLowVoltageAction(QString action)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setLowVoltageAction(action);
	}
}

double Autopilot::getCriticalVoltageThreshold()
{
	double ret = qQNaN();

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getCriticalVoltageThreshold();
	}

	return ret;
}

void Autopilot::setCriticalVoltageThreshold(double threshold)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setCriticalVoltageThreshold(threshold);
	}
}

bool Autopilot::isCriticalVoltageActionEnable()
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->isCriticalVoltageActionEnable();
	}

	return ret;
}

QString Autopilot::getCriticalVoltageAction()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getCriticalVoltageAction();
	}

	return ret;
}

QList<QString> Autopilot::getAllCriticalVoltageActions()
{
	QList<QString> low_voltage_actions = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		low_voltage_actions = autopilot_map[autopilot_type]->getAllCriticalVoltageActions();
	}

	return low_voltage_actions;
}

void Autopilot::setCriticalVoltageAction(QString action)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setCriticalVoltageAction(action);
	}
}

bool Autopilot::isFenceEnabled()
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->isFenceEnabled();
	}

	return ret;
}

void Autopilot::enableFence(bool enable)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->enableFence(enable);
	}
}

QString Autopilot::getFenceType()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getFenceType();
	}

	return ret;
}

QList<QString> Autopilot::getAllFenceTypes()
{
	QList<QString> fence_types = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		fence_types = autopilot_map[autopilot_type]->getAllFenceTypes();
	}

	return fence_types;
}

void Autopilot::setFenceType(QString type)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setFenceType(type);
	}
}

QString Autopilot::getFenceAction()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getFenceAction();
	}

	return ret;
}

QList<QString> Autopilot::getAllFenceActions()
{
	QList<QString> fence_actions = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		fence_actions = autopilot_map[autopilot_type]->getAllFenceActions();
	}

	return fence_actions;
}

void Autopilot::setFenceAction(QString action)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setFenceAction(action);
	}
}

qint16 Autopilot::getFenceAltitudeMax()
{
	qint16 alt = -1;

	if (autopilot_map.contains(autopilot_type)) {
		alt = autopilot_map[autopilot_type]->getFenceAltitudeMax();
	}

	return alt;
}

void Autopilot::setFenceAltitudeMax(qint16 alt)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setFenceAltitudeMax(alt);
	}
}

qint16 Autopilot::getFenceRadiusMax()
{
	qint16 radius = -1;

	if (autopilot_map.contains(autopilot_type)) {
		radius = autopilot_map[autopilot_type]->getFenceRadiusMax();
	}

	return radius;
}

void Autopilot::setFenceRadiusMax(qint16 radius)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setFenceRadiusMax(radius);
	}
}

QString Autopilot::getRemoteControlOption(quint8 channel)
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getRemoteControlOption(channel);
	}

	return ret;
}

QList<QString> Autopilot::getAllRemoteControlOptions()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getAllRemoteControlOptions();
	}

	return ret;
}

bool Autopilot::setRemoteControlOption(quint8 channel, QString option)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setRemoteControlOption(channel, option);
	}

	return ret;
}

QString Autopilot::getTelemProtocol(quint8 number)
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getTelemProtocol(number);
	}

	return ret;
}

QList<QString> Autopilot::getAllTelemProtocols()
{
	QList<QString> list = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		list = autopilot_map[autopilot_type]->getAllTelemProtocols();
	}

	return list;
}

bool Autopilot::setTelemProtocol(quint8 number, QString protocol)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setTelemProtocol(number, protocol);
	}

	return ret;
}

QString Autopilot::getTelemBaudRate(quint8 number)
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getTelemBaudRate(number);
	}

	return ret;
}

QList<QString> Autopilot::getAllTelemBaudRates()
{
	QList<QString> list = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		list = autopilot_map[autopilot_type]->getAllTelemBaudRates();
	}

	return list;
}

bool Autopilot::setTelemBaudRate(quint8 number, QString protocol)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setTelemBaudRate(number, protocol);
	}

	return ret;
}

QString Autopilot::getBoardSafety()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getBoardSafety();
	}

	return ret;
}

QList<QString> Autopilot::getAllBoardSafeties()
{
	QList<QString> list = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		list = autopilot_map[autopilot_type]->getAllBoardSafeties();
	}

	return list;
}

bool Autopilot::setBoardSafety(QString status)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->setBoardSafety(status);
	}

	return ret;
}

qint16 Autopilot::getOutputRate()
{
	qint16 ret = -1;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getOutputRate();
	}

	return ret;
}

void Autopilot::setOutputRate(quint16 rate)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputRate(rate);
	}
}

qint16 Autopilot::getOutputMin(quint8 channel)
{
	qint16 ret = -1;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getOutputMin(channel);
	}

	return ret;
}

void Autopilot::setOutputMin(quint8 channel, quint16 min)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputMin(channel, min);
	}
}

qint16 Autopilot::getOutputMax(quint8 channel)
{
	qint16 ret = -1;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getOutputMax(channel);
	}

	return ret;
}

void Autopilot::setOutputMax(quint8 channel, quint16 max)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputMax(channel, max);
	}
}

qint16 Autopilot::getOutputTrim(quint8 channel)
{
	qint16 ret = -1;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getOutputTrim(channel);
	}

	return ret;
}

void Autopilot::setOutputTrim(quint8 channel, quint16 trim)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputTrim(channel, trim);
	}
}

bool Autopilot::isOutputReversed(quint8 channel)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->isOutputReversed(channel);
	}

	return ret;
}

void Autopilot::setOutputReversed(quint8 channel, bool reversed)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputReversed(channel, reversed);
	}
}

QString Autopilot::getOutputFunction(quint8 channel)
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getOutputFunction(channel);
	}

	return ret;
}

QList<QString> Autopilot::getAllOutputFunctions()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getAllOutputFunctions();
	}

	return ret;
}

void Autopilot::setOutputFunction(quint8 channel, QString function)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setOutputFunction(channel, function);
	}
}

QString Autopilot::getCameraTriggerType()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getCameraTriggerType();
	}

	return ret;
}

QList<QString> Autopilot::getAllCameraTriggerTypes()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getAllCameraTriggerTypes();
	}

	return ret;
}

void Autopilot::setCameraTriggerType(QString type)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setCameraTriggerType(type);
	}
}

QString Autopilot::getCameraTriggerPin()
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getCameraTriggerPin();
	}

	return ret;
}

QList<QString> Autopilot::getAllCameraTriggerPins()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getAllCameraTriggerPins();
	}

	return ret;
}

void Autopilot::setCameraTriggerPin(QString pin)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setCameraTriggerPin(pin);
	}
}

void Autopilot::triggerCamera()
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->triggerCamera();
	}
}

bool Autopilot::isBatteryMonitorEnabled(const quint8 &id)
{
	bool ret = false;

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->isBatteryMonitorEnabled(id);
	}

	return ret;
}

QString Autopilot::getBatteryMonitorOption(const quint8 &id)
{
	QString ret = "N/A";

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getBatteryMonitorOption(id);
	}

	return ret;
}

QList<QString> Autopilot::getBatteryMonitorOptions()
{
	QList<QString> ret = {"N/A"};

	if (autopilot_map.contains(autopilot_type)) {
		ret = autopilot_map[autopilot_type]->getBatteryMonitorOptions();
	}

	return ret;
}

void Autopilot::setBatteryMonitorOption(const quint8 &id, const QString &option)
{
	if (autopilot_map.contains(autopilot_type)) {
		autopilot_map[autopilot_type]->setBatteryMonitorOption(id, option);
	}
}
