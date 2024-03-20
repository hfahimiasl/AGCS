#pragma once

#include <QObject>
#include <QTimer>
#include <QMap>

#include "src/Aircraft/protocol/mavlink/MAVLink.h"
#include "AbstractLink.h"
#include "Serial.h"
#include "TCP.h"
#include "UDP.h"


class Link : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Link)

public:
	explicit Link();
	~Link();

	static Link *instance();

signals:
	void connectionChanged(bool connected);

public slots:
	bool isConnected();
	void disconnectAll();
	QList<QString> getSerialPortsList();
	bool connectSerial(QString, qint32, quint8, quint8, quint8, quint8);
	bool connectTCP(QString, quint16);
	bool connectUDP(QString, quint16);

private:
	QTimer *timer {nullptr};

	QMap<AbstractLink *, bool> link_map {
		{Serial::instance(), false},
		{TCP::instance(), false},
		{UDP::instance(), false}
	};
};
