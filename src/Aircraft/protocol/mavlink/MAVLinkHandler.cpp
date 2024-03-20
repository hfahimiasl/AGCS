#include "MAVLinkHandler.h"


MAVLinkHandler::MAVLinkHandler()
{
	// empty
}

MAVLinkHandler *MAVLinkHandler::instance()
{
	static MAVLinkHandler self;
	return &self;
}

void MAVLinkHandler::build()
{
	MAVLink::instance()->addHandler(new Altitude(MAVLink::instance()));
	MAVLink::instance()->addHandler(new Attitude(MAVLink::instance()));
	MAVLink::instance()->addHandler(new AutopilotVersion(MAVLink::instance()));
	MAVLink::instance()->addHandler(new BatteryStatus(MAVLink::instance()));
	MAVLink::instance()->addHandler(new GlobalPositionInt(MAVLink::instance()));
	MAVLink::instance()->addHandler(new GPS(MAVLink::instance()));
	MAVLink::instance()->addHandler(new HeartBeat(MAVLink::instance()));
	MAVLink::instance()->addHandler(new HomePosition(MAVLink::instance()));
	MAVLink::instance()->addHandler(new LocalPositionNED(MAVLink::instance()));
	MAVLink::instance()->addHandler(new Mission(MAVLink::instance()));
	MAVLink::instance()->addHandler(new MountStatus(MAVLink::instance()));
	MAVLink::instance()->addHandler(new Param(MAVLink::instance()));
	MAVLink::instance()->addHandler(new PositionTargetGlobalInt(MAVLink::instance()));
	MAVLink::instance()->addHandler(new RawIMU(MAVLink::instance()));
	MAVLink::instance()->addHandler(new RemoteControl(MAVLink::instance()));
	MAVLink::instance()->addHandler(new ScaledIMU(MAVLink::instance()));
	MAVLink::instance()->addHandler(new ServoOutput(MAVLink::instance()));
	MAVLink::instance()->addHandler(new StatusText(MAVLink::instance()));
	MAVLink::instance()->addHandler(new SystemStatus(MAVLink::instance()));
	MAVLink::instance()->addHandler(new TerrainReport(MAVLink::instance()));
	MAVLink::instance()->addHandler(new VFR(MAVLink::instance()));
}
