#pragma once

#include <QObject>
#include <QSettings>
#include <QQmlEngine>
#include <QCryptographicHash>
#include <QDebug>

#include "CryptoGraphy.h"
#include "SystemSettings.h"


class Settings : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Settings)

public:
	explicit Settings();
	~Settings();

	static Settings *instance();

	void init();

signals:
	void notifyChanges(const SystemSettings::SystemSettingsEnum &key);

public slots:
	QVariant get(const SystemSettings::SystemSettingsEnum &);
	bool set(const SystemSettings::SystemSettingsEnum &, const QVariant &);

	void sync();
	void reset();
	void printAll();

private:
	CryptoGraphy *crypto {nullptr};
	QSettings *settings_ptr {nullptr};

	QString hash(const QVariant &);
};
