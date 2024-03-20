#pragma once

#include <QObject>
#include <QJsonArray>


class AirportItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ getName NOTIFY notifyChanges)
	Q_PROPERTY(QString id READ getId NOTIFY notifyChanges)
	Q_PROPERTY(QString iata READ getIATACode NOTIFY notifyChanges)
	Q_PROPERTY(QString icao READ getICAOCode NOTIFY notifyChanges)
	Q_PROPERTY(QString iataCountry READ getIATACountryCode NOTIFY notifyChanges)
	Q_PROPERTY(QString cityName READ getCityName NOTIFY notifyChanges)
	Q_PROPERTY(double latitude READ getLatitude NOTIFY notifyChanges)
	Q_PROPERTY(double longitude READ getLongitude NOTIFY notifyChanges)

public:
	explicit AirportItem(QObject * = nullptr);

	void setName(const QString &);
	QString getName() const;

	void setId(const QString &);
	QString getId() const;

	void setIATACode(const QString &);
	QString getIATACode() const;

	void setICAOCode(const QString &);
	QString getICAOCode() const;

	void setIATACountryCode(const QString &);
	QString getIATACountryCode() const;

	void setCityName(const QString &);
	QString getCityName() const;

	void setLatitude(const double &);
	double getLatitude() const;

	void setLongitude(const double &);
	double getLongitude() const;

signals:
	void notifyChanges();

private:
	QString m_name {""};
	QString m_id {""};
	QString m_iata_code {""};
	QString m_icao_code {""};
	QString m_iata_country_code {""};
	QString m_city_name {""};
	double m_latitude {};
	double m_longitude {};
};
