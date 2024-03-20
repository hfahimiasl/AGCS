#pragma once

#include <QObject>
#include <QSharedMemory>
#include <QSystemSemaphore>
#include <QCryptographicHash>


#define RUNGUARDKEY "AGCSRunGuardKey"


class RunGuard
{
	Q_DISABLE_COPY(RunGuard)

public:
	RunGuard();
	~RunGuard();

	static RunGuard *instance();

	bool isAnotherRunning();
	bool isExecutable();

private:
	const QString memLockKey;
	const QString sharedmemKey;
	QSharedMemory sharedMem;
	QSystemSemaphore memLock;

	QString generateKeyHash(const QString &, const QString &);
	void release();
};
