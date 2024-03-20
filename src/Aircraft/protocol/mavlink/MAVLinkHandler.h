#pragma once

#include "src/Aircraft/protocol/mavlink/MAVLink.h"

#include "handler/Altitude.h"
#include "handler/Attitude.h"
#include "handler/AutopilotVersion.h"
#include "handler/BatteryStatus.h"
#include "handler/GlobalPositionInt.h"
#include "handler/GPS.h"
#include "handler/HeartBeat.h"
#include "handler/HomePosition.h"
#include "handler/LocalPositionNED.h"
#include "handler/Mission.h"
#include "handler/MountStatus.h"
#include "handler/Param.h"
#include "handler/PositionTargetGlobalInt.h"
#include "handler/RawIMU.h"
#include "handler/RemoteControl.h"
#include "handler/ScaledIMU.h"
#include "handler/ServoOutput.h"
#include "handler/StatusText.h"
#include "handler/SystemStatus.h"
#include "handler/TerrainReport.h"
#include "handler/VFR.h"


class MAVLinkHandler
{
	Q_DISABLE_COPY(MAVLinkHandler)

public:
	explicit MAVLinkHandler();

	static MAVLinkHandler *instance();

	void build();
};
