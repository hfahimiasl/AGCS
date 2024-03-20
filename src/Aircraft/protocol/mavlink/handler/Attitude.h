#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class Attitude : public AbstractHandler
{
public:
	explicit Attitude(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
