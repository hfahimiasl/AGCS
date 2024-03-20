#include "Units.h"


Units::Units() :
	distance_unit(static_cast<SystemUnits::SystemDistanceUnitsEnum>(Settings::instance()->get(SystemSettings::UnitsDistance).toUInt())),
	speed_unit(static_cast<SystemUnits::SystemSpeedUnitsEnum>(Settings::instance()->get(SystemSettings::UnitsSpeed).toUInt())),
	voltage_unit(static_cast<SystemUnits::SystemVoltageUnitsEnum>(Settings::instance()->get(SystemSettings::UnitsVoltage).toUInt()))
{
	qmlRegisterType<SystemUnits>("SystemUnits", 1, 0, "SystemUnits");

	QObject::connect(Settings::instance(), &Settings::notifyChanges,
	this, [this](const SystemSettings::SystemSettingsEnum & key) {
		switch (key) {
		case SystemSettings::UnitsDistance:
			distance_unit = static_cast<SystemUnits::SystemDistanceUnitsEnum>(Settings::instance()->get(key).toUInt());
			break;

		case SystemSettings::UnitsSpeed:
			speed_unit = static_cast<SystemUnits::SystemSpeedUnitsEnum>(Settings::instance()->get(key).toUInt());
			break;

		case SystemSettings::UnitsVoltage:
			voltage_unit = static_cast<SystemUnits::SystemVoltageUnitsEnum>(Settings::instance()->get(key).toUInt());
			break;

		default:
			break;
		}
	});
}

Units *Units::instance()
{
	static Units self;
	return &self;
}

bool Units::set(SystemUnits::SystemQuantityEnum quantity, QVariant unit)
{
	if (SystemUnits::SystemUnitsMap.contains(quantity) && SystemUnits::SystemUnitsSettingsMap.contains(quantity)
	    && SystemUnits::SystemUnitsMap[quantity].contains(unit)) {
		if (Settings::instance()->set(SystemUnits::SystemUnitsSettingsMap[quantity], unit)) {
			emit notifyChanges(quantity);
			return true;
		}
	}

	return false;
}

QVariant Units::getUnit(SystemUnits::SystemQuantityEnum quantity)
{
	switch (quantity) {
	case SystemUnits::SystemQuantityEnum::Distance:
		return distance_unit;
		break;

	case SystemUnits::SystemQuantityEnum::Speed:
		return speed_unit;
		break;

	case SystemUnits::SystemQuantityEnum::Voltage:
		return voltage_unit;
		break;

	default:
		return QVariant::Invalid;
		break;
	}
}

double Units::getScale(SystemUnits::SystemQuantityEnum quantity)
{
	if (SystemUnits::SystemUnitsMap.contains(quantity) && SystemUnits::SystemUnitsSettingsMap.contains(quantity)) {
		QVariant unit = Settings::instance()->get(SystemUnits::SystemUnitsSettingsMap[quantity]);

		if (SystemUnits::SystemUnitsMap[quantity].contains(unit)) {
			return SystemUnits::SystemUnitsMap[quantity][unit][0].toDouble();
		}
	}

	return qQNaN();
}

QString Units::getSymbol(SystemUnits::SystemQuantityEnum quantity)
{
	if (SystemUnits::SystemUnitsMap.contains(quantity) && SystemUnits::SystemUnitsSettingsMap.contains(quantity)) {
		QVariant unit = Settings::instance()->get(SystemUnits::SystemUnitsSettingsMap[quantity]);

		if (SystemUnits::SystemUnitsMap[quantity].contains(unit)) {
			return SystemUnits::SystemUnitsMap[quantity][unit][1].toString();
		}
	}

	return "N/A";
}

double Units::convertFrom(SystemUnits::SystemQuantityEnum quantity, QVariant unit, double value)
{
	if (SystemUnits::SystemUnitsMap.contains(quantity) && SystemUnits::SystemUnitsMap[quantity].contains(unit)
	    && !qIsNaN(value)) {
		return value * SystemUnits::SystemUnitsMap[quantity][unit][0].toDouble();
	}

	return qQNaN();
}

double Units::convertTo(SystemUnits::SystemQuantityEnum quantity, QVariant unit, double value)
{
	if (SystemUnits::SystemUnitsMap.contains(quantity) && SystemUnits::SystemUnitsMap[quantity].contains(unit)
	    && !qIsNaN(value)) {
		return value / SystemUnits::SystemUnitsMap[quantity][unit][0].toDouble();
	}

	return qQNaN();
}

double Units::convert(SystemUnits::SystemQuantityEnum quantity, QVariant from, QVariant to, double value)
{
	return convertTo(quantity, to, convertFrom(quantity, from, value));
}

double Units::convert(SystemUnits::SystemQuantityEnum quantity, QVariant unit, double value)
{
	return convert(quantity, unit, getUnit(quantity), value);
}
