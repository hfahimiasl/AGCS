#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class RemoteControl : public AbstractHandler
{
public:
	explicit RemoteControl(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
