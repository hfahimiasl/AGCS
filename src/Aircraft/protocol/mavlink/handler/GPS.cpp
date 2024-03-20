#include "GPS.h"


GPS::GPS(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("GPS_RAW_LAT");
	variable.add("GPS_RAW_LON");
	variable.add("GPS_RAW_ALT");
	variable.add("GPS_RAW_EPH");
	variable.add("GPS_RAW_EPV");
	variable.add("GPS_RAW_VEL");
	variable.add("GPS_RAW_COG");
	variable.add("GPS_RAW_FIX_TYPE");
	variable.add("GPS_RAW_SATELLITES_VISIBLE", 255);
	variable.add("GPS_RAW_ALT_ELLIPSOID");
	variable.add("GPS_RAW_H_ACC");
	variable.add("GPS_RAW_V_ACC");
	variable.add("GPS_RAW_VEL_ACC");
	variable.add("GPS_RAW_HDG_ACC");
	variable.add("GPS_RAW_YAW");

	variable.add("AIRCRAFT_2D_DISTANCE");
	variable.add("AIRCRAFT_3D_DISTANCE");
}

void GPS::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_GPS_RAW_INT) { return; }

	mavlink_gps_raw_int_t gps_raw_int;
	mavlink_msg_gps_raw_int_decode(&message, &gps_raw_int);

	const double valid_latitude = isValidLatitude(decodeLatLon(gps_raw_int.lat)) ? decodeLatLon(gps_raw_int.lat) : 0.0;
	const double valid_longitude = isValidLongitude(decodeLatLon(gps_raw_int.lon)) ? decodeLatLon(gps_raw_int.lon) : 0.0;

	variable.setValue("GPS_RAW_LAT", valid_latitude);
	variable.setValue("GPS_RAW_LON", valid_longitude);
	variable.setValue("GPS_RAW_ALT", decodeAltitude(gps_raw_int.alt));
	variable.setValue("GPS_RAW_EPH", decodeDOP(gps_raw_int.eph));
	variable.setValue("GPS_RAW_EPV", decodeDOP(gps_raw_int.epv));
	variable.setValue("GPS_RAW_VEL", double(decodeGroundSpeed(gps_raw_int.vel)));
	variable.setValue("GPS_RAW_COG", double(decodeCourse(gps_raw_int.cog)));
	variable.setValue("GPS_RAW_FIX_TYPE", gps_raw_int.fix_type);
	variable.setValue("GPS_RAW_SATELLITES_VISIBLE", gps_raw_int.satellites_visible);
	variable.setValue("GPS_RAW_ALT_ELLIPSOID", gps_raw_int.alt_ellipsoid);
	variable.setValue("GPS_RAW_H_ACC", gps_raw_int.h_acc);
	variable.setValue("GPS_RAW_V_ACC", gps_raw_int.v_acc);
	variable.setValue("GPS_RAW_VEL_ACC", gps_raw_int.vel_acc);
	variable.setValue("GPS_RAW_HDG_ACC", gps_raw_int.hdg_acc);
	variable.setValue("GPS_RAW_YAW", gps_raw_int.yaw);

	emit variable.notifyChanges("GPS_RAW");

	double distance2D = geometryDistance(valid_latitude, valid_longitude, variable.getValue("HOME_POS_LAT"), variable.getValue("HOME_POS_LON"));

	double distance3D = sqrt(pow(distance2D, 2) + pow(decodeAltitude(gps_raw_int.alt) - variable.getValue("HOME_POS_ALT"), 2));

	if (int(variable.getValue("HOME_POS_LAT")) == 0 && int(variable.getValue("HOME_POS_LON")) == 0) {
		distance2D = 0.0;
		distance3D = 0.0;
	}

	variable.setValue("AIRCRAFT_2D_DISTANCE", distance2D, true);
	variable.setValue("AIRCRAFT_3D_DISTANCE", distance3D, true);
}
