#include "AutopilotVersion.h"


AutopilotVersion::AutopilotVersion(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("AUTOPILOT_VERSION_NUMBER", -1, "N/A");
	variable.add("AUTOPILOT_VERSION_TYPE", -1, "N/A");
	variable.add("AUTOPILOT_VERSION_GIT_HASH", -1, "N/A");
}

void AutopilotVersion::handle(const mavlink_message_t &message)
{
	// Send MAV_CMD_REQUEST_MESSAGE with mavlink command long to get this message

	if (message.msgid != MAVLINK_MSG_ID_AUTOPILOT_VERSION) { return; }

	mavlink_autopilot_version_t autopilot_version {};
	mavlink_msg_autopilot_version_decode(&message, &autopilot_version);

	if (autopilot_version.flight_sw_version == 0) {
		return;
	}

	variable.setText("AUTOPILOT_VERSION_NUMBER", QString("%1.%2.%3")
			 .arg((autopilot_version.flight_sw_version >> (8 * 3)) & 0xFF)
			 .arg((autopilot_version.flight_sw_version >> (8 * 2)) & 0xFF)
			 .arg((autopilot_version.flight_sw_version >> (8 * 1)) & 0xFF));

	const FIRMWARE_VERSION_TYPE version_type = static_cast<FIRMWARE_VERSION_TYPE>((autopilot_version.flight_sw_version >>(8 * 0)) & 0xFF);

	switch (version_type) {
	case FIRMWARE_VERSION_TYPE::FIRMWARE_VERSION_TYPE_DEV:
		variable.setText("AUTOPILOT_VERSION_TYPE", "dev");
		break;

	case FIRMWARE_VERSION_TYPE::FIRMWARE_VERSION_TYPE_ALPHA:
		variable.setText("AUTOPILOT_VERSION_TYPE", "alpha");
		break;

	case FIRMWARE_VERSION_TYPE::FIRMWARE_VERSION_TYPE_BETA:
		variable.setText("AUTOPILOT_VERSION_TYPE", "beta");
		break;

	case FIRMWARE_VERSION_TYPE::FIRMWARE_VERSION_TYPE_RC:
		variable.setText("AUTOPILOT_VERSION_TYPE", "rc");
		break;

	case FIRMWARE_VERSION_TYPE::FIRMWARE_VERSION_TYPE_OFFICIAL:
		variable.setText("AUTOPILOT_VERSION_TYPE", "official");
		break;

	default:
		variable.setText("AUTOPILOT_VERSION_TYPE", "N/A");
		break;
	}

	variable.setValue("AUTOPILOT_VERSION_TYPE", version_type);

	variable.setText("AUTOPILOT_VERSION_GIT_HASH", QString(QByteArray((char *)autopilot_version.flight_custom_version,
			 MAVLINK_MSG_AUTOPILOT_VERSION_FIELD_FLIGHT_CUSTOM_VERSION_LEN).trimmed()));

	emit variable.notifyChanges("AUTOPILOT_VERSION");
}
