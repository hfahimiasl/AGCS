#pragma once

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"


class TerrainReport : public AbstractHandler
{
public:
	explicit TerrainReport(MAVLink *);

	void handle(const mavlink_message_t &) override;
};
