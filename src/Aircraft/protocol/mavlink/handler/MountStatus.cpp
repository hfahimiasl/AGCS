#include "MountStatus.h"


MountStatus::MountStatus(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("MOUNT_PITCH");
	variable.add("MOUNT_ROLL");
	variable.add("MOUNT_YAW");
}

void MountStatus::handle(const mavlink_message_t &message)
{
	if (message.msgid == MAVLINK_MSG_ID_MOUNT_ORIENTATION) {
		mavlink_mount_orientation_t mount_orientation {};
		mavlink_msg_mount_orientation_decode(&message, &mount_orientation);

		qDebug() << "TODO:" << mount_orientation.roll << mount_orientation.pitch << mount_orientation.yaw;
	}

	if (message.msgid != MAVLINK_MSG_ID_MOUNT_STATUS) { return; }

	mavlink_mount_status_t mount_status {};
	mavlink_msg_mount_status_decode(&message, &mount_status);

	variable.setValue("MOUNT_PITCH", double(mount_status.pointing_a) / 100.0);
	variable.setValue("MOUNT_ROLL", double(mount_status.pointing_b) / 100.0);
	variable.setValue("MOUNT_YAW", double(mount_status.pointing_c) / 100.0);

	qDebug() << "TODO:" << variable.getValue("MOUNT_YAW");

	emit variable.notifyChanges("MOUNT");
}
