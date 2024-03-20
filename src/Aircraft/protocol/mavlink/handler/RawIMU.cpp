#include "RawIMU.h"


RawIMU::RawIMU(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("RAW_IMU_XACC");
	variable.add("RAW_IMU_YACC");
	variable.add("RAW_IMU_ZACC");
	variable.add("RAW_IMU_XGYRO");
	variable.add("RAW_IMU_YGYRO");
	variable.add("RAW_IMU_ZGYRO");
	variable.add("RAW_IMU_XMAG");
	variable.add("RAW_IMU_YMAG");
	variable.add("RAW_IMU_ZMAG");
	variable.add("RAW_IMU_TEMP");
	variable.add("RAW_IMU_ID");
}

void RawIMU::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_RAW_IMU) { return; }

	mavlink_raw_imu_t raw_imu;
	mavlink_msg_raw_imu_decode(&message, &raw_imu);

	variable.setValue("RAW_IMU_XACC", raw_imu.xacc);
	variable.setValue("RAW_IMU_YACC", raw_imu.yacc);
	variable.setValue("RAW_IMU_ZACC", raw_imu.zacc);
	variable.setValue("RAW_IMU_XGYRO", raw_imu.xgyro);
	variable.setValue("RAW_IMU_YGYRO", raw_imu.ygyro);
	variable.setValue("RAW_IMU_ZGYRO", raw_imu.zgyro);
	variable.setValue("RAW_IMU_XMAG", raw_imu.xmag);
	variable.setValue("RAW_IMU_YMAG", raw_imu.ymag);
	variable.setValue("RAW_IMU_ZMAG", raw_imu.zmag);
	variable.setValue("RAW_IMU_TEMP", raw_imu.temperature);
	variable.setValue("RAW_IMU_ID", raw_imu.id);

	emit variable.notifyChanges("RAW_IMU");
}
