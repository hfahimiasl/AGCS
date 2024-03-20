#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class Altitude : public AbstractHandler
{
public:
	explicit Altitude(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
