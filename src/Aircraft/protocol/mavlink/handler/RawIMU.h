#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class RawIMU : public AbstractHandler
{
public:
	explicit RawIMU(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
