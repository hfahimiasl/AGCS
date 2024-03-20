#include "GenericMapProvider.h"


QString JapanStdMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/std/%1/%2/%3.png");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString JapanSeamlessMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/%1/%2/%3.jpg");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString JapanAnaglyphMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/anaglyphmap_color/%1/%2/%3.png");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString JapanSlopeMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/slopemap/%1/%2/%3.png");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString JapanReliefMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/relief/%1/%2/%3.png");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString LINZBasemapMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://basemaps.linz.govt.nz/v1/tiles/aerial/EPSG:3857/%1/%2/%3.png?api=d01ev80nqcjxddfvc6amyvkk1ka");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString CustomURLMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    QString url;// AGCS TODO = qgcApp()->toolbox()->settingsManager()->appSettings()->customURL()->rawValue().toString();
    return url.replace("{x}", QString::number(x)).replace("{y}", QString::number(y)).replace(QRegExp("\\{(z|zoom)\\}"), QString::number(zoom));
}

QString StatkartMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://opencache.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=topo4&zoom=%1&x=%2&y=%3");
    return kURL.arg(zoom).arg(x).arg(y);
}

QString EniroMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://map.eniro.com/geowebcache/service/tms1.0.0/map/%1/%2/%3.png");
    return kURL.arg(zoom).arg(x).arg((1 << zoom) - 1 - y);
}

QString MapQuestMapMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://otile%1.mqcdn.com/tiles/1.0.0/map/%2/%3/%4.jpg");
    return kURL.arg(_getServerNum(x, y, 4)).arg(zoom).arg(x).arg(y);
}

QString MapQuestSatMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://otile%1.mqcdn.com/tiles/1.0.0/sat/%2/%3/%4.jpg");
    return kURL.arg(_getServerNum(x, y, 4)).arg(zoom).arg(x).arg(y);
}

QString VWorldStreetMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)

    const int gap = zoom - 6;
    const int x_min = int(53 * pow(2, gap));
    const int x_max = int(55 * pow(2, gap) + (2 * gap - 1));
    const int y_min = int(22 * pow(2, gap));
    const int y_max = int(26 * pow(2, gap) + (2 * gap - 1));

    if (zoom > 19) {
        return QString();

    } else if (zoom > 5 && x >= x_min && x <= x_max && y >= y_min && y <= y_max) {
        return QString(QStringLiteral("http://xdworld.vworld.kr:8080/2d/Base/service/%1/%2/%3.png")).arg(zoom, x, y);

    } else {
        return QString(QStringLiteral("http://ecn.t%1.tiles.virtualearth.net/tiles/r%2.png?g=%3&mkt=%4"))
                .arg(_getServerNum(x, y, 4)).arg(_tileXYToQuadKey(x, y, zoom), _versionBingMaps, _language);
    }
}

QString VWorldSatMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)

    const int gap = zoom - 6;
    const int x_min = int(53 * pow(2, gap));
    const int x_max = int(55 * pow(2, gap) + (2 * gap - 1));
    const int y_min = int(22 * pow(2, gap));
    const int y_max = int(26 * pow(2, gap) + (2 * gap - 1));

    if (zoom > 19) {
        return QString();

    } else if (zoom > 5 && x >= x_min && x <= x_max && y >= y_min && y <= y_max) {
        return QString("http://xdworld.vworld.kr:8080/2d/Satellite/service/%1/%2/%3.jpeg").arg(zoom, x, y);

    } else {
        return QString("http://ecn.t%1.tiles.virtualearth.net/tiles/a%2.jpeg?g=%3&mkt=%4")
                .arg(_getServerNum(x, y, 4)).arg(_tileXYToQuadKey(x, y, zoom), kBingMapsVersion, _language);
    }
}
