#include "Link.h"


Link::Link() :
	timer(new QTimer(this))
{
#ifdef Q_OS_ANDROID
	QObject::connect(timer, &QTimer::timeout, this, [this]() {
		static bool status = isConnected();

		if (status != isConnected()) {
			status = isConnected();
			emit connectionChanged(status);
		}
	});

	timer->start(500);
#endif
}

Link::~Link()
{
	delete timer;
}

Link *Link::instance()
{
	static Link self;
	return &self;
}

bool Link::isConnected()
{
	for (AbstractLink *link : link_map.keys()) {
		if (link_map.value(link)) {
			return link->isConnected();
		}
	}

	return false;
}

void Link::disconnectAll()
{
	for (AbstractLink *link : link_map.keys()) {
		link->disconnect();
		link_map[link] = false;

		QObject::disconnect(link, &AbstractLink::connectionChanged,
				    this, &Link::connectionChanged);

		QObject::disconnect(link, &AbstractLink::notifyRead,
				    MAVLink::instance(), &MAVLink::read);

		QObject::disconnect(MAVLink::instance(), &MAVLink::notifyWrite,
				    link, &AbstractLink::write);
	}
}

QList<QString> Link::getSerialPortsList()
{
#ifdef Q_OS_ANDROID

	if (isConnected()) {
		return {};
	}

#endif

	return Serial::instance()->getPortsList();
}

bool Link::connectSerial(QString port, qint32 baudrate, quint8 databits, quint8 parity, quint8 stopbits,
			 quint8 flowcontrol)
{
	disconnectAll();

	Serial::instance()->setPortName(port);
	Serial::instance()->setBaudRate(baudrate);
	Serial::instance()->setDataBits(QSerialPort::DataBits(databits));
	Serial::instance()->setParity(QSerialPort::Parity(parity));
	Serial::instance()->setStopBits(QSerialPort::StopBits(stopbits));
	Serial::instance()->setFlowControl(QSerialPort::FlowControl(flowcontrol));
	Serial::instance()->connect();

	if (Serial::instance()->isConnected()) {
		QObject::connect(Serial::instance(), &Serial::connectionChanged,
				 this, &Link::connectionChanged);

		QObject::connect(Serial::instance(), &Serial::notifyRead,
				 MAVLink::instance(), &MAVLink::read);

		QObject::connect(MAVLink::instance(), &MAVLink::notifyWrite,
				 Serial::instance(), &Serial::write);

		link_map[Serial::instance()] = true;
		emit connectionChanged(true);
		return true;
	}

	return false;
}

bool Link::connectTCP(QString host, quint16 port)
{
	disconnectAll();

	TCP::instance()->setHost(host);
	TCP::instance()->setPort(port);
	TCP::instance()->connect();

	if (TCP::instance()->isConnected()) {
		QObject::connect(TCP::instance(), &TCP::connectionChanged,
				 this, &Link::connectionChanged);

		QObject::connect(TCP::instance(), &TCP::notifyRead,
				 MAVLink::instance(), &MAVLink::read);

		QObject::connect(MAVLink::instance(), &MAVLink::notifyWrite,
				 TCP::instance(), &TCP::write);

		link_map[TCP::instance()] = true;
		emit connectionChanged(true);
		return true;
	}

	return false;
}

bool Link::connectUDP(QString host, quint16 port)
{
	disconnectAll();

	UDP::instance()->setHost(host);
	UDP::instance()->setPort(port);
	UDP::instance()->connect();

	if (UDP::instance()->isConnected()) {
		QObject::connect(UDP::instance(), &UDP::connectionChanged,
				 this, &Link::connectionChanged);

		QObject::connect(UDP::instance(), &UDP::notifyRead,
				 MAVLink::instance(), &MAVLink::read);

		QObject::connect(MAVLink::instance(), &MAVLink::notifyWrite,
				 UDP::instance(), &UDP::write);

		link_map[UDP::instance()] = true;
		emit connectionChanged(true);
		return true;
	}

	return false;
}
