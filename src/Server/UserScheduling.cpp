#include "UserScheduling.h"


UserScheduling::UserScheduling() :
	user_timer(new QTimer(this)),
	upload_timer(new QTimer(this)),
	upload_manager(new QNetworkAccessManager(this)),
	web_socket(new WebSocket(this)),
	up_time(Settings::instance()->get(SystemSettings::UserUpTime).toULongLong()),
	connection_time(Settings::instance()->get(SystemSettings::UserAircraftConnectionTime).toULongLong()),
	arm_time(Settings::instance()->get(SystemSettings::UserAircraftArmTime).toULongLong())
{
	QObject::connect(user_timer, &QTimer::timeout, this, QOverload<>::of(&UserScheduling::update));
	//	user_timer->start(1_s);

	QObject::connect(upload_timer, &QTimer::timeout, this, QOverload<>::of(&UserScheduling::upload));

	QObject::connect(web_socket, &WebSocket::disconnected, upload_timer, &QTimer::stop);

	QObject::connect(Server::instance(), &Server::connectedChanged, this, [ = ](const bool & connected) {
		if (connected) {
			web_socket->open(QUrl("ws://api.adlanpaya.ir/websocket/agcs/log"));
			upload_timer->start(1_s);

		} else {
			web_socket->close();
			upload_timer->stop();
		}
	});
}

UserScheduling *UserScheduling::instance()
{
	static UserScheduling self;
	return &self;
}

void UserScheduling::update()
{
	//	up_time += 1_s;
	//	Settings::instance()->set(SystemSettings::UserUpTime, up_time);

	//	if (Link::instance()->isConnected()) {
	//		connection_time += 1_s;
	//		Settings::instance()->set(SystemSettings::UserAircraftConnectionTime, connection_time);
	//	}

	//	if (static_cast<int>(variable.getValue("ARM_STATUS"))) {
	//		arm_time += 1_s;
	//		Settings::instance()->set(SystemSettings::UserAircraftArmTime, arm_time);
	//	}
}

void UserScheduling::upload()
{
	QString message;
	message.append("{\n" + getDataFormat(1).arg("secret").arg(Settings::instance()->get(SystemSettings::UserAccessToken).toString()));
	message.append("\t\"drone_information\": {\n");
	message.append(getDataFormat(2).arg("firmware_version_number").arg(variable.getText("AUTOPILOT_VERSION_NUMBER")));
	message.append(getDataFormat(2).arg("firmware_version_type").arg(variable.getText("AUTOPILOT_VERSION_TYPE")));
	message.append(getDataFormat(2).arg("firmware_version_git_hash").arg(variable.getText("AUTOPILOT_VERSION_GIT_HASH")));
	message.append(getDataFormat(2).arg("firmware_type").arg(variable.getText("AUTOPILOT_TYPE").split("_").last().toLower()));
	message.append(getDataFormat(2, false).arg("aircraft_type").arg(variable.getText("AIRCRAFT_TYPE").toLower()));
	message.append("\t},\n\t\"software_information\": {\n");
	message.append(getDataFormat(2).arg("version").arg(QApplication::applicationVersion()));
	message.append(getDataFormat(2).arg("platform").arg(QSysInfo::productType() + "_" + QSysInfo::currentCpuArchitecture()));
	message.append(getDataFormat(2, false).arg("hid").arg(QString(QSysInfo::machineUniqueId())));
	message.append("\t},\n\t\"data\": [\n");
	message.append("\t\t{\n");
	message.append(getDataFormat(3).arg("timestamp").arg(quint64(Clock::getTime() / 1e3)));
	message.append(getDataFormat(3).arg("altitude").arg(variable.getValue("GLOBAL_POSITION_INT_RELATIVE_ALT") / 1.0e3));
	message.append(getDataFormat(3).arg("distance").arg(variable.getValue("AIRCRAFT_3D_DISTANCE")));
	message.append(getDataFormat(3).arg("vertical_speed").arg(variable.getValue("AIRCRAFT_VERTICAL_SPEED")));
	message.append(getDataFormat(3).arg("horizontal_speed").arg(variable.getValue("AIRCRAFT_HORIZONTAL_SPEED")));
	message.append(getDataFormat(3).arg("flight_time").arg(variable.getText("FLIGHT_TIME")));
	message.append(getDataFormat(3).arg("battery_voltage").arg(variable.getValue("BATTERY1_VOLTAGE")));
	message.append(getDataFormat(3).arg("flight_mode").arg(Autopilot::instance()->getFlightMode()));
	message.append("\t\t\t\"attitude\": {\n");
	message.append(getDataFormat(4).arg("roll").arg(variable.getValue("ATTITUDE_ROLL") * -57.2958));
	message.append(getDataFormat(4).arg("pitch").arg(variable.getValue("ATTITUDE_PITCH") * 57.2958));
	message.append(getDataFormat(4, false).arg("heading").arg(variable.getValue("AIRCRAFT_HEADING")));
	message.append("\t\t\t},\n");
	message.append("\t\t\t\"gps\": {\n");
	message.append(getDataFormat(4).arg("latitude").arg(variable.getValue("GPS_RAW_LAT")));
	message.append(getDataFormat(4).arg("longitude").arg(variable.getValue("GPS_RAW_LON")));
	message.append(getDataFormat(4).arg("altitude").arg(variable.getValue("GPS_RAW_ALT")));
	message.append(getDataFormat(4, false).arg("satellites_visible").arg(variable.getValue("GPS_RAW_SATELLITES_VISIBLE")));
	message.append("\t\t\t}\n\t\t}\n\t}");
	web_socket->sendTextMessage(message);
}

QString UserScheduling::getDataFormat(const uint8_t &tabs, const bool &comma)
{
	QString format;

	for (uint8_t i = 0 ; i < tabs ; ++i) {
		format.append("\t");
	}

	return format.append(QString("\"%1\": \"%2\"") + (comma ? ",\n" : "\n"));
}
