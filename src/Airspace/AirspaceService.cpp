#include "AirspaceService.h"


AirspaceService::AirspaceService(QObject *parent, QQmlApplicationEngine *engine) :
	QObject(parent),
	timer(new QTimer(this)),
	area_manager(new QNetworkAccessManager(this)),
	airport_manager(new QNetworkAccessManager(this)),
	air_traffic_manager(new QNetworkAccessManager(this)),
	circle_area_model(new QGenericListModel<AreaItem>(true, nullptr)),
	polygon_area_model(new QGenericListModel<AreaItem>(true, nullptr)),
	airport_model(new QGenericListModel<AirportItem>(true, nullptr)),
	air_traffic_model(new QGenericListModel<AirTrafficItem>(true, nullptr))
{
	circle_area_model->setEditable(true);
	polygon_area_model->setEditable(true);
	airport_model->setEditable(true);
	air_traffic_model->setEditable(true);

	engine->rootContext()->setContextProperty("circle_area_model", circle_area_model);
	engine->rootContext()->setContextProperty("polygon_area_model", polygon_area_model);
	engine->rootContext()->setContextProperty("airport_model", airport_model);
	engine->rootContext()->setContextProperty("air_traffic_model", air_traffic_model);
	engine->rootContext()->setContextProperty("airspace_service", this);

	QObject::connect(area_manager, &QNetworkAccessManager::finished,
			 this, &AirspaceService::areaManagerFinished);

	QObject::connect(airport_manager, &QNetworkAccessManager::finished,
			 this, &AirspaceService::airportManagerFinished);

	QObject::connect(air_traffic_manager, &QNetworkAccessManager::finished,
			 this, &AirspaceService::airTrafficManagerFinished);

	QObject::connect(timer, &QTimer::timeout,
			 this, &AirspaceService::requestAirTraffic);

	timer->start(5000);

	base_url = QString("%1://api.adlanpaya.ir").arg(QSslSocket::supportsSsl() ? "https" : "http");
}

AirspaceService::~AirspaceService()
{
	delete timer;
	delete area_manager;
	delete airport_manager;
	delete air_traffic_manager;
	delete circle_area_model;
	delete polygon_area_model;
	delete airport_model;
	delete air_traffic_model;
}

AirspaceService *AirspaceService::instance(QObject *parent, QQmlApplicationEngine *engine)
{
	static AirspaceService self(parent, engine);
	return &self;
}

void AirspaceService::requestArea()
{
	area_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/airspace/area/list"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	area_manager->get(request);
}

void AirspaceService::requestAirport()
{
	airport_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/airspace/airport/list"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	airport_manager->get(request);
}

void AirspaceService::requestAirTraffic()
{
	air_traffic_manager->clearConnectionCache();
	const QNetworkRequest request(
		QUrl("http://data-live.flightradar24.com/zones/fcgi/feed.js?faa=1&bounds=40.729%2C26.015%2C23.303%2C79.552&satellite=1&mlat=1&flarm=1&adsb=1&gnd=1&air=1&vehicles=1&estimated=1&maxage=14400&gliders=1&selected=271e1283&ems=1&stats=1")
	);
	air_traffic_manager->get(request);
}

void AirspaceService::request()
{
	requestArea();
	requestAirport();
}

void AirspaceService::areaManagerFinished(QNetworkReply *reply)
{
	const QString url = reply->url().toString();
	const uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	const QString json = QString(reply->readAll());

	reply->close();

	const QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	const QJsonObject jsonObject = document.object();

	// qDebug() << "area manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		areaClear();

		const QJsonArray jsonArray = jsonObject.value("record").toArray();

		for (auto i = jsonArray.constBegin() ; i != jsonArray.constEnd() ; ++i) {
			areaInsert(i->toObject());
		}

	} else if (code == 401 || code == 403) {
		UserAuthentication::instance()->refresh();
	}
}

void AirspaceService::airportManagerFinished(QNetworkReply *reply)
{
	const QString url = reply->url().toString();
	const uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	const QString json = QString(reply->readAll());

	reply->close();

	const QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	const QJsonObject jsonObject = document.object();

	// qDebug() << "airport manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		airportClear();

		const QJsonArray jsonArray = jsonObject.value("record").toArray();

		for (auto i = jsonArray.constBegin() ; i != jsonArray.constEnd() ; ++i) {
			airportInsert(i->toObject());
		}

	} else if (code == 401 || code == 403) {
		UserAuthentication::instance()->refresh();
	}
}

void AirspaceService::airTrafficManagerFinished(QNetworkReply *reply)
{
	const QString url = reply->url().toString();
	const uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	const QString json = QString(reply->readAll());

	reply->close();

	const QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	const QJsonObject jsonObject = document.object();

	// qDebug() << "air traffic manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		airTrafficClear();

		for (const QString &i : jsonObject.keys()) {
			if (!invalid_air_traffic_keys.contains(i)) {
				airTrafficInsert(jsonObject.value(i).toArray());
			}
		}
	}
}

void AirspaceService::areaClear()
{
	circle_area_model->resetModel({});
	polygon_area_model->resetModel({});
}

void AirspaceService::airportClear()
{
	airport_model->resetModel({});
}

void AirspaceService::airTrafficClear()
{
	air_traffic_model->resetModel({});
}

void AirspaceService::areaInsert(const QJsonObject &object)
{
	AreaItem *ptr {new AreaItem()};

	ptr->setName(object.value("label").toString());
	ptr->setGroup(object.value("group").toObject().value("name").toString());
	ptr->setColor(object.value("group").toObject().value("color").toString());
	ptr->setPoints(object.value("points").toArray());

	if (object.value("type").toString() == "circle") {
		circle_area_model->addObject(ptr);

	} else if (object.value("type").toString() == "polygon") {
		polygon_area_model->addObject(ptr);
	}
}

void AirspaceService::airportInsert(const QJsonObject &object)
{
	AirportItem *ptr {new AirportItem()};

	ptr->setName(object.value("name").toString());
	ptr->setId(object.value("id").toString());
	ptr->setIATACode(object.value("iata_code").toString());
	ptr->setICAOCode(object.value("icao_code").toString());
	ptr->setIATACountryCode(object.value("iata_country_code").toString());
	ptr->setCityName(object.value("city_name").toString());
	ptr->setLatitude(object.value("latitude").toDouble());
	ptr->setLongitude(object.value("longitude").toDouble());

	airport_model->addObject(ptr);
}

void AirspaceService::airTrafficInsert(const QJsonArray &array)
{
	if (qFuzzyCompare(array.at(1).toDouble(), 0) && qFuzzyCompare(array.at(2).toDouble(), 0)) {
		return;
	}

	AirTrafficItem *ptr {new AirTrafficItem()};

	ptr->setLatitude(array.at(1).toDouble());
	ptr->setLongitude(array.at(2).toDouble());
	ptr->setHeading(uint(array.at(3).toInt()));

	air_traffic_model->addObject(ptr);
}
