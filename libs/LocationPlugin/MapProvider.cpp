#include "MapProvider.h"


MapProvider::MapProvider(const QString &referrer, const QString &imageFormat, const quint32 &averageSize, const QGeoMapType::MapStyle &mapType, QObject *parent)
    : QObject(parent)
    , _referrer(referrer)
    , _imageFormat(imageFormat)
    , _averageSize(averageSize)
    , _mapType(mapType)
{
    const QStringList ui_languages = QLocale::system().uiLanguages();

    if (ui_languages.size()) {
        _language = ui_languages[0];
    }
}

QNetworkRequest MapProvider::getTileURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *networkManager)
{
    const QString url = getURL(x, y, zoom, networkManager);

    if (url.isEmpty()) {
        return QNetworkRequest();
    }

    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setRawHeader(QByteArrayLiteral("Accept"), QByteArrayLiteral("*/*"));
    request.setRawHeader(QByteArrayLiteral("Referrer"), _referrer.toUtf8());
    request.setRawHeader(QByteArrayLiteral("User-Agent"), _userAgent);
    return request;
}

QString MapProvider::getImageFormat(const QByteArray& image) const {
    QString format;
    if (image.size() > 2) {
        if (image.startsWith(reinterpret_cast<const char *>(kPNGSignature)))
            format = QStringLiteral("png");
        else if (image.startsWith(reinterpret_cast<const char *>(kJPEGSignature)))
            format = QStringLiteral("jpg");
        else if (image.startsWith(reinterpret_cast<const char *>(kGIFSignature)))
            format = QStringLiteral("gif");
        else {
            return _imageFormat;
        }
    }
    return format;
}

QString MapProvider::_tileXYToQuadKey(const int &tileX, const int &tileY, const int &levelOfDetail) const {
    QString quadKey;
    for (int i = levelOfDetail; i > 0; i--) {
        char digit = '0';
        const int  mask  = 1 << (i - 1);
        if ((tileX & mask) != 0) {
            digit++;
        }
        if ((tileY & mask) != 0) {
            digit++;
            digit++;
        }
        quadKey.append(digit);
    }
    return quadKey;
}

int MapProvider::_getServerNum(const int &x, const int &y, const int &max) const {
    return (x + (y * 2)) % max;
}

int MapProvider::latToTileY(const double &lat, const int &z) const {
    return static_cast<int>(floor((1.0 - log(tan(lat * M_PI / 180.0) + 1.0 / cos(lat * M_PI / 180.0)) / M_PI) / 2.0 * pow(2.0, z)));
}

int MapProvider::lonToTileX(const double &lon, const int &z) const {
    return static_cast<int>(floor((lon + 180.0) / 360.0 * pow(2.0, z)));
}

MapTileSet_t MapProvider::getTileCount(const int &zoom, const double &topleftLon,
                                     const double &topleftLat, const double &bottomRightLon,
                                     const double &bottomRightLat) const {
    MapTileSet_t set {};
    set.tileX0 = lonToTileX(topleftLon, zoom);
    set.tileY0 = latToTileY(topleftLat, zoom);
    set.tileX1 = lonToTileX(bottomRightLon, zoom);
    set.tileY1 = latToTileY(bottomRightLat, zoom);

    set.tileCount = (static_cast<quint64>(set.tileX1) -
                     static_cast<quint64>(set.tileX0) + 1) *
                    (static_cast<quint64>(set.tileY1) -
                     static_cast<quint64>(set.tileY0) + 1);

    set.tileSize = getAverageSize() * set.tileCount;
    return set;
}
