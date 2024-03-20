#include "Downloader.h"


Downloader::Downloader(QObject *parent) :
	QObject(parent),
	m_url(QString("")),
	m_startTime(0),
	m_fileName(QString("download.file")),
	m_openAfterFinished(false),
	m_manager(new QNetworkAccessManager(this))
{
	m_downloadDir.setPath(QStandardPaths::writableLocation(QStandardPaths::DownloadLocation));
}

Downloader::~Downloader()
{
	delete m_manager;
	delete m_reply;
}

void Downloader::setURL(const QString &url)
{
	m_url = url;
}

void Downloader::setFileName(const QString &name)
{
	m_fileName = name.isEmpty() ? QString("download.file") : (QString("%1.%2").arg(name).arg(m_url.split(".").last()));
}

void Downloader::setRawFileName(const QString &name)
{
	m_fileName = name.isEmpty() ? QString("download.file") : name;
}

QString Downloader::getFileName() const
{
	return m_fileName;
}

void Downloader::setDownloadDir(const QString &downloadDir)
{
	if (downloadDir != m_downloadDir.absolutePath()) {
		m_downloadDir.setPath(downloadDir);
	}
}

QString Downloader::getDownloadDir() const
{
	return m_downloadDir.absolutePath();
}

void Downloader::setOpenAfterFinished(bool open_after_finished)
{
	m_openAfterFinished = open_after_finished;
}

bool Downloader::getOpenAfterFinished() const
{
	return m_openAfterFinished;
}

void Downloader::start(QUrl url)
{
	if (url.isEmpty()) {
		if (m_url.isEmpty()) {
			emit notifyError("Empty URL");
//			qCritical("Empty URL");
			return;

		} else {
			url = QUrl(m_url);
		}
	}

	QNetworkRequest request(url);

	request.setRawHeader("Authorization", Settings::instance()->get(SystemSettings::UserAccessToken).toString().toUtf8());
	request.setRawHeader("User-Agent", QString("(%1; %2) %3/%4 (%5)")
			     .arg(QSysInfo::prettyProductName())
			     .arg(QSysInfo::currentCpuArchitecture())
			     .arg("AGCS")
			     .arg(QApplication::applicationVersion())
			     .arg("Nokia; Qt").toUtf8());

	m_reply = m_manager->get(request);

	m_startTime = QDateTime::currentDateTime().toTime_t();

	if (!m_downloadDir.exists()) {
		m_downloadDir.mkpath(".");
	}

	QFile::remove(m_downloadDir.filePath(m_fileName));
	QFile::remove(m_downloadDir.filePath(m_fileName + ".file"));

	QObject::connect(m_reply, SIGNAL(downloadProgress(qint64, qint64)),
			 this, SLOT(updateProgress(qint64, qint64)));

	QObject::connect(m_reply, SIGNAL(finished()),
			 this, SLOT(finished()));

	QObject::connect(m_reply, SIGNAL(redirected(QUrl)),
			 this, SLOT(start(QUrl)));
}

void Downloader::cancel()
{
	if (!m_reply->isFinished()) {
		m_reply->abort();
	}
}

void Downloader::finished()
{
	QFile::rename(m_downloadDir.filePath(m_fileName + ".file"), m_downloadDir.filePath(m_fileName));
	m_reply->close();
	emit notifyFinished(m_url, m_downloadDir.filePath(m_fileName));

	if (m_openAfterFinished) {
		open();
	}
}

void Downloader::open()
{
	if (QFile::exists(m_downloadDir.filePath(m_fileName))) {
		QDesktopServices::openUrl(QUrl::fromLocalFile(m_downloadDir.filePath(m_fileName)));

	} else {
		emit notifyError("Cannot find downloaded file");
//		qCritical("Cannot find downloaded file");
	}
}

void Downloader::calculateSizes(qint64 received, qint64 total)
{
	QString totalSize;
	QString receivedSize;

	if (total < 1024) {
		totalSize = QString("%1 bytes").arg(total);

	} else if (total < 1048576) {
		totalSize = QString("%1 KB").arg(round(total / 1024));

	} else {
		totalSize = QString("%1 MB").arg(round(total / 1048576));
	}

	if (received < 1024) {
		receivedSize = QString("%1 bytes").arg(received);

	} else if (received < 1048576) {
		receivedSize = QString("%1 KB").arg(received / 1024);

	} else {
		receivedSize = QString("%1 MB").arg(received / 1048576);
	}

	emit notifySize(receivedSize, totalSize);
//	qInfo("Downloaded %s of %s", qPrintable(receivedSize), qPrintable(totalSize));
}

void Downloader::calculateRemainingTime(qint64 received, qint64 total)
{
	uint difference = QDateTime::currentDateTime().toTime_t() - m_startTime;

	if (difference > 0) {
		QString timeString;
		qreal timeRemaining = (total - received) / (received / difference);

		if (timeRemaining > 7200) {
			timeRemaining /= 3600;
			int hours = int (timeRemaining + 0.5);

			if (hours > 1) {
				timeString = QString("about %1 hours").arg(hours);

			} else {
				timeString = QString("about one hour");
			}
		}

		else if (timeRemaining > 60) {
			timeRemaining /= 60;
			int minutes = int (timeRemaining + 0.5);

			if (minutes > 1) {
				timeString = QString("%1 minutes").arg(minutes);

			} else {
				timeString = QString("1 minute");
			}
		}

		else if (timeRemaining <= 60) {
			int seconds = int (timeRemaining + 0.5);

			if (seconds > 1) {
				timeString = QString("%1 seconds").arg(seconds);

			} else {
				timeString = QString("1 second");
			}
		}

		emit notifyRemainingTime(QString("Remaining Time: %1").arg(timeString));
//		qInfo("Remaining Time: %s", qPrintable(timeString));
	}
}

void Downloader::save()
{
	QUrl url = m_reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();

	if (!url.isEmpty()) {
		start(url);
		return;
	}

	QFile file(m_downloadDir.filePath(m_fileName + ".file"));

	if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
		file.write(m_reply->readAll());
		file.close();
	}
}

void Downloader::updateProgress(qint64 received, qint64 total)
{
	if (total > 0) {
		calculateSizes(received, total);
		calculateRemainingTime(received, total);
		save();

		emit notifyProgress(uint((received * 100) / total));
//		qInfo("Download Progress: %d %%", uint((received * 100) / total));

	} else {
		emit notifyProgress(0);
		emit notifyRemainingTime("Time Remaining: unknown");
//		qWarning("Download Progress: unknown");
//		qWarning("Time Remaining: unknown");
	}
}

qreal Downloader::round(const qreal &input)
{
	return static_cast<qreal>(roundf(static_cast<float>(input) * 100) / 100);
}
