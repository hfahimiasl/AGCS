#pragma once

#include <QObject>

#include "AbstractHandler.h"


class MAVLink : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(MAVLink)

public:
	explicit MAVLink();
	~MAVLink();

	static MAVLink *instance();

	void addHandler(AbstractHandler *);

	void setGCSSysID(uint8_t);
	void setGCSCompID(uint8_t);
	void setAircraftSysID(uint8_t);
	void setAircraftCompID(uint8_t);

	uint8_t getGCSSysID() const;
	uint8_t getGCSCompID() const;
	uint8_t getAircraftSysID() const;
	uint8_t getAircraftCompID() const;

	void write(mavlink_message_t &);
	void writeCommandAck(uint16_t, uint8_t, uint8_t, int32_t);
	void writeCommandLong(uint16_t, uint8_t, float, float, float, float, float, float, float);

signals:
	void notifyRead(const mavlink_message_t &);
	void notifyWrite(const QByteArray &);

public slots:
	void read(const QByteArray &);

private:
	QList<AbstractHandler *> list;

	uint8_t gcs_sysid;
	uint8_t gcs_compid;
	uint8_t aircraft_sysid;
	uint8_t aircraft_compid;
};
