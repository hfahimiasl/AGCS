#ifndef SYSTEM_VARIABLE_H
#define SYSTEM_VARIABLE_H

#include <QObject>
#include <QDebug>


class Variable : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Variable)

public:
	explicit Variable();

signals:
	void notifyChanges(const QString &id = "-a");
	void notifyRemove(const QString &id = "-a");

public slots:
	int getIndex(QString);
	bool isExist(QString);

	bool add(QString, double = 0.0, QString = "", bool = false);

	bool setValue(QString, double, bool = false);
	bool setText(QString, QString, bool = false);

	double getValue(QString);
	QString getText(QString);

	bool reset(QString, bool = false);
	bool remove(QString, bool = false);

	void resetAll(bool = false);
	void removeAll(bool = false);

	int getCount();
	void printAll();

private:
	struct variable_s {
		QString id;
		double value;
		double default_value;
		QString text;
		QString default_text;

		bool operator == (const variable_s &ref)
		{
			return this->id == ref.id;
		}
	};

	QList<variable_s> list;
};

#endif // SYSTEM_VARIABLE_H

extern Variable variable;
