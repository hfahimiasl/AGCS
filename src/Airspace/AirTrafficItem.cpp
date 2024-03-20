#include "AirTrafficItem.h"


AirTrafficItem::AirTrafficItem(QObject *parent) : QObject(parent) {}

void AirTrafficItem::setLatitude(const double &latitude)
{
	if (!qFuzzyCompare(m_latitude, latitude)) {
		m_latitude = latitude;
		emit notifyChanges();
	}
}

double AirTrafficItem::getLatitude() const
{
	return m_latitude;
}

void AirTrafficItem::setLongitude(const double &longitude)
{
	if (!qFuzzyCompare(m_longitude, longitude)) {
		m_longitude = longitude;
		emit notifyChanges();
	}
}

double AirTrafficItem::getLongitude() const
{
	return m_longitude;
}

void AirTrafficItem::setHeading(const uint &heading)
{
	if (m_heading != heading) {
		m_heading = heading;
		emit notifyChanges();
	}
}

uint AirTrafficItem::getHeading() const
{
	return m_heading;
}
