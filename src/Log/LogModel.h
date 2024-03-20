#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "LogItem.h"


class LogModel : public QAbstractListModel
{
	Q_OBJECT
	Q_PROPERTY(int size READ size NOTIFY sizeChanged)

public:
	explicit LogModel(QObject * = nullptr);
	~LogModel();

signals:
	void sizeChanged();

public slots:
	LogItem *get(const int &);
	QList<LogItem *> objects() const;

	int size() const;
	void append(LogItem *);
	void clear();

	int rowCount(const QModelIndex & = QModelIndex()) const;
	QVariant data(const QModelIndex &, int = Qt::DisplayRole) const;

private:
	enum LogModelRoles {
		ObjectRole = Qt::UserRole + 1
	};

	QList<LogItem *> list;
};
