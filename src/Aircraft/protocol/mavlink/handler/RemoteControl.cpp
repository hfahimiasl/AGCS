#include "RemoteControl.h"


RemoteControl::RemoteControl(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("REMOTE_CONTROL_CHAN1", 1000);
	variable.add("REMOTE_CONTROL_CHAN2", 1000);
	variable.add("REMOTE_CONTROL_CHAN3", 1000);
	variable.add("REMOTE_CONTROL_CHAN4", 1000);
	variable.add("REMOTE_CONTROL_CHAN5", 1000);
	variable.add("REMOTE_CONTROL_CHAN6", 1000);
	variable.add("REMOTE_CONTROL_CHAN7", 1000);
	variable.add("REMOTE_CONTROL_CHAN8", 1000);
	variable.add("REMOTE_CONTROL_CHAN9", 1000);
	variable.add("REMOTE_CONTROL_CHAN10", 1000);
	variable.add("REMOTE_CONTROL_CHAN11", 1000);
	variable.add("REMOTE_CONTROL_CHAN12", 1000);
	variable.add("REMOTE_CONTROL_CHAN13", 1000);
	variable.add("REMOTE_CONTROL_CHAN14", 1000);
	variable.add("REMOTE_CONTROL_CHAN15", 1000);
	variable.add("REMOTE_CONTROL_CHAN16", 1000);
	variable.add("REMOTE_CONTROL_CHAN17", 1000);
	variable.add("REMOTE_CONTROL_CHAN18", 1000);
	variable.add("REMOTE_CONTROL_CHANCOUNT");
	variable.add("REMOTE_CONTROL_RSSI", 255);
}

void RemoteControl::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_RC_CHANNELS) { return; }

	mavlink_rc_channels_t rc_channels;
	mavlink_msg_rc_channels_decode(&message, &rc_channels);

	variable.setValue("REMOTE_CONTROL_CHAN1", rc_channels.chan1_raw);
	variable.setValue("REMOTE_CONTROL_CHAN2", rc_channels.chan2_raw);
	variable.setValue("REMOTE_CONTROL_CHAN3", rc_channels.chan3_raw);
	variable.setValue("REMOTE_CONTROL_CHAN4", rc_channels.chan4_raw);
	variable.setValue("REMOTE_CONTROL_CHAN5", rc_channels.chan5_raw);
	variable.setValue("REMOTE_CONTROL_CHAN6", rc_channels.chan6_raw);
	variable.setValue("REMOTE_CONTROL_CHAN7", rc_channels.chan7_raw);
	variable.setValue("REMOTE_CONTROL_CHAN8", rc_channels.chan8_raw);
	variable.setValue("REMOTE_CONTROL_CHAN9", rc_channels.chan9_raw);
	variable.setValue("REMOTE_CONTROL_CHAN10", rc_channels.chan10_raw);
	variable.setValue("REMOTE_CONTROL_CHAN11", rc_channels.chan11_raw);
	variable.setValue("REMOTE_CONTROL_CHAN12", rc_channels.chan12_raw);
	variable.setValue("REMOTE_CONTROL_CHAN13", rc_channels.chan13_raw);
	variable.setValue("REMOTE_CONTROL_CHAN14", rc_channels.chan14_raw);
	variable.setValue("REMOTE_CONTROL_CHAN15", rc_channels.chan15_raw);
	variable.setValue("REMOTE_CONTROL_CHAN16", rc_channels.chan16_raw);
	variable.setValue("REMOTE_CONTROL_CHAN17", rc_channels.chan17_raw);
	variable.setValue("REMOTE_CONTROL_CHAN18", rc_channels.chan18_raw);
	variable.setValue("REMOTE_CONTROL_CHANCOUNT", rc_channels.chancount);
	variable.setValue("REMOTE_CONTROL_RSSI", rc_channels.rssi);

	emit variable.notifyChanges("REMOTE_CONTROL");
}
