#include "UDP.h"


UDP::UDP() :
	socket(new QUdpSocket(this))
{
	QObject::connect(socket, &QUdpSocket::readyRead, this, &UDP::read);
	QObject::connect(socket, QOverload<QAbstractSocket::SocketError>::of(&QUdpSocket::error), this, &UDP::error);
}

UDP::~UDP()
{
	delete socket;
}

UDP *UDP::instance()
{
	static UDP self;
	return &self;
}

bool UDP::isConnected()
{
	return socket->state() == QAbstractSocket::BoundState;
}

void UDP::connect()
{
	if (!isConnected() && !host.isEmpty() && port) {
		socket->bind(QHostAddress(host), port) ? emit connectionChanged(true) : socket->close();
	}
}

void UDP::disconnect()
{
	if (isConnected()) {
		socket->close();
		emit connectionChanged(false);
	}
}

void UDP::setHost(QString addr)
{
	if (!addr.isEmpty() && addr != host) {
		host = addr;
	}
}

void UDP::setPort(uint16_t _port)
{
	if (_port != port) {
		port = _port;

		if (isConnected()) {
			disconnect();
			connect();
		}
	}
}

void UDP::read()
{
	while (socket->bytesAvailable()) {
		QByteArray datagram;
		datagram.resize(socket->pendingDatagramSize());
		socket->readDatagram(datagram.data(), datagram.size(), &endpoint_host, &endpoint_port);
		emit notifyRead(datagram);
	}
}

void UDP::write(const QByteArray &data)
{
	if (isConnected() && !endpoint_host.isNull() && endpoint_port) {
		socket->writeDatagram(data, endpoint_host, endpoint_port);
	}
}

void UDP::error(QAbstractSocket::SocketError error)
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
