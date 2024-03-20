#ifndef QGC_TILE_CACHE_WORKER_H
#define QGC_TILE_CACHE_WORKER_H

#include <QString>
#include <QThread>
#include <QQueue>
#include <QMutex>
#include <QWaitCondition>
#include <QMutexLocker>
#include <QtSql/QSqlDatabase>
#include <QHostInfo>


class QGCMapTask;
class QGCCachedTileSet;

//-----------------------------------------------------------------------------
class QGCCacheWorker : public QThread
{
    Q_OBJECT
public:
    QGCCacheWorker  ();
    ~QGCCacheWorker ();

    void    quit            ();
    bool    enqueueTask     (QGCMapTask* task);
    void    setDatabaseFile (const QString& path);

protected:
    void    run             ();

private slots:
    void        _lookupReady            (QHostInfo info);

private:
    void        _runTask                (QGCMapTask* task);

    void        _saveTile               (QGCMapTask* mtask);
    void        _getTile                (QGCMapTask* mtask);
    void        _getTileSets            (QGCMapTask* mtask);
    void        _createTileSet          (QGCMapTask* mtask);
    void        _getTileDownloadList    (QGCMapTask* mtask);
    void        _updateTileDownloadState(QGCMapTask* mtask);
    void        _deleteTileSet          (QGCMapTask* mtask);
    void        _renameTileSet          (QGCMapTask* mtask);
    void        _resetCacheDatabase     (QGCMapTask* mtask);
    void        _pruneCache             (QGCMapTask* mtask);
    void        _exportSets             (QGCMapTask* mtask);
    void        _importSets             (QGCMapTask* mtask);
    bool        _testTask               (QGCMapTask* mtask);
    void        _testInternet           ();
    void        _deleteBingNoTileTiles  ();

    quint64     _findTile               (const QString hash);
    bool        _findTileSetID          (const QString name, quint64& setID);
    void        _updateSetTotals        (QGCCachedTileSet* set);
    bool        _init                   ();
    bool        _connectDB              ();
    bool        _createDB               (QSqlDatabase& db, bool createDefault = true);
    void        _disconnectDB           ();
    quint64     _getDefaultTileSet      ();
    void        _updateTotals           ();
    void        _deleteTileSet          (qulonglong id);

signals:
    void        updateTotals            (quint32 totaltiles, quint64 totalsize, quint32 defaulttiles, quint64 defaultsize);
    void        internetStatus          (bool active);

private:
    QQueue<QGCMapTask*>             _taskQueue;
    QMutex                          _taskQueueMutex;
    QWaitCondition                  _waitc;
    QString                         _databasePath;
    QScopedPointer<QSqlDatabase>    _db;
    std::atomic_bool                _valid;
    bool                            _failed;
    quint64                         _defaultSet;
    quint64                         _totalSize;
    quint32                         _totalCount;
    quint64                         _defaultSize;
    quint32                         _defaultCount;
    time_t                          _lastUpdate;
    int                             _updateTimeout;
    int                             _hostLookupID;

    static constexpr quint8 kShortTimeout {2};
    static constexpr quint8 kLongTimeout {4};
};

#endif // QGC_TILE_CACHE_WORKER_H
