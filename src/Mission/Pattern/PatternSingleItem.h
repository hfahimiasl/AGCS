#pragma once

#include <QObject>
#include <QGeoCoordinate>


class PatternSingleItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QGeoCoordinate   coordinate  READ getCoordinate  WRITE setCoordinate NOTIFY coordinateChanged)
	Q_PROPERTY(bool             visible     READ getVisible     WRITE setVisible    NOTIFY visibleChanged)

public:
	explicit PatternSingleItem(QObject * = nullptr);

	QGeoCoordinate getCoordinate() const;
	void setCoordinate(const QGeoCoordinate &);

	bool getVisible() const;
	void setVisible(const bool &);

signals:
	void coordinateChanged();
	void visibleChanged();

private:
	QGeoCoordinate m_coordinate;
	bool m_visible {false};
};
