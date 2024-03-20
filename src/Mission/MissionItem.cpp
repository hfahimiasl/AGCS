#include "MissionItem.h"


MissionItem::MissionItem(QObject *parent) : QObject(parent)
{
	// empty
}

quint16 MissionItem::getSequence() const
{
	return m_sequence;
}

void MissionItem::setSequence(const quint16 &sequence)
{
	if (m_sequence != sequence) {
		m_sequence = sequence;
		emit sequenceChanged();
	}
}

QGeoCoordinate MissionItem::getCoordinate() const
{
	return m_coordinate;
}

void MissionItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}

quint16 MissionItem::getCommand() const
{
	return m_command;
}

void MissionItem::setCommand(const quint16 &command)
{
	if (m_command != command) {
		m_command = command;
		emit commandChanged();
	}
}

quint8 MissionItem::getFrame() const
{
	return m_frame;
}

void MissionItem::setFrame(const quint8 &frame)
{
	if (m_frame != frame) {
		m_frame = frame;
		emit frameChanged();
	}
}

quint8 MissionItem::getCurrent() const
{
	return m_current;
}

void MissionItem::setCurrent(const quint8 &current)
{
	if (m_current != current) {
		m_current = current;
		emit currentChanged();
	}
}

quint8 MissionItem::getAutoContinue() const
{
	return m_auto_continue;
}

void MissionItem::setAutoContinue(const quint8 &auto_continue)
{
	if (m_auto_continue != auto_continue) {
		m_auto_continue = auto_continue;
		emit autoContinueChanged();
	}
}

quint8 MissionItem::getType() const
{
	return m_type;
}

void MissionItem::setType(const quint8 &type)
{
	if (m_type != type) {
		m_type = type;
		emit typeChanged();
	}
}

double MissionItem::getParam1() const
{
	return m_param1;
}

void MissionItem::setParam1(const double &param1)
{
	if (!qFuzzyCompare(m_param1, param1)) {
		m_param1 = param1;
		emit param1Changed();
	}
}

double MissionItem::getParam2() const
{
	return m_param2;
}

void MissionItem::setParam2(const double &param2)
{
	if (!qFuzzyCompare(m_param2, param2)) {
		m_param2 = param2;
		emit param2Changed();
	}
}

double MissionItem::getParam3() const
{
	return m_param3;
}

void MissionItem::setParam3(const double &param3)
{
	if (!qFuzzyCompare(m_param3, param3)) {
		m_param3 = param3;
		emit param3Changed();
	}
}

double MissionItem::getParam4() const
{
	return m_param4;
}

void MissionItem::setParam4(const double &param4)
{
	if (!qFuzzyCompare(m_param4, param4)) {
		m_param4 = param4;
		emit param4Changed();
	}
}

QString MissionItem::getLabel() const
{
	return m_label;
}

void MissionItem::setLabel(const QString &label)
{
	if (m_label != label.trimmed()) {
		m_label = label.trimmed();
		emit labelChanged();
	}
}

bool MissionItem::getUnicodeLabel() const
{
	return m_unicode_label;
}

void MissionItem::setUnicodeLabel(const bool &unicode_label)
{
	if (m_unicode_label != unicode_label) {
		m_unicode_label = unicode_label;
		emit unicodeLabelChanged();
	}
}

bool MissionItem::getVisible() const
{
	return m_visible;
}

void MissionItem::setVisible(const bool &visible)
{
	if (m_visible != visible) {
		m_visible = visible;
		emit visibleChanged();
	}
}
