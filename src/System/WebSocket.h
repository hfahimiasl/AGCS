#pragma once

#include <QObject>
#include <QWebSocket>


class WebSocket : public QObject
{
	Q_OBJECT

public:
	explicit WebSocket(QObject * = nullptr);

	qint64 sendTextMessage(const QString &);

	void open(const QUrl &);
	void close(const QWebSocketProtocol::CloseCode & = QWebSocketProtocol::CloseCodeNormal, const QString & = QString());

signals:
	void connected();
	void disconnected();
	void errorString(const QString &);
	void textMessageReceived(const QString &);

private:
	QWebSocket web_socket;
};
