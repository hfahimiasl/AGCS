#include "ScaledIMU.h"


ScaledIMU::ScaledIMU(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("SCALED_IMU1_XACC");
	variable.add("SCALED_IMU1_YACC");
	variable.add("SCALED_IMU1_ZACC");
	variable.add("SCALED_IMU1_XGYRO");
	variable.add("SCALED_IMU1_YGYRO");
	variable.add("SCALED_IMU1_ZGYRO");
	variable.add("SCALED_IMU1_XMAG");
	variable.add("SCALED_IMU1_YMAG");
	variable.add("SCALED_IMU1_ZMAG");
	variable.add("SCALED_IMU1_TEMP");

	variable.add("SCALED_IMU2_XACC");
	variable.add("SCALED_IMU2_YACC");
	variable.add("SCALED_IMU2_ZACC");
	variable.add("SCALED_IMU2_XGYRO");
	variable.add("SCALED_IMU2_YGYRO");
	variable.add("SCALED_IMU2_ZGYRO");
	variable.add("SCALED_IMU2_XMAG");
	variable.add("SCALED_IMU2_YMAG");
	variable.add("SCALED_IMU2_ZMAG");
	variable.add("SCALED_IMU2_TEMP");

	variable.add("SCALED_IMU3_XACC");
	variable.add("SCALED_IMU3_YACC");
	variable.add("SCALED_IMU3_ZACC");
	variable.add("SCALED_IMU3_XGYRO");
	variable.add("SCALED_IMU3_YGYRO");
	variable.add("SCALED_IMU3_ZGYRO");
	variable.add("SCALED_IMU3_XMAG");
	variable.add("SCALED_IMU3_YMAG");
	variable.add("SCALED_IMU3_ZMAG");
	variable.add("SCALED_IMU3_TEMP");
}

void ScaledIMU::handle(const mavlink_message_t &message)
{
	if (message.msgid == MAVLINK_MSG_ID_SCALED_IMU) {
		mavlink_scaled_imu_t scaled_imu1;
		mavlink_msg_scaled_imu_decode(&message, &scaled_imu1);

		variable.setValue("SCALED_IMU1_XACC", scaled_imu1.xacc);
		variable.setValue("SCALED_IMU1_YACC", scaled_imu1.yacc);
		variable.setValue("SCALED_IMU1_ZACC", scaled_imu1.zacc);
		variable.setValue("SCALED_IMU1_XGYRO", scaled_imu1.xgyro);
		variable.setValue("SCALED_IMU1_YGYRO", scaled_imu1.ygyro);
		variable.setValue("SCALED_IMU1_ZGYRO", scaled_imu1.zgyro);
		variable.setValue("SCALED_IMU1_XMAG", scaled_imu1.xmag);
		variable.setValue("SCALED_IMU1_YMAG", scaled_imu1.ymag);
		variable.setValue("SCALED_IMU1_ZMAG", scaled_imu1.zmag);
		variable.setValue("SCALED_IMU1_TEMP", scaled_imu1.temperature);

		emit variable.notifyChanges("SCALED_IMU1");

	} else if (message.msgid == MAVLINK_MSG_ID_SCALED_IMU2) {
		mavlink_scaled_imu2_t scaled_imu2;
		mavlink_msg_scaled_imu2_decode(&message, &scaled_imu2);

		variable.setValue("SCALED_IMU2_XACC", scaled_imu2.xacc);
		variable.setValue("SCALED_IMU2_YACC", scaled_imu2.yacc);
		variable.setValue("SCALED_IMU2_ZACC", scaled_imu2.zacc);
		variable.setValue("SCALED_IMU2_XGYRO", scaled_imu2.xgyro);
		variable.setValue("SCALED_IMU2_YGYRO", scaled_imu2.ygyro);
		variable.setValue("SCALED_IMU2_ZGYRO", scaled_imu2.zgyro);
		variable.setValue("SCALED_IMU2_XMAG", scaled_imu2.xmag);
		variable.setValue("SCALED_IMU2_YMAG", scaled_imu2.ymag);
		variable.setValue("SCALED_IMU2_ZMAG", scaled_imu2.zmag);
		variable.setValue("SCALED_IMU2_TEMP", scaled_imu2.temperature);

		emit variable.notifyChanges("SCALED_IMU2");

	} else if (message.msgid == MAVLINK_MSG_ID_SCALED_IMU3) {
		mavlink_scaled_imu3_t scaled_imu3;
		mavlink_msg_scaled_imu3_decode(&message, &scaled_imu3);

		variable.setValue("SCALED_IMU3_XACC", scaled_imu3.xacc);
		variable.setValue("SCALED_IMU3_YACC", scaled_imu3.yacc);
		variable.setValue("SCALED_IMU3_ZACC", scaled_imu3.zacc);
		variable.setValue("SCALED_IMU3_XGYRO", scaled_imu3.xgyro);
		variable.setValue("SCALED_IMU3_YGYRO", scaled_imu3.ygyro);
		variable.setValue("SCALED_IMU3_ZGYRO", scaled_imu3.zgyro);
		variable.setValue("SCALED_IMU3_XMAG", scaled_imu3.xmag);
		variable.setValue("SCALED_IMU3_YMAG", scaled_imu3.ymag);
		variable.setValue("SCALED_IMU3_ZMAG", scaled_imu3.zmag);
		variable.setValue("SCALED_IMU3_TEMP", scaled_imu3.temperature);

		emit variable.notifyChanges("SCALED_IMU3");
	}
}
