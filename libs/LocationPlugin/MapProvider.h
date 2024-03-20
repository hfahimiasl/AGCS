#pragma once

#include <QObject>
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QtLocation/private/qgeomaptype_p.h>

#include <cmath>

#include "MapTileSet.h"

static constexpr quint32 kAverageTileSize = 13652;

static constexpr unsigned char kPNGSignature[] = {0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00};
static constexpr unsigned char kJPEGSignature[] = {0xFF, 0xD8, 0xFF, 0x00};
static constexpr unsigned char kGIFSignature[] = {0x47, 0x49, 0x46, 0x38, 0x00};


class MapProvider : public QObject
{
    Q_OBJECT

public:
    MapProvider(const QString &, const QString &, const quint32 &, const QGeoMapType::MapStyle & = QGeoMapType::CustomMap, QObject * = nullptr);

    virtual QNetworkRequest getTileURL(const int &, const int &, const int &, QNetworkAccessManager *);

    QString getImageFormat(const QByteArray &) const;

    quint32 getAverageSize() const { return _averageSize; }

    QGeoMapType::MapStyle getMapStyle() { return _mapType; }

    virtual int latToTileY(const double &, const int &) const;
    virtual int lonToTileX(const double &, const int &) const;

    virtual bool isElevationProvider() const { return false; }
    virtual bool isBingProvider() const { return false; }

    virtual MapTileSet_t getTileCount(const int &, const double &,
                                     const double &, const double &,
                                     const double &) const;

protected:
    QString _tileXYToQuadKey(const int &, const int &, const int &) const;
    int _getServerNum(const int &, const int &, const int &) const;

    virtual QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) = 0;

    QString     _referrer;
    QString     _imageFormat;
    quint32     _averageSize;
    QByteArray  _userAgent;
    QString     _language;
    QGeoMapType::MapStyle _mapType;
};
