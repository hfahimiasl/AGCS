#ifndef SYSTEM_TOAST_H
#define SYSTEM_TOAST_H

#include <QObject>


class Toast : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Toast)

public:
	explicit Toast();

	void info(const QString &, const quint32 &);
	void warn(const QString &, const quint32 &);
	void error(const QString &, const quint32 &);

signals:
	void notifyInfo(const QString &text, const quint32 &duration);
	void notifyWarn(const QString &text, const quint32 &duration);
	void notifyError(const QString &text, const quint32 &duration);
};

#endif // SYSTEM_TOAST_H

extern Toast toast;
