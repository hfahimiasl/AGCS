#pragma once

#include "MapProvider.h"

static constexpr quint16 kAverageBingStreetMap = 1297;
static constexpr quint16 kAverageBingSatelliteMap = 19597;


class BingMapProvider : public MapProvider
{
    Q_OBJECT

public:
    BingMapProvider(const QString &format, const quint32 &size, const QGeoMapType::MapStyle &type, QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://www.bing.com/maps/"), format, size, type, parent)
    {
        // empty
    }

    bool isBingProvider() const override { return true; }

protected:
    const QString kBingMapsVersion = QStringLiteral("563");
};


class BingRoadMapProvider : public BingMapProvider
{
    Q_OBJECT

public:
    BingRoadMapProvider(QObject *parent = nullptr)
        : BingMapProvider(QStringLiteral("png"), kAverageBingStreetMap, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class BingSatelliteMapProvider : public BingMapProvider
{
    Q_OBJECT

public:
    BingSatelliteMapProvider(QObject *parent = nullptr)
        : BingMapProvider(QStringLiteral("jpg"), kAverageBingSatelliteMap, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class BingHybridMapProvider : public BingMapProvider
{
    Q_OBJECT

public:
    BingHybridMapProvider(QObject *parent = nullptr)
        : BingMapProvider(QStringLiteral("jpg"), kAverageBingSatelliteMap, QGeoMapType::HybridMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};
