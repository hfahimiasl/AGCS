#include "Altitude.h"


Altitude::Altitude(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("ALTITUDE_MONOTONIC");
	variable.add("ALTITUDE_AMSL");
	variable.add("ALTITUDE_LOCAL");
	variable.add("ALTITUDE_RELATIVE");
	variable.add("ALTITUDE_TERRAIN");
	variable.add("ALTITUDE_BOTTOM_CLEARANCE");
}

void Altitude::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_ALTITUDE) { return; }

	mavlink_altitude_t altitude;
	mavlink_msg_altitude_decode(&message, &altitude);

	variable.setValue("ALTITUDE_MONOTONIC",         altitude.altitude_monotonic);
	variable.setValue("ALTITUDE_AMSL",              altitude.altitude_amsl);
	variable.setValue("ALTITUDE_LOCAL",             altitude.altitude_local);
	variable.setValue("ALTITUDE_RELATIVE",          altitude.altitude_relative);
	variable.setValue("ALTITUDE_TERRAIN",           altitude.altitude_terrain);
	variable.setValue("ALTITUDE_BOTTOM_CLEARANCE",  altitude.bottom_clearance);

	emit variable.notifyChanges("ALTITUDE");
}
