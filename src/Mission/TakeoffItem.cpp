#include "TakeoffItem.h"


TakeoffItem::TakeoffItem(QObject *parent) : QObject(parent)
{
	// empty
}

QGeoCoordinate TakeoffItem::getCoordinate() const
{
	return m_coordinate;
}

void TakeoffItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}

void TakeoffItem::reset()
{
	setCoordinate(QGeoCoordinate());
}
