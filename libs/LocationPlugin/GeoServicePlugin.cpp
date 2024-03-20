#include "GeoServicePlugin.h"


Q_EXTERN_C Q_DECL_EXPORT const char *qt_plugin_query_metadata();
Q_EXTERN_C Q_DECL_EXPORT QT_PREPEND_NAMESPACE(QObject) *qt_plugin_instance();

const QT_PREPEND_NAMESPACE(QStaticPlugin) qt_static_plugin_GeoServicePlugin()
{
    QT_PREPEND_NAMESPACE(QStaticPlugin) plugin = { qt_plugin_instance, qt_plugin_query_metadata };
    return plugin;
}

QGeoCodingManagerEngine *GeoServicePlugin::createGeocodingManagerEngine
(const QVariantMap &parameters, QGeoServiceProvider::Error *error, QString *errorString) const
{
    return new QGeoCodingManagerEngineQGC(parameters, error, errorString);
}

QGeoMappingManagerEngine *GeoServicePlugin::createMappingManagerEngine
(const QVariantMap &parameters, QGeoServiceProvider::Error *error, QString *errorString) const
{
    return new QGeoTiledMappingManagerEngineQGC(parameters, error, errorString);
}

QGeoRoutingManagerEngine *GeoServicePlugin::createRoutingManagerEngine
(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const
{
    // not implemented
    return nullptr;
}

QPlaceManagerEngine *GeoServicePlugin::createPlaceManagerEngine
(const QVariantMap &, QGeoServiceProvider::Error *, QString *) const
{
    // not implemented
    return nullptr;
}
