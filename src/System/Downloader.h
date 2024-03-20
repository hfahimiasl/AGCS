#pragma once

#include <QObject>
#include <QDir>
#include <QFile>
#include <QProcess>
#include <QDateTime>
#include <QNetworkReply>
#include <QDesktopServices>
#include <QNetworkAccessManager>
#include <QApplication>

#include <math.h>

#include "src/System/Settings.h"


class Downloader : public QObject
{
	Q_OBJECT

public:
	explicit Downloader(QObject * = nullptr);
	~Downloader();

signals:
	void notifyError(const QString &error);
	void notifySize(const QString &received, const QString &total);
	void notifyRemainingTime(const QString &time);
	void notifyProgress(const uint &progress);
	void notifyFinished(const QString &url, const QString &path);

public slots:
	void setURL(const QString &);
	void setFileName(const QString &);
	void setRawFileName(const QString &);
	QString getFileName() const;
	void setDownloadDir(const QString &);
	QString getDownloadDir() const;
	void setOpenAfterFinished(bool);
	bool getOpenAfterFinished() const;
	void start(QUrl = QUrl(""));
	void cancel();

private slots:
	void finished();
	void open();
	void calculateSizes(qint64, qint64);
	void calculateRemainingTime(qint64, qint64);
	void save();
	void updateProgress(qint64, qint64);

private:
	QString m_url;
	uint m_startTime;
	QString m_fileName;
	QDir m_downloadDir;
	bool m_openAfterFinished;

	QNetworkReply *m_reply;
	QNetworkAccessManager *m_manager;

	qreal round(const qreal &);
};
