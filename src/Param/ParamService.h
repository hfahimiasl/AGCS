#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <limits>
#include <QStandardPaths>
#include <QFileDialog>
#include <QFile>
#include <QDebug>

#include "ParamFact.h"
#include "ParamItem.h"
#include "ParamMetaData.h"

#include "libs/QObjectListModel/qobjectlistmodel.h"
#include "libs/QObjectListModel/qgadgetlistmodel.h"
#include "libs/QObjectListModel/qobjectproxymodel.h"

#include "libs/mavlink/v2.0/ardupilotmega/mavlink.h"

#include "src/System/Variable.h"
#include "src/System/Toast.h"


class ParamService : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ParamService)

public:
	explicit ParamService(QObject *, QQmlApplicationEngine *);
	~ParamService();

	static ParamService *instance(QObject * = nullptr, QQmlApplicationEngine * = nullptr);

	void insert(const QString &, const quint16 &, const quint8 &, const double &);

signals:
	void notifyDownload();
	void notifyDownloadComplete();
	void notifyProgress(const double &progress);
	void notifyUpload(const QString &, const double &);
	void notifyUploadList(const QStringList &);
	void notifyChanges(ParamItem *param);
	void notifyRestoreDefault();
	void notifySaveToFile();
	void notifyLoadFromFile();

public slots:
	QModelIndex indexOf(const QString &);
	bool isExist(const QString &);
	int count();
	void clear();
	ParamItem *get(const int &);
	ParamItem *get(const QString &);
	void print(const QString & = "");

private:
	ParamItem *other {nullptr};
	QGenericListModel<ParamItem> *model {nullptr};

	void print(const ParamItem *);
};
