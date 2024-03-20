#pragma once

#include <QObject>

typedef struct {
	QString group;
	QString category;
	QString short_description;
	QString long_description;
	QString min;
	QString max;
	QString increment_size;
	QString units;
	QString unit_text;
	bool reboot_required;
	QList<QPair<int, QString>> values;
	QList<QPair<int, QString>> bitmask;
}   param_fact_s;

typedef QHash<QString, param_fact_s *> ParamFactMetaData;
