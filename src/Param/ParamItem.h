#pragma once

#include <QObject>
#include <QVariant>


class ParamItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ getID NOTIFY notifyChanges)
	Q_PROPERTY(quint16 index READ getIndex NOTIFY notifyChanges)
	Q_PROPERTY(QString group READ getGroup NOTIFY notifyChanges)
	Q_PROPERTY(QString category READ getCategory NOTIFY notifyChanges)
	Q_PROPERTY(QString short_description READ getShortDescription NOTIFY notifyChanges)
	Q_PROPERTY(QString long_description READ getLongDescription NOTIFY notifyChanges)
	Q_PROPERTY(QString units READ getUnits NOTIFY notifyChanges)
	Q_PROPERTY(QString unit_text READ getUnitText NOTIFY notifyChanges)
	Q_PROPERTY(quint8 type READ getType NOTIFY notifyChanges)
	Q_PROPERTY(QString type_text READ getTypeText NOTIFY notifyChanges)
	Q_PROPERTY(bool decimal READ getDecimal NOTIFY notifyChanges)
	Q_PROPERTY(QVariant min READ getMin NOTIFY notifyChanges)
	Q_PROPERTY(QVariant max READ getMax NOTIFY notifyChanges)
	Q_PROPERTY(QVariant increment_size READ getIncrementSize NOTIFY notifyChanges)
	Q_PROPERTY(QVariant value READ getValue NOTIFY notifyChanges)
	Q_PROPERTY(bool reboot_required READ getRebootRequired NOTIFY notifyChanges)

	//    QList<QPair<long, QString>> values {};
	//    QList<QPair<long, QString>> bitmask {};

public:
	explicit ParamItem(QObject * = nullptr);

	QString getID() const;
	void setID(const QString &);

	quint16 getIndex() const;
	void setIndex(const quint16 &);

	QString getGroup() const;
	void setGroup(const QString &);

	QString getCategory() const;
	void setCategory(const QString &);

	QString getShortDescription() const;
	void setShortDescription(const QString &);

	QString getLongDescription() const;
	void setLongDescription(const QString &);

	QString getUnits() const;
	void setUnits(const QString &);

	QString getUnitText() const;
	void setUnitText(const QString &);

	quint8 getType() const;
	void setType(const quint8 &);

	QString getTypeText() const;
	void setTypeText(const QString &);

	bool getDecimal() const;
	void setDecimal(const bool &);

	QVariant getMin() const;
	void setMin(const QVariant &);

	QVariant getMax() const;
	void setMax(const QVariant &);

	QVariant getIncrementSize() const;
	void setIncrementSize(const QVariant &);

	QVariant getValue() const;
	void setValue(const QVariant &);

	bool getRebootRequired() const;
	void setRebootRequired(const bool &);

signals:
	void notifyChanges();

private:
	QString m_id {QString()};
	quint16 m_index {65535};
	QString m_group {QString()};
	QString m_category {QString()};
	QString m_short_description {QString()};
	QString m_long_description {QString()};
	QString m_units {QString()};
	QString m_unit_text {QString()};
	quint8 m_type {255};
	QString m_type_text {QString()};
	bool m_decimal {false};
	QVariant m_min {QVariant::Invalid};
	QVariant m_max {QVariant::Invalid};
	QVariant m_increment_size {QVariant::Invalid};
	QVariant m_value {QVariant::Invalid};
	bool m_reboot_required {false};
};
