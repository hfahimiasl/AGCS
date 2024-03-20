#include "ArdupilotBatteryHelper.h"


ArdupilotBatteryHelper::ArdupilotBatteryHelper()
{
	for (const QString &i : battery_monitor_option.keys()) {
		battery_monitor_option_param_base.insert(battery_monitor_option.value(i), i);
	}
}

ArdupilotBatteryHelper *ArdupilotBatteryHelper::instance()
{
	static ArdupilotBatteryHelper self;
	return &self;
}

bool ArdupilotBatteryHelper::isBatteryMonitorEnabled(const quint8 &id)
{
	const QVariant param = ParamService::instance()->get(rebuildParamID(id, "BATT_MONITOR"))->getValue();
	return param != QVariant::Invalid && param.toInt() != 0;
}

QString ArdupilotBatteryHelper::getBatteryMonitorOption(const quint8 &id)
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get(rebuildParamID(id, "BATT_MONITOR"))->getValue();

	if (param != QVariant::Invalid && battery_monitor_option_param_base.contains(uint8_t(param.toUInt()))) {
		ret = battery_monitor_option_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotBatteryHelper::getBatteryMonitorOptions()
{
	QList<QString> list;

	for (const QString &i : battery_monitor_option.keys()) {
		list.append(i);
	}

	return list;
}

void ArdupilotBatteryHelper::setBatteryMonitorOption(const quint8 &id, const QString &option)
{
	if (battery_monitor_option.contains(option)) {
		emit ParamService::instance()->notifyUpload(rebuildParamID(id, "BATT_MONITOR"), battery_monitor_option.value(option));
	}
}

QString ArdupilotBatteryHelper::rebuildParamID(const quint8 &id, QString name)
{
	return id == 1 ? name : name.insert(4, QString::number(id));
}
