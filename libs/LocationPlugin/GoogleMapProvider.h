#pragma once

#include "MapProvider.h"

#include <QMutex>
#include <QNetworkReply>
#include <QNetworkProxy>

#if defined(DEBUG_GOOGLE_MAPS)
#include <QFile>
#include <QStandardPaths>
#endif

static constexpr quint16 kAverageGoogleStreetMap = 4913;
static constexpr quint16 kAverageGoogleTerrainMap = 19391;
static constexpr quint16 kAverageGoogleSatelliteMap = 56887;


class GoogleMapProvider : public MapProvider
{
    Q_OBJECT

public:
    GoogleMapProvider(const QString &, const quint32 &, const QGeoMapType::MapStyle &, QObject * = nullptr);
    ~GoogleMapProvider();

private slots:
    void networkReplyError(QNetworkReply::NetworkError);
    void googleVersionCompleted();
    void replyDestroyed();

protected:
    bool version_retrieved {false};
    QNetworkReply *network_reply {nullptr};
    QMutex mutex;
    QString map_version;
    QString satellite_version;
    QString labels_version;
    QString terrain_version;
    QString hybrid_version;
    QString word_sec;

    void getSecGoogleWords(const int &, const int &, QString &, QString &) const;
    void tryCorrectGoogleVersions(QNetworkAccessManager* networkManager);
};

// NoMap = 0,
// StreetMap,
// SatelliteMapDay,
// SatelliteMapNight,
// TerrainMap,
// HybridMap,
// TransitMap,
// GrayStreetMap,
// PedestrianMap,
// CarNavigationMap,
// CycleMap,
// CustomMap = 100


class GoogleStreetMapProvider : public GoogleMapProvider
{
    Q_OBJECT

public:
    GoogleStreetMapProvider(QObject *parent = nullptr)
        : GoogleMapProvider(QStringLiteral("png"), kAverageGoogleStreetMap, QGeoMapType::StreetMap, parent)
    {
        // empty
    }

protected:
     QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class GoogleSatelliteMapProvider : public GoogleMapProvider {
    Q_OBJECT

public:
    GoogleSatelliteMapProvider(QObject *parent = nullptr)
        : GoogleMapProvider(QStringLiteral("jpg"), kAverageGoogleSatelliteMap, QGeoMapType::SatelliteMapDay, parent)
    {
        // empty
    }

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class GoogleLabelsMapProvider : public GoogleMapProvider
{
    Q_OBJECT

public:
    GoogleLabelsMapProvider(QObject *parent = nullptr)
        : GoogleMapProvider(QStringLiteral("png"), kAverageTileSize, QGeoMapType::CustomMap, parent)
    {
        // empty
    }

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class GoogleTerrainMapProvider : public GoogleMapProvider
{
    Q_OBJECT

public:
    GoogleTerrainMapProvider(QObject *parent = nullptr)
        : GoogleMapProvider(QStringLiteral("png"), kAverageGoogleTerrainMap, QGeoMapType::TerrainMap, parent)
    {
        // empty
    }

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};


class GoogleHybridMapProvider : public GoogleMapProvider
{
    Q_OBJECT

public:
    GoogleHybridMapProvider(QObject *parent = nullptr)
        : GoogleMapProvider(QStringLiteral("png"), kAverageGoogleSatelliteMap, QGeoMapType::HybridMap, parent)
    {
        // empty
    }

protected:
    QString getURL(const int &, const int &, const int &, QNetworkAccessManager *) override;
};
