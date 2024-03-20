#include "Geographical.h"


void Geographical::convertGeoToNed(const QGeoCoordinate &coord, const QGeoCoordinate &origin, double *x, double *y, double *z)
{
	if (coord == origin) {
		*x = 0;
		*y = 0;
		*z = 0;
		return;
	}

	const double lat_rad = coord.latitude() * kDegToRad;
	const double lon_rad = coord.longitude() * kDegToRad;

	const double ref_lon_rad = origin.longitude() * kDegToRad;
	const double ref_lat_rad = origin.latitude() * kDegToRad;

	const double sin_lat = sin(lat_rad);
	const double cos_lat = cos(lat_rad);
	const double cos_d_lon = cos(lon_rad - ref_lon_rad);

	const double ref_sin_lat = sin(ref_lat_rad);
	const double ref_cos_lat = cos(ref_lat_rad);

	const double c = acos(ref_sin_lat * sin_lat + ref_cos_lat * cos_lat * cos_d_lon);
	const double k = (fabs(c) < kEpsilon) ? 1.0 : (c / sin(c));

	*x = k * (ref_cos_lat * sin_lat - ref_sin_lat * cos_lat * cos_d_lon) * kEarthRadius;
	*y = k * cos_lat * sin(lon_rad - ref_lon_rad) * kEarthRadius;
	*z = origin.altitude() - coord.altitude();
}

void Geographical::convertNedToGeo(const double &x, const double &y, const double &z, const QGeoCoordinate &origin, QGeoCoordinate *coord)
{
	const double x_rad = x / kEarthRadius;
	const double y_rad = y / kEarthRadius;
	const double c = sqrt(x_rad * x_rad + y_rad * y_rad);
	const double sin_c = sin(c);
	const double cos_c = cos(c);

	const double ref_lon_rad = origin.longitude() * kDegToRad;
	const double ref_lat_rad = origin.latitude() * kDegToRad;

	const double ref_sin_lat = sin(ref_lat_rad);
	const double ref_cos_lat = cos(ref_lat_rad);

	double lat_rad = 0;
	double lon_rad = 0;

	if (fabs(c) > kEpsilon) {
		lat_rad = asin(cos_c * ref_sin_lat + (x_rad * sin_c * ref_cos_lat) / c);
		lon_rad = (ref_lon_rad + atan2(y_rad * sin_c, c * ref_cos_lat * cos_c - x_rad * ref_sin_lat * sin_c));

	} else {
		lat_rad = ref_lat_rad;
		lon_rad = ref_lon_rad;
	}

	coord->setLatitude(lat_rad * kRadToDeg);
	coord->setLongitude(lon_rad * kRadToDeg);
	coord->setAltitude(origin.altitude() - z);
}
