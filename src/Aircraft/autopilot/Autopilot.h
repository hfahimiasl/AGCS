#pragma once

#include <QObject>

#include "src/Aircraft/link/Link.h"
#include "src/System/Variable.h"
#include "ardupilot/Ardupilot.h"


class Autopilot : public QObject
{
	Q_OBJECT

public:
	explicit Autopilot();

	static Autopilot *instance();

signals:
	void levelCalibrationAccepted();
	void levelCalibrationFailed();
	void accelCalibrationPosLevel();
	void accelCalibrationPosLeft();
	void accelCalibrationPosRight();
	void accelCalibrationPosNoseDown();
	void accelCalibrationPosNoseUp();
	void accelCalibrationPosBack();
	void accelCalibrationAccepted();
	void accelCalibrationFailed();
	void compassCalibrationStarted();
	void compassCalibrationAccepted();
	void compassCalibrationCancelled();
	void compassCalibrationFailed();
	void remoteControllerCalibrationAccepted();
	void remoteControllerCalibrationFailed();

public slots:
	void connectionChanged(bool);
	void variableChanges(QString);

	QList<QString> getAllFlightModes();

	QString getFlightMode(quint8);
	bool setFlightMode(quint8, QString);

	QList<QString> getAvailableFlightModeChannels();
	int getFlightModeChannel();
	bool setFlightModeChannel(quint8);

	QString getFlightMode();
	bool setFlightMode(QString);

	QString getFrameClass();
	QString getFrameType();
	bool setFrame(QString, QString);

	void requestLevelCalibration();
	void requestAccelCalibration();
	void requestNextAccelCalibrationSide();
	void requestCompassCalibration();
	void requestCancelCompassCalibration();
	void requestRemoteControllerCalibration();
	void writeRemoteControllerTrims();
	void resetCalibrationProgress();

	void navArmDisarm(bool, bool);
	void takeoff();
	void mission(QString);
	void setCurrentWaypoint(quint16);

	void reboot();

	double getLowVoltageThreshold();
	void setLowVoltageThreshold(double);

	bool isLowVoltageActionEnable();
	QString getLowVoltageAction();
	QList<QString> getAllLowVoltageActions();
	void setLowVoltageAction(QString);

	double getCriticalVoltageThreshold();
	void setCriticalVoltageThreshold(double);

	bool isCriticalVoltageActionEnable();
	QString getCriticalVoltageAction();
	QList<QString> getAllCriticalVoltageActions();
	void setCriticalVoltageAction(QString);

	bool isFenceEnabled();
	void enableFence(bool);

	QString getFenceType();
	QList<QString> getAllFenceTypes();
	void setFenceType(QString);

	QString getFenceAction();
	QList<QString> getAllFenceActions();
	void setFenceAction(QString);

	qint16 getFenceAltitudeMax();
	void setFenceAltitudeMax(qint16);

	qint16 getFenceRadiusMax();
	void setFenceRadiusMax(qint16);

	QString getRemoteControlOption(quint8);
	QList<QString> getAllRemoteControlOptions();
	bool setRemoteControlOption(quint8, QString);

	QString getTelemProtocol(quint8);
	QList<QString> getAllTelemProtocols();
	bool setTelemProtocol(quint8, QString);

	QString getTelemBaudRate(quint8);
	QList<QString> getAllTelemBaudRates();
	bool setTelemBaudRate(quint8, QString);

	QString getBoardSafety();
	QList<QString> getAllBoardSafeties();
	bool setBoardSafety(QString);

	qint16 getOutputRate();
	void setOutputRate(quint16);

	qint16 getOutputMin(quint8);
	void setOutputMin(quint8, quint16);

	qint16 getOutputMax(quint8);
	void setOutputMax(quint8, quint16);

	qint16 getOutputTrim(quint8);
	void setOutputTrim(quint8, quint16);

	bool isOutputReversed(quint8);
	void setOutputReversed(quint8, bool);

	QString getOutputFunction(quint8);
	QList<QString> getAllOutputFunctions();
	void setOutputFunction(quint8, QString);

	QString getCameraTriggerType();
	QList<QString> getAllCameraTriggerTypes();
	void setCameraTriggerType(QString);

	QString getCameraTriggerPin();
	QList<QString> getAllCameraTriggerPins();
	void setCameraTriggerPin(QString);

	void triggerCamera();

	bool isBatteryMonitorEnabled(const quint8 &);
	QString getBatteryMonitorOption(const quint8 &);
	QList<QString> getBatteryMonitorOptions();
	void setBatteryMonitorOption(const quint8 &, const QString &);

private slots:
	void missionComplete();

private:
	QMap<uint8_t, AbstractAutopilot *> autopilot_map;

	int8_t autopilot_type;
	int8_t last_autopilot_type;
};
