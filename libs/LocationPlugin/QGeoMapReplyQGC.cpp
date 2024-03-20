#include "MapEngine.h"
#include "QGeoMapReplyQGC.h"
#include "GeoTileFetcher.h"

#include <QtLocation/private/qgeotilespec_p.h>
#include <QtNetwork/QNetworkAccessManager>
#include <QFile>
#include "MapTerrainTile.h"

int         QGeoTiledMapReplyQGC::_requestCount = 0;
QByteArray  QGeoTiledMapReplyQGC::_bingNoTileImage;

//-----------------------------------------------------------------------------
QGeoTiledMapReplyQGC::QGeoTiledMapReplyQGC(QNetworkAccessManager *networkManager, const QNetworkRequest &request, const QGeoTileSpec &spec, QObject *parent)
    : QGeoTiledMapReply(spec, parent)
    , _reply(nullptr)
    , _request(request)
    , _networkManager(networkManager)
{
    if (_bingNoTileImage.count() == 0) {
        QFile file(":/res/BingNoTileBytes.dat");
        file.open(QFile::ReadOnly);
        _bingNoTileImage = file.readAll();
        file.close();
    }
    if(_request.url().isEmpty()) {
        if(!_badMapbox.size()) {
            QFile b(":/res/notile.png");
            if(b.open(QFile::ReadOnly))
                _badMapbox = b.readAll();
        }
        setMapImageData(_badMapbox);
        setMapImageFormat("png");
        setFinished(true);
        setCached(false);
    } else {
        QGCFetchTileTask* task = MapEngine::instance()->createFetchTileTask(MapEngine::instance()->urlFactory()->getTypeByID(spec.mapId()), spec.x(), spec.y(), spec.zoom());
        connect(task, &QGCFetchTileTask::tileFetched, this, &QGeoTiledMapReplyQGC::cacheReply);
        connect(task, &QGCMapTask::error, this, &QGeoTiledMapReplyQGC::cacheError);
        MapEngine::instance()->addTask(task);
    }
}

//-----------------------------------------------------------------------------
QGeoTiledMapReplyQGC::~QGeoTiledMapReplyQGC()
{
    _clearReply();
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::_clearReply()
{
    _timer.stop();
    if (_reply) {
        _reply->deleteLater();
        _reply = nullptr;
        _requestCount--;
    }
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::abort()
{
    _timer.stop();
    if (_reply)
        _reply->abort();
    emit aborted();
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::networkReplyFinished()
{
    _timer.stop();
    if (!_reply) {
        emit aborted();
        return;
    }
    if (_reply->error() != QNetworkReply::NoError) {
        emit aborted();
        return;
    }
    QByteArray a = _reply->readAll();
    MapProviderFactory* urlFactory = MapEngine::instance()->urlFactory();
    QString format = urlFactory->getImageFormat(tileSpec().mapId(), a);
    //-- Test for a specialized, elevation data (not map tile)
    if( MapEngine::instance()->urlFactory()->isElevation(tileSpec().mapId())){
        a = MapTerrainTile::serializeFromAirMapJson(a);
        //-- Cache it if valid
        if(!a.isEmpty()) {
            MapEngine::instance()->cacheTile(
                MapEngine::instance()->urlFactory()->getTypeByID(
                    tileSpec().mapId()),
                tileSpec().x(), tileSpec().y(), tileSpec().zoom(), a, format);
        }
        emit terrainDone(a, QNetworkReply::NoError);
    } else {
        MapProvider* mapProvider = urlFactory->getMapProviderByID(tileSpec().mapId());
        if (mapProvider && mapProvider->isBingProvider() && a.size() && _bingNoTileImage.size() && a == _bingNoTileImage) {
            // Bing doesn't return an error if you request a tile above supported zoom level
            // It instead returns an image of a missing tile graphic. We need to detect that
            // and error out so Qt will deal with zooming correctly even if it doesn't have the tile.
            // This allows us to zoom up to level 23 even though the tiles don't actually exist
            setError(QGeoTiledMapReply::CommunicationError, "Bing tile above zoom level");
        } else {
            //-- This is a map tile. Process and cache it if valid.
            setMapImageData(a);
            if(!format.isEmpty()) {
                setMapImageFormat(format);
                MapEngine::instance()->cacheTile(MapEngine::instance()->urlFactory()->getTypeByID(tileSpec().mapId()), tileSpec().x(), tileSpec().y(), tileSpec().zoom(), a, format);
            }
        }
        setFinished(true);
    }
    _clearReply();
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::networkReplyError(QNetworkReply::NetworkError error)
{
    _timer.stop();
    if (!_reply) {
        return;
    }
    //-- Test for a specialized, elevation data (not map tile)
    if( MapEngine::instance()->urlFactory()->isElevation(tileSpec().mapId())){
        emit terrainDone(QByteArray(), error);
    } else {
        //-- Regular map tile
        if (error != QNetworkReply::OperationCanceledError) {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "Fetch tile error:" << _reply->errorString();
#endif
            setError(QGeoTiledMapReply::CommunicationError, _reply->errorString());
        }
        setFinished(true);
    }
    _clearReply();
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::cacheError(QGCMapTask::TaskType type, QString /*errorString*/)
{
    if(!MapEngine::instance()->isInternetActive()) {
        if( MapEngine::instance()->urlFactory()->isElevation(tileSpec().mapId())){
            emit terrainDone(QByteArray(), QNetworkReply::NetworkSessionFailedError);
        } else {
            setError(QGeoTiledMapReply::CommunicationError, "Network not available");
            setFinished(true);
        }
    } else {
        if(type != QGCMapTask::taskFetchTile) {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "QGeoTiledMapReplyQGC::cacheError() for wrong task";
#endif
        }
        //-- Tile not in cache. Get it off the Internet.
#ifndef Q_OS_ANDROID
        QNetworkProxy proxy = _networkManager->proxy();
        QNetworkProxy tProxy;
        tProxy.setType(QNetworkProxy::DefaultProxy);
        _networkManager->setProxy(tProxy);
#endif
        _reply = _networkManager->get(_request);
        _reply->setParent(nullptr);
        connect(_reply, &QNetworkReply::finished, this, &QGeoTiledMapReplyQGC::networkReplyFinished);
        connect(_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkReplyError(QNetworkReply::NetworkError)));
#ifndef Q_OS_ANDROID
        _networkManager->setProxy(proxy);
#endif
        //- Wait for an answer up to 10 seconds
        connect(&_timer, &QTimer::timeout, this, &QGeoTiledMapReplyQGC::timeout);
        _timer.setSingleShot(true);
        _timer.start(10000);
        _requestCount++;
    }
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::cacheReply(QGCCacheTile* tile)
{
    //-- Test for a specialized, elevation data (not map tile)
    if( MapEngine::instance()->urlFactory()->isElevation(tileSpec().mapId())){
        emit terrainDone(tile->img(), QNetworkReply::NoError);
    } else {
        //-- Regular map tile
        setMapImageData(tile->img());
        setMapImageFormat(tile->format());
        setFinished(true);
        setCached(true);
    }
    tile->deleteLater();
}

//-----------------------------------------------------------------------------
void
QGeoTiledMapReplyQGC::timeout()
{
    if(_reply) {
        _reply->abort();
    }
    emit aborted();
}
