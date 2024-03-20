#include "RunGuard.h"


RunGuard::RunGuard() :
	memLockKey(generateKeyHash(RUNGUARDKEY, "_memLockKey")),
	sharedmemKey(generateKeyHash(RUNGUARDKEY, "_sharedmemKey")),
	sharedMem(sharedmemKey),
	memLock(memLockKey, 1)
{
	memLock.acquire();

	{
		QSharedMemory fix(sharedmemKey);
		fix.attach();
	}

	memLock.release();
}

RunGuard::~RunGuard()
{
	release();
}

RunGuard *RunGuard::instance()
{
	static RunGuard run_guard;
	return &run_guard;
}

bool RunGuard::isAnotherRunning()
{
	if (sharedMem.isAttached()) {
		return false;
	}

	memLock.acquire();
	const bool isRunning = sharedMem.attach();

	if (isRunning) {
		sharedMem.detach();
	}

	memLock.release();
	return isRunning;
}

bool RunGuard::isExecutable()
{
	if (isAnotherRunning()) {
		return false;
	}

	memLock.acquire();
	const bool result = sharedMem.create(sizeof(quint64));
	memLock.release();

	if (!result) {
		release();
		return false;
	}

	return true;
}

QString RunGuard::generateKeyHash(const QString &key, const QString &salt)
{
	QByteArray data;
	data.append(key.toUtf8());
	data.append(salt.toUtf8());
	data = QCryptographicHash::hash(data, QCryptographicHash::Sha1).toHex();
	return data;
}

void RunGuard::release()
{
	memLock.acquire();

	if (sharedMem.isAttached()) {
		sharedMem.detach();
	}

	memLock.release();
}