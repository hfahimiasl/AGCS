#include "AirportItem.h"


AirportItem::AirportItem(QObject *parent) : QObject(parent) {}

void AirportItem::setName(const QString &name)
{
	if (m_name != name) {
		m_name = name;
		emit notifyChanges();
	}
}

QString AirportItem::getName() const
{
	return m_name;
}

void AirportItem::setId(const QString &id)
{
	if (m_id != id) {
		m_id = id;
		emit notifyChanges();
	}
}

QString AirportItem::getId() const
{
	return m_id;
}

void AirportItem::setIATACode(const QString &iata_code)
{
	if (m_iata_code != iata_code) {
		m_iata_code = iata_code;
		emit notifyChanges();
	}
}

QString AirportItem::getIATACode() const
{
	return m_iata_code;
}

void AirportItem::setICAOCode(const QString &icao_code)
{
	if (m_icao_code != icao_code) {
		m_icao_code = icao_code;
		emit notifyChanges();
	}
}

QString AirportItem::getICAOCode() const
{
	return m_icao_code;
}

void AirportItem::setIATACountryCode(const QString &iata_country_code)
{
	if (m_iata_country_code != iata_country_code) {
		m_iata_country_code = iata_country_code;
		emit notifyChanges();
	}
}

QString AirportItem::getIATACountryCode() const
{
	return m_iata_country_code;
}

void AirportItem::setCityName(const QString &city_name)
{
	if (m_city_name != city_name) {
		m_city_name = city_name;
		emit notifyChanges();
	}
}

QString AirportItem::getCityName() const
{
	return m_city_name;
}

void AirportItem::setLatitude(const double &latitude)
{
	if (!qFuzzyCompare(m_latitude, latitude)) {
		m_latitude = latitude;
		emit notifyChanges();
	}
}

double AirportItem::getLatitude() const
{
	return m_latitude;
}

void AirportItem::setLongitude(const double &longitude)
{
	if (!qFuzzyCompare(m_longitude, longitude)) {
		m_longitude = longitude;
		emit notifyChanges();
	}
}

double AirportItem::getLongitude() const
{
	return m_longitude;
}
