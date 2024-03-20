#pragma once

#include <QObject>
#include <QTimer>
#include <QTcpSocket>
#include <QHostInfo>

#include "InternalLog.h"
#include "UserAuthentication.h"
#include "UpdateChecker.h"
#include "UserScheduling.h"
#include "Support.h"

#include "src/System/Global.h"
#include "src/Firmware/UpgradeThread.h"

using namespace Global;

class Server : public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool connected READ getConnected NOTIFY connectedChanged)

public:
	explicit Server();

	static Server *instance();

	void init();

	UpgradeThreadController *firmware_controller { nullptr };

signals:
	void connectedChanged(const bool &connected);

private slots:
	void lookupReady(const QHostInfo &);

private:
	QTimer timer;

	int host_lookup {0};

	bool m_connected {false};

	static constexpr const char *kBaseURL { "api.adlanpaya.ir" };

	static constexpr quint16 kTimeout {5_s};

	bool getConnected() const;
	void setConnected(const bool &);
};
