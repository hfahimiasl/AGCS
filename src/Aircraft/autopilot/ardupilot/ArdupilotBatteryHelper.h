#pragma once

#include <QObject>
#include <QMap>

#include "src/Param/ParamService.h"


class ArdupilotBatteryHelper
{
public:
	explicit ArdupilotBatteryHelper();

	static ArdupilotBatteryHelper *instance();

	bool isBatteryMonitorEnabled(const quint8 &);
	QString getBatteryMonitorOption(const quint8 &);
	QList<QString> getBatteryMonitorOptions();
	void setBatteryMonitorOption(const quint8 &, const QString &);

private:
	const QMap<QString, uint8_t> battery_monitor_option {
		{("غیرفعال"),       0},
		{("فقط ولتاژ"),     3},
		{("ولتاژ و جریان"), 4}
	};

	QMap<uint8_t, QString> battery_monitor_option_param_base;

	QString rebuildParamID(const quint8 &, QString);
};
