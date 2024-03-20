#include "TerrainReport.h"


TerrainReport::TerrainReport(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("TERRAIN_REPORT_LAT");
	variable.add("TERRAIN_REPORT_LON");
	variable.add("TERRAIN_REPORT_TERRAIN_HEIGHT");
	variable.add("TERRAIN_REPORT_CURRENT_HEIGHT");
	variable.add("TERRAIN_REPORT_SPACING");
	variable.add("TERRAIN_REPORT_PENDING");
	variable.add("TERRAIN_REPORT_LOADED");
}

void TerrainReport::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_TERRAIN_REPORT) { return; }

	mavlink_terrain_report_t terrain_report;
	mavlink_msg_terrain_report_decode(&message, &terrain_report);

	variable.setValue("TERRAIN_REPORT_LAT",             terrain_report.lat);
	variable.setValue("TERRAIN_REPORT_LON",             terrain_report.lon);
	variable.setValue("TERRAIN_REPORT_TERRAIN_HEIGHT",  terrain_report.terrain_height);
	variable.setValue("TERRAIN_REPORT_CURRENT_HEIGHT",  terrain_report.current_height);
	variable.setValue("TERRAIN_REPORT_SPACING",         terrain_report.spacing);
	variable.setValue("TERRAIN_REPORT_PENDING",         terrain_report.pending);
	variable.setValue("TERRAIN_REPORT_LOADED",          terrain_report.loaded);

	emit variable.notifyChanges("TERRAIN_REPORT");
}
