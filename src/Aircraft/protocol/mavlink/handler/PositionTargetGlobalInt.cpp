#include "PositionTargetGlobalInt.h"


PositionTargetGlobalInt::PositionTargetGlobalInt(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("POSITION_TARGET_LAT");
	variable.add("POSITION_TARGET_LON");
}

void PositionTargetGlobalInt::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_POSITION_TARGET_GLOBAL_INT) { return; }

	mavlink_position_target_global_int_t position_target {};
	mavlink_msg_position_target_global_int_decode(&message, &position_target);

	variable.setValue("POSITION_TARGET_LAT", decodeLatLon(position_target.lat_int));
	variable.setValue("POSITION_TARGET_LON", decodeLatLon(position_target.lon_int));

	emit variable.notifyChanges("POSITION_TARGET");
}
