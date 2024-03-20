#pragma once

#include <QObject>
#include <QTimer>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QApplication>
#include <QJsonArray>
#include <QMessageBox>

#include "src/System/Global.h"
#include "src/System/Settings.h"
#include "src/System/Variable.h"
#include "src/Server/UserAuthentication.h"

using namespace Global;

class UpdateChecker : public QObject
{
	Q_OBJECT

public:
	explicit UpdateChecker();

	static UpdateChecker *instance();

	void init(const QString &);
	bool compare(const QString &, const QString &);

private slots:
	void checkForUpdate();
	void updateManagerFinished(QNetworkReply *);

private:
	QTimer *timer;

	QNetworkAccessManager *update_manager;

	QString base_url;

	static constexpr uint16_t kTimeout {60_s};

	void quit();
};
