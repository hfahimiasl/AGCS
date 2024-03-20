#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class VFR : public AbstractHandler
{
public:
	explicit VFR(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
