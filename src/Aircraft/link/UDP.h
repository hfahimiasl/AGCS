#pragma once

#include <QUdpSocket>

#include "AbstractLink.h"


class UDP : public AbstractLink
{
	Q_OBJECT
	Q_DISABLE_COPY(UDP)

public:
	explicit UDP();
	~UDP();

	static UDP *instance();

	bool isConnected() override;
	void connect() override;
	void disconnect() override;

	void setHost(QString);
	void setPort(uint16_t);

public slots:
	void read();
	void write(const QByteArray &) override;
	void error(QAbstractSocket::SocketError);

private:
	QUdpSocket *socket;
	QString host;
	uint16_t port;
	QHostAddress endpoint_host;
	uint16_t endpoint_port;
};
