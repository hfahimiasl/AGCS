#include "Scheduler.h"


Scheduler::Scheduler() :
	timer(new QTimer(this)),
	boot_time(0),
	counter(0)
{
	QObject::connect(timer, &QTimer::timeout,
			 this, QOverload<>::of(&Scheduler::update));

	timer->start(10);
}

Scheduler::~Scheduler()
{
	delete timer;
}

Scheduler *Scheduler::instance()
{
	static Scheduler self;
	return &self;
}

void Scheduler::init()
{
	boot_time = static_cast<quint64>(QDateTime::currentMSecsSinceEpoch());
}

double Scheduler::seconds()
{
	return static_cast<double>(milliseconds()) / 1000.0;
}

quint64 Scheduler::milliseconds()
{
	return static_cast<quint64>(QDateTime::currentMSecsSinceEpoch()) - boot_time;
}

void Scheduler::update()
{
	counter != UINT16_MAX ? counter ++ : counter = 0;

	if (counter % 100 == 0) { emit schedule1Hz(); }

	if (counter % 50  == 0) { emit schedule2Hz(); }

	if (counter % 25  == 0) { emit schedule4Hz(); }

	if (counter % 20  == 0) { emit schedule5Hz(); }

	if (counter % 10  == 0) { emit schedule10Hz(); }

	if (counter % 5   == 0) { emit schedule20Hz(); }

	if (counter % 4   == 0) { emit schedule25Hz(); }

	if (counter % 2   == 0) { emit schedule50Hz(); }

	if (counter % 1   == 0) { emit schedule100Hz(); }
}
