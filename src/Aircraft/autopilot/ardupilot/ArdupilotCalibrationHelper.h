#ifndef ARDUPILOT_CALIBRATION_HELPER_H
#define ARDUPILOT_CALIBRATION_HELPER_H

#include <QObject>

#include "src/platform_common.h"
#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class ArdupilotCalibrationHelper : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ArdupilotCalibrationHelper)

public:
	explicit ArdupilotCalibrationHelper();

	static ArdupilotCalibrationHelper *instance();

	void request(const CALIBRATION_TYPE &);
	void readCommandAck(const mavlink_command_ack_t &);
	void readCommandLong(const mavlink_command_long_t &);
	void requestNextAccelCalibrationSide();
	void compassCalibrationProgress(const mavlink_mag_cal_progress_t &);
	void compassCalibrationReport(const mavlink_mag_cal_report_t &);
	void remoteControllerCalibrationProgress(const mavlink_rc_channels_t &);
	void writeRemoteControllerTrims(const mavlink_rc_channels_t &);
	void handleFailure();
	void resetProgress();

private:
	enum CALIBRATION_ROUTINES {
		READY_TO_CALIBRATION,
		LEVEL_IN_PROGRESS,
		ACCEL_IN_PROGRESS,
		COMPASS_IN_PROGRESS,
		CANCEL_COMPASS_IN_PROGRESS,
		REMOTE_CONTROLLER_IN_PROGRESS,
	}   calibration_routines;

	ACCELCAL_VEHICLE_POS aircraft_accel_side;

	bool compass_id[6] = {false, false, false, false, false, false};
	bool compass_calibration_status[6] = {false, false, false, false, false, false};
	uint8_t compass_calibration_progress[6] = {0, 0, 0, 0, 0, 0};

	uint16_t remote_controller_trim[16][2];
	bool remote_controller_calibration_status {false};
};


#include "src/Aircraft/autopilot/Autopilot.h"

#endif // ARDUPILOT_CALIBRATION_HELPER_H
