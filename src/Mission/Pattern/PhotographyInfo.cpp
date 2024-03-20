#include "PhotographyInfo.h"


PhotographyInfo::PhotographyInfo(QObject *parent) : QObject(parent)
{
	// empty
}

double PhotographyInfo::getAltitude() const
{
	return m_altitude;
}

void PhotographyInfo::setAltitude(const double &altitude)
{
	if (!qFuzzyCompare(m_altitude, altitude)) {
		m_altitude = altitude;
		emit altitudeChanged();
	}
}

double PhotographyInfo::getSpeed() const
{
	return m_speed;
}

void PhotographyInfo::setSpeed(const double &speed)
{
	if (!qFuzzyCompare(m_speed, speed)) {
		m_speed = speed;
		emit speedChanged();
	}
}

double PhotographyInfo::getAngle() const
{
	return m_angle;
}

void PhotographyInfo::setAngle(const double &angle)
{
	if (!qFuzzyCompare(m_angle, angle)) {
		m_angle = angle;
		emit angleChanged();
	}
}

double PhotographyInfo::getSpacing() const
{
	return m_spacing;
}

void PhotographyInfo::setSpacing(const double &spacing)
{
	if (!qFuzzyCompare(m_spacing, spacing)) {
		m_spacing = spacing;
		emit spacingChanged();
	}
}

double PhotographyInfo::getCameraTriggerDistance() const
{
	return m_camera_trigger_distance;
}

void PhotographyInfo::setCameraTriggerDistance(const double &camera_trigger_distance)
{
	if (!qFuzzyCompare(m_camera_trigger_distance, camera_trigger_distance)) {
		m_camera_trigger_distance = camera_trigger_distance;
		emit cameraTriggerDistanceChanged();
	}
}

void PhotographyInfo::operator=(const PhotographyInfo &other)
{
	setAltitude(other.getAltitude());
	setSpeed(other.getSpeed());
	setAngle(other.getAngle());
	setSpacing(other.getSpacing());
	setCameraTriggerDistance(other.getCameraTriggerDistance());
}
