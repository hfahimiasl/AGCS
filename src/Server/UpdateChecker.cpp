#include "UpdateChecker.h"


UpdateChecker::UpdateChecker() :
	timer(new QTimer(this)),
	update_manager(new QNetworkAccessManager(this))
{
	QObject::connect(update_manager, &QNetworkAccessManager::finished, this, &UpdateChecker::updateManagerFinished);
}

UpdateChecker *UpdateChecker::instance()
{
	static UpdateChecker self;
	return &self;
}

void UpdateChecker::init(const QString &url)
{
	base_url = url;

	QObject::connect(timer, &QTimer::timeout, this, &UpdateChecker::checkForUpdate);

	timer->start(UpdateChecker::kTimeout);

	checkForUpdate();
}

void UpdateChecker::checkForUpdate()
{
	QString platform;

#if defined(Q_OS_WIN)
	platform = "windows32";

#elif defined(Q_OS_ANDROID)
	platform = "android";
#endif

	update_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/agcs/software/update/" + platform));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	update_manager->get(request);
}

void UpdateChecker::updateManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "update manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	jsonObj = jsonObj.value("record").toObject();

	if (code == 200) {
		Settings::instance()->set(SystemSettings::ServerLatestVersion, jsonObj.value("version").toString());
		Settings::instance()->set(SystemSettings::ServerMandatoryUpdate, jsonObj.value("mandatory").toBool());
		Settings::instance()->set(SystemSettings::ServerDownloadLink, jsonObj.value("link").toString());

	} else if (code == 401 || code == 403) {
		UserAuthentication::instance()->refresh();
	}

	if (compare(QApplication::applicationVersion(),
		    Settings::instance()->get(SystemSettings::ServerLatestVersion).toString())
	    && Settings::instance()->get(SystemSettings::ServerMandatoryUpdate).toBool()
	    && !static_cast<int>(variable.getValue("ARM_STATUS"))) {
		UserAuthentication::instance()->resetSettings();
		quit();
	}
}

bool UpdateChecker::compare(const QString &current, const QString &latest)
{
	QStringList current_version_number = current.split(".");
	QStringList latest_version_number = latest.split(".");

	int count = qMin(current_version_number.count(), latest_version_number.count());

	for (int i = 0 ; i < count ; ++i) {
		int a = current_version_number.at(i).toInt();
		int b = latest_version_number.at(i).toInt();

		if (a < b) {
			return true;

		} else if (a > b) {
			return false;
		}
	}

	if (current_version_number.count() < latest_version_number.count()) {
		return latest_version_number.at(current_version_number.count()).toInt() != 0;
	}

	return false;
}

void UpdateChecker::quit()
{
	QMessageBox::information(nullptr,
				 QObject::tr("ایستگاه زمینی آدلان پایا"),
				 QString("نرم افزار خود را <a href=\"%1\">از اینجا</a> آپدیت کنید")
				 .arg(Settings::instance()->get(SystemSettings::ServerDownloadLink).toString()),
				 QMessageBox::StandardButton::Ok);
	UserAuthentication::instance()->resetSettings();
	QApplication::quit();
}
