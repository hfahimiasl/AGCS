#pragma once

#include <QTcpSocket>

#include "AbstractLink.h"


class TCP : public AbstractLink
{
	Q_OBJECT
	Q_DISABLE_COPY(TCP)

public:
	explicit TCP();
	~TCP();

	static TCP *instance();

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
	QTcpSocket *socket;
	QString host;
	uint16_t port;
};
