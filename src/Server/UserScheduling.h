#pragma once

#include <QObject>
#include <QTimer>
#include <QDateTime>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QApplication>
#include <QJsonArray>
#include <QDebug>

#include "src/Server/Server.h"
#include "src/System/Global.h"
#include "src/System/Variable.h"
#include "src/System/Settings.h"
#include "src/System/Scheduler.h"
#include "src/Aircraft/link/Link.h"
#include "src/System/WebSocket.h"

using namespace Global;

class UserScheduling : public QObject
{
	Q_OBJECT

public:
	explicit UserScheduling();

	static UserScheduling *instance();

private slots:
	void update();
	void upload();

private:
	QTimer *user_timer {nullptr};
	QTimer *upload_timer {nullptr};

	QNetworkAccessManager *upload_manager {nullptr};

	WebSocket *web_socket {nullptr};

	qulonglong up_time {0};
	qulonglong connection_time {0};
	qulonglong arm_time {0};

	QString getDataFormat(const uint8_t &, const bool & = true);
};
