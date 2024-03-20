#include "Global.h"


QString Global::sizeToString(const quint64 &size)
{
	static const QLocale kLocal;

	if (size < 1024) {
		return kLocal.toString(size);

	} else if (size < 1048576) {
		return kLocal.toString(size / 1024.0, 'f', 1) + " KB";

	} else if (size < 1073741824) {
		return kLocal.toString(size / 1048576.0, 'f', 1) + " MB";

	} else if (size < 1099511627776) {
		return kLocal.toString(size / 1073741824.0, 'f', 1) + " GB";

	} else {
		return kLocal.toString(size / 1099511627776.0, 'f', 1) + " TB";
	}
}

void Global::setRawHeader(QNetworkRequest &request, const QString &token)
{
	request.setRawHeader("Content-Type", "application/json");
	request.setRawHeader("User-Agent", QString("(%1; %2) %3/%4 (%5)")
			     .arg(QSysInfo::prettyProductName())
			     .arg(QSysInfo::currentCpuArchitecture())
			     .arg("AGCS")
			     .arg(QApplication::applicationVersion())
			     .arg("Nokia; Qt").toUtf8());
	request.setRawHeader("Authorization", token.toUtf8());
	request.setRawHeader("Client-Id", "aa614e69-0168-4bd9-9307-ad0502d81754");
	request.setRawHeader("version", QApplication::applicationVersion().toUtf8());
	request.setRawHeader("platform", (QSysInfo::productType() + "_" + QSysInfo::currentCpuArchitecture()).toUtf8());
	request.setRawHeader("architecture", QSysInfo::prettyProductName().toUtf8());
	request.setRawHeader("hid", QSysInfo::machineUniqueId());
}
