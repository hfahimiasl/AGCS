#pragma once

#include <QObject>


class AgricultureInfo : public QObject
{
	Q_OBJECT
	Q_PROPERTY(double   altitude        READ getAltitude        WRITE setAltitude       NOTIFY altitudeChanged)
	Q_PROPERTY(double   speed           READ getSpeed           WRITE setSpeed          NOTIFY speedChanged)
	Q_PROPERTY(double   angle           READ getAngle           WRITE setAngle          NOTIFY angleChanged)
	Q_PROPERTY(double   boomLength      READ getBoomLength      WRITE setBoomLength     NOTIFY boomLengthChanged)
	Q_PROPERTY(quint8   nozzleChannel   READ getNozzleChannel   WRITE setNozzleChannel  NOTIFY nozzleChannelChanged)
	Q_PROPERTY(quint16  nozzleMin       READ getNozzleMin       WRITE setNozzleMin      NOTIFY nozzleMinChanged)
	Q_PROPERTY(quint16  nozzleMax       READ getNozzleMax       WRITE setNozzleMax      NOTIFY nozzleMaxChanged)

public:
	explicit AgricultureInfo(QObject * = nullptr);

	double getAltitude() const;
	void setAltitude(const double &);

	double getSpeed() const;
	void setSpeed(const double &);

	double getAngle() const;
	void setAngle(const double &);

	double getBoomLength() const;
	void setBoomLength(const double &);

	quint8 getNozzleChannel() const;
	void setNozzleChannel(const quint8 &);

	quint16 getNozzleMin() const;
	void setNozzleMin(const quint16 &);

	quint16 getNozzleMax() const;
	void setNozzleMax(const quint16 &);

	void operator=(const AgricultureInfo &);

signals:
	void altitudeChanged();
	void speedChanged();
	void angleChanged();
	void boomLengthChanged();
	void nozzleChannelChanged();
	void nozzleMinChanged();
	void nozzleMaxChanged();

private:
	double m_altitude {qQNaN()};
	double m_speed {qQNaN()};
	double m_angle {qQNaN()};
	double m_boom_length {qQNaN()};
	quint8 m_nozzle_channel {UINT8_MAX};
	quint16 m_nozzle_min {UINT16_MAX};
	quint16 m_nozzle_max {UINT16_MAX};
};
