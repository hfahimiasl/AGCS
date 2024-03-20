#pragma once

#include <QObject>
#include <QGeoCoordinate>


class PatternGroupItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(quint16          sequence    READ getSequence    WRITE setSequence   NOTIFY sequenceChanged)
	Q_PROPERTY(QGeoCoordinate   coordinate  READ getCoordinate  WRITE setCoordinate NOTIFY coordinateChanged)

public:
	explicit PatternGroupItem(QObject * = nullptr);

	quint16 getSequence() const;
	void setSequence(const quint16 &);

	QGeoCoordinate getCoordinate() const;
	void setCoordinate(const QGeoCoordinate &);

signals:
	void sequenceChanged();
	void coordinateChanged();

private:
	quint16 m_sequence {65535};
	QGeoCoordinate m_coordinate;
};
