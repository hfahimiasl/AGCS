#pragma once

#include "src/System/Logger.h"

#if !defined(Q_OS_IOS) && !(defined(Q_OS_LINUX) && defined(Q_OS_ANDROID))
#include "src/System/RunGuard.h"
#endif

#include "src/System/Global.h"
#include "src/System/Scheduler.h"
#include "src/System/Settings.h"
#include "src/System/Toast.h"
#include "src/System/Units.h"
#include "src/System/Variable.h"

// TODO #include services
#include "src/Param/ParamService.h"
#include "src/Mission/MissionService.h" // TODO /System -> /Mission
#include "src/Mission/Pattern/PatternService.h"
#include "src/Airspace/AirspaceService.h"


typedef enum AIRCRAFT_TYPE {
	AIRCRAFT_TYPE_GENERIC,
	AIRCRAFT_TYPE_FIXEDWING,
	AIRCRAFT_TYPE_MULTIROTOR,
	AIRCRAFT_TYPE_HELICOPTER,
	AIRCRAFT_TYPE_VTOL
}   AIRCRAFT_TYPE;

typedef enum CALIBRATION_TYPE {
	CALIBRATION_TYPE_GYRO,
	CALIBRATION_TYPE_ACCEL,
	CALIBRATION_TYPE_LEVEL,
	CALIBRATION_TYPE_COMPASS,
	CALIBRATION_TYPE_CANCEL_COMPASS,
	CALIBRATION_TYPE_REMOTE_CONTROLLER
}   CALIBRATION_TYPE;
