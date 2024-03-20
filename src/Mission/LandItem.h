#pragma once

#include <QObject>
#include <QGeoCoordinate>


class LandItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QGeoCoordinate coordinate READ getCoordinate WRITE setCoordinate NOTIFY coordinateChanged)

public:
	explicit LandItem(QObject * = nullptr);

	QGeoCoordinate getCoordinate() const;
	void setCoordinate(const QGeoCoordinate &);

	void reset();

signals:
	void coordinateChanged();

private:
	QGeoCoordinate m_coordinate;
};
