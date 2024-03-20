#pragma once

#include <QObject>
#include <QTimer>

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"
#include "src/Aircraft/link/Link.h"


class HeartBeat : public QObject, public AbstractHandler
{
	Q_OBJECT

public:
	explicit HeartBeat(MAVLink *);
	~HeartBeat() override;

	void handle(const mavlink_message_t &) override;

private slots:
	void send();

private:
	void updateAircraftType(uint8_t);
	void updateAutopilotType(uint8_t);
	void updateFlightTime();

	QTimer *timer {nullptr};

	uint64_t total_flight_time {0};
	uint64_t flight_time_offset {0};

	bool flight_time_offset_init {false};

	const QMap<qint32, uint16_t> stream_rate_map {
		{2400, 2},
		{4800, 2},
		{9600, 2},
		{19200, 4},
		{38400, 6},
		{57600, 8},
		{115200, 10},
		{230400, 15},
		{460800, 20},
		{500000, 25},
		{921600, 30}
	};
};
