#pragma once

#include <QObject>
#include <QtPlugin>
#include <QGeoServiceProviderFactory>

#include "QGeoCodingManagerEngineQGC.h"
#include "QGeoTiledMappingManagerEngineQGC.h"


class GeoServicePlugin : public QObject, public QGeoServiceProviderFactory
{
    Q_OBJECT
    Q_INTERFACES(QGeoServiceProviderFactory)
    Q_PLUGIN_METADATA(IID "org.qt-project.qt.geoservice.serviceproviderfactory/5.0" FILE "LocationPluginMetaData.json")

public:
    QGeoCodingManagerEngine *createGeocodingManagerEngine(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const;
    QGeoMappingManagerEngine *createMappingManagerEngine(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const;
    QGeoRoutingManagerEngine *createRoutingManagerEngine(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const;
    QPlaceManagerEngine *createPlaceManagerEngine(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const;
};
