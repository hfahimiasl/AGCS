#include "WebSocket.h"


WebSocket::WebSocket(QObject *parent)
	: QObject(parent)
{
	QObject::connect(&web_socket, &QWebSocket::connected, this, [ = ]() {
		QObject::connect(&web_socket, &QWebSocket::textMessageReceived, this, &WebSocket::textMessageReceived);
		emit connected();
	});

	QObject::connect(&web_socket, &QWebSocket::disconnected, this, &WebSocket::disconnected);

	QObject::connect(&web_socket, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error), this, [ = ]() {
		// qCritical() << web_socket.errorString();
		emit errorString(web_socket.errorString());
	});
}

void WebSocket::open(const QUrl &url)
{
	web_socket.open(url);
}

qint64 WebSocket::sendTextMessage(const QString &message)
{
	return web_socket.sendTextMessage(message);
}

void WebSocket::close(const QWebSocketProtocol::CloseCode &close_code, const QString &reason)
{
	web_socket.close(close_code, reason);
}
