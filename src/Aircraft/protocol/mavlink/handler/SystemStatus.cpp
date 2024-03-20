#include "SystemStatus.h"


SystemStatus::SystemStatus(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("SYS_STATUS_AHRS_PRESENT");
	variable.add("SYS_STATUS_AHRS_ENABLED");
	variable.add("SYS_STATUS_AHRS_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_GYRO1_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_GYRO1_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_GYRO1_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_ACCEL1_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_ACCEL1_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_ACCEL1_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_MAG1_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_MAG1_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_MAG1_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_GYRO2_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_GYRO2_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_GYRO2_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_ACCEL2_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_ACCEL2_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_ACCEL2_HEALTH");

	variable.add("SYS_STATUS_SENSOR_3D_MAG2_PRESENT");
	variable.add("SYS_STATUS_SENSOR_3D_MAG2_ENABLED");
	variable.add("SYS_STATUS_SENSOR_3D_MAG2_HEALTH");

	variable.add("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_PRESENT");
	variable.add("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_ENABLED");
	variable.add("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_HEALTH");

	variable.add("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_PRESENT");
	variable.add("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_ENABLED");
	variable.add("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_HEALTH");

	variable.add("SYS_STATUS_SENSOR_GPS_PRESENT");
	variable.add("SYS_STATUS_SENSOR_GPS_ENABLED");
	variable.add("SYS_STATUS_SENSOR_GPS_HEALTH");

	variable.add("SYS_STATUS_SENSOR_OPTICAL_FLOW_PRESENT");
	variable.add("SYS_STATUS_SENSOR_OPTICAL_FLOW_ENABLED");
	variable.add("SYS_STATUS_SENSOR_OPTICAL_FLOW_HEALTH");

	variable.add("SYS_STATUS_SENSOR_VISION_POSITION_PRESENT");
	variable.add("SYS_STATUS_SENSOR_VISION_POSITION_ENABLED");
	variable.add("SYS_STATUS_SENSOR_VISION_POSITION_HEALTH");

	variable.add("SYS_STATUS_SENSOR_LASER_POSITION_PRESENT");
	variable.add("SYS_STATUS_SENSOR_LASER_POSITION_ENABLED");
	variable.add("SYS_STATUS_SENSOR_LASER_POSITION_HEALTH");

	variable.add("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_PRESENT");
	variable.add("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_ENABLED");
	variable.add("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_HEALTH");

	variable.add("SYS_STATUS_SENSOR_RC_RECEIVER_PRESENT");
	variable.add("SYS_STATUS_SENSOR_RC_RECEIVER_ENABLED");
	variable.add("SYS_STATUS_SENSOR_RC_RECEIVER_HEALTH");

	variable.add("SYS_STATUS_PREARM_CHECK_PRESENT");
	variable.add("SYS_STATUS_PREARM_CHECK_ENABLED");
	variable.add("SYS_STATUS_PREARM_CHECK_HEALTH");

	variable.add("SYS_STATUS_OBSTACLE_AVOIDANCE_PRESENT");
	variable.add("SYS_STATUS_OBSTACLE_AVOIDANCE_ENABLED");
	variable.add("SYS_STATUS_OBSTACLE_AVOIDANCE_HEALTH");

	variable.add("SYS_STATUS_SENSOR_BATTERY_PRESENT");
	variable.add("SYS_STATUS_SENSOR_BATTERY_ENABLED");
	variable.add("SYS_STATUS_SENSOR_BATTERY_HEALTH");

	variable.add("SYS_STATUS_BATTERY_VOLTAGE");
	variable.add("SYS_STATUS_BATTERY_CURRENT");
	variable.add("SYS_STATUS_BATTERY_REMAINING", -1);
}

void SystemStatus::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_SYS_STATUS) { return; }

	mavlink_sys_status_t sys_status;
	mavlink_msg_sys_status_decode(&message, &sys_status);

	variable.setValue("SYS_STATUS_AHRS_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_AHRS);
	variable.setValue("SYS_STATUS_AHRS_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_AHRS);
	variable.setValue("SYS_STATUS_AHRS_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_AHRS);

	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO1_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO);
	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO1_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO);
	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO1_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO);

	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL1_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL);
	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL1_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL);
	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL1_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL);

	variable.setValue("SYS_STATUS_SENSOR_3D_MAG1_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG);
	variable.setValue("SYS_STATUS_SENSOR_3D_MAG1_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG);
	variable.setValue("SYS_STATUS_SENSOR_3D_MAG1_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG);

	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO2_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO2);
	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO2_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO2);
	variable.setValue("SYS_STATUS_SENSOR_3D_GYRO2_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_GYRO2);

	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL2_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL2);
	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL2_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL2);
	variable.setValue("SYS_STATUS_SENSOR_3D_ACCEL2_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_ACCEL2);

	variable.setValue("SYS_STATUS_SENSOR_3D_MAG2_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG2);
	variable.setValue("SYS_STATUS_SENSOR_3D_MAG2_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG2);
	variable.setValue("SYS_STATUS_SENSOR_3D_MAG2_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_3D_MAG2);

	variable.setValue("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE);
	variable.setValue("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE);
	variable.setValue("SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE);

	variable.setValue("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE);
	variable.setValue("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE);
	variable.setValue("SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE);

	variable.setValue("SYS_STATUS_SENSOR_GPS_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_GPS);
	variable.setValue("SYS_STATUS_SENSOR_GPS_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_GPS);
	variable.setValue("SYS_STATUS_SENSOR_GPS_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_GPS);

	variable.setValue("SYS_STATUS_SENSOR_OPTICAL_FLOW_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_OPTICAL_FLOW);
	variable.setValue("SYS_STATUS_SENSOR_OPTICAL_FLOW_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_OPTICAL_FLOW);
	variable.setValue("SYS_STATUS_SENSOR_OPTICAL_FLOW_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_OPTICAL_FLOW);

	variable.setValue("SYS_STATUS_SENSOR_VISION_POSITION_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_VISION_POSITION);
	variable.setValue("SYS_STATUS_SENSOR_VISION_POSITION_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_VISION_POSITION);
	variable.setValue("SYS_STATUS_SENSOR_VISION_POSITION_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_VISION_POSITION);

	variable.setValue("SYS_STATUS_SENSOR_LASER_POSITION_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_LASER_POSITION);
	variable.setValue("SYS_STATUS_SENSOR_LASER_POSITION_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_LASER_POSITION);
	variable.setValue("SYS_STATUS_SENSOR_LASER_POSITION_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_LASER_POSITION);

	variable.setValue("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_MOTOR_OUTPUTS);
	variable.setValue("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_MOTOR_OUTPUTS);
	variable.setValue("SYS_STATUS_SENSOR_MOTOR_OUTPUTS_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_MOTOR_OUTPUTS);

	variable.setValue("SYS_STATUS_SENSOR_RC_RECEIVER_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_RC_RECEIVER);
	variable.setValue("SYS_STATUS_SENSOR_RC_RECEIVER_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_RC_RECEIVER);
	variable.setValue("SYS_STATUS_SENSOR_RC_RECEIVER_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_RC_RECEIVER);

	variable.setValue("SYS_STATUS_PREARM_CHECK_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_PREARM_CHECK);
	variable.setValue("SYS_STATUS_PREARM_CHECK_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_PREARM_CHECK);
	variable.setValue("SYS_STATUS_PREARM_CHECK_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_PREARM_CHECK);

	variable.setValue("SYS_STATUS_OBSTACLE_AVOIDANCE_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_OBSTACLE_AVOIDANCE);
	variable.setValue("SYS_STATUS_OBSTACLE_AVOIDANCE_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_OBSTACLE_AVOIDANCE);
	variable.setValue("SYS_STATUS_OBSTACLE_AVOIDANCE_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_OBSTACLE_AVOIDANCE);

	variable.setValue("SYS_STATUS_SENSOR_BATTERY_PRESENT",
			  sys_status.onboard_control_sensors_present & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_BATTERY);
	variable.setValue("SYS_STATUS_SENSOR_BATTERY_ENABLED",
			  sys_status.onboard_control_sensors_enabled & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_BATTERY);
	variable.setValue("SYS_STATUS_SENSOR_BATTERY_HEALTH",
			  sys_status.onboard_control_sensors_health  & MAV_SYS_STATUS_SENSOR::MAV_SYS_STATUS_SENSOR_BATTERY);

	variable.setValue("SYS_STATUS_BATTERY_VOLTAGE", decodeVoltage(sys_status.voltage_battery));
	variable.setValue("SYS_STATUS_BATTERY_CURRENT", decodeCurrent(sys_status.current_battery));
	variable.setValue("SYS_STATUS_BATTERY_REMAINING", sys_status.battery_remaining);

	emit variable.notifyChanges("SYS_STATUS");
}
