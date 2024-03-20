#pragma once

#include <QtMath>
#include <QGeoCoordinate>

#ifndef UINT16_MAX
#include <limits.h>
#define UINT16_MAX std::numeric_limits<std::uint16_t>::max()
#endif

int32_t inline hzToUs(const float &frequency)
{
	return 1000000 / frequency;
}

inline int32_t encodeLatLon(const double &value)
{
	return value * 1e7;
}

inline int32_t encodeAltitude(const double &value)
{
	return value * 1000;
}

inline int16_t decodeTemperature(const float &value)
{
	return value * 100;
}

inline uint16_t encodeCourse(const float &value)
{
	return value * 100;
}

inline uint16_t encodeGroundSpeed(const float &value)
{
	return value * 100;
}

inline double decodeLatLon(const int32_t &value)
{
	return double(value) / 1e7;
}

inline double decodeAltitude(const int32_t &value)
{
	return double(value) / 1000;
}

inline float decodeTemperature(const int16_t &value)
{
	return float(value) / 100;
}

inline float decodeCourse(const uint16_t &value)
{
	return value == UINT16_MAX ? -1.0 : float(value) / 100;
}

inline float decodeGroundSpeed(const uint16_t &value)
{
	return value == UINT16_MAX ? -1.0 : float(value) / 100;
}

inline float getTrueAirspeed(const float &indicatedAirspeed, const float &altitude)
{
	return indicatedAirspeed + (indicatedAirspeed * 0.02 * altitude / 1000);
}

inline float fixAirspeedError(const float &airspeedError)
{
	// APM ISSUE: https://github.com/ArduPilot/ardupilot/issues/335
	return airspeedError * 0.01;
}

inline float fromCentidegrees(const float &centiDegrees)
{
	return centiDegrees / 100;
}

inline float decodeVoltage(const uint16_t &value)
{
	return value == UINT16_MAX ? -1.0 : float(value) / 1000;
}

inline float decodeCurrent(const int16_t &value)
{
	return value < 0 ? -1.0 : float(value) / 100;
}

inline QGeoCoordinate decodeCoordinate(const int32_t &lat, const int32_t &lon, const int32_t &alt)
{
	return (lat == 0
		&& lon == 0) ? QGeoCoordinate() : QGeoCoordinate(decodeLatLon(lat), decodeLatLon(lon), decodeAltitude(alt));
}

inline float decodeRssi(const uint16_t &value)
{
	return qMin(qMax(qRound(value / 1.9 - 127.0), - 120), 0);
}

inline double geometryDistance(const double &lat1, const double &lon1, const double &lat2, const double &lon2)
{
	// Earth radius in meters
	static const double Re = 6371000;

	const double lat[2] = {lat1 *M_PI / 180, lat2 *M_PI / 180};
	const double lon[2] = {lon1 *M_PI / 180, lon2 *M_PI / 180};

	return asin(sqrt(pow(sin((lat[1] - lat[0]) / 2), 2) + cos(lat[0]) * cos(lat[1]) * pow(sin((lon[1] - lon[0]) / 2),
			 2))) * 2 * Re;
}

inline bool isValidLatitude(const double &lat)
{
	return !qIsNaN(lat) && lat >= -90.0 && lat <= 90.0;
}

inline bool isValidLongitude(const double &lon)
{
	return !qIsNaN(lon) && abs(lon) >= 0.0 && abs(lon) <= 180.0;
}

inline double decodeDOP(const uint16_t &dop)
{
	return (dop == UINT16_MAX) ? qQNaN() : double(dop) / 100;
}
