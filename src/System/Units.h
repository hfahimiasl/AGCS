#pragma once

#include <QObject>

#include "Settings.h"
#include "SystemUnits.h"


class Units : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Units)

public:
	explicit Units();

	static Units *instance();

signals:
	void notifyChanges(SystemUnits::SystemQuantityEnum quantity);

public slots:
	bool set(SystemUnits::SystemQuantityEnum, QVariant);

	QVariant getUnit(SystemUnits::SystemQuantityEnum);
	double getScale(SystemUnits::SystemQuantityEnum);
	QString getSymbol(SystemUnits::SystemQuantityEnum);

	double convertFrom(SystemUnits::SystemQuantityEnum, QVariant, double);
	double convertTo(SystemUnits::SystemQuantityEnum, QVariant, double);
	double convert(SystemUnits::SystemQuantityEnum, QVariant, QVariant, double);
	double convert(SystemUnits::SystemQuantityEnum, QVariant, double);

private:
	SystemUnits::SystemDistanceUnitsEnum distance_unit {SystemUnits::SystemDistanceUnitsEnum::Meter};
	SystemUnits::SystemSpeedUnitsEnum speed_unit {SystemUnits::SystemSpeedUnitsEnum::Mps};
	SystemUnits::SystemVoltageUnitsEnum voltage_unit {SystemUnits::SystemVoltageUnitsEnum::Volt};
};
