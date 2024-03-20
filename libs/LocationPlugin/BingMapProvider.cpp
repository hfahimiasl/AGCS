#include "BingMapProvider.h"


QString BingRoadMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://ecn.t%1.tiles.virtualearth.net/tiles/r%2.png?g=%3&mkt=%4");
    return kURL.arg(QString::number(_getServerNum(x, y, 4)), _tileXYToQuadKey(x, y, zoom), kBingMapsVersion, _language);
}

QString BingSatelliteMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://ecn.t%1.tiles.virtualearth.net/tiles/a%2.jpeg?g=%3&mkt=%4");
    return kURL.arg(QString::number(_getServerNum(x, y, 4)), _tileXYToQuadKey(x, y, zoom), kBingMapsVersion ,_language);
}

QString BingHybridMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://ecn.t%1.tiles.virtualearth.net/tiles/h%2.jpeg?g=%3&mkt=%4");
    return kURL.arg(QString::number(_getServerNum(x, y, 4)), _tileXYToQuadKey(x, y, zoom), kBingMapsVersion, _language);
}
