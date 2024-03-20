#pragma once

#include <QtMath>

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class GlobalPositionInt : public AbstractHandler
{
public:
	explicit GlobalPositionInt(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
