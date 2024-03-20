#include "MapProviderFactory.h"


MapProviderFactory::MapProviderFactory()
{
    /*
     * in provider_hash, keys needs to follow this format:
     * "Provider Type"
     */

    provider_hash["Bing Road"] = new BingRoadMapProvider(this);
    provider_hash["Bing Satellite"] = new BingSatelliteMapProvider(this);
    provider_hash["Bing Hybrid"] = new BingHybridMapProvider(this);

    // provider_hash["Airmap Elevation"] = new AirmapElevationProvider(this);

    provider_hash["Esri World Street"] = new EsriWorldStreetMapProvider(this);
    provider_hash["Esri World Satellite"] = new EsriWorldSatelliteMapProvider(this);
    provider_hash["Esri Terrain"] = new EsriTerrainMapProvider(this);

    provider_hash["Japan-GSI Contour"] = new JapanStdMapProvider(this);
    provider_hash["Japan-GSI Seamless"] = new JapanSeamlessMapProvider(this);
    provider_hash["Japan-GSI Anaglyph"] = new JapanAnaglyphMapProvider(this);
    provider_hash["Japan-GSI Slope"] = new JapanSlopeMapProvider(this);
    provider_hash["Japan-GSI Relief"] = new JapanReliefMapProvider(this);

    provider_hash["LINZ Basemap"] = new LINZBasemapMapProvider(this);

    // provider_hash["CustomURL Custom"] = new CustomURLMapProvider(this);

    provider_hash["Statkart Topo"] = new StatkartMapProvider(this);

    provider_hash["Eniro Topo"] = new EniroMapProvider(this);

    provider_hash["MapQuest Map"] = new MapQuestMapMapProvider(this);
    provider_hash["MapQuest Sat"] = new MapQuestSatMapProvider(this);

    provider_hash["VWorld Street Map"] = new VWorldStreetMapProvider(this);
    provider_hash["VWorld Satellite Map"] = new VWorldSatMapProvider(this);

    provider_hash["Google Street Map"] = new GoogleStreetMapProvider(this);
    provider_hash["Google Satellite"] = new GoogleSatelliteMapProvider(this);
    provider_hash["Google Terrain"] = new GoogleTerrainMapProvider(this);
    provider_hash["Google Hybrid"] = new GoogleHybridMapProvider(this);
    provider_hash["Google Labels"] = new GoogleTerrainMapProvider(this);

    provider_hash["Mapbox Streets"] = new MapboxStreetMapProvider(this);
    provider_hash["Mapbox Light"] = new MapboxLightMapProvider(this);
    provider_hash["Mapbox Dark"] = new MapboxDarkMapProvider(this);
    provider_hash["Mapbox Satellite"] = new MapboxSatelliteMapProvider(this);
    provider_hash["Mapbox Hybrid"] = new MapboxHybridMapProvider(this);
    provider_hash["Mapbox Bright"] = new MapboxBrightMapProvider(this);
    provider_hash["Mapbox StreetsBasic"] = new MapboxStreetsBasicMapProvider(this);
    provider_hash["Mapbox Outdoors"] = new MapboxOutdoorsMapProvider(this);
    provider_hash["Mapbox Custom"] = new MapboxCustomMapProvider(this);
}

int MapProviderFactory::getIDByType(const QString &type)
{
    return int(qHash(type.trimmed()) >> 1);
}

QString MapProviderFactory::getTypeByID(const int &id)
{
    for (const QString &i : provider_hash.keys()) {
        if (getIDByType(i) == id) {
            return i;
        }
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "id" << id << "not found";
#endif

    return QString("");
}

bool MapProviderFactory::isElevation(const int &id)
{
    const QString type = getTypeByID(id);

    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->isElevationProvider();
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "id" << id << "not registered";
#endif

    return false;
}

quint32 MapProviderFactory::averageSizeForType(const QString &type)
{
    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->getAverageSize();
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "type" << type << "not registered";
#endif

    // TODO
    return kAverageTileSize;
}

MapTileSet_t MapProviderFactory::getTileCount(const int &zoom, const double &topleftLon, const double &topleftLat, const double &bottomRightLon, const double &bottomRightLat, const QString &mapType)
{
    return provider_hash.value(mapType)->getTileCount(zoom, topleftLon, topleftLat, bottomRightLon, bottomRightLat);
}

MapProvider *MapProviderFactory::getMapProviderByID(const int &id)
{
    const QString type = getTypeByID(id);

    if (provider_hash.contains(type)) {
        return provider_hash.value(type);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "id" << id << "not registered";
#endif

    return nullptr;
}

QString MapProviderFactory::getImageFormat(const QString &type, const QByteArray &image)
{
    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->getImageFormat(image);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "type" << type << "not registered";
#endif

    return QString("");
}

QString MapProviderFactory::getImageFormat(const int &id, const QByteArray &image)
{
    const QString type = getTypeByID(id);

    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->getImageFormat(image);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "id" << id << "not registered";
#endif

    return QString("");
}

QNetworkRequest MapProviderFactory::getTileURL(const QString &type, const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->getTileURL(x, y, zoom, network_manager);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "type" << type << "not registered";
#endif

    return QNetworkRequest(QUrl());
}

QNetworkRequest MapProviderFactory::getTileURL(const int &id, const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    const QString type = getTypeByID(id);

    if (provider_hash.contains(type)) {
        return provider_hash.value(type)->getTileURL(x, y, zoom, network_manager);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "id" << id << "not registered";
#endif

    return QNetworkRequest(QUrl());
}
