#include "Attitude.h"


Attitude::Attitude(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("ATTITUDE_ROLL");
	variable.add("ATTITUDE_PITCH");
	variable.add("ATTITUDE_YAW");
	variable.add("ATTITUDE_ROLLSPEED");
	variable.add("ATTITUDE_PITCHSPEED");
	variable.add("ATTITUDE_YAWSPEED");
}

void Attitude::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_ATTITUDE) { return; }

	mavlink_attitude_t attitude;
	mavlink_msg_attitude_decode(&message, &attitude);

	variable.setValue("ATTITUDE_ROLL",       attitude.roll);
	variable.setValue("ATTITUDE_PITCH",      attitude.pitch);
	variable.setValue("ATTITUDE_YAW",        attitude.yaw);
	variable.setValue("ATTITUDE_ROLLSPEED",  attitude.rollspeed);
	variable.setValue("ATTITUDE_PITCHSPEED", attitude.pitchspeed);
	variable.setValue("ATTITUDE_YAWSPEED",   attitude.yawspeed);

	emit variable.notifyChanges("ATTITUDE");
}
