#pragma once

#include <QObject>
#include <QMap>

#include "src/System/Variable.h"
#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class ArdupilotModeHelper : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ArdupilotModeHelper)

public:
	explicit ArdupilotModeHelper();

	static ArdupilotModeHelper *instance();

	QList<QString> getAll();

	QString get(uint8_t);
	bool set(uint8_t, QString);

	QList<QString> getAvailableChannels();
	int8_t getChannel();
	bool setChannel(uint8_t);

	QString get();
	bool set(QString);

private:
	QMap<uint8_t, QString> plane_flight_modes_param_base;

	const QMap<QString, uint8_t> plane_flight_modes {
		{"MANUAL",          0},
		{"CIRCLE",          1},
		{"STABILIZE",       2},
		{"TRAINING",        3},
		{"ACRO",            4},
		{"FLY BY WIRE A",   5},
		{"FLY BY WIRE B",   6},
		{"CRUISE",          7},
		{"AUTOTUNE",        8},
		{"AUTO",            10},
		{"RTL",             11},
		{"LOITER",          12},
		{"TAKEOFF",         13},
		{"AVOID ADSB",      14},
		{"GUIDED",          15},
		{"INITIALISING",    16},
		{"QSTABILIZE",      17},
		{"QHOVER",          18},
		{"QLOITER",         19},
		{"QLAND",           20},
		{"QRTL",            21},
		{"QAUTOTUNE",       22},
		{"QACRO",           23}
	};

	QMap<uint8_t, QString> multirotor_flight_modes_param_base;

	const QMap<QString, uint8_t> multirotor_flight_modes {
		{"STABILIZE",       0},
		{"ACRO",            1},
		{"ALT HOLD",        2},
		{"AUTO",            3},
		{"GUIDED",          4},
		{"LOITER",          5},
		{"RTL",             6},
		{"CIRCLE",          7},
		{"LAND",            9},
		{"DRIFT",           11},
		{"SPORT",           13},
		{"FLIP",            14},
		{"AUTOTUNE",        15},
		{"POSHOLD",         16},
		{"BRAKE",           17},
		{"THROW",           18},
		{"ADOID ADSB",      19},
		{"GUIDED NOGPS",    20},
		{"SMART RTL",       21},
		{"FLOWHOLD",        22},
		{"FOLLOW",          23},
		{"ZIGZAG",          24},
		{"SYSTEMID",        25},
		{"AUTOROTATE",      26}
	};
};
