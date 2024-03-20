#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class ScaledIMU : public AbstractHandler
{
public:
	explicit ScaledIMU(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
