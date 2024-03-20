#include "Toast.h"


Toast::Toast() {}

void Toast::info(const QString &text, const quint32 &duration)
{
	emit notifyInfo(text, duration);
}

void Toast::warn(const QString &text, const quint32 &duration)
{
	emit notifyWarn(text, duration);
}

void Toast::error(const QString &text, const quint32 &duration)
{
	emit notifyError(text, duration);
}

Toast toast;
