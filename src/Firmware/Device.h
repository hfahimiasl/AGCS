#pragma once

#include <QObject>
#include <QTimer>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include "libs/qtandroidserialport/qserialport.h"
#include "libs/qtandroidserialport/qserialportinfo.h"
#else
#include <QSerialPort>
#include <QSerialPortInfo>
#endif


class Device : public QObject
{
	Q_OBJECT

public:
	explicit Device(QObject * = nullptr);
	~Device();

	QSerialPort *port { nullptr };

signals:
	void notifyChanges(const QString &);
	void notifyDisconnected();

private slots:
	void onCheckForChanges();
	void onError(QSerialPort::SerialPortError);

private:
	QTimer *timer;
	QList<QString> last_list;

	QStringList getList();
};
