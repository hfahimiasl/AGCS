#pragma once

#include "MapProvider.h"


class EsriMapProvider : public MapProvider
{
    Q_OBJECT

public:
    EsriMapProvider(const quint32 &size, const QGeoMapType::MapStyle &type, QObject *parent = nullptr)
        : MapProvider(QString(), QString(), size, type, parent)
    {
        // empty
    }

    QNetworkRequest getTileURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class EsriWorldStreetMapProvider : public EsriMapProvider
{
    Q_OBJECT

public:
    EsriWorldStreetMapProvider(QObject* parent = nullptr)
        : EsriMapProvider(kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class EsriWorldSatelliteMapProvider : public EsriMapProvider
{
    Q_OBJECT

public:
    EsriWorldSatelliteMapProvider(QObject* parent = nullptr)
        : EsriMapProvider(kAverageTileSize, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class EsriTerrainMapProvider : public EsriMapProvider
{
    Q_OBJECT

public:
    EsriTerrainMapProvider(QObject* parent = nullptr)
        : EsriMapProvider(kAverageTileSize, QGeoMapType::TerrainMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};
