QT += location-private positioning-private network sql

INCLUDEPATH += \
    $$PWD \
    $$PWD/QMLControl

HEADERS += \
    $$PWD/MapEngine.h \
    $$PWD/MapEngineData.h \
    $$PWD/QGCMapTileSet.h \
    $$PWD/MapProviderFactory.h \
    $$PWD/QGCTileCacheWorker.h \
    $$PWD/GeoCodeReply.h \
    $$PWD/QGeoCodingManagerEngineQGC.h \
    $$PWD/QGeoMapReplyQGC.h \
    $$PWD/GeoServicePlugin.h \
    $$PWD/GeoTileFetcher.h \
    $$PWD/QGeoTiledMappingManagerEngineQGC.h \
    $$PWD/MapProvider.h \
    $$PWD/ElevationMapProvider.h \
    $$PWD/GoogleMapProvider.h \
    $$PWD/BingMapProvider.h \
    $$PWD/GenericMapProvider.h \
    $$PWD/EsriMapProvider.h \
    $$PWD/MapboxMapProvider.h \
    $$PWD/MapTileSet.h \
    $$PWD/MapTerrainTile.h

SOURCES += \
    $$PWD/MapEngine.cpp \
    $$PWD/QGCMapTileSet.cpp \
    $$PWD/MapProviderFactory.cpp \
    $$PWD/QGCTileCacheWorker.cpp \
    $$PWD/GeoCodeReply.cpp \
    $$PWD/QGeoCodingManagerEngineQGC.cpp \
    $$PWD/QGeoMapReplyQGC.cpp \
    $$PWD/GeoServicePlugin.cpp \
    $$PWD/GeoTileFetcher.cpp \
    $$PWD/QGeoTiledMappingManagerEngineQGC.cpp \
    $$PWD/MapProvider.cpp \
    $$PWD/ElevationMapProvider.cpp \
    $$PWD/GoogleMapProvider.cpp \
    $$PWD/BingMapProvider.cpp \
    $$PWD/GenericMapProvider.cpp \
    $$PWD/EsriMapProvider.cpp \
    $$PWD/MapboxMapProvider.cpp \
    $$PWD/MapTerrainTile.cpp

RESOURCES += \
    $$PWD/resources/LocationPluginResources.qrc

OTHER_FILES += \
    $$PWD/LocationPluginMetaData.json
