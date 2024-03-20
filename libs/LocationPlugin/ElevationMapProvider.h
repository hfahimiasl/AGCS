#pragma once

#include <cmath>

#include "MapProvider.h"
#include "MapTerrainTile.h"

static constexpr quint16 kAverageAirmapElevationSize = 2786;


class ElevationProvider : public MapProvider
{
    Q_OBJECT

public:
    ElevationProvider(const QString &format, const quint32 &size, const QGeoMapType::MapStyle &type, QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://api.airmap.com/"), format, size, type, parent)
    {
        // empty
    }

    virtual bool isElevationProvider() const override { return true; }
};


class AirmapElevationProvider : public ElevationProvider
{
    Q_OBJECT

public:
    AirmapElevationProvider(QObject *parent = nullptr)
        : ElevationProvider(QStringLiteral("bin"), kAverageAirmapElevationSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    int latToTileY(const double &, const int &) const override;
    int lonToTileX(const double &, const int &) const override;

    MapTileSet_t getTileCount(const int &, const double &, const double &, const double &, const double &) const override;

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};
