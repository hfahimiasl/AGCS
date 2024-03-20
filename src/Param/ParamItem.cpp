#include "ParamItem.h"


ParamItem::ParamItem(QObject *parent) :
	QObject(parent)
{
	// empty
}

QString ParamItem::getID() const
{
	return m_id;
}

void ParamItem::setID(const QString &id)
{
	if (m_id != id) {
		m_id = id;
		emit notifyChanges();
	}
}

quint16 ParamItem::getIndex() const
{
	return m_index;
}

void ParamItem::setIndex(const quint16 &index)
{
	if (m_index != index) {
		m_index = index;
		emit notifyChanges();
	}
}

QString ParamItem::getGroup() const
{
	return m_group;
}

void ParamItem::setGroup(const QString &group)
{
	if (m_group != group) {
		m_group = group;
		emit notifyChanges();
	}
}

QString ParamItem::getCategory() const
{
	return m_category;
}

void ParamItem::setCategory(const QString &category)
{
	if (m_category != category) {
		m_category = category;
		emit notifyChanges();
	}
}

QString ParamItem::getShortDescription() const
{
	return m_short_description;
}

void ParamItem::setShortDescription(const QString &short_description)
{
	if (m_short_description != short_description) {
		m_short_description = short_description;
		emit notifyChanges();
	}
}

QString ParamItem::getLongDescription() const
{
	return m_long_description;
}

void ParamItem::setLongDescription(const QString &long_description)
{
	if (m_long_description != long_description) {
		m_long_description = long_description;
		emit notifyChanges();
	}
}

QString ParamItem::getUnits() const
{
	return m_units;
}

void ParamItem::setUnits(const QString &units)
{
	if (m_units != units) {
		m_units = units;
		emit notifyChanges();
	}
}

QString ParamItem::getUnitText() const
{
	return m_unit_text;
}

void ParamItem::setUnitText(const QString &unit_text)
{
	if (m_unit_text != unit_text) {
		m_unit_text = unit_text;
		emit notifyChanges();
	}
}

quint8 ParamItem::getType() const
{
	return m_type;
}

void ParamItem::setType(const quint8 &type)
{
	if (m_type != type) {
		m_type = type;
		emit notifyChanges();
	}
}

QString ParamItem::getTypeText() const
{
	return m_type_text;
}

void ParamItem::setTypeText(const QString &type_text)
{
	if (m_type_text != type_text) {
		m_type_text = type_text;
		emit notifyChanges();
	}
}

bool ParamItem::getDecimal() const
{
	return m_decimal;
}

void ParamItem::setDecimal(const bool &decimal)
{
	if (m_decimal != decimal) {
		m_decimal = decimal;
		emit notifyChanges();
	}
}

QVariant ParamItem::getMin() const
{
	return m_min;
}

void ParamItem::setMin(const QVariant &min)
{
	if (m_min != min) {
		m_min = min;
		emit notifyChanges();
	}
}

QVariant ParamItem::getMax() const
{
	return m_max;
}

void ParamItem::setMax(const QVariant &max)
{
	if (m_max != max) {
		m_max = max;
		emit notifyChanges();
	}
}

QVariant ParamItem::getIncrementSize() const
{
	return m_increment_size;
}

void ParamItem::setIncrementSize(const QVariant &increment_size)
{
	if (m_increment_size != increment_size) {
		m_increment_size = increment_size;
		emit notifyChanges();
	}
}

QVariant ParamItem::getValue() const
{
	return m_value;
}

void ParamItem::setValue(const QVariant &value)
{
	if (m_value != value) {
		m_value = value;
		emit notifyChanges();
	}
}

bool ParamItem::getRebootRequired() const
{
	return m_reboot_required;
}

void ParamItem::setRebootRequired(const bool &reboot_required)
{
	if (m_reboot_required != reboot_required) {
		m_reboot_required = reboot_required;
		emit notifyChanges();
	}
}
