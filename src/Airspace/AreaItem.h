#pragma once

#include <QObject>
#include <QJsonArray>


class AreaItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ getName NOTIFY notifyChanges)
	Q_PROPERTY(QString group READ getGroup NOTIFY notifyChanges)
	Q_PROPERTY(QString color READ getColor NOTIFY notifyChanges)
	Q_PROPERTY(QJsonArray points READ getPoints NOTIFY notifyChanges)

public:
	explicit AreaItem(QObject * = nullptr);

	void setName(const QString &);
	QString getName() const;

	void setGroup(const QString &);
	QString getGroup() const;

	void setColor(const QString &);
	QString getColor() const;

	void setPoints(const QJsonArray &);
	QJsonArray getPoints() const;

signals:
	void notifyChanges();

private:
	QString m_name {""};
	QString m_group {""};
	QString m_color {""};
	QJsonArray m_points {};
};
