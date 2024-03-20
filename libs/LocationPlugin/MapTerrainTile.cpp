#include "MapTerrainTile.h"


MapTerrainTile::MapTerrainTile()
{
    // empty
}

MapTerrainTile::MapTerrainTile(const QByteArray &byte_array)
{
    const int kTileBytesAvailable = byte_array.size();

    if (kTileBytesAvailable < MapTerrainTile::kTileHeaderBytes) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "terrain tile binary data too small for TileInfo_t header";
#endif
        return;
    }

    const TileInfo_t *tile_info = reinterpret_cast<const TileInfo_t *>(byte_array.constData());

    south_west.setLatitude(tile_info->south_west_lat);
    south_west.setLongitude(tile_info->south_west_lon);
    north_east.setLatitude(tile_info->north_east_lat);
    north_east.setLongitude(tile_info->north_east_lon);
    min_elevation = tile_info->min_elevation;
    max_elevation = tile_info->max_elevation;
    avg_elevation = tile_info->avg_elevation;
    grid_size_lat = tile_info->grid_size_lat;
    grid_size_lon = tile_info->grid_size_lon;

#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "loading terrain tile:" << south_west << "-" << north_east;
    qDebug() << "min:max:avg:sizeLat:sizeLon" << min_elevation << max_elevation << avg_elevation << grid_size_lat << grid_size_lon;
#endif

    const int kTileDataBytes = static_cast<int>(sizeof(int16_t)) * grid_size_lat * grid_size_lon;

    if (kTileBytesAvailable < MapTerrainTile::kTileHeaderBytes + kTileDataBytes) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "terrain tile binary data too small for tile data";
#endif
        return;
    }

    data = new int16_t*[grid_size_lat];

    for (int k=0 ; k<grid_size_lat ; ++k) {
        data[k] = new int16_t[grid_size_lon];
    }

    int index = 0;

    const int16_t *tile_data_ptr = reinterpret_cast<const int16_t *>(&reinterpret_cast<const uint8_t *>(byte_array.constData())[MapTerrainTile::kTileHeaderBytes]);

    for (int i=0 ; i<grid_size_lat ; ++i) {
        for (int j=0 ; j<grid_size_lon ; ++j) {
            data[i][j] = tile_data_ptr[index++];
        }
    }

    is_valid = true;

    return;
}

MapTerrainTile::~MapTerrainTile()
{
    if (data) {
        for (int i=0 ; i<grid_size_lat ; ++i) {
            delete[] data[i];
        }

        delete[] data;
        data = nullptr;
    }
}

double MapTerrainTile::elevation(const QGeoCoordinate& coordinate) const
{
    if (!is_valid || !south_west.isValid() || !north_east.isValid()) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "internal error: invalid tile";
#endif
        return qQNaN();
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "elevation: " << coordinate << " , in sw " << south_west << " , ne " << north_east;
#endif

    const double kClampedLon = qMax(coordinate.longitude(), south_west.longitude());
    const double kClampedLat = qMax(coordinate.latitude(), south_west.latitude());

    const int kLonIndex = qFloor((kClampedLon - south_west.longitude()) / MapTerrainTile::kTileValueSpacingDegrees);
    const int kLatIndex = qFloor((kClampedLat - south_west.latitude()) / MapTerrainTile::kTileValueSpacingDegrees);

    const double kLonIndexLongitude = south_west.longitude() + (double(kLonIndex) * MapTerrainTile::kTileValueSpacingDegrees);
    const double kLonFraction = (kClampedLon - kLonIndexLongitude) / MapTerrainTile::kTileValueSpacingDegrees;
    const double kLatIndexLatitude = south_west.latitude() + (double(kLatIndex) * MapTerrainTile::kTileValueSpacingDegrees);
    const double kLatFraction = (kClampedLat - kLatIndexLatitude) / MapTerrainTile::kTileValueSpacingDegrees;

    const double kKnown00 = data[kLatIndex][kLonIndex];
    const double kKnown01 = data[kLatIndex][kLonIndex + 1];
    const double kKnown10 = data[kLatIndex + 1][kLonIndex];
    const double kKnown11 = data[kLatIndex + 1][kLonIndex + 1];
    const double kLonValue1 = kKnown00 + ((kKnown01 - kKnown00) * kLonFraction);
    const double kLonValue2 = kKnown10 + ((kKnown11 - kKnown10) * kLonFraction);

    return kLonValue1 + ((kLonValue2 - kLonValue1) * kLatFraction);
}

QGeoCoordinate MapTerrainTile::centerCoordinate(void) const
{
    return south_west.atDistanceAndAzimuth(south_west.distanceTo(north_east) * 0.5, south_west.azimuthTo(north_east));
}

QByteArray MapTerrainTile::serializeFromAirMapJson(const QByteArray &input)
{
    QJsonParseError error_parser;

    const QJsonDocument kDocument = QJsonDocument::fromJson(input, &error_parser);

    if (error_parser.error != QJsonParseError::NoError) {
        return QByteArray();
    }

    if (!kDocument.isObject()) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "terrain tile json doc is not an object";
#endif
        return QByteArray();
    }

    const QJsonObject kRootObject = kDocument.object();

    const QList<JsonHelper::KeyValidateInfo_t> kRootVersionKeyInfoList = {
        { MapTerrainTile::kJsonStatusKey, QJsonValue::String, true },
        { MapTerrainTile::kJsonDataKey, QJsonValue::Object, true },
    };

    QString error_string;

    if (!JsonHelper::validateKeys(kRootObject, kRootVersionKeyInfoList, error_string)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "error in reading json: " << error_string;
#endif
        return QByteArray();
    }

    if (kRootObject[MapTerrainTile::kJsonStatusKey].toString() != "success") {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "invalid terrain tile";
#endif
        return QByteArray();
    }

    const QJsonObject &kDataObject = kRootObject[MapTerrainTile::kJsonDataKey].toObject();

    const QList<JsonHelper::KeyValidateInfo_t> kDataVersionKeyInfoList = {
        { MapTerrainTile::kJsonBoundsKey, QJsonValue::Object, true },
        { MapTerrainTile::kJsonStatsKey, QJsonValue::Object, true },
        { MapTerrainTile::kJsonCarpetKey, QJsonValue::Array, true },
    };

    if (!JsonHelper::validateKeys(kDataObject, kDataVersionKeyInfoList, error_string)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "error in reading json: " << error_string;
#endif
        return QByteArray();
    }

    const QJsonObject &kBoundsObject = kDataObject[MapTerrainTile::kJsonBoundsKey].toObject();

    const QList<JsonHelper::KeyValidateInfo_t> kBoundsVersionKeyInfoList = {
        { MapTerrainTile::kJsonSouthWestKey, QJsonValue::Array, true },
        { MapTerrainTile::kJsonNorthEastKey, QJsonValue::Array, true },
    };

    if (!JsonHelper::validateKeys(kBoundsObject, kBoundsVersionKeyInfoList, error_string)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "error in reading json: " << error_string;
#endif
        return QByteArray();
    }

    const QJsonArray &kSEArray = kBoundsObject[MapTerrainTile::kJsonSouthWestKey].toArray();
    const QJsonArray &kNEArray = kBoundsObject[MapTerrainTile::kJsonNorthEastKey].toArray();

    if (kSEArray.size() < 2 || kNEArray.size() < 2) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "incomplete bounding location";
#endif
        return QByteArray();
    }

    const QJsonObject &kStatsObject = kDataObject[MapTerrainTile::kJsonStatsKey].toObject();

    const QList<JsonHelper::KeyValidateInfo_t> kStatsVersionKeyInfoList = {
        { MapTerrainTile::kJsonMinElevationKey, QJsonValue::Double, true },
        { MapTerrainTile::kJsonMaxElevationKey, QJsonValue::Double, true },
        { MapTerrainTile::kJsonAvgElevationKey, QJsonValue::Double, true },
    };

    if (!JsonHelper::validateKeys(kStatsObject, kStatsVersionKeyInfoList, error_string)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qCritical() << "error in reading json: " << error_string;
#endif
        return QByteArray();
    }

    const QJsonArray &kCarpetArray = kDataObject[MapTerrainTile::kJsonCarpetKey].toArray();

    const int kGridSizeLat = kCarpetArray.size();
    const int gridSizeLon = kCarpetArray[0].toArray().size();

    TileInfo_t tile_info {};

    tile_info.south_west_lat = kSEArray[0].toDouble();
    tile_info.south_west_lon = kSEArray[1].toDouble();
    tile_info.north_east_lat = kNEArray[0].toDouble();
    tile_info.north_east_lon = kNEArray[1].toDouble();
    tile_info.min_elevation = int16_t(kStatsObject[MapTerrainTile::kJsonMinElevationKey].toInt());
    tile_info.max_elevation = int16_t(kStatsObject[MapTerrainTile::kJsonMaxElevationKey].toInt());
    tile_info.avg_elevation = kStatsObject[MapTerrainTile::kJsonAvgElevationKey].toDouble();
    tile_info.grid_size_lat = int16_t(kGridSizeLat);
    tile_info.grid_size_lon = int16_t(gridSizeLon);

    const double kNECornerLatExpected = tile_info.south_west_lat + ((tile_info.grid_size_lat - 1) * MapTerrainTile::kTileValueSpacingDegrees);
    const double kNECornerLonExpected = tile_info.south_west_lon + ((tile_info.grid_size_lon - 1) * MapTerrainTile::kTileValueSpacingDegrees);

    if (!qFuzzyCompare(tile_info.north_east_lat, kNECornerLatExpected) || !qFuzzyCompare(tile_info.north_east_lon, kNECornerLonExpected)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << QStringLiteral("serialize: Internal error - distance between values incorrect neExpected(%1, %2) neActual(%3, %4) sw(%5, %6) gridSize(%7, %8)")
                      .arg(kNECornerLatExpected).arg(kNECornerLonExpected).arg(tile_info.north_east_lat).arg(tile_info.north_east_lon).arg(tile_info.south_west_lat).arg(tile_info.south_west_lon).arg(tile_info.grid_size_lat).arg(tile_info.grid_size_lon);
#endif
        return QByteArray();
    }

    const int kTileDataBytes = int(sizeof(int16_t)) * kGridSizeLat * gridSizeLon;

    QByteArray byte_array(MapTerrainTile::kTileHeaderBytes + kTileDataBytes, 0);

    TileInfo_t *tile_info_ptr = reinterpret_cast<TileInfo_t *>(byte_array.data());
    int16_t *tile_data_ptr = reinterpret_cast<int16_t *>(&reinterpret_cast<uint8_t *>(byte_array.data())[MapTerrainTile::kTileHeaderBytes]);

    *tile_info_ptr = tile_info;

    int index = 0;

    for (int i=0 ; i<kGridSizeLat ; ++i) {
        const QJsonArray &kRow = kCarpetArray[i].toArray();

        if (kRow.size() < gridSizeLon) {
#ifdef DEBUG_LOCATION_PLUGIN
            qCritical() << "expected row array of " << gridSizeLon << ", instead got " << kRow.size();
#endif
            return QByteArray();
        }

        for (int j=0 ; j<gridSizeLon ; ++j) {
            tile_data_ptr[index++] = static_cast<int16_t>(kRow[j].toDouble());
        }
    }

    return byte_array;
}
