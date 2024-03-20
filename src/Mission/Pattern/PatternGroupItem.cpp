#include "PatternGroupItem.h"


PatternGroupItem::PatternGroupItem(QObject *parent) : QObject(parent)
{
	// empty
}

quint16 PatternGroupItem::getSequence() const
{
	return m_sequence;
}

void PatternGroupItem::setSequence(const quint16 &sequence)
{
	if (m_sequence != sequence) {
		m_sequence = sequence;
		emit sequenceChanged();
	}
}

QGeoCoordinate PatternGroupItem::getCoordinate() const
{
	return m_coordinate;
}

void PatternGroupItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}
