#pragma once

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QApplication>
#include <QTimer>
#include <QSslSocket>
#include <QDebug>

#include "libs/QObjectListModel/qobjectlistmodel.h"
#include "libs/QObjectListModel/qgadgetlistmodel.h"
#include "libs/QObjectListModel/qobjectproxymodel.h"

#include "src/Airspace/AreaItem.h"
#include "src/Airspace/AirportItem.h"
#include "src/Airspace/AirTrafficItem.h"
#include "src/System/Global.h"
#include "src/System/Settings.h"
#include "src/Server/UserAuthentication.h"


class AirspaceService : public QObject
{
	Q_OBJECT

public:
	explicit AirspaceService(QObject *, QQmlApplicationEngine *);
	~AirspaceService();

	static AirspaceService *instance(QObject * = nullptr, QQmlApplicationEngine * = nullptr);

public slots:
	void request();
	void areaClear();
	void airportClear();
	void airTrafficClear();

private slots:
	void areaManagerFinished(QNetworkReply *);
	void airportManagerFinished(QNetworkReply *);
	void airTrafficManagerFinished(QNetworkReply *);

private:
	QTimer *timer {nullptr};

	QNetworkAccessManager *area_manager {nullptr};
	QNetworkAccessManager *airport_manager {nullptr};
	QNetworkAccessManager *air_traffic_manager {nullptr};

	QGenericListModel<AreaItem> *circle_area_model {nullptr};
	QGenericListModel<AreaItem> *polygon_area_model {nullptr};
	QGenericListModel<AirportItem> *airport_model {nullptr};
	QGenericListModel<AirTrafficItem> *air_traffic_model {nullptr};

	QString base_url;

	const QStringList invalid_air_traffic_keys {"full_count", "stats", "version"};

	void requestArea();
	void requestAirport();
	void requestAirTraffic();

	void areaInsert(const QJsonObject &);
	void airportInsert(const QJsonObject &);
	void airTrafficInsert(const QJsonArray &);
};
