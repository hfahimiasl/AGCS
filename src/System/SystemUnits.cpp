#include "SystemUnits.h"


const QMap<SystemUnits::SystemQuantityEnum, QMap<QVariant, QVariantList>> SystemUnits::SystemUnitsMap {
	{
		Distance, {
			{SystemDistanceUnitsEnum::MilliMeter,   {0.001,     "mm"}},
			{SystemDistanceUnitsEnum::Foot,         {0.3048,    "ft"}},
			{SystemDistanceUnitsEnum::Meter,        {1.0,		"m"}},
			{SystemDistanceUnitsEnum::Kilometer,    {1000.0,    "km"}},
			{SystemDistanceUnitsEnum::Mile,         {1609.344,  "mi"}}
		}
	},

	{
		Speed, {
			{SystemSpeedUnitsEnum::Mps,		{1.0,		"m/s"}},
			{SystemSpeedUnitsEnum::Knot,	{1.943844,	"kn"}},
			{SystemSpeedUnitsEnum::Mph,		{2.236936,	"mph"}},
			{SystemSpeedUnitsEnum::Kph,		{3.6,		"km/h"}}
		}
	},

	{
		Voltage, {
			{SystemVoltageUnitsEnum::MilliVolt, {0.001, "mV"}},
			{SystemVoltageUnitsEnum::Volt,      {1.0,   "V"}}
		}
	},
};

const QMap<SystemUnits::SystemQuantityEnum, SystemSettings::SystemSettingsEnum> SystemUnits::SystemUnitsSettingsMap {
	{Distance,  SystemSettings::UnitsDistance},
	{Speed,     SystemSettings::UnitsSpeed},
	{Voltage,   SystemSettings::UnitsVoltage},
};
