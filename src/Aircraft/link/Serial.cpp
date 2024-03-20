#include "Serial.h"


Serial::Serial() :
	port(new QSerialPort(this))
{
	QObject::connect(port, &QSerialPort::readyRead, this, &Serial::read);
	QObject::connect(port, QOverload<QSerialPort::SerialPortError>::of(&QSerialPort::error), this, &Serial::error);
}

Serial::~Serial()
{
	delete port;
}

Serial *Serial::instance()
{
	static Serial self;
	return &self;
}

QList<QString> Serial::getPortsList()
{
	QList<QString> list {};
	QMap<VidPidPair_t, QStringList> seen_serial_numbers {};

	for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts()) {
		if (!isSystemPort(info)) {
			if (info.hasVendorIdentifier() && info.hasProductIdentifier() && !info.serialNumber().isEmpty() && info.serialNumber() != "0") {
				const VidPidPair_t vid_pid(info.vendorIdentifier(), info.productIdentifier());

				if (seen_serial_numbers.contains(vid_pid) && seen_serial_numbers.value(vid_pid).contains(info.serialNumber())) {
					qDebug() << "skipping secondary port on same device" << info.portName() << info.vendorIdentifier() << info.productIdentifier() <<
						 info.serialNumber();
					continue;
				}

				seen_serial_numbers[vid_pid].append(info.serialNumber());
			}

			list.append(info.portName());
		}
	}

	return list;
}

bool Serial::isSystemPort(const QSerialPortInfo &port)
{
	// TODO: XXX Add Linux (LTE modems, etc) and Windows as needed

	// MAC OS
	if (port.systemLocation().contains("tty.MALS")
	    || port.systemLocation().contains("tty.SOC")
	    || port.systemLocation().contains("tty.Bluetooth-Incoming-Port")
	    || port.systemLocation().contains("tty.usbserial")
	    || port.systemLocation().contains("tty.usbmodem")) {
		return true;
	}

	return false;
}

bool Serial::isConnected()
{
	return port->isOpen();
}

void Serial::connect()
{
	if (!(isConnected() || port->portName().isEmpty()) && port->open(QIODevice::ReadWrite)) {
		emit connectionChanged(true);
	}
}

void Serial::disconnect()
{
	if (isConnected()) {
		port->close();
		emit connectionChanged(false);
	}
}

void Serial::setPortName(QString portname)
{
	if (!portname.isEmpty() && portname != port->portName()) {
		port->setPortName(portname);
	}
}

void Serial::setBaudRate(qint32 baudrate)
{
	if (baudrate != port->baudRate()) {
		port->setBaudRate(baudrate);
	}
}

void Serial::setDataBits(QSerialPort::DataBits databits)
{
	if (databits != port->dataBits()) {
		port->setDataBits(databits);
	}
}

void Serial::setParity(QSerialPort::Parity parity)
{
	if (parity != port->parity()) {
		port->setParity(parity);
	}
}

void Serial::setStopBits(QSerialPort::StopBits stopbits)
{
	if (stopbits != port->stopBits()) {
		port->setStopBits(stopbits);
	}
}

void Serial::setFlowControl(QSerialPort::FlowControl flowcontrol)
{
	if (flowcontrol != port->flowControl()) {
		port->setFlowControl(flowcontrol);
	}
}

QString Serial::getPortName() const
{
	return port->portName();
}

qint32 Serial::getBaudRate() const
{
	return port->baudRate();
}

QSerialPort::DataBits Serial::getDataBits() const
{
	return  port->dataBits();
}

QSerialPort::Parity Serial::getParity() const
{
	return port->parity();
}

QSerialPort::StopBits Serial::getStopBits() const
{
	return port->stopBits();
}

QSerialPort::FlowControl Serial::getFlowControl() const
{
	return port->flowControl();
}

void Serial::read()
{
	if (port->isReadable()) {
		emit notifyRead(port->readAll());
	}
}

void Serial::write(const QByteArray &data)
{
	if (port->isOpen() && port->isWritable()) {
		port->write(data.data(), data.size());
	}
}

void Serial::error(int error)
{
	switch (error) {
	case QSerialPort::NoError:
		return;

	case QSerialPort::DeviceNotFoundError:
		port->close();
		emit connectionChanged(false);
		break;

	case QSerialPort::PermissionError:
		port->close();
		emit connectionChanged(false);
		break;

	case QSerialPort::OpenError:
		port->close();
		emit connectionChanged(false);
		break;

	case QSerialPort::NotOpenError:
		break;

	case QSerialPort::WriteError:
		break;

	case QSerialPort::ReadError:
		break;

	case QSerialPort::ResourceError:
		port->close();
		emit connectionChanged(false);
		break;

	case QSerialPort::UnsupportedOperationError:
		port->close();
		emit connectionChanged(false);
		break;

	case QSerialPort::TimeoutError:
		break;

	case QSerialPort::UnknownError:
	default:
		break;
	}

	toast.error(port->errorString(), 5000);
}
