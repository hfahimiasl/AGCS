#include "PatternSingleItem.h"


PatternSingleItem::PatternSingleItem(QObject *parent) : QObject(parent)
{
	// empty
}

QGeoCoordinate PatternSingleItem::getCoordinate() const
{
	return m_coordinate;
}

void PatternSingleItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}

bool PatternSingleItem::getVisible() const
{
	return m_visible;
}

void PatternSingleItem::setVisible(const bool &visible)
{
	if (m_visible != visible) {
		m_visible = visible;
		emit visibleChanged();
	}
}
