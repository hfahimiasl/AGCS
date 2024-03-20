#include "LandItem.h"


LandItem::LandItem(QObject *parent) : QObject(parent)
{
	// empty
}

QGeoCoordinate LandItem::getCoordinate() const
{
	return m_coordinate;
}

void LandItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}

void LandItem::reset()
{
	setCoordinate(QGeoCoordinate());
}
