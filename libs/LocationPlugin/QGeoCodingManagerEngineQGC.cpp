#include "QGeoCodingManagerEngineQGC.h"
#include "GeoCodeReply.h"


static QString addressToQuery(const QGeoAddress &address)
{
    return address.street() + QStringLiteral(", ")
            + address.district() + QStringLiteral(", ")
            + address.city() + QStringLiteral(", ")
            + address.state() + QStringLiteral(", ")
            + address.country();
}

static QString boundingBoxToLtrb(const QGeoRectangle &rectangle)
{
    return QString::number(rectangle.topLeft().longitude()) + QLatin1Char(',')
            + QString::number(rectangle.topLeft().latitude()) + QLatin1Char(',')
            + QString::number(rectangle.bottomRight().longitude()) + QLatin1Char(',')
            + QString::number(rectangle.bottomRight().latitude());
}

QGeoCodingManagerEngineQGC::QGeoCodingManagerEngineQGC(const QVariantMap &parameters, QGeoServiceProvider::Error *error, QString *errorString)
    : QGeoCodingManagerEngine(parameters)
    , network_manager(new QNetworkAccessManager(this))
{
    if (parameters.contains(QStringLiteral("useragent"))) {
        user_agent = parameters.value(QStringLiteral("useragent")).toString().toLatin1();

    } else {
        user_agent = "Qt Location based application";
    }

    *error = QGeoServiceProvider::NoError;
    errorString->clear();
}

QGeoCodingManagerEngineQGC::~QGeoCodingManagerEngineQGC()
{
    delete network_manager;
}

QGeoCodeReply *QGeoCodingManagerEngineQGC::geocode(const QGeoAddress &address, const QGeoShape &bounds)
{
    return geocode(addressToQuery(address), -1, -1, bounds);
}

QGeoCodeReply *QGeoCodingManagerEngineQGC::geocode(const QString &address, int limit, int offset, const QGeoShape &bounds)
{
    Q_UNUSED(limit)
    Q_UNUSED(offset)

    QNetworkRequest request;
    request.setRawHeader("User-Agent", user_agent);

    QUrl url(QStringLiteral("http://maps.googleapis.com/maps/api/geocode/json"));

    QUrlQuery query;
    query.addQueryItem(QStringLiteral("sensor"), QStringLiteral("false"));
    query.addQueryItem(QStringLiteral("language"), locale().name().left(2));
    query.addQueryItem(QStringLiteral("address"), address);

    if (bounds.type() == QGeoShape::RectangleType) {
        query.addQueryItem(QStringLiteral("bounds"), boundingBoxToLtrb(bounds));
    }

    url.setQuery(query);
    request.setUrl(url);

    QNetworkReply *reply = network_manager->get(request);
    reply->setParent(nullptr);

    GeoCodeReply *geocodeReply = new GeoCodeReply(reply);

    QObject::connect(geocodeReply, &QGeoCodeReply::finished, this, &QGeoCodingManagerEngineQGC::replyFinished);
    QObject::connect(geocodeReply, SIGNAL(error(QGeoCodeReply::Error,QString)), this, SLOT(replyError(QGeoCodeReply::Error,QString)));

    return geocodeReply;
}

QGeoCodeReply *QGeoCodingManagerEngineQGC::reverseGeocode(const QGeoCoordinate &coordinate, const QGeoShape &bounds)
{
    Q_UNUSED(bounds)

    QNetworkRequest request;
    request.setRawHeader("User-Agent", user_agent);

    QUrl url(QStringLiteral("http://maps.googleapis.com/maps/api/geocode/json"));

    QUrlQuery query;
    query.addQueryItem(QStringLiteral("sensor"), QStringLiteral("false"));
    query.addQueryItem(QStringLiteral("language"), locale().name().left(2));
    query.addQueryItem(QStringLiteral("latlng"), QStringLiteral("%1,%2").arg(coordinate.latitude()).arg(coordinate.longitude()));

    url.setQuery(query);
    request.setUrl(url);

    QNetworkReply *reply = network_manager->get(request);
    reply->setParent(nullptr);

    GeoCodeReply *geocodeReply = new GeoCodeReply(reply);

    QObject::connect(geocodeReply, &QGeoCodeReply::finished, this, &QGeoCodingManagerEngineQGC::replyFinished);
    QObject::connect(geocodeReply, SIGNAL(error(QGeoCodeReply::Error,QString)), this, SLOT(replyError(QGeoCodeReply::Error,QString)));

    return geocodeReply;
}

void QGeoCodingManagerEngineQGC::replyFinished()
{
    QGeoCodeReply *reply = qobject_cast<QGeoCodeReply *>(sender());

    if (reply) {
        emit finished(reply);
    }
}

void QGeoCodingManagerEngineQGC::replyError(QGeoCodeReply::Error errorCode, const QString &errorString)
{
    QGeoCodeReply *reply = qobject_cast<QGeoCodeReply *>(sender());

    if (reply) {
        emit error(reply, errorCode, errorString);
    }
}
