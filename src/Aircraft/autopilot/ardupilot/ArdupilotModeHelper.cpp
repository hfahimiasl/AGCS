#include "ArdupilotModeHelper.h"


ArdupilotModeHelper::ArdupilotModeHelper()
{
	for (QString key : plane_flight_modes.keys()) {
		plane_flight_modes_param_base.insert(plane_flight_modes[key], key);
	}

	for (QString key : multirotor_flight_modes.keys()) {
		multirotor_flight_modes_param_base.insert(multirotor_flight_modes[key], key);
	}

	//	variable.add("AIRCRAFT_FLIGHT_MODE");

	//	QObject::connect(&variable, &Variable::notifyChanges,
	//	this, [this](QString id) {
	//		if (id == "CUSTOM_MODE") {
	//			variable.setText("AIRCRAFT_FLIGHT_MODE", get(), true);
	//		}
	//	});
}

ArdupilotModeHelper *ArdupilotModeHelper::instance()
{
	static ArdupilotModeHelper ardupilot_mode_helper;
	return &ardupilot_mode_helper;
}

QList<QString> ArdupilotModeHelper::getAll()
{
	QList<QString> list;
	list.clear();

	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		for (QString key : plane_flight_modes.keys()) {
			list.append(key);
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		for (QString key : multirotor_flight_modes.keys()) {
			list.append(key);
		}

		break;

	default:
		list.append("N/A");
		break;
	}

	return list;
}

QString ArdupilotModeHelper::get(uint8_t index)
{
	QString ret = "N/A";

	const QVariant fltmode = ParamService::instance()->get(QString("FLTMODE%1").arg(index))->getValue();

	if (fltmode != QVariant::Invalid) {
		switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
		case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
			if (plane_flight_modes_param_base.contains(uint8_t(fltmode.toUInt()))) {
				ret = plane_flight_modes_param_base[uint8_t(fltmode.toUInt())];
			}

			break;

		case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
			if (multirotor_flight_modes_param_base.contains(uint8_t(fltmode.toUInt()))) {
				ret = multirotor_flight_modes_param_base[uint8_t(fltmode.toUInt())];
			}

			break;

		default:
			break;
		}
	}

	return ret;
}

bool ArdupilotModeHelper::set(uint8_t index, QString mode)
{
	bool ret = false;

	const QString fltmode = QString("FLTMODE%1").arg(index);

	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		if (index != 0 && index <= 6 && plane_flight_modes.contains(mode)) {
			emit ParamService::instance()->notifyUpload(fltmode, plane_flight_modes[mode]);
			ret = true;
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		if (index != 0 && index <= 6 && multirotor_flight_modes.contains(mode)) {
			emit ParamService::instance()->notifyUpload(fltmode, multirotor_flight_modes[mode]);
			ret = true;
		}

		break;

	default:
		break;
	}

	return ret;
}

QList<QString> ArdupilotModeHelper::getAvailableChannels()
{
	QList<QString> ret;
	ret.clear();

	const QVariant used_channels[] = {
		ParamService::instance()->get("RCMAP_ROLL")->getValue(),
		ParamService::instance()->get("RCMAP_PITCH")->getValue(),
		ParamService::instance()->get("RCMAP_THROTTLE")->getValue(),
		ParamService::instance()->get("RCMAP_YAW")->getValue()
	};

	bool params_available = true;

	for (uint8_t i = 0 ; i < 4 ; i++) {
		if (used_channels[i] == QVariant::Invalid) {
			params_available = false;
			break;
		}
	}

	if (params_available) {
		for (uint8_t i = 1 ; i <= uint8_t(variable.getValue("REMOTE_CONTROL_CHANCOUNT")) ; i++) {
			if (i != used_channels[0].toUInt()
			    && i != used_channels[1].toUInt()
			    && i != used_channels[2].toUInt()
			    && i != used_channels[3].toUInt()) {
				ret.append(QString("%1").arg(i));
			}
		}
	}

	return ret;
}

int8_t ArdupilotModeHelper::getChannel()
{
	const QVariant param = ParamService::instance()->get("FLTMODE_CH")->getValue();
	return param == QVariant::Invalid ? -1 : int8_t(param.toUInt());
}

bool ArdupilotModeHelper::setChannel(uint8_t channel)
{
	bool ret = false;

	if (channel <= variable.getValue("REMOTE_CONTROL_CHANCOUNT")) {
		emit ParamService::instance()->notifyUpload("FLTMODE_CH", channel);
		ret = true;
	}

	return ret;
}

QString ArdupilotModeHelper::get()
{
	QString ret = "N/A";

	const uint8_t custom_mode = uint8_t(variable.getValue("CUSTOM_MODE"));

	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		if (plane_flight_modes_param_base.contains(custom_mode)) {
			ret = plane_flight_modes_param_base[custom_mode];
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		if (multirotor_flight_modes_param_base.contains(custom_mode)) {
			ret = multirotor_flight_modes_param_base[custom_mode];
		}

		break;

	default:
		break;
	}

	return ret;
}

bool ArdupilotModeHelper::set(QString mode)
{
	bool ret = false;

	switch (AIRCRAFT_TYPE(uint8_t(variable.getValue("AIRCRAFT_TYPE")))) {
	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING:
		if (plane_flight_modes.contains(mode)) {
			MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_DO_SET_MODE, 0, 1, plane_flight_modes[mode], 0, 0, 0, 0, 0);
			ret = true;
		}

		break;

	case AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR:
		if (multirotor_flight_modes.contains(mode)) {
			MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_DO_SET_MODE, 0, 1, multirotor_flight_modes[mode], 0, 0, 0, 0, 0);
			ret = true;
		}

		break;

	default:
		break;
	}

	return ret;
}
