#include "LogModel.h"


LogModel::LogModel(QObject *parent)
	: QAbstractListModel(parent)
{
	// empty
}

LogModel::~LogModel()
{
	clear();
}

LogItem *LogModel::get(const int &index)
{
	if (index < 0 || index >= list.size()) {
		return nullptr;
	}

	return list.at(index);
}

QList<LogItem *> LogModel::objects() const
{
	return list;
}

int LogModel::size() const
{
	return list.size();
}

void LogModel::append(LogItem *object)
{
	beginInsertRows(QModelIndex(), rowCount(), rowCount());
	QQmlEngine::setObjectOwnership(object, QQmlEngine::CppOwnership);
	list.append(object);
	endInsertRows();
	emit sizeChanged();
}

void LogModel::clear()
{
	if (list.isEmpty()) {
		return;
	}

	beginRemoveRows(QModelIndex(), 0, list.size() - 1);

	while (list.size()) {
		LogItem *object = list.takeLast();

		if (object) {
			delete object;
		}
	}

	endRemoveRows();

	emit sizeChanged();
}

int LogModel::rowCount(const QModelIndex &) const
{
	return list.size();
}

QVariant LogModel::data(const QModelIndex &index, int role) const
{
	if (index.row() < 0 || index.row() >= list.size()) {
		return QVariant();
	}

	if (role == LogModelRoles::ObjectRole) {
		return QVariant::fromValue(list.at(index.row()));
	}

	return QVariant();
}
