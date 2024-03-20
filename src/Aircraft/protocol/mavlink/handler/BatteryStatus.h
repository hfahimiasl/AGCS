#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class BatteryStatus : public AbstractHandler
{
public:
	explicit BatteryStatus(MAVLink *);

	void handle(const mavlink_message_t &) override;

private:
	double getVoltage(const uint16_t *);
	double getCurrent(const int16_t &);
};
