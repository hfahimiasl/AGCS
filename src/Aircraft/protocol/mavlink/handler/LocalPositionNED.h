#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class LocalPositionNED : public AbstractHandler
{
public:
	explicit LocalPositionNED(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
