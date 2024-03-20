#include "TCP.h"


TCP::TCP() :
	socket(new QTcpSocket(this))
{
	QObject::connect(socket, &QTcpSocket::readyRead, this, &TCP::read);
	QObject::connect(socket, QOverload<QAbstractSocket::SocketError>::of(&QTcpSocket::error), this, &TCP::error);
}

TCP::~TCP()
{
	delete socket;
}

TCP *TCP::instance()
{
	static TCP self;
	return &self;
}

bool TCP::isConnected()
{
	return socket->state() == QTcpSocket::ConnectedState || socket->state() == QTcpSocket::BoundState;
}

void TCP::connect()
{
	if (!isConnected() && !host.isEmpty() && port) {
		socket->connectToHost(host, port);
		emit connectionChanged(socket->waitForConnected());
	}
}

void TCP::disconnect()
{
	if (isConnected()) {
		socket->disconnectFromHost();

		if (socket->state() == QAbstractSocket::UnconnectedState || socket->waitForDisconnected()) {
			emit connectionChanged(false);
		}
	}
}

void TCP::setHost(QString addr)
{
	if (!addr.isEmpty() && addr != host) {
		host = addr;
	}
}

void TCP::setPort(uint16_t _port)
{
	if (_port != port) {
		port = _port;

		if (isConnected()) {
			disconnect();
			connect();
		}
	}
}

void TCP::read()
{
	while (socket->bytesAvailable()) {
		emit notifyRead(socket->readAll());
	}
}

void TCP::write(const QByteArray &data)
{
	if (isConnected()) {
		socket->write(data);
	}
}

void TCP::error(QAbstractSocket::SocketError error)
{
	switch (error) {
	case QAbstractSocket::ConnectionRefusedError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::RemoteHostClosedError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::HostNotFoundError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::SocketAccessError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::SocketResourceError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::SocketTimeoutError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::DatagramTooLargeError:
		break;

	case QAbstractSocket::NetworkError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::AddressInUseError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::SocketAddressNotAvailableError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::UnsupportedSocketOperationError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::OperationError:
		socket->close();
		emit connectionChanged(false);
		break;

	case QAbstractSocket::TemporaryError:
		break;

	case QAbstractSocket::UnknownSocketError:
	default:
		break;
	}

	toast.error(socket->errorString(), 5000);
}
