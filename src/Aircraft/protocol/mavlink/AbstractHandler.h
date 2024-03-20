#pragma once

#include "src/platform_common.h"
#include "libs/mavlink/v2.0/ardupilotmega/mavlink.h"
#include "MAVLinkProtocolHelpers.h"

class MAVLink;

class AbstractHandler
{
public:
	explicit AbstractHandler(MAVLink *);
	virtual ~AbstractHandler();

	virtual void handle(const mavlink_message_t &) = 0;

protected:
	MAVLink *const mavlink;
};
