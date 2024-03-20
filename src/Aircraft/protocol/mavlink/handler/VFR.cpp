#include "VFR.h"


VFR::VFR(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("VFR_AIRSPEED");
	variable.add("VFR_GROUNDSPEED");
	variable.add("VFR_ALT");
	variable.add("VFR_CLIMB");
	variable.add("VFR_HEADING");
	variable.add("VFR_THROTTLE");
}

void VFR::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_VFR_HUD) { return; }

	mavlink_vfr_hud_t vfr_hud;
	mavlink_msg_vfr_hud_decode(&message, &vfr_hud);

	variable.setValue("VFR_AIRSPEED",    vfr_hud.airspeed);
	variable.setValue("VFR_GROUNDSPEED", vfr_hud.groundspeed);
	variable.setValue("VFR_ALT",         vfr_hud.alt);
	variable.setValue("VFR_CLIMB",       vfr_hud.climb);
	variable.setValue("VFR_HEADING",     vfr_hud.heading);
	variable.setValue("VFR_THROTTLE",    vfr_hud.throttle);

	emit variable.notifyChanges("VFR");
}
