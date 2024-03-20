#include "BatteryStatus.h"


BatteryStatus::BatteryStatus(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("BATTERY1_VOLTAGE", qQNaN());
	variable.add("BATTERY1_CURRENT", qQNaN());

	variable.add("BATTERY2_VOLTAGE", qQNaN());
	variable.add("BATTERY2_CURRENT", qQNaN());
}

void BatteryStatus::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_BATTERY_STATUS) { return; }

	mavlink_battery_status_t battery_status;
	mavlink_msg_battery_status_decode(&message, &battery_status);

	if (battery_status.id == 0) {
		variable.setValue("BATTERY1_VOLTAGE", getVoltage(battery_status.voltages), true);
		variable.setValue("BATTERY1_CURRENT", getCurrent(battery_status.current_battery), true);
	}

	if (battery_status.id == 1) {
		variable.setValue("BATTERY2_VOLTAGE", getVoltage(battery_status.voltages), true);
		variable.setValue("BATTERY2_CURRENT", getCurrent(battery_status.current_battery), true);
	}
}

double BatteryStatus::getVoltage(const uint16_t *cell)
{
	double voltage = qQNaN();

	for (uint8_t i = 0 ; i < MAVLINK_MSG_BATTERY_STATUS_FIELD_VOLTAGES_LEN ; ++i) {
		const double tmp = (cell[i] == UINT16_MAX) ? qQNaN() : (cell[i] / 1.0e3);

		if (qIsNaN(tmp)) {
			break;
		}

		if (i == 0) {
			voltage = tmp;

		} else {
			voltage += tmp;
		}
	}

	return voltage;
}

double BatteryStatus::getCurrent(const int16_t &current)
{
	return (current == -1) ? qQNaN() : (current / 1.0e2);
}
