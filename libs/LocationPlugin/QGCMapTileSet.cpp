#include "MapEngine.h"
#include "QGCMapTileSet.h"
#include "MapEngineManager.h"
#include "MapTerrainTile.h"

#include <QSettings>
#include <math.h>


#define TILE_BATCH_SIZE      256

//-----------------------------------------------------------------------------
QGCCachedTileSet::QGCCachedTileSet(const QString& name)
    : _name(name)
    , _topleftLat(0.0)
    , _topleftLon(0.0)
    , _bottomRightLat(0.0)
    , _bottomRightLon(0.0)
    , _totalTileCount(0)
    , _totalTileSize(0)
    , _uniqueTileCount(0)
    , _uniqueTileSize(0)
    , _savedTileCount(0)
    , _savedTileSize(0)
    , _minZoom(3)
    , _maxZoom(3)
    , _defaultSet(false)
    , _deleting(false)
    , _downloading(false)
    , _id(0)
    , _type("Invalid")
    , _networkManager(nullptr)
    , _errorCount(0)
    , _noMoreTiles(false)
    , _batchRequested(false)
    , _manager(nullptr)
    , _selected(false)
{

}

//-----------------------------------------------------------------------------
QGCCachedTileSet::~QGCCachedTileSet()
{
    delete _networkManager;
    _networkManager = nullptr;
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::errorCountStr() const
{
    return MapEngine::numberToString(_errorCount);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::totalTileCountStr() const
{
    return MapEngine::numberToString(_totalTileCount);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::totalTilesSizeStr() const
{
    return MapEngine::bigSizeToString(_totalTileSize);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::uniqueTileSizeStr() const
{
    return MapEngine::bigSizeToString(_uniqueTileSize);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::uniqueTileCountStr() const
{
    return MapEngine::numberToString(_uniqueTileCount);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::savedTileCountStr() const
{
    return MapEngine::numberToString(_savedTileCount);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::savedTileSizeStr() const
{
    return MapEngine::bigSizeToString(_savedTileSize);
}

//-----------------------------------------------------------------------------
QString
QGCCachedTileSet::downloadStatus()
{
    if(_defaultSet) {
        return totalTilesSizeStr();
    }
    if(_totalTileCount <= _savedTileCount) {
        return savedTileSizeStr();
    } else {
        return savedTileSizeStr() + " / " + totalTilesSizeStr();
    }
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::createDownloadTask()
{
    if(!_downloading) {
        _errorCount   = 0;
        _downloading  = true;
        _noMoreTiles  = false;
        emit downloadingChanged();
        emit errorCountChanged();
    }
    QGCGetTileDownloadListTask* task = new QGCGetTileDownloadListTask(_id, TILE_BATCH_SIZE);
    connect(task, &QGCGetTileDownloadListTask::tileListFetched, this, &QGCCachedTileSet::_tileListFetched);
    if(_manager)
        connect(task, &QGCMapTask::error, _manager, &MapEngineManager::taskError);
    MapEngine::instance()->addTask(task);
    emit totalTileCountChanged();
    emit totalTilesSizeChanged();
    _batchRequested = true;
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::resumeDownloadTask()
{
    //-- Reset and download error flag (for all tiles)
    QGCUpdateTileDownloadStateTask* task = new QGCUpdateTileDownloadStateTask(_id, QGCTile::StatePending, "*");
    MapEngine::instance()->addTask(task);
    //-- Start download
    createDownloadTask();
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::cancelDownloadTask()
{
    if(_downloading) {
        _downloading = false;
        emit downloadingChanged();
    }
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::_tileListFetched(QList<QGCTile *> tiles)
{
    _batchRequested = false;
    //-- Done?
    if(tiles.size() < TILE_BATCH_SIZE) {
        _noMoreTiles = true;
    }
    if(!tiles.size()) {
        _doneWithDownload();
        return;
    }
    //-- If this is the first time, create Network Manager
    if (!_networkManager) {
        _networkManager = new QNetworkAccessManager(this);
    }
    //-- Add tiles to the list
    _tilesToDownload += tiles;
    //-- Kick downloads
    _prepareDownload();
}

//-----------------------------------------------------------------------------
void QGCCachedTileSet::_doneWithDownload()
{
    if(!_errorCount) {
        _totalTileCount = _savedTileCount;
        _totalTileSize  = _savedTileSize;
        //-- Too expensive to compute the real size now. Estimate it for the time being.
        quint32 avg;
        if(_savedTileSize != 0){
            avg = _savedTileSize / _savedTileCount;
        }
        else{
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "MapEngineManager::_doneWithDownload _savedTileSize=0 !";
#endif
            avg = 0;
        }

        _uniqueTileSize = _uniqueTileCount * avg;
    }
    emit totalTileCountChanged();
    emit totalTilesSizeChanged();
    emit savedTileSizeChanged();
    emit savedTileCountChanged();
    emit uniqueTileSizeChanged();
    _downloading = false;
    emit downloadingChanged();
    emit completeChanged();
}

//-----------------------------------------------------------------------------
void QGCCachedTileSet::_prepareDownload()
{
    if(!_tilesToDownload.count()) {
        //-- Are we done?
        if(_noMoreTiles) {
            _doneWithDownload();
        } else {
            if(!_batchRequested)
                createDownloadTask();
        }
        return;
    }
    //-- Prepare queue (QNetworkAccessManager has a limit for concurrent downloads)
    for(int i = _replies.count(); i < MapEngine::concurrentDownloads(_type); i++) {
        if(_tilesToDownload.count()) {
            QGCTile* tile = _tilesToDownload.first();
            _tilesToDownload.removeFirst();
            QNetworkRequest request = MapEngine::instance()->urlFactory()->getTileURL(tile->type(), tile->x(), tile->y(), tile->z(), _networkManager);
            request.setAttribute(QNetworkRequest::User, tile->hash());
#ifndef Q_OS_ANDROID
            QNetworkProxy proxy = _networkManager->proxy();
            QNetworkProxy tProxy;
            tProxy.setType(QNetworkProxy::DefaultProxy);
            _networkManager->setProxy(tProxy);
#endif
            QNetworkReply* reply = _networkManager->get(request);
            reply->setParent(nullptr);
            connect(reply, &QNetworkReply::finished, this, &QGCCachedTileSet::_networkReplyFinished);
#if QT_VERSION < QT_VERSION_CHECK(5, 15, 0)
            connect(reply, static_cast<void (QNetworkReply::*)(QNetworkReply::NetworkError)>(&QNetworkReply::error), this, &QGCCachedTileSet::_networkReplyError);
#else
            connect(reply, &QNetworkReply::errorOccurred, this, &QGCCachedTileSet::_networkReplyError);
#endif
            _replies.insert(tile->hash(), reply);
#ifndef Q_OS_ANDROID
            _networkManager->setProxy(proxy);
#endif
            delete tile;
            //-- Refill queue if running low
            if(!_batchRequested && !_noMoreTiles && _tilesToDownload.count() < (MapEngine::concurrentDownloads(_type) * 10)) {
                //-- Request new batch of tiles
                createDownloadTask();
            }
        }
    }
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::_networkReplyFinished()
{
    //-- Figure out which reply this is
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    if(!reply) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "MapEngineManager::networkReplyFinished() NULL Reply";
#endif
        return;
    }
    if (reply->error() == QNetworkReply::NoError) {
        //-- Get tile hash
        const QString hash = reply->request().attribute(QNetworkRequest::User).toString();
        if(!hash.isEmpty()) {
            if(_replies.contains(hash)) {
                _replies.remove(hash);
            } else {
#ifdef DEBUG_LOCATION_PLUGIN
                qWarning() << "MapEngineManager::networkReplyFinished() Reply not in list: " << hash;
#endif
            }

#ifdef DEBUG_LOCATION_PLUGIN
            qDebug() << "Tile fetched" << hash;
#endif

            QByteArray image = reply->readAll();
            QString type = MapEngine::instance()->hashToType(hash);
            if (type == "Airmap Elevation" ) {
                image = MapTerrainTile::serializeFromAirMapJson(image);
            }
            QString format = MapEngine::instance()->urlFactory()->getImageFormat(type, image);
            if(!format.isEmpty()) {
                //-- Cache tile
                MapEngine::instance()->cacheTile(type, hash, image, format, _id);
                QGCUpdateTileDownloadStateTask* task = new QGCUpdateTileDownloadStateTask(_id, QGCTile::StateComplete, hash);
                MapEngine::instance()->addTask(task);
                //-- Updated cached (downloaded) data
                _savedTileSize += image.size();
                _savedTileCount++;
                emit savedTileSizeChanged();
                emit savedTileCountChanged();
                //-- Update estimate
                if(_savedTileCount % 10 == 0) {
                    quint32 avg = _savedTileSize / _savedTileCount;
                    _totalTileSize  = avg * _totalTileCount;
                    _uniqueTileSize = avg * _uniqueTileCount;
                    emit totalTilesSizeChanged();
                    emit uniqueTileSizeChanged();
                }
            }
            //-- Setup a new download
            _prepareDownload();
        } else {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "MapEngineManager::networkReplyFinished() Empty Hash";
#endif
        }
    }
    reply->deleteLater();
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::_networkReplyError(QNetworkReply::NetworkError error)
{
    //-- Figure out which reply this is
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    if (!reply) {
        return;
    }
    //-- Update error count
    _errorCount++;
    emit errorCountChanged();
    //-- Get tile hash
    QString hash = reply->request().attribute(QNetworkRequest::User).toString();

#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "Error fetching tile" << reply->errorString();
#endif

    if(!hash.isEmpty()) {
        if(_replies.contains(hash)) {
            _replies.remove(hash);
        } else {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "MapEngineManager::networkReplyError() Reply not in list: " << hash;
#endif
        }
        if (error != QNetworkReply::OperationCanceledError) {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "MapEngineManager::networkReplyError() Error:" << reply->errorString();
#endif
        }
        QGCUpdateTileDownloadStateTask* task = new QGCUpdateTileDownloadStateTask(_id, QGCTile::StateError, hash);
        MapEngine::instance()->addTask(task);
    } else {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "MapEngineManager::networkReplyError() Empty Hash";
#endif
    }
    //-- Setup a new download
    _prepareDownload();
    reply->deleteLater();
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::setManager(MapEngineManager* mgr)
{
    _manager = mgr;
}

//-----------------------------------------------------------------------------
void
QGCCachedTileSet::setSelected(bool sel)
{
    _selected = sel;
    emit selectedChanged();
    if(_manager) {
        emit _manager->selectedCountChanged();
    }
}
