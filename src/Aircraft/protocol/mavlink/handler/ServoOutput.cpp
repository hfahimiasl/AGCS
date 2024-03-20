#include "ServoOutput.h"


ServoOutput::ServoOutput(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("SERVO_PORT");
	variable.add("SERVO1_RAW");
	variable.add("SERVO2_RAW");
	variable.add("SERVO3_RAW");
	variable.add("SERVO4_RAW");
	variable.add("SERVO5_RAW");
	variable.add("SERVO6_RAW");
	variable.add("SERVO7_RAW");
	variable.add("SERVO8_RAW");
	variable.add("SERVO9_RAW");
	variable.add("SERVO10_RAW");
	variable.add("SERVO11_RAW");
	variable.add("SERVO12_RAW");
	variable.add("SERVO13_RAW");
	variable.add("SERVO14_RAW");
	variable.add("SERVO15_RAW");
	variable.add("SERVO16_RAW");
}

void ServoOutput::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_SERVO_OUTPUT_RAW) { return; }

	mavlink_servo_output_raw_t servo_output_raw;
	mavlink_msg_servo_output_raw_decode(&message, &servo_output_raw);

	variable.setValue("SERVO_PORT", servo_output_raw.port);
	variable.setValue("SERVO1_RAW", servo_output_raw.servo1_raw);
	variable.setValue("SERVO2_RAW", servo_output_raw.servo2_raw);
	variable.setValue("SERVO3_RAW", servo_output_raw.servo3_raw);
	variable.setValue("SERVO4_RAW", servo_output_raw.servo4_raw);
	variable.setValue("SERVO5_RAW", servo_output_raw.servo5_raw);
	variable.setValue("SERVO6_RAW", servo_output_raw.servo6_raw);
	variable.setValue("SERVO7_RAW", servo_output_raw.servo7_raw);
	variable.setValue("SERVO8_RAW", servo_output_raw.servo8_raw);
	variable.setValue("SERVO9_RAW", servo_output_raw.servo9_raw);
	variable.setValue("SERVO10_RAW", servo_output_raw.servo10_raw);
	variable.setValue("SERVO11_RAW", servo_output_raw.servo11_raw);
	variable.setValue("SERVO12_RAW", servo_output_raw.servo12_raw);
	variable.setValue("SERVO13_RAW", servo_output_raw.servo13_raw);
	variable.setValue("SERVO14_RAW", servo_output_raw.servo14_raw);
	variable.setValue("SERVO15_RAW", servo_output_raw.servo15_raw);
	variable.setValue("SERVO16_RAW", servo_output_raw.servo16_raw);

	emit variable.notifyChanges("SERVO");
}
