#pragma once

#include <QObject>

#include "src/System/Toast.h"


class AbstractLink : public QObject
{
	Q_OBJECT

public:
	explicit AbstractLink();
	virtual ~AbstractLink();

	virtual bool isConnected() = 0;
	virtual void connect() = 0;
	virtual void disconnect() = 0;

signals:
	void connectionChanged(bool);
	void notifyRead(const QByteArray &);

public slots:
	virtual void write(const QByteArray &) = 0;
};
