#pragma once

#include <QObject>
#include <QMap>

#include "src/System/Variable.h"
#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class ArdupilotOutputHelper : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ArdupilotOutputHelper)

public:
	explicit ArdupilotOutputHelper();

	static ArdupilotOutputHelper *instance();

	int16_t getRate();
	void setRate(uint16_t);

	int16_t getMin(uint8_t);
	void setMin(uint8_t, uint16_t);

	int16_t getMax(uint8_t);
	void setMax(uint8_t, uint16_t);

	int16_t getTrim(uint8_t);
	void setTrim(uint8_t, uint16_t);

	bool isReversed(uint8_t);
	void setReversed(uint8_t, bool);

	QString getFunction(uint8_t);
	QList<QString> getAllFunctions();
	void setFunction(uint8_t, QString);

	QString getCameraTriggerType();
	QList<QString> getAllCameraTriggerTypes();
	void setCameraTriggerType(QString);

	QString getCameraTriggerPin();
	QList<QString> getAllCameraTriggerPins();
	void setCameraTriggerPin(QString);

private:
	QMap<uint8_t, QString> output_function_param_base;

	const QMap<QString, uint8_t> output_function {
		{"Disabled",                    0},
		{"RCPassThru",                  1},
		{"Flap",                        2},
		{"Flap_auto",                   3},
		{"Aileron",                     4},
		{"mount_pan",                   6},
		{"mount_tilt",                  7},
		{"mount_roll",                  8},
		{"mount_open",                  9},
		{"camera_trigger",              10},
		{"mount2_pan",                  12},
		{"mount2_tilt",                 13},
		{"mount2_roll",                 14},
		{"mount2_open",                 15},
		{"DifferentialSpoilerLeft1",    16},
		{"DifferentialSpoilerRight1",   17},
		{"Elevator",                    19},
		{"Rudder",                      21},
		{"SprayerPump",                 22},
		{"SprayerSpinner",              23},
		{"FlaperonLeft",                24},
		{"FlaperonRight",               25},
		{"GroundSteering",              26},
		{"Parachute",                   27},
		{"Gripper",                     28},
		{"LandingGear",                 29},
		{"EngineRunEnable",             30},
		{"HeliRSC",                     31},
		{"HeliTailRSC",                 32},
		{"Motor1",                      33},
		{"Motor2",                      34},
		{"Motor3",                      35},
		{"Motor4",                      36},
		{"Motor5",                      37},
		{"Motor6",                      38},
		{"Motor7",                      39},
		{"Motor8",                      40},
		{"MotorTilt",                   41},
		{"RCIN1",                       51},
		{"RCIN2",                       52},
		{"RCIN3",                       53},
		{"RCIN4",                       54},
		{"RCIN5",                       55},
		{"RCIN6",                       56},
		{"RCIN7",                       57},
		{"RCIN8",                       58},
		{"RCIN9",                       59},
		{"RCIN10",                      60},
		{"RCIN11",                      61},
		{"RCIN12",                      62},
		{"RCIN13",                      63},
		{"RCIN14",                      64},
		{"RCIN15",                      65},
		{"RCIN16",                      66},
		{"Ignition",                    67},
		{"Starter",                     69},
		{"Throttle",                    70},
		{"TrackerYaw",                  71},
		{"TrackerPitch",                72},
		{"ThrottleLeft",                73},
		{"ThrottleRight",               74},
		{"tiltMotorLeft",               75},
		{"tiltMotorRight",              76},
		{"ElevonLeft",                  77},
		{"ElevonRight",                 78},
		{"VTailLeft",                   79},
		{"VTailRight",                  80},
		{"BoostThrottle",               81},
		{"Motor9",                      82},
		{"Motor10",                     83},
		{"Motor11",                     84},
		{"Motor12",                     85},
		{"DifferentialSpoilerLeft2",    86},
		{"DifferentialSpoilerRight2",   87},
		{"Winch",                       88},
		{"Main Sail",                   89},
		{"CameraISO",                   90},
		{"CameraAperture",              91},
		{"CameraFocus",                 92},
		{"CameraShutterSpeed",          93},
		{"Script 1",                    94},
		{"Script 2",                    95},
		{"Script 3",                    96},
		{"Script 4",                    97},
		{"Script 5",                    98},
		{"Script 6",                    99},
		{"Script 7",                    100},
		{"Script 8",                    101},
		{"Script 9",                    102},
		{"Script 10",                   103},
		{"Script 11",                   104},
		{"Script 12",                   105},
		{"Script 13",                   106},
		{"Script 14",                   107},
		{"Script 15",                   108},
		{"Script 16",                   109},
		{"NeoPixel1",                   120},
		{"NeoPixel2",                   121},
		{"NeoPixel3",                   122},
		{"NeoPixel4",                   123},
		{"RateRoll",                    124},
		{"RatePitch",                   125},
		{"RateThrust",                  126},
		{"RateYaw",                     127},
		{"Wing Sail Elevator",          128},
		{"ProfiLED 1",                  129},
		{"ProfiLED 2",                  130},
		{"ProfiLED 3",                  131},
		{"ProfiLED Clock",              132},
		{"Winch Clutch",                133},
	};

	QMap<uint8_t, QString> camera_trigger_type_param_base;

	const QMap<QString, uint8_t> camera_trigger_type {
		{"Servo", 0},
		{"Relay", 1}
	};

	QMap<int8_t, QString> camera_trigger_relay_pin_param_base;

	const QMap<QString, int8_t> camera_trigger_relay_pin {
		{"Disabled", -1},
		{"AUXOUT1", 50},
		{"AUXOUT2", 51},
		{"AUXOUT3", 52},
		{"AUXOUT4", 53},
		{"AUXOUT5", 54},
		{"AUXOUT6", 55},
		{"BB Blue GP0 pin 3", 57},
		{"BB Blue GP0 pin 4", 49},
		{"BB Blue GP0 pin 5", 116},
		{"BB Blue GP0 pin 6", 113},
		{"BBBMini Pin P8.17", 27},
	};

	QMap<uint8_t, QString> camera_trigger_servo_pin_param_base;

	const QMap<QString, uint8_t> camera_trigger_servo_pin {
		{"Disabled", 0},
		{"SERVO1", 1},
		{"SERVO2", 2},
		{"SERVO3", 3},
		{"SERVO4", 4},
		{"SERVO5", 5},
		{"SERVO6", 6},
		{"SERVO7", 7},
		{"SERVO8", 8},
		{"SERVO9", 9},
		{"SERVO10", 10},
		{"SERVO11", 11},
		{"SERVO12", 12},
		{"SERVO13", 13},
		{"SERVO14", 14},
		{"SERVO15", 15},
		{"SERVO16", 16}
	};
};
