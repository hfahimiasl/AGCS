#include "GeoTileFetcher.h"


GeoTileFetcher::GeoTileFetcher(QGeoTiledMappingManagerEngine *parent)
    : QGeoTileFetcher(parent)
    , timer(new QTimer(this))
    , network_manager(new QNetworkAccessManager(this))
{
    QObject::connect(timer, &QTimer::timeout, this, []() {
        MapEngine::instance()->testInternet();
    });

    timer->start(GeoTileFetcher::timeout);
}

GeoTileFetcher::~GeoTileFetcher()
{
    delete timer;
    delete network_manager;
}

QGeoTiledMapReply *GeoTileFetcher::getTileImage(const QGeoTileSpec &spec)
{
    const QNetworkRequest request = MapEngine::instance()->urlFactory()->getTileURL(spec.mapId(), spec.x(), spec.y(), spec.zoom(), network_manager);

    if (request.url().isEmpty()) {
        return nullptr;
    }

    return new QGeoTiledMapReplyQGC(network_manager, request, spec);
}
