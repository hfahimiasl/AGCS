#include "ElevationMapProvider.h"


int AirmapElevationProvider::latToTileY(const double &lat, const int &z) const
{
    Q_UNUSED(z)
    return static_cast<int>(floor((lat + 90.0) / MapTerrainTile::kTileSizeDegrees));
}

int AirmapElevationProvider::lonToTileX(const double &lon, const int &z) const
{
    Q_UNUSED(z)
    return static_cast<int>(floor((lon + 180.0) / MapTerrainTile::kTileSizeDegrees));
}

MapTileSet_t AirmapElevationProvider::getTileCount(const int &zoom, const double &top_left_lon, const double &top_left_lat, const double &bottom_right_lon, const double &bottom_right_lat) const
{
    MapTileSet_t map_tile_set {};
    map_tile_set.tileX0 = lonToTileX(top_left_lon, zoom);
    map_tile_set.tileY0 = latToTileY(bottom_right_lat, zoom);
    map_tile_set.tileX1 = lonToTileX(bottom_right_lon, zoom);
    map_tile_set.tileY1 = latToTileY(top_left_lat, zoom);
    map_tile_set.tileCount = (static_cast<quint64>(map_tile_set.tileX1) - static_cast<quint64>(map_tile_set.tileX0) + 1) * (static_cast<quint64>(map_tile_set.tileY1) - static_cast<quint64>(map_tile_set.tileY0) + 1);
    map_tile_set.tileSize = getAverageSize() * map_tile_set.tileCount;
    return map_tile_set;
}

QString AirmapElevationProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(zoom)
    Q_UNUSED(network_manager)
    static const QString kURL = QStringLiteral("https://api.airmap.com/elevation/v1/ele/carpet?points=%1,%2,%3,%4");
    return kURL
            .arg(static_cast<double>(y) * MapTerrainTile::kTileSizeDegrees - 90.0)
            .arg(static_cast<double>(x) * MapTerrainTile::kTileSizeDegrees - 180.0)
            .arg(static_cast<double>(y + 1) * MapTerrainTile::kTileSizeDegrees - 90.0)
            .arg(static_cast<double>(x + 1) * MapTerrainTile::kTileSizeDegrees - 180.0);
}
