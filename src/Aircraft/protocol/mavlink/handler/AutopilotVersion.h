#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class AutopilotVersion : public AbstractHandler
{
public:
	explicit AutopilotVersion(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
