#pragma once

#include <QObject>


class AirTrafficItem : public QObject
{
	Q_OBJECT
	// TODO: add flight or aircraft name
	Q_PROPERTY(double latitude READ getLatitude NOTIFY notifyChanges)
	Q_PROPERTY(double longitude READ getLongitude NOTIFY notifyChanges)
	Q_PROPERTY(uint heading READ getHeading NOTIFY notifyChanges)

public:
	explicit AirTrafficItem(QObject * = nullptr);

	void setLatitude(const double &);
	double getLatitude() const;

	void setLongitude(const double &);
	double getLongitude() const;

	void setHeading(const uint &);
	uint getHeading() const;

signals:
	void notifyChanges();

private:
	double m_longitude {};
	double m_latitude {};
	uint m_heading {};
};
