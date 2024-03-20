#include "Device.h"


Device::Device(QObject *parent) :
	QObject(parent),
	port(new QSerialPort(this)),
	timer(new QTimer(this)),
	last_list(getList())
{
	QObject::connect(port, static_cast<void(QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error),
			 this, &Device::onError);

	QObject::connect(timer, &QTimer::timeout,
			 this, QOverload<>::of(&Device::onCheckForChanges));

	timer->start(200);
}

Device::~Device()
{
	delete port;
	delete timer;
}

QStringList Device::getList()
{
	QStringList list;
	list.clear();

	foreach (const QSerialPortInfo &portInfo, QSerialPortInfo::availablePorts()) {
		list.append(portInfo.portName());
	}

	return list;
}

void Device::onCheckForChanges()
{
	const QList<QString> list = getList();

	for (const QString &port : list) {
		if (!last_list.contains(port)) {
			emit notifyChanges(port);
		}
	}

	last_list.clear();
	last_list = list;
}

void Device::onError(QSerialPort::SerialPortError error)
{
	switch (error) {
	case QSerialPort::NoError:
		break;

	case QSerialPort::DeviceNotFoundError:
		qCritical("attempting to open an non-existing device %s", qPrintable(port->portName()));
		port->close();
		emit notifyDisconnected();
		break;

	case QSerialPort::PermissionError:
		qCritical("attempting to open an already opened device %s or a user not having enough permission to open",
			  qPrintable(port->portName()));
		port->close();
		emit notifyDisconnected();
		break;

	case QSerialPort::OpenError:
		qCritical("attempting to open an already opened device in this object");
		port->close();
		emit notifyDisconnected();
		break;

	case QSerialPort::NotOpenError:
		qCritical("operation is executed that can only be successfully performed if the device is open");
		break;

	case QSerialPort::WriteError:
		qCritical("an I/O error occurred while writing the data");
		break;

	case QSerialPort::ReadError:
		qCritical("an I/O error occurred while reading the data");
		break;

	case QSerialPort::ResourceError:
		qCritical("an I/O error occurred when a resource becomes unavailable");
		port->close();
		emit notifyDisconnected();
		break;

	case QSerialPort::UnsupportedOperationError:
		qCritical("the requested device operation is not supported or prohibited by the operating system");
		port->close();
		emit notifyDisconnected();
		break;

	case QSerialPort::TimeoutError:
//        qCritical("a timeout error occurred");    // we set a large timeout for bootloader
		break;

	case QSerialPort::UnknownError:
	default:
		qCritical("an unidentified error occurred (code %d)", error);
		port->close();
		emit notifyDisconnected();
		break;
	}
}
