#pragma once

#include <QString>

#include "MapProviderFactory.h"
#include "MapEngineData.h"
#include "QGCTileCacheWorker.h"
#include "QGeoTiledMappingManagerEngineQGC.h"


class MapEngine : public QObject
{
    Q_OBJECT

public:
    MapEngine();
    ~MapEngine();

    static MapEngine *instance();
    static void destroy();

    void                        init                ();
    void                        addTask             (QGCMapTask *task);
    void                        cacheTile           (QString type, int x, int y, int z, const QByteArray& image, const QString& format, qulonglong set = UINT64_MAX);
    void                        cacheTile           (QString type, const QString& hash, const QByteArray& image, const QString& format, qulonglong set = UINT64_MAX);
    QGCFetchTileTask*           createFetchTileTask (QString type, int x, int y, int z);
    QStringList                 getMapNameList      ();
    const QString               userAgent           () { return _userAgent; }
    void                        setUserAgent        (const QString& ua) { _userAgent = ua; }
    QString         hashToType          (const QString& hash);
    quint32                     getMaxDiskCache     ();
    void                        setMaxDiskCache     (quint32 size);
    quint32                     getMaxMemCache      ();
    void                        setMaxMemCache      (quint32 size);
    const QString               getCachePath        () { return _cachePath; }
    const QString               getCacheFilename    () { return _cacheFile; }
    void                        testInternet        ();
    bool                        wasCacheReset       () const{ return _cacheWasReset; }
    bool                        isInternetActive    () const{ return _isInternetActive; }

    MapProviderFactory*                 urlFactory          () { return _urlFactory; }

    //-- Tile Math
    static MapTileSet_t           getTileCount        (int zoom, double topleftLon, double topleftLat, double bottomRightLon, double bottomRightLat, QString mapType);
    static QString              getTileHash         (QString type, int x, int y, int z);
    static QString              getTypeFromName     (const QString &name);
    static QString              bigSizeToString     (quint64 size);
    static QString              storageFreeSizeToString(quint64 size_MB);
    static QString              numberToString      (quint64 number);
    static int                  concurrentDownloads (QString type);

private slots:
    void _updateTotals          (quint32 totaltiles, quint64 totalsize, quint32 defaulttiles, quint64 defaultsize);
    void _pruned                ();
    void _internetStatus        (bool active);

signals:
    void updateTotals           (quint32 totaltiles, quint64 totalsize, quint32 defaulttiles, quint64 defaultsize);
    void internetUpdated        ();

private:
    void _wipeOldCaches         ();
    void _checkWipeDirectory    (const QString& dirPath);
    bool _wipeDirectory         (const QString& dirPath);

private:
    QGCCacheWorker          _worker;
    QString                 _cachePath;
    QString                 _cacheFile;
    MapProviderFactory*             _urlFactory;
    QString                 _userAgent;
    quint32                 _maxDiskCache;
    quint32                 _maxMemCache;
    bool                    _prunning;
    bool                    _cacheWasReset;
    bool                    _isInternetActive;

    static MapEngine *self;
};
