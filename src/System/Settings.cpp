#include "Settings.h"


Settings::Settings() :
	crypto(new CryptoGraphy(0xa85e8e92130d839d)),
	settings_ptr(new QSettings(QSettings::NativeFormat, QSettings::UserScope, "AGCS", "AGCS"))
{
	qmlRegisterType<SystemSettings>("SystemSettings", 2, 6, "SystemSettings");
	crypto->setProtectionMode(CryptoGraphy::ProtectionMode::ProtectionModeChecksum);
}

Settings::~Settings()
{
	settings_ptr->sync();
	delete settings_ptr;
	delete crypto;
}

Settings *Settings::instance()
{
	static Settings self;
	return &self;
}

void Settings::init()
{
	if (settings_ptr->allKeys().isEmpty() || settings_ptr->allKeys().size() != SystemSettings::SystemSettingsMap.keys().size()) {
		reset();
		return;
	}

	for (const SystemSettings::SystemSettingsEnum &key : SystemSettings::SystemSettingsMap.keys()) {
		const QString hash_key = hash(SystemSettings::SystemSettingsMap.value(key).value(0));

		if (!settings_ptr->contains(hash_key)) {
			reset();
			return;
		}

		if (crypto->decrypt(QByteArray::fromHex(settings_ptr->value(hash_key).toString().toLatin1())) == QVariant::Invalid) {
			reset();
			return;
		}
	}

	if (QApplication::applicationVersion() != get(SystemSettings::AppPreviousInstalledVersion).toString()) {
		reset();
	}
}

QVariant Settings::get(const SystemSettings::SystemSettingsEnum &key)
{
	if (SystemSettings::SystemSettingsMap.contains(key)) {
		const QString hash_key = hash(SystemSettings::SystemSettingsMap.value(key).value(0));
		return crypto->decrypt(QByteArray::fromHex(settings_ptr->value(hash_key).toString().toLatin1()));
	}

	qCritical() << key << "not found";

	return QVariant::Invalid;
}

bool Settings::set(const SystemSettings::SystemSettingsEnum &key, const QVariant &value)
{
	if (SystemSettings::SystemSettingsMap.contains(key)) {
		if (value != get(key)) {
			const QString hash_key = hash(SystemSettings::SystemSettingsMap.value(key).value(0));
			settings_ptr->setValue(hash_key, QString::fromLatin1(crypto->encrypt(value).toByteArray().toHex()));
			settings_ptr->sync();
			emit notifyChanges(key);
		}

		return true;
	}

	qCritical() << key << "not found";

	return false;
}

void Settings::sync()
{
	settings_ptr->sync();
}

void Settings::reset()
{
	settings_ptr->clear();

	for (const SystemSettings::SystemSettingsEnum &key : SystemSettings::SystemSettingsMap.keys()) {
		const QString hash_key = hash(SystemSettings::SystemSettingsMap.value(key).value(0));
		settings_ptr->setValue(hash_key, QString::fromLatin1(crypto->encrypt(SystemSettings::SystemSettingsMap.value(key).value(
					       1)).toByteArray().toHex()));
		emit notifyChanges(key);
	}

	set(SystemSettings::AppPreviousInstalledVersion, QApplication::applicationVersion());
}

QString Settings::hash(const QVariant &data)
{
	return QString(QCryptographicHash::hash(data.toByteArray(), QCryptographicHash::Algorithm::Md5).toHex());
}

void Settings::printAll()
{
	qInfo("------------------------------------------------------------");
	qInfo("System settings");
	qInfo("------------------------------------------------------------");
	qInfo("KEY                           TYPE / VALUE");
	qInfo("------------------------------------------------------------");

	int i = 0;

	for (const SystemSettings::SystemSettingsEnum &key : SystemSettings::SystemSettingsMap.keys()) {
		char id[30];
		snprintf(id, 30, "%-30s", qPrintable(SystemSettings::SystemSettingsMap.value(key).value(0).toString()));
		qInfo() << id << get(key).toString();
		i++;
	}

	qInfo("------------------------------------------------------------");
	qInfo("TOTAL                         %d", i);
	qInfo("------------------------------------------------------------");
}
