#pragma once

#include "MapProvider.h"


class JapanStdMapProvider : public MapProvider
{
    Q_OBJECT

public:
    JapanStdMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/std"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class JapanSeamlessMapProvider : public MapProvider
{
    Q_OBJECT

public:
    JapanSeamlessMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto"), QStringLiteral("jpg"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class JapanAnaglyphMapProvider : public MapProvider
{
    Q_OBJECT

public:
    JapanAnaglyphMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/anaglyphmap_color"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class JapanSlopeMapProvider : public MapProvider
{
    Q_OBJECT

public:
    JapanSlopeMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/slopemap"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class JapanReliefMapProvider : public MapProvider
{
    Q_OBJECT

public:
    JapanReliefMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://cyberjapandata.gsi.go.jp/xyz/relief"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class LINZBasemapMapProvider : public MapProvider
{
    Q_OBJECT

public:
    LINZBasemapMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://basemaps.linz.govt.nz/v1/tiles/aerial"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class CustomURLMapProvider : public MapProvider
{
    Q_OBJECT

public:
    CustomURLMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral(""), QStringLiteral(""), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class StatkartMapProvider : public MapProvider
{
    Q_OBJECT

public:
    StatkartMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://www.norgeskart.no/"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class EniroMapProvider : public MapProvider
{
    Q_OBJECT

public:
    EniroMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://www.eniro.se/"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class MapQuestMapMapProvider : public MapProvider
{
    Q_OBJECT

public:
    MapQuestMapMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://mapquest.com"), QStringLiteral("jpg"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class MapQuestSatMapProvider : public MapProvider
{
    Q_OBJECT

public:
    MapQuestSatMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("https://mapquest.com"), QStringLiteral("jpg"), kAverageTileSize, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class VWorldStreetMapProvider : public MapProvider
{
    Q_OBJECT

public:
    VWorldStreetMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("www.vworld.kr"), QStringLiteral("png"), kAverageTileSize, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;

private:
    const QString _versionBingMaps = QStringLiteral("563");
};


class VWorldSatMapProvider : public MapProvider
{
    Q_OBJECT

public:
    VWorldSatMapProvider(QObject *parent = nullptr)
        : MapProvider(QStringLiteral("www.vworld.kr"), QStringLiteral("jpg"), kAverageTileSize, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;

private:
    const QString kBingMapsVersion = QStringLiteral("563");
};
