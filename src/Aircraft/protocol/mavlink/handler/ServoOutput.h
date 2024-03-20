#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class ServoOutput : public AbstractHandler
{
public:
	explicit ServoOutput(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
