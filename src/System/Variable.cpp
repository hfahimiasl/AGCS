#include "Variable.h"


Variable::Variable()
{
	list.begin();
}

int Variable::getIndex(QString id)
{
	variable_s var {};
	var.id = id;
	return list.indexOf(var);
}

bool Variable::isExist(QString id)
{
	return getIndex(id) >= 0;
}

bool Variable::add(QString id, double value, QString text, bool notification)
{
	if (isExist(id)) {
		qCritical("failed to create variable. %s already exists.", qPrintable(id));
		return false;

	} else if (id == "-a") {
		qCritical("failed to create variable. command %s reserved.", qPrintable(id));
		return false;

	} else if (id == "") {
		qCritical("failed to create variable with empty id");
		return false;

	} else {
		variable_s var {};
		var.id = id;
		var.value = value;
		var.default_value = value;
		var.text = text;
		var.default_text = text;
		list.append(var);

		if (notification) {
			emit notifyChanges(id);
		}

		return true;
	}
}

bool Variable::setValue(QString id, double value, bool notification)
{
	if (isExist(id)) {
		list[getIndex(id)].value = value;

		if (notification) {
			emit notifyChanges(id);
		}

		return true;
	}

	return false;
}

bool Variable::setText(QString id, QString text, bool notification)
{
	if (isExist(id)) {
		list[getIndex(id)].text = text;

		if (notification) {
			emit notifyChanges(id);
		}

		return true;
	}

	return false;
}

double Variable::getValue(QString id)
{
	return isExist(id) ? list[getIndex(id)].value : qQNaN();
}

QString Variable::getText(QString id)
{
	return isExist(id) ? list[getIndex(id)].text : "ID not found";
}

bool Variable::reset(QString id, bool notification)
{
	if (isExist(id)) {
		list[getIndex(id)].value = list[getIndex(id)].default_value;
		list[getIndex(id)].text = list[getIndex(id)].default_text;

		if (notification) {
			emit notifyChanges(id);
		}

		return true;
	}

	return false;
}

bool Variable::remove(QString id, bool notification)
{
	if (isExist(id)) {
		list.removeAt(getIndex(id));

		if (notification) {
			emit notifyRemove(id);
		}

		return true;
	}

	return false;
}

void Variable::resetAll(bool notification)
{
	for (int i = 0 ; i < list.size() ; i++) {
		list[i].value = list[i].default_value;
		list[i].text = list[i].default_text;

		if (notification) {
			emit notifyChanges(list[i].id);
		}
	}
}

void Variable::removeAll(bool notification)
{
	list.clear();

	if (notification) {
		emit notifyRemove();
	}
}

int Variable::getCount()
{
	return list.size();
}

void Variable::printAll()
{
	qInfo("------------------------------------------------------------------------------------------");
	qInfo("System variables");
	qInfo("------------------------------------------------------------------------------------------");
	qInfo("ID                                                DEFAULT     VALUE     TEXT");
	qInfo("------------------------------------------------------------------------------------------");

	int i = 0;

	for (i = 0 ; i < list.size() ; i++) {
		char id[50];
		snprintf(id, 50, "%-50s", qPrintable(list[i].id));

		char default_value[12];
		snprintf(default_value, 12, "%-12.5f", list[i].value);

		char value[10];
		snprintf(value, 10, "%-10.5f", list[i].value);

		qInfo() << id << default_value << value << qPrintable(list[i].text);
	}

	qInfo("------------------------------------------------------------------------------------------");
	qInfo("TOTAL                                                         %d", i);
	qInfo("------------------------------------------------------------------------------------------");
}

Variable variable;
