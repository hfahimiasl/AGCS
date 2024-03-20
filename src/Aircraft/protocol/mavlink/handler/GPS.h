#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class GPS : public AbstractHandler
{
public:
	explicit GPS(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
