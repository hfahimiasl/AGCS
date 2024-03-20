#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class TEMPLATE : public AbstractHandler
{
public:
	explicit TEMPLATE(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
