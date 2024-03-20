#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class SystemStatus : public AbstractHandler
{
public:
	explicit SystemStatus(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
