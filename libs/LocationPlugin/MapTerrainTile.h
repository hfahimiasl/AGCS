#pragma once

#include <QGeoCoordinate>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QtMath>
#include <QDebug>

#include "src/System/JsonHelper.h"


/**
 * @brief The MapTerrainTile class
 *
 * Implements an interface for https://developers.airmap.com/v2.0/docs/elevation-api
 */

class MapTerrainTile
{
public:
    MapTerrainTile();
    MapTerrainTile(const QByteArray &);
    ~MapTerrainTile();

    bool isValid() const { return is_valid; }

    double elevation(const QGeoCoordinate &) const;

    double minElevation() const { return min_elevation; }
    double maxElevation() const { return max_elevation; }
    double avgElevation() const { return avg_elevation; }

    QGeoCoordinate centerCoordinate() const;

    static QByteArray serializeFromAirMapJson(const QByteArray &);

    static constexpr double kTileSizeDegrees { 0.01 };
    static constexpr double kTileValueSpacingMeters { 30.0 };
    static constexpr double kTileValueSpacingDegrees { 1.0 / 3600 };

private:
    typedef struct {
        double south_west_lat;
        double south_west_lon;
        double north_east_lat;
        double north_east_lon;
        double avg_elevation;
        int16_t min_elevation;
        int16_t max_elevation;
        int16_t grid_size_lat;
        int16_t grid_size_lon;
    }   TileInfo_t;

    QGeoCoordinate south_west;
    QGeoCoordinate north_east;

    int16_t min_elevation { -1 };
    int16_t max_elevation { -1 };

    double avg_elevation { -1.0 };

    int16_t **data { nullptr };

    int16_t grid_size_lat { -1 };
    int16_t grid_size_lon { -1 };

    bool is_valid { false };

    static constexpr int kTileHeaderBytes { sizeof(TileInfo_t) };

    static constexpr const char *kJsonStatusKey         { "status" };
    static constexpr const char *kJsonDataKey           { "data" };
    static constexpr const char *kJsonBoundsKey         { "bounds" };
    static constexpr const char *kJsonSouthWestKey      { "sw" };
    static constexpr const char *kJsonNorthEastKey      { "ne" };
    static constexpr const char *kJsonStatsKey          { "stats" };
    static constexpr const char *kJsonMaxElevationKey   { "max" };
    static constexpr const char *kJsonMinElevationKey   { "min" };
    static constexpr const char *kJsonAvgElevationKey   { "avg" };
    static constexpr const char *kJsonCarpetKey         { "carpet" };
};
