#pragma once

#include <QObject>
#include <QTimer>
#include <QGeoCoordinate>

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"
#include "src/Aircraft/protocol/mavlink/MAVLinkProtocolHelpers.h"
#include "src/Aircraft/link/Link.h"


class HomePosition : public QObject, public AbstractHandler
{
	Q_OBJECT

public:
	explicit HomePosition(MAVLink *);
	~HomePosition() override;

	void handle(const mavlink_message_t &) override;

private slots:
	void request();

private:
	QTimer *timer {nullptr};
};
