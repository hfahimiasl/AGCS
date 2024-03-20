#include "AreaItem.h"


AreaItem::AreaItem(QObject *parent) : QObject(parent) {}

void AreaItem::setName(const QString &name)
{
	if (m_name != name) {
		m_name = name;
		emit notifyChanges();
	}
}

QString AreaItem::getName() const
{
	return m_name;
}

void AreaItem::setGroup(const QString &group)
{
	if (m_group != group) {
		m_group = group;
		emit notifyChanges();
	}
}

QString AreaItem::getGroup() const
{
	return m_group;
}

void AreaItem::setColor(const QString &color)
{
	if (m_color != color) {
		m_color = color;
		emit notifyChanges();
	}
}

QString AreaItem::getColor() const
{
	return m_color;
}

void AreaItem::setPoints(const QJsonArray &points)
{
	if (m_points != points) {
		m_points = points;
		emit notifyChanges();
	}
}

QJsonArray AreaItem::getPoints() const
{
	return m_points;
}
