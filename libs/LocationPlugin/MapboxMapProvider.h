#pragma once

#include "MapProvider.h"

static constexpr quint16 kAverageMapboxStreetMap = 5648;
static constexpr quint16 kAverageMapboxSatelliteMap = 15739;


class MapboxMapProvider : public MapProvider
{
    Q_OBJECT

public:
    MapboxMapProvider(const QString &, const quint32 &, const QGeoMapType::MapStyle &, QObject * = nullptr);

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;

    QString name;

private:
    const QString kURL {QStringLiteral("https://api.mapbox.com/styles/v1/mapbox/%1/tiles/%2/%3/%4?access_token=%5")};
    const QString kURLCustom {QStringLiteral("https://api.mapbox.com/styles/v1/%1/%2/tiles/256/%3/%4/%5?access_token=%6")};
};


class MapboxStreetMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxStreetMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("streets-v10"), kAverageMapboxStreetMap, QGeoMapType::StreetMap, parent)
    {
        // empty
    }
};


class MapboxLightMapProvider : public MapboxMapProvider {
    Q_OBJECT

public:
    MapboxLightMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("light-v9"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }
};


class MapboxDarkMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxDarkMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("dark-v9"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }
};


class MapboxSatelliteMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxSatelliteMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("satellite-v9"), kAverageMapboxSatelliteMap, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }
};


class MapboxHybridMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxHybridMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("satellite-streets-v10"), kAverageMapboxSatelliteMap, QGeoMapType::HybridMap, parent)
    {
        // empty
    }
};


class MapboxBrightMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxBrightMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("bright-v9"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }
};


class MapboxStreetsBasicMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxStreetsBasicMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("basic-v9"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }
};


class MapboxOutdoorsMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxOutdoorsMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("outdoors-v10"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }
};


class MapboxCustomMapProvider : public MapboxMapProvider
{
    Q_OBJECT

public:
    MapboxCustomMapProvider(QObject *parent = nullptr)
        : MapboxMapProvider(QStringLiteral("mapbox.custom"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }
};
