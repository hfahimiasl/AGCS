#include "EsriMapProvider.h"


QNetworkRequest EsriMapProvider::getTileURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *networkManager)
{
    const QString url = getURL(x, y, zoom, networkManager);

    if (url.isEmpty()) {
        return QNetworkRequest();
    }

    const QByteArray token; // AGCS TODO = qgcApp()->toolbox()->settingsManager()->appSettings()->esriToken()->rawValue().toString().toLatin1();

    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setRawHeader(QByteArrayLiteral("Accept"), QByteArrayLiteral("*/*"));
    request.setRawHeader(QByteArrayLiteral("User-Agent"), QByteArrayLiteral("Qt Location based application"));
    request.setRawHeader(QByteArrayLiteral("User-Token"), token);
    return request;
}

QString EsriWorldStreetMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/%1/%2/%3");
    return kURL.arg(zoom).arg(y).arg(x);
}

QString EsriWorldSatelliteMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/%1/%2/%3");
    return kURL.arg(zoom).arg(y).arg(x);
}

QString EsriTerrainMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("http://server.arcgisonline.com/ArcGIS/rest/services/World_Terrain_Base/MapServer/tile/%1/%2/%3");
    return kURL.arg(zoom).arg(y).arg(x);
}
