#pragma once

#include <QObject>
#include <QMap>
#include <QVariantList>

#include "SystemSettings.h"


class SystemUnits : public QObject
{
	Q_OBJECT

public:
	enum SystemQuantityEnum {
		Distance    = 0,
		Speed       = 1,
		Voltage     = 2
	};

	Q_ENUM(SystemQuantityEnum)

	enum SystemDistanceUnitsEnum {
		MilliMeter  = 0,
		Foot        = 1,
		Meter       = 2,
		Kilometer   = 3,
		Mile        = 4
	};

	Q_ENUM(SystemDistanceUnitsEnum)

	enum SystemSpeedUnitsEnum {
		Mps     = 0,
		Knot    = 1,
		Mph     = 2,
		Kph     = 3
	};

	Q_ENUM(SystemSpeedUnitsEnum)

	enum SystemVoltageUnitsEnum {
		MilliVolt   = 0,
		Volt        = 1
	};

	Q_ENUM(SystemVoltageUnitsEnum)

	static const QMap<SystemQuantityEnum, QMap<QVariant, QVariantList>> SystemUnitsMap;
	static const QMap<SystemQuantityEnum, SystemSettings::SystemSettingsEnum> SystemUnitsSettingsMap;
};

Q_DECLARE_METATYPE(SystemUnits::SystemQuantityEnum)
Q_DECLARE_METATYPE(SystemUnits::SystemDistanceUnitsEnum)
Q_DECLARE_METATYPE(SystemUnits::SystemSpeedUnitsEnum)
Q_DECLARE_METATYPE(SystemUnits::SystemVoltageUnitsEnum)
