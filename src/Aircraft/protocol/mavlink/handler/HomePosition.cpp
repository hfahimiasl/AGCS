#include "HomePosition.h"


HomePosition::HomePosition(MAVLink *mavlink) :
	AbstractHandler(mavlink),
	timer(new QTimer(this))
{
	variable.add("HOME_POS_LAT");
	variable.add("HOME_POS_LON");
	variable.add("HOME_POS_ALT");

	variable.add("TAKEOFF_POS_LAT");
	variable.add("TAKEOFF_POS_LON");
	variable.add("TAKEOFF_POS_ALT");

	QObject::connect(timer, &QTimer::timeout,
			 this, QOverload<>::of(&HomePosition::request));

	timer->start(1000);
}

HomePosition::~HomePosition()
{
	delete timer;
}

void HomePosition::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_HOME_POSITION) { return; }

	mavlink_home_position_t home_position {};
	mavlink_msg_home_position_decode(&message, &home_position);

	const QGeoCoordinate home_coordinate(decodeLatLon(home_position.latitude), decodeLatLon(home_position.longitude),
					     decodeAltitude(home_position.altitude));

	variable.setValue("HOME_POS_LAT", home_coordinate.latitude());
	variable.setValue("HOME_POS_LON", home_coordinate.longitude());
	variable.setValue("HOME_POS_ALT", home_coordinate.altitude());

	emit variable.notifyChanges("HOME_POS");

	variable.setValue("TAKEOFF_POS_LAT", double(home_position.approach_x));
	variable.setValue("TAKEOFF_POS_LON", double(home_position.approach_y));
	variable.setValue("TAKEOFF_POS_ALT", double(home_position.approach_z));

	emit variable.notifyChanges("TAKEOFF_POS");
}

void HomePosition::request()
{
	if (Link::instance()->isConnected()) {
		mavlink->writeCommandLong(MAV_CMD::MAV_CMD_GET_HOME_POSITION, 0, 0, 0, 0, 0, 0, 0, 0);
	}
}
