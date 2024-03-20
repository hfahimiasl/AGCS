#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class MountStatus : public AbstractHandler
{
public:
	explicit MountStatus(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
