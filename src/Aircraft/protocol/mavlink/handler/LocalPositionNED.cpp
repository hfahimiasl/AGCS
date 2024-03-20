#include "LocalPositionNED.h"


LocalPositionNED::LocalPositionNED(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("LOCAL_POSITION_NED_X");
	variable.add("LOCAL_POSITION_NED_Y");
	variable.add("LOCAL_POSITION_NED_Z");
	variable.add("LOCAL_POSITION_NED_VX");
	variable.add("LOCAL_POSITION_NED_VY");
	variable.add("LOCAL_POSITION_NED_VZ");
}

void LocalPositionNED::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_LOCAL_POSITION_NED) { return; }

	mavlink_local_position_ned_t local_position_ned;
	mavlink_msg_local_position_ned_decode(&message, &local_position_ned);

	variable.setValue("LOCAL_POSITION_NED_X",   local_position_ned.x);
	variable.setValue("LOCAL_POSITION_NED_Y",   local_position_ned.y);
	variable.setValue("LOCAL_POSITION_NED_Z",   local_position_ned.z);
	variable.setValue("LOCAL_POSITION_NED_VX",  local_position_ned.vx);
	variable.setValue("LOCAL_POSITION_NED_VY",  local_position_ned.vy);
	variable.setValue("LOCAL_POSITION_NED_VZ",  local_position_ned.vz);

	emit variable.notifyChanges("LOCAL_POSITION_NED");
}
