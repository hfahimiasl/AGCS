#include "AgricultureInfo.h"


AgricultureInfo::AgricultureInfo(QObject *parent) : QObject(parent)
{
	// empty
}

double AgricultureInfo::getAltitude() const
{
	return m_altitude;
}

void AgricultureInfo::setAltitude(const double &altitude)
{
	if (!qFuzzyCompare(m_altitude, altitude)) {
		m_altitude = altitude;
		emit altitudeChanged();
	}
}

double AgricultureInfo::getSpeed() const
{
	return m_speed;
}

void AgricultureInfo::setSpeed(const double &speed)
{
	if (!qFuzzyCompare(m_speed, speed)) {
		m_speed = speed;
		emit speedChanged();
	}
}

double AgricultureInfo::getAngle() const
{
	return m_angle;
}

void AgricultureInfo::setAngle(const double &angle)
{
	if (!qFuzzyCompare(m_angle, angle)) {
		m_angle = angle;
		emit angleChanged();
	}
}

double AgricultureInfo::getBoomLength() const
{
	return m_boom_length;
}

void AgricultureInfo::setBoomLength(const double &boom_length)
{
	if (!qFuzzyCompare(m_boom_length, boom_length)) {
		m_boom_length = boom_length;
		emit boomLengthChanged();
	}
}

quint8 AgricultureInfo::getNozzleChannel() const
{
	return m_nozzle_channel;
}

void AgricultureInfo::setNozzleChannel(const quint8 &nozzle_channel)
{
	if (m_nozzle_channel != nozzle_channel) {
		m_nozzle_channel = nozzle_channel;
		emit nozzleChannelChanged();
	}
}

quint16 AgricultureInfo::getNozzleMin() const
{
	return m_nozzle_min;
}

void AgricultureInfo::setNozzleMin(const quint16 &nozzle_min)
{
	if (m_nozzle_min != nozzle_min) {
		m_nozzle_min = nozzle_min;
		emit nozzleMinChanged();
	}
}

quint16 AgricultureInfo::getNozzleMax() const
{
	return m_nozzle_max;
}

void AgricultureInfo::setNozzleMax(const quint16 &nozzle_max)
{
	if (m_nozzle_max != nozzle_max) {
		m_nozzle_max = nozzle_max;
		emit nozzleMaxChanged();
	}
}

void AgricultureInfo::operator=(const AgricultureInfo &other)
{
	setAltitude(other.getAltitude());
	setSpeed(other.getSpeed());
	setAngle(other.getAngle());
	setBoomLength(other.getBoomLength());
	setNozzleChannel(other.getNozzleChannel());
	setNozzleMin(other.getNozzleMin());
	setNozzleMax(other.getNozzleMax());
}
