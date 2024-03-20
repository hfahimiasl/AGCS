#pragma once

#include "../AbstractAutopilot.h"
#include "../Autopilot.h"
#include "ArdupilotBatteryHelper.h"
#include "ArdupilotCalibrationHelper.h"
#include "ArdupilotFrameHelper.h"
#include "ArdupilotModeHelper.h"
#include "ArdupilotNavigationHelper.h"
#include "ArdupilotOutputHelper.h"


class Ardupilot : public AbstractAutopilot
{
	Q_OBJECT
	Q_DISABLE_COPY(Ardupilot)

public:
	explicit Ardupilot();

	static Ardupilot *instance();

	void init() override;

	QList<QString> getAllFlightModes() override;

	QString getFlightMode(uint8_t) override;
	bool setFlightMode(uint8_t, QString) override;

	QList<QString> getAvailableFlightModeChannels() override;
	int8_t getFlightModeChannel() override;
	bool setFlightModeChannel(uint8_t) override;

	QString getFlightMode() override;
	bool setFlightMode(QString) override;

	QString getFrameClass() override;
	QString getFrameType() override;
	bool setFrame(QString, QString) override;

	void requestLevelCalibration() override;
	void requestAccelCalibration() override;
	void requestNextAccelCalibrationSide() override;
	void requestCompassCalibration() override;
	void requestCancelCompassCalibration() override;
	void requestRemoteControllerCalibration() override;
	void writeRemoteControllerTrims() override;
	void resetCalibrationProgress() override;

	void handleConnectionFailure() override;

	void navArmDisarm(bool, bool) override;
	void takeoff() override;
	void mission(QString) override;
	void setCurrentWaypoint(uint16_t) override;

	void reboot() override;

	double getLowVoltageThreshold() override;
	void setLowVoltageThreshold(double) override;

	bool isLowVoltageActionEnable() override;
	QString getLowVoltageAction() override;
	QList<QString> getAllLowVoltageActions() override;
	void setLowVoltageAction(QString) override;

	double getCriticalVoltageThreshold() override;
	void setCriticalVoltageThreshold(double) override;

	bool isCriticalVoltageActionEnable() override;
	QString getCriticalVoltageAction() override;
	QList<QString> getAllCriticalVoltageActions() override;
	void setCriticalVoltageAction(QString) override;

	bool isFenceEnabled() override;
	void enableFence(bool) override;

	QString getFenceType() override;
	QList<QString> getAllFenceTypes() override;
	void setFenceType(QString) override;

	QString getFenceAction() override;
	QList<QString> getAllFenceActions() override;
	void setFenceAction(QString) override;

	qint16 getFenceAltitudeMax() override;
	void setFenceAltitudeMax(qint16) override;

	qint16 getFenceRadiusMax() override;
	void setFenceRadiusMax(qint16) override;

	QString getRemoteControlOption(uint8_t) override;
	QList<QString> getAllRemoteControlOptions() override;
	bool setRemoteControlOption(uint8_t, QString) override;

	QString getTelemProtocol(uint8_t) override;
	QList<QString> getAllTelemProtocols() override;
	bool setTelemProtocol(uint8_t, QString) override;

	QString getTelemBaudRate(uint8_t) override;
	QList<QString> getAllTelemBaudRates() override;
	bool setTelemBaudRate(uint8_t, QString) override;

	QString getBoardSafety() override;
	QList<QString> getAllBoardSafeties() override;
	bool setBoardSafety(QString) override;

	int16_t getOutputRate() override;
	void setOutputRate(uint16_t) override;

	int16_t getOutputMin(uint8_t) override;
	void setOutputMin(uint8_t, uint16_t) override;

	int16_t getOutputMax(uint8_t) override;
	void setOutputMax(uint8_t, uint16_t) override;

	int16_t getOutputTrim(uint8_t) override;
	void setOutputTrim(uint8_t, uint16_t) override;

	bool isOutputReversed(uint8_t) override;
	void setOutputReversed(uint8_t, bool) override;

	QString getOutputFunction(uint8_t) override;
	QList<QString> getAllOutputFunctions() override;
	void setOutputFunction(uint8_t, QString) override;

	QString getCameraTriggerType() override;
	QList<QString> getAllCameraTriggerTypes() override;
	void setCameraTriggerType(QString) override;

	QString getCameraTriggerPin() override;
	QList<QString> getAllCameraTriggerPins() override;
	void setCameraTriggerPin(QString) override;

	void triggerCamera() override;

	bool isBatteryMonitorEnabled(const quint8 &) override;
	QString getBatteryMonitorOption(const quint8 &) override;
	QList<QString> getBatteryMonitorOptions() override;
	void setBatteryMonitorOption(const quint8 &, const QString &) override;

public slots:
	void read(const mavlink_message_t &) override;

private:
	mavlink_rc_channels_t rc_channels;
};
