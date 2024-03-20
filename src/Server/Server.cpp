#include "Server.h"


Server::Server()
	: firmware_controller(new UpgradeThreadController(this))
{
	QObject::connect(&timer, &QTimer::timeout, this, [ = ]() {
#ifdef Q_OS_ANDROID
		QTcpSocket socket;
		socket.connectToHost("8.8.8.8", 53);
		setConnected(socket.waitForConnected(2_s));

#else

		if (!host_lookup) {
			host_lookup = QHostInfo::lookupHost("www.github.com", this, &Server::lookupReady);
		}

#endif
	});

	timer.start(Server::kTimeout);
}

Server *Server::instance()
{
	static Server self;
	return &self;
}

void Server::init()
{
	const QString url = QString("%1://%2").arg(QSslSocket::supportsSsl() ? "https" : "http").arg(Server::kBaseURL);

	UserScheduling::instance();

	Support::instance()->init(url);
	InternalLog::instance()->init(url);
	UpdateChecker::instance()->init(url);
	UserAuthentication::instance()->init(url);

	emit firmware_controller->notifySetBaseURL(url);
}

void Server::lookupReady(const QHostInfo &info)
{
#ifdef Q_OS_ANDROID
	Q_UNUSED(info)
#else
	host_lookup = 0;

	if (info.error() == QHostInfo::NoError && info.addresses().size()) {
		QNetworkProxy tempProxy;
		tempProxy.setType(QNetworkProxy::DefaultProxy);
		QTcpSocket *socket = new QTcpSocket();
		socket->setProxy(tempProxy);
		socket->connectToHost(info.addresses().first(), 80);

		QObject::connect(socket, &QTcpSocket::connected, this, [this, socket] {
			setConnected(true);
			socket->deleteLater();
		});

		QObject::connect(socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error), this, [this,
		socket](QAbstractSocket::SocketError error) {
			Q_UNUSED(error)
			setConnected(false);
			socket->deleteLater();
		});

	} else {
		setConnected(false);
	}

#endif
}

bool Server::getConnected() const
{
	return m_connected;
}

void Server::setConnected(const bool &connected)
{
	if (m_connected != connected) {
		m_connected = connected;
		emit connectedChanged(connected);
	}
}
