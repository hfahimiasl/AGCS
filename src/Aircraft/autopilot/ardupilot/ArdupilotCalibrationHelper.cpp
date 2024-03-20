#include "ArdupilotCalibrationHelper.h"


ArdupilotCalibrationHelper::ArdupilotCalibrationHelper()
{
	resetProgress();
	variable.add("COMPASS_CAL_PROG");
}

ArdupilotCalibrationHelper *ArdupilotCalibrationHelper::instance()
{
	static ArdupilotCalibrationHelper ardupilot_calibration_helper;
	return &ardupilot_calibration_helper;
}

void ArdupilotCalibrationHelper::request(const CALIBRATION_TYPE &calibration_type)
{
	if (calibration_routines == CALIBRATION_ROUTINES::READY_TO_CALIBRATION) {
		uint16_t command = 0;

		float param1 = 0;
		float param2 = 0;
		float param3 = 0;
		float param4 = 0;
		float param5 = 0;
		float param6 = 0;
		float param7 = 0;

		switch (calibration_type) {
		case CALIBRATION_TYPE::CALIBRATION_TYPE_GYRO:
		case CALIBRATION_TYPE::CALIBRATION_TYPE_LEVEL:
			param5 = 2;
			command = MAV_CMD::MAV_CMD_PREFLIGHT_CALIBRATION;
			calibration_routines = CALIBRATION_ROUTINES::LEVEL_IN_PROGRESS;
			break;

		case CALIBRATION_TYPE::CALIBRATION_TYPE_ACCEL:
			param5 = 1;
			command = MAV_CMD::MAV_CMD_PREFLIGHT_CALIBRATION;
			calibration_routines = CALIBRATION_ROUTINES::ACCEL_IN_PROGRESS;
			break;

		case CALIBRATION_TYPE::CALIBRATION_TYPE_COMPASS:
			param2 = 1;
			param3 = 1;
			command = MAV_CMD::MAV_CMD_DO_START_MAG_CAL;
			calibration_routines = CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS;
			break;

		case CALIBRATION_TYPE::CALIBRATION_TYPE_REMOTE_CONTROLLER:
			calibration_routines = CALIBRATION_ROUTINES::REMOTE_CONTROLLER_IN_PROGRESS;
			return;
			break;

		default:
			return;
			break;
		}

		if (MAV_STATE(uint8_t(variable.getValue("SYSTEM_STATUS"))) == MAV_STATE::MAV_STATE_ACTIVE
		    || bool(variable.getValue("ARM_STATUS"))) {
			handleFailure();

		} else {
			MAVLink::instance()->writeCommandLong(command, 0, param1, param2, param3, param4, param5, param6, param7);
		}

	} else if (calibration_type == CALIBRATION_TYPE::CALIBRATION_TYPE_CANCEL_COMPASS
		   && calibration_routines == CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS) {
		calibration_routines = CALIBRATION_ROUTINES::CANCEL_COMPASS_IN_PROGRESS;
		MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_DO_CANCEL_MAG_CAL, 0, 0, 0, 1, 0, 0, 0, 0);
	}
}

void ArdupilotCalibrationHelper::readCommandAck(const mavlink_command_ack_t &command_ack)
{
	switch (calibration_routines) {
	case CALIBRATION_ROUTINES::READY_TO_CALIBRATION:
		break;

	case CALIBRATION_ROUTINES::LEVEL_IN_PROGRESS:
		switch (command_ack.result) {
		case MAV_RESULT::MAV_RESULT_ACCEPTED:
			emit Autopilot::instance()->levelCalibrationAccepted();
			resetProgress();
			break;

		case MAV_RESULT::MAV_RESULT_IN_PROGRESS:
			break;

		default:
			emit Autopilot::instance()->levelCalibrationFailed();
			resetProgress();
			break;
		}

		break;

	case CALIBRATION_ROUTINES::ACCEL_IN_PROGRESS:
		switch (command_ack.result) {
		case MAV_RESULT::MAV_RESULT_ACCEPTED:
			break;

		case MAV_RESULT::MAV_RESULT_IN_PROGRESS:
			break;

		default:
			emit Autopilot::instance()->accelCalibrationFailed();
			resetProgress();
			break;
		}

		break;

	case CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS:
		switch (command_ack.result) {
		case MAV_RESULT::MAV_RESULT_ACCEPTED:
			emit Autopilot::instance()->compassCalibrationStarted();
			break;

		case MAV_RESULT::MAV_RESULT_IN_PROGRESS:
			break;

		default:
			emit Autopilot::instance()->compassCalibrationFailed();
			resetProgress();
			break;
		}

		break;

	case CALIBRATION_ROUTINES::CANCEL_COMPASS_IN_PROGRESS:
		switch (command_ack.result) {
		case MAV_RESULT::MAV_RESULT_ACCEPTED:
			emit Autopilot::instance()->compassCalibrationCancelled();
			resetProgress();
			break;

		default:
			break;
		}

		break;

	case CALIBRATION_ROUTINES::REMOTE_CONTROLLER_IN_PROGRESS:
//        if (command_ack.result == 4)
		break;
	}
}

void ArdupilotCalibrationHelper::readCommandLong(const mavlink_command_long_t &command_long)
{
	if (calibration_routines == CALIBRATION_ROUTINES::ACCEL_IN_PROGRESS) {
		switch (ACCELCAL_VEHICLE_POS(uint32_t(command_long.param1))) {
		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_LEVEL:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_LEVEL;
			emit Autopilot::instance()->accelCalibrationPosLevel();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_LEFT:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_LEFT;
			emit Autopilot::instance()->accelCalibrationPosLeft();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_RIGHT:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_RIGHT;
			emit Autopilot::instance()->accelCalibrationPosRight();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_NOSEDOWN:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_NOSEDOWN;
			emit Autopilot::instance()->accelCalibrationPosNoseDown();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_NOSEUP:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_NOSEUP;
			emit Autopilot::instance()->accelCalibrationPosNoseUp();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_BACK:
			aircraft_accel_side = ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_BACK;
			emit Autopilot::instance()->accelCalibrationPosBack();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_SUCCESS:
			emit Autopilot::instance()->accelCalibrationAccepted();
			resetProgress();
			break;

		case ACCELCAL_VEHICLE_POS::ACCELCAL_VEHICLE_POS_FAILED:
			emit Autopilot::instance()->accelCalibrationFailed();
			resetProgress();
			break;

		default:
			break;
		}
	}
}

void ArdupilotCalibrationHelper::requestNextAccelCalibrationSide()
{
	if (calibration_routines == CALIBRATION_ROUTINES::ACCEL_IN_PROGRESS) {
		MAVLink::instance()->writeCommandAck(aircraft_accel_side, 0, 0, 0);
	}
}

void ArdupilotCalibrationHelper::compassCalibrationProgress(const mavlink_mag_cal_progress_t &mag_cal_progress)
{
	if (calibration_routines == CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS) {
		compass_id[mag_cal_progress.compass_id] = true;
		compass_calibration_progress[mag_cal_progress.compass_id] = mag_cal_progress.completion_pct;

		int activists_num = 0;
		int total_progress = 0;

		for (uint8_t i = 0 ; i < 6 ; i++) {
			if (compass_id[i]) {
				activists_num ++;
				total_progress += compass_calibration_progress[i];
			}
		}

		variable.setValue("COMPASS_CAL_PROG", total_progress / activists_num, true);
	}
}

void ArdupilotCalibrationHelper::compassCalibrationReport(const mavlink_mag_cal_report_t &mag_cal_report)
{
	if (calibration_routines == CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS) {
		if (compass_id[mag_cal_report.compass_id]) {
			switch (mag_cal_report.cal_status) {
			case MAG_CAL_STATUS::MAG_CAL_SUCCESS:
				compass_calibration_status[mag_cal_report.compass_id] = true;

				if (!mag_cal_report.autosaved) {
					MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_DO_ACCEPT_MAG_CAL, 0, 0, 0, 0, 0, 0, 0, 0);
				}

				break;

			case MAG_CAL_STATUS::MAG_CAL_FAILED:
			case MAG_CAL_STATUS::MAG_CAL_BAD_ORIENTATION:
			case MAG_CAL_STATUS::MAG_CAL_BAD_RADIUS:
				handleFailure();
				return;
				break;
			}

			if (!compass_id[mag_cal_report.compass_id + 1]) {
				bool calibration_status = true;

				for (uint8_t i = 0 ; i < 6 ; i++) {
					if (compass_id[i]) {
						calibration_status &= compass_calibration_status[i];
					}
				}

				calibration_status ? emit Autopilot::instance()->compassCalibrationAccepted() : emit
				Autopilot::instance()->compassCalibrationFailed();

				resetProgress();
			}
		}
	}
}

void ArdupilotCalibrationHelper::remoteControllerCalibrationProgress(const mavlink_rc_channels_t &rc_channels)
{
	if (calibration_routines == CALIBRATION_ROUTINES::REMOTE_CONTROLLER_IN_PROGRESS) {
		if (rc_channels.chan1_raw < 2200 && rc_channels.chan1_raw > 800 &&
		    rc_channels.chan2_raw < 2200 && rc_channels.chan2_raw > 800 &&
		    rc_channels.chan3_raw < 2200 && rc_channels.chan3_raw > 800 &&
		    rc_channels.chan4_raw < 2200 && rc_channels.chan4_raw > 800) {
			remote_controller_calibration_status = true;
		}

		for (uint8_t i = 0 ; i < 16 ; i++) {
			if (((uint16_t *)&rc_channels)[i + 2] < remote_controller_trim[i][0]) {
				remote_controller_trim[i][0] = ((uint16_t *)&rc_channels)[i + 2];
			}

			if (((uint16_t *)&rc_channels)[i + 2] > remote_controller_trim[i][1]) {
				remote_controller_trim[i][1] = ((uint16_t *)&rc_channels)[i + 2];
			}
		}
	}
}

void ArdupilotCalibrationHelper::writeRemoteControllerTrims(const mavlink_rc_channels_t &rc_channels)
{
	if (calibration_routines == CALIBRATION_ROUTINES::REMOTE_CONTROLLER_IN_PROGRESS) {
		if (remote_controller_calibration_status) {
			char param_name[16];

			emit ParamService::instance()->notifyUpload("RCMAP_ROLL", 1);
			emit ParamService::instance()->notifyUpload("RCMAP_PITCH", 2);
			emit ParamService::instance()->notifyUpload("RCMAP_THROTTLE", 3);
			emit ParamService::instance()->notifyUpload("RCMAP_YAW", 4);

			for (uint8_t i = 0 ; i < 16 ; i++) {
				snprintf(param_name, 16, "RC%d_MIN", i + 1);
				emit ParamService::instance()->notifyUpload(param_name, remote_controller_trim[i][0]);

				snprintf(param_name, 16, "RC%d_MAX", i + 1);
				emit ParamService::instance()->notifyUpload(param_name, remote_controller_trim[i][1]);

				snprintf(param_name, 16, "RC%d_TRIM", i + 1);

				if (i < 4) {
					emit ParamService::instance()->notifyUpload(param_name, ((uint16_t *)&rc_channels)[i + 2]);

				} else {
					emit ParamService::instance()->notifyUpload(param_name, (uint16_t)((remote_controller_trim[i][0] + remote_controller_trim[i][1]) / 2));
				}
			}

			MAVLink::instance()->writeCommandLong(MAV_CMD::MAV_CMD_PREFLIGHT_STORAGE, 0, 1, 0, 0, 0, 0, 0, 0);
			emit Autopilot::instance()->remoteControllerCalibrationAccepted();

		} else {
			emit Autopilot::instance()->remoteControllerCalibrationFailed();
		}

		resetProgress();
	}
}

void ArdupilotCalibrationHelper::handleFailure()
{
	switch (calibration_routines) {
	case CALIBRATION_ROUTINES::LEVEL_IN_PROGRESS:
		emit Autopilot::instance()->levelCalibrationFailed();
		resetProgress();
		break;

	case CALIBRATION_ROUTINES::ACCEL_IN_PROGRESS:
		emit Autopilot::instance()->accelCalibrationFailed();
		resetProgress();
		break;

	case CALIBRATION_ROUTINES::COMPASS_IN_PROGRESS:
		emit Autopilot::instance()->compassCalibrationFailed();
		resetProgress();
		break;

	case CALIBRATION_ROUTINES::REMOTE_CONTROLLER_IN_PROGRESS:
		emit Autopilot::instance()->remoteControllerCalibrationFailed();
		resetProgress();
		break;

	default:
		break;
	}
}

void ArdupilotCalibrationHelper::resetProgress()
{
	for (uint8_t i = 0 ; i < 6 ; i++) {
		compass_id[i] = false;
		compass_calibration_status[i] = false;
		compass_calibration_progress[i] = 0;
	}

	for (uint8_t i = 0 ; i < 16 ; i++) {
		remote_controller_trim[i][0] = 1000;
		remote_controller_trim[i][1] = 2000;
	}

	remote_controller_calibration_status = false;

	calibration_routines = CALIBRATION_ROUTINES::READY_TO_CALIBRATION;
}
