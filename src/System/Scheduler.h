#pragma once

#include <QObject>
#include <QTimer>
#include <QDateTime>
#include <QMessageBox>
#include <QApplication>

#include "src/System/Settings.h"
#include "src/System/Variable.h"


class Scheduler : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Scheduler)

public:
	explicit Scheduler();
	~Scheduler();

	static Scheduler *instance();

	void init();

signals:
	void schedule1Hz();
	void schedule2Hz();
	void schedule4Hz();
	void schedule5Hz();
	void schedule10Hz();
	void schedule20Hz();
	void schedule25Hz();
	void schedule50Hz();
	void schedule100Hz();

public slots:
	double seconds();
	quint64 milliseconds();

private slots:
	void update();

private:
	QTimer *timer {nullptr};
	quint64 boot_time;
	uint16_t counter;
};
