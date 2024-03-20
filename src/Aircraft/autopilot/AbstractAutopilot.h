#pragma once

#include <QObject>

#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class AbstractAutopilot : public QObject
{
	Q_OBJECT

public:
	explicit AbstractAutopilot();
	virtual ~AbstractAutopilot();

	virtual void init() = 0;

	virtual QList<QString> getAllFlightModes() = 0;

	virtual QString getFlightMode(uint8_t) = 0;
	virtual bool setFlightMode(uint8_t, QString) = 0;

	virtual QList<QString> getAvailableFlightModeChannels() = 0;
	virtual int8_t getFlightModeChannel() = 0;
	virtual bool setFlightModeChannel(uint8_t) = 0;

	virtual QString getFlightMode() = 0;
	virtual bool setFlightMode(QString) = 0;

	virtual QString getFrameClass() = 0;
	virtual QString getFrameType() = 0;
	virtual bool setFrame(QString, QString) = 0;

	virtual void requestLevelCalibration() = 0;
	virtual void requestAccelCalibration() = 0;
	virtual void requestNextAccelCalibrationSide() = 0;
	virtual void requestCompassCalibration() = 0;
	virtual void requestCancelCompassCalibration() = 0;
	virtual void requestRemoteControllerCalibration() = 0;
	virtual void writeRemoteControllerTrims() = 0;
	virtual void resetCalibrationProgress() = 0;

	virtual void handleConnectionFailure() = 0;

	virtual void navArmDisarm(bool, bool) = 0;
	virtual void takeoff() = 0;
	virtual void mission(QString) = 0;
	virtual void setCurrentWaypoint(uint16_t) = 0;

	virtual void reboot() = 0;

	virtual double getLowVoltageThreshold() = 0;
	virtual void setLowVoltageThreshold(double) = 0;

	virtual bool isLowVoltageActionEnable() = 0;
	virtual QString getLowVoltageAction() = 0;
	virtual QList<QString> getAllLowVoltageActions() = 0;
	virtual void setLowVoltageAction(QString) = 0;

	virtual double getCriticalVoltageThreshold() = 0;
	virtual void setCriticalVoltageThreshold(double) = 0;

	virtual bool isCriticalVoltageActionEnable() = 0;
	virtual QString getCriticalVoltageAction() = 0;
	virtual QList<QString> getAllCriticalVoltageActions() = 0;
	virtual void setCriticalVoltageAction(QString) = 0;

	virtual bool isFenceEnabled() = 0;
	virtual void enableFence(bool) = 0;

	virtual QString getFenceType() = 0;
	virtual QList<QString> getAllFenceTypes() = 0;
	virtual void setFenceType(QString) = 0;

	virtual QString getFenceAction() = 0;
	virtual QList<QString> getAllFenceActions() = 0;
	virtual void setFenceAction(QString) = 0;

	virtual qint16 getFenceAltitudeMax() = 0;
	virtual void setFenceAltitudeMax(qint16) = 0;

	virtual qint16 getFenceRadiusMax() = 0;
	virtual void setFenceRadiusMax(qint16) = 0;

	virtual QString getRemoteControlOption(uint8_t) = 0;
	virtual QList<QString> getAllRemoteControlOptions() = 0;
	virtual bool setRemoteControlOption(uint8_t, QString) = 0;

	virtual QString getTelemProtocol(uint8_t) = 0;
	virtual QList<QString> getAllTelemProtocols() = 0;
	virtual bool setTelemProtocol(uint8_t, QString) = 0;

	virtual QString getTelemBaudRate(uint8_t) = 0;
	virtual QList<QString> getAllTelemBaudRates() = 0;
	virtual bool setTelemBaudRate(uint8_t, QString) = 0;

	virtual QString getBoardSafety() = 0;
	virtual QList<QString> getAllBoardSafeties() = 0;
	virtual bool setBoardSafety(QString) = 0;

	virtual int16_t getOutputRate() = 0;
	virtual void setOutputRate(uint16_t) = 0;

	virtual int16_t getOutputMin(uint8_t) = 0;
	virtual void setOutputMin(uint8_t, uint16_t) = 0;

	virtual int16_t getOutputMax(uint8_t) = 0;
	virtual void setOutputMax(uint8_t, uint16_t) = 0;

	virtual int16_t getOutputTrim(uint8_t) = 0;
	virtual void setOutputTrim(uint8_t, uint16_t) = 0;

	virtual bool isOutputReversed(uint8_t) = 0;
	virtual void setOutputReversed(uint8_t, bool) = 0;

	virtual QString getOutputFunction(uint8_t) = 0;
	virtual QList<QString> getAllOutputFunctions() = 0;
	virtual void setOutputFunction(uint8_t, QString) = 0;

	virtual QString getCameraTriggerType() = 0;
	virtual QList<QString> getAllCameraTriggerTypes() = 0;
	virtual void setCameraTriggerType(QString) = 0;

	virtual QString getCameraTriggerPin() = 0;
	virtual QList<QString> getAllCameraTriggerPins() = 0;
	virtual void setCameraTriggerPin(QString) = 0;

	virtual void triggerCamera() = 0;

	virtual bool isBatteryMonitorEnabled(const quint8 &) = 0;
	virtual QString getBatteryMonitorOption(const quint8 &) = 0;
	virtual QList<QString> getBatteryMonitorOptions() = 0;
	virtual void setBatteryMonitorOption(const quint8 &, const QString &) = 0;

public slots:
	virtual void read(const mavlink_message_t &) = 0;
};
