#include "GlobalPositionInt.h"


GlobalPositionInt::GlobalPositionInt(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("GLOBAL_POSITION_INT_LAT");
	variable.add("GLOBAL_POSITION_INT_LON");
	variable.add("GLOBAL_POSITION_INT_ALT");
	variable.add("GLOBAL_POSITION_INT_RELATIVE_ALT");
	variable.add("GLOBAL_POSITION_INT_VX");
	variable.add("GLOBAL_POSITION_INT_VY");
	variable.add("GLOBAL_POSITION_INT_VZ");
	variable.add("GLOBAL_POSITION_INT_HDG");

	variable.add("AIRCRAFT_HEADING");
	variable.add("AIRCRAFT_VERTICAL_SPEED");
	variable.add("AIRCRAFT_HORIZONTAL_SPEED");
}

void GlobalPositionInt::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_GLOBAL_POSITION_INT) { return; }

	mavlink_global_position_int_t global_position_int;
	mavlink_msg_global_position_int_decode(&message, &global_position_int);

	variable.setValue("GLOBAL_POSITION_INT_LAT",            global_position_int.lat);
	variable.setValue("GLOBAL_POSITION_INT_LON",            global_position_int.lon);
	variable.setValue("GLOBAL_POSITION_INT_ALT",            global_position_int.alt);
	variable.setValue("GLOBAL_POSITION_INT_RELATIVE_ALT",   global_position_int.relative_alt);
	variable.setValue("GLOBAL_POSITION_INT_VX",             global_position_int.vx);
	variable.setValue("GLOBAL_POSITION_INT_VY",             global_position_int.vy);
	variable.setValue("GLOBAL_POSITION_INT_VZ",             global_position_int.vz);
	variable.setValue("GLOBAL_POSITION_INT_HDG",            global_position_int.hdg);

	emit variable.notifyChanges("GLOBAL_POSITION_INT");

	const double heading = global_position_int.hdg / 100;
	const double vertical_speed = global_position_int.vz / -100.0;
	const double horizontal_speed = qSqrt(pow(global_position_int.vx / 100.0, 2) + pow(global_position_int.vy / 100.0, 2));

	variable.setValue("AIRCRAFT_HEADING", heading, true);
	variable.setValue("AIRCRAFT_VERTICAL_SPEED", vertical_speed, true);
	variable.setValue("AIRCRAFT_HORIZONTAL_SPEED", horizontal_speed, true);
}
