#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class PositionTargetGlobalInt : public AbstractHandler
{
public:
	explicit PositionTargetGlobalInt(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
