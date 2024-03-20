#pragma once

#include <QObject>
#include <QThread>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QApplication>
#include <QJsonArray>
#include <QDebug>

#include "Bootloader.h"
#include "src/System/Downloader.h"
#include "FirmwareImage.h"

#include "src/System/Settings.h"
#include "src/System/Global.h"
#include "src/System/Toast.h"

#include "src/Server/UserAuthentication.h"


class UpgradeThreadController;


class UpgradeThreadWorker : public QObject
{
	Q_OBJECT

public:
	UpgradeThreadWorker(UpgradeThreadController *);

private slots:
	void onSetBaseURL(const QString &);
	void onSetPermission(const bool &);
	void onPortsChanged(const QString &);
	void onFirmwareManagerFinished(QNetworkReply *);
	void onDownloadRequest(const QString &);
	void onFirmwareDownloaded(const QString &, const QString &);

private:
	UpgradeThreadController *thread_controller { nullptr };
	Bootloader *bootloader { nullptr };
	QNetworkAccessManager *firmware_manager { nullptr };
	Downloader *downloader { nullptr };
	FirmwareImage *image { nullptr };

	bool permission;
	QString port;
	QString base_url;

	void networkRequest(const uint32_t &);

	struct firmware_s {
		QString type;
		QString name;
		QString date;
		QString provider;
		QString link;
		QString version;

		bool operator == (const firmware_s &ref)
		{
			return this->type == ref.type;
		}
	};

	QList<firmware_s> firmware_list;

	QStringList getTypes();

	void upload(FirmwareImage *);
	bool erase();
	void cancel();
};


class UpgradeThreadController : public QObject
{
	Q_OBJECT

public:
	UpgradeThreadController(QObject * = nullptr);
	~UpgradeThreadController();

signals:
	void notifySetBaseURL(const QString &);
	void notifySetPermission(const bool &);
	void notifyFirmwaresList(const QStringList &list);
	void notifyUpload(const QString &);
	void notifyStart();
	void notifyProgress(const uint &progress);
	void notifyInfo(const QString &info);
	void notifyError(const QString &error);
	void notifyComplete();

private:
	UpgradeThreadWorker *worker_ptr {nullptr};
	QThread *worker_thread {nullptr};
};
