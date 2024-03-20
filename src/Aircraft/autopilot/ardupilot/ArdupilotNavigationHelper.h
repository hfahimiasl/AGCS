#pragma once

#include <QObject>

#include "ArdupilotModeHelper.h"
#include "src/System/Variable.h"
#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class ArdupilotNavigationHelper : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ArdupilotNavigationHelper)

public:
	explicit ArdupilotNavigationHelper();

	static ArdupilotNavigationHelper *instance();

	enum ARM_DISARM_OPERATION {
		REQUEST_ARMING,
		REQUEST_DISARMING,
		ARM_DISARM_ACCEPTED,
		ARM_DISARM_FAILED
	}   arm_disarm_opn;

	void ArmDisarm(bool, bool);

	enum TAKEOFF_OPERATION {
		PENDING_REQUEST,
		REQUEST_TAKEOFF,
		TAKEOFF_ACCEPTED,
		TAKEOFF_FAILED
	}   takeoff_opn;

	void takeoff();

	enum MISSION_OPERATION {
		MISSION_OPERATION_PENDING_REQUEST,
		MISSION_OPERATION_REQUEST_START,
		MISSION_OPERATION_START_ACCEPTED,
		MISSION_OPERATION_START_FAILED
	}   mission_opn;

	void mission(QString);

	void setCurrentWaypoint(uint16_t);

	void readCommandAck(const mavlink_command_ack_t &);

	QMap<uint8_t, QString> low_voltage_action_param_base;

	const QMap<QString, uint8_t> low_voltage_action {
		{("غیرفعال"),               0},
		{("فرود"),                  1},
		{("بازگشت به خانه"),        2},
		{("بازگشت به خانه هوشمند"), 3},
		{("بازگشت هوشمند یا فرود"), 4},
		{("خاتمه دادن"),            5}
	};

	double getLowVoltageThreshold();
	void setLowVoltageThreshold(double);

	bool isLowVoltageActionEnable();
	QString getLowVoltageAction();
	QList<QString> getAllLowVoltageActions();
	void setLowVoltageAction(QString);

	QMap<uint8_t, QString> critical_voltage_action_param_base;

	const QMap<QString, uint8_t> critical_voltage_action {
		{("غیرفعال"),               0},
		{("فرود"),                  1},
		{("بازگشت به خانه"),        2},
		{("بازگشت به خانه هوشمند"), 3},
		{("بازگشت هوشمند یا فرود"), 4},
		{("خاتمه دادن"),            5}
	};

	double getCriticalVoltageThreshold();
	void setCriticalVoltageThreshold(double);

	bool isCriticalVoltageActionEnable();
	QString getCriticalVoltageAction();
	QList<QString> getAllCriticalVoltageActions();
	void setCriticalVoltageAction(QString);

	bool isFenceEnabled();
	void enableFence(bool);

	QMap<uint8_t, QString> fence_type_param_base;

	const QMap<QString, uint8_t> fence_type {
		{"None",                    0},
		{"Altitude",                1},
		{"Circle",                  2},
		{"Altitude and Circle",     3},
		{"Polygon",                 4},
		{"Altitude and Polygon",    5},
		{"Circle and Polygon",      6},
		{"All",                     7}
	};

	QString getFenceType();
	QList<QString> getAllFenceTypes();
	void setFenceType(QString);

	QMap<uint8_t, QString> fence_action_param_base;

	const QMap<QString, uint8_t> fence_action {
		{"Report Only",             0},
		{"RTL or Land",             1},
		{"Always Land",             2},
		{"SmartRTL or RTL or Land", 3},
		{"Brake or Land",           4}
	};

	QString getFenceAction();
	QList<QString> getAllFenceActions();
	void setFenceAction(QString);

	qint16 getFenceAltitudeMax();
	void setFenceAltitudeMax(qint16);

	qint16 getFenceRadiusMax();
	void setFenceRadiusMax(qint16);

	QMap<uint16_t, QString> remote_control_option_param_base;

	const QMap<QString, uint16_t> remote_control_option {
		{"Do Nothing",              0},
		{"Flip",                    2},
		{"Simple Mode",             3},
		{"RTL",                     4},
		{"Save Trim",               5},
		{"Save WP",                 7},
		{"Camera Trigger",          9},
		{"RangeFinder",             10},
		{"Fence",                   11},
		{"Super Simple Mode",       13},
		{"Acro Trainer",            14},
		{"Sprayer",                 15},
		{"Auto",                    16},
		{"AutoTune",                17},
		{"Land",                    18},
		{"Gripper",                 19},
		{"Parachute Enable",        21},
		{"Parachute Release",       22},
		{"Parachute 3pos",          23},
		{"Auto Mission Reset",      24},
		{"AttCon Feed Forward",     25},
		{"AttCon Accel Limits",     26},
		{"Retract Mount",           27},
		{"Relay On/Off",            28},
		{"Landing Gear",            29},
		{"Lost Copter Sound",       30},
		{"Motor Emergency Stop",    31},
		{"Motor Interlock",         32},
		{"Brake",                   33},
		{"Relay2 On/Off",           34},
		{"Relay3 On/Off",           35},
		{"Relay4 On/Off",           36},
		{"Throw",                   37},
		{"ADSB Avoidance En",       38},
		{"PrecLoiter",              39},
		{"Proximity Avoidance",     40},
		{"ArmDisarm",               41},
		{"SmartRTL",                42},
		{"InvertedFlight",          43},
		{"RC Override Enable",      46},
		{"User Function 1",         47},
		{"User Function 2",         48},
		{"User Function 3",         49},
		{"Acro",                    52},
		{"Guided",                  55},
		{"Loiter",                  56},
		{"Follow",                  57},
		{"Clear Waypoints",         58},
		{"ZigZag",                  60},
		{"ZigZag SaveWP",           61},
		{"Compass Learn",           62},
		{"GPS Disable",             65},
		{"Relay5",                  66},
		{"Relay6",                  67},
		{"Stabilize",               68},
		{"PosHold",                 69},
		{"AltHold",                 70},
		{"FlowHold",                71},
		{"Circle",                  72},
		{"Drift",                   73},
		{"SurfaceTrackingUpDown",   75},
		{"Standby Mode",            76},
		{"RunCam Control",          78},
		{"RunCam OSD Control",      79},
		{"Viso Align",              80},
		{"Disarm",                  81},
		{"ZigZag Auto",             83},
		{"Air Mode",                84},
		{"Generator",               85},
		{"EKF Pos Source",          90},
		{"KillIMU1",                100},
		{"KillIMU2",                101},
		{"Camera Mode Toggle",      102},
		{"GPS Disable Yaw",         105},
		{"Scripting1",              300},
		{"Scripting2",              301},
		{"Scripting3",              302},
		{"Scripting4",              303},
		{"Scripting5",              304},
		{"Scripting6",              305},
		{"Scripting7",              306},
		{"Scripting8",              307}
	};

	QString getRemoteControlOption(uint8_t);
	QList<QString> getAllRemoteControlOptions();
	bool setRemoteControlOption(uint8_t, QString);

	QMap<int8_t, QString> telem_protocol_param_base;

	const QMap<QString, int8_t> telem_protocol {
		{"None",                               -1},
		{"MAVLink1",                            1},
		{"MAVLink2",                            2},
		{"Frsky D",                             3},
		{"Frsky SPort",                         4},
		{"GPS",                                 5},
		{"Alexmos Gimbal Serial",               7},
		{"SToRM32 Gimbal Serial",               8},
		{"Rangefinder",                         9},
		{"FrSky SPort Passthrough (OpenTX)",    10},
		{"Lidar360",                            11},
		{"Beacon",                              13},
		{"Volz servo out",                      14},
		{"SBus servo out",                      15},
		{"ESC Telemetry",                       16},
		{"Devo Telemetry",                      17},
		{"OpticalFlow",                         18},
		{"RobotisServo",                        19},
		{"NMEA Output",                         20},
		{"WindVane",                            21},
		{"SLCAN",                               22},
		{"RCIN",                                23},
		{"MegaSquirt EFI",                      24},
		{"LTM",                                 25},
		{"RunCam",                              26},
		{"HottTelem",                           27},
		{"Scripting",                           28},
		{"Crossfire",                           29},
		{"Generator",                           30},
		{"Winch",                               31},
		{"MSP",                                 32},
		{"DJI FPV",                             33},
		{"AirSpeed",                            34}
	};

	QString getTelemProtocol(uint8_t);
	QList<QString> getAllTelemProtocols();
	bool setTelemProtocol(uint8_t, QString);

	QMap<uint8_t, QString> telem_baudrate_param_base;

	const QMap<QString, uint8_t> telem_baudrate {
		{"1200",    1},
		{"2400",    2},
		{"4800",    4},
		{"9600",    9},
		{"19200",   19},
		{"38400",   38},
		{"57600",   57},
		{"111100",  111},
		{"115200",  115},
		{"230400",  230},
		{"256000",  256},
		{"460800",  460},
		{"500000",  500},
		{"921600",  921},
		{"1500000", 1500}
	};

	QString getTelemBaudRate(uint8_t);
	QList<QString> getAllTelemBaudRates();
	bool setTelemBaudRate(uint8_t, QString);

	QMap<uint8_t, QString> board_safety_param_base;

	const QMap<QString, uint8_t> board_safety {
		{tr("فعال"),        1},
		{tr("غیر فعال"),    0}
	};

	QString getBoardSafety();
	QList<QString> getAllBoardSafeties();
	bool setBoardSafety(QString);

	static bool comparison(const QString &str1, const QString &str2)
	{
		return str1.toUInt() < str2.toUInt();
	}
};
