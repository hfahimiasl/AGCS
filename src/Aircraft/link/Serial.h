#pragma once

#include <QObject>
#include <QPair>
#include <QMap>
#include <QDebug>

#include "AbstractLink.h"

#ifdef Q_OS_ANDROID
#include "libs/qtandroidserialport/qserialport.h"
#include "libs/qtandroidserialport/qserialportinfo.h"
#else
#include <QSerialPort>
#include <QSerialPortInfo>
#endif


class Serial : public AbstractLink
{
	Q_OBJECT
	Q_DISABLE_COPY(Serial)

public:
	explicit Serial();
	~Serial();

	static Serial *instance();

	QList<QString> getPortsList();
	bool isSystemPort(const QSerialPortInfo &);

	bool isConnected() override;
	void connect() override;
	void disconnect() override;

	void setPortName(QString);
	void setBaudRate(qint32);
	void setDataBits(QSerialPort::DataBits);
	void setParity(QSerialPort::Parity);
	void setStopBits(QSerialPort::StopBits);
	void setFlowControl(QSerialPort::FlowControl);

	QString getPortName() const;
	qint32 getBaudRate() const;
	QSerialPort::DataBits getDataBits() const;
	QSerialPort::Parity getParity() const;
	QSerialPort::StopBits getStopBits() const;
	QSerialPort::FlowControl getFlowControl() const;

public slots:
	void read();
	void write(const QByteArray &) override;
	void error(int);

private:
	QSerialPort *port {nullptr};

	typedef QPair<quint16, quint16> VidPidPair_t;
};
