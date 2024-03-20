#include "MapEngineManager.h"
#include "QGCMapTileSet.h"
#include "MapProviderFactory.h"

#include <QSettings>
#include <QStorageInfo>
#include <stdio.h>


static const char* kQmlOfflineMapKeyName = "QGCOfflineMap";

//-----------------------------------------------------------------------------
MapEngineManager::MapEngineManager()
    : _topleftLat(0.0)
    , _topleftLon(0.0)
    , _bottomRightLat(0.0)
    , _bottomRightLon(0.0)
    , _minZoom(0)
    , _maxZoom(0)
    , _setID(UINT64_MAX)
    , _freeDiskSpace(0)
    , _diskSpace(0)
    , _fetchElevation(true)
    , _actionProgress(0)
    , _importAction(ActionNone)
    , _importReplace(false)
{

}

//-----------------------------------------------------------------------------
MapEngineManager::~MapEngineManager()
{
    _tileSets.clear();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::setToolbox()
{
   QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
   qmlRegisterUncreatableType<MapEngineManager>("QGroundControl.MapEngineManager", 1, 0, "MapEngineManager", "Reference only");
   connect(MapEngine::instance(), &MapEngine::updateTotals, this, &MapEngineManager::_updateTotals);
   _updateDiskFreeSpace();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::updateForCurrentView(double lon0, double lat0, double lon1, double lat1, int minZoom, int maxZoom, const QString& mapName)
{
    _topleftLat     = lat0;
    _topleftLon     = lon0;
    _bottomRightLat = lat1;
    _bottomRightLon = lon1;
    _minZoom        = minZoom;
    _maxZoom        = maxZoom;

    _imageSet.clear();
    _elevationSet.clear();

    for(int z = minZoom; z <= maxZoom; z++) {
        MapTileSet_t set = MapEngine::getTileCount(z, lon0, lat0, lon1, lat1, mapName);
        _imageSet += set;
    }
    if (_fetchElevation) {
        MapTileSet_t set = MapEngine::getTileCount(1, lon0, lat0, lon1, lat1, "Airmap Elevation");
        _elevationSet += set;
    }

    emit tileCountChanged();
    emit tileSizeChanged();

#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "updateForCurrentView" << lat0 << lon0 << lat1 << lon1 << minZoom << maxZoom;
#endif
}

//-----------------------------------------------------------------------------
QString
MapEngineManager::tileCountStr() const
{
    return MapEngine::numberToString(_imageSet.tileCount + _elevationSet.tileCount);
}

//-----------------------------------------------------------------------------
QString
MapEngineManager::tileSizeStr() const
{
    return MapEngine::bigSizeToString(_imageSet.tileSize + _elevationSet.tileSize);
}

//-----------------------------------------------------------------------------
void
MapEngineManager::loadTileSets()
{
    if(_tileSets.count()) {
        _tileSets.clear();
        emit tileSetsChanged();
    }
    QGCFetchTileSetTask* task = new QGCFetchTileSetTask();
    connect(task, &QGCFetchTileSetTask::tileSetFetched, this, &MapEngineManager::_tileSetFetched);
    connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
    MapEngine::instance()->addTask(task);
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_tileSetFetched(QGCCachedTileSet* tileSet)
{
    //-- A blank (default) type means it uses various types and not just one
    if(tileSet->type() == "Invalid") {
        tileSet->setMapTypeStr("Various");
    }
    _tileSets.append(tileSet);
    tileSet->setManager(this);
    emit tileSetsChanged();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::startDownload(const QString& name, const QString& mapType)
{
    if(_imageSet.tileSize) {
        QGCCachedTileSet* set = new QGCCachedTileSet(name);
        set->setMapTypeStr(mapType);
        set->setTopleftLat(_topleftLat);
        set->setTopleftLon(_topleftLon);
        set->setBottomRightLat(_bottomRightLat);
        set->setBottomRightLon(_bottomRightLon);
        set->setMinZoom(_minZoom);
        set->setMaxZoom(_maxZoom);
        set->setTotalTileSize(_imageSet.tileSize);
        set->setTotalTileCount(static_cast<quint32>(_imageSet.tileCount));
        set->setType(mapType);
        QGCCreateTileSetTask* task = new QGCCreateTileSetTask(set);
        //-- Create Tile Set (it will also create a list of tiles to download)
        connect(task, &QGCCreateTileSetTask::tileSetSaved, this, &MapEngineManager::_tileSetSaved);
        connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
        MapEngine::instance()->addTask(task);
    } else {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() <<  "MapEngineManager::startDownload() No Tiles to save";
#endif
    }
    if (mapType != "Airmap Elevation" && _fetchElevation) {
        QGCCachedTileSet* set = new QGCCachedTileSet(name + " Elevation");
        set->setMapTypeStr("Airmap Elevation");
        set->setTopleftLat(_topleftLat);
        set->setTopleftLon(_topleftLon);
        set->setBottomRightLat(_bottomRightLat);
        set->setBottomRightLon(_bottomRightLon);
        set->setMinZoom(1);
        set->setMaxZoom(1);
        set->setTotalTileSize(_elevationSet.tileSize);
        set->setTotalTileCount(static_cast<quint32>(_elevationSet.tileCount));
        set->setType("Airmap Elevation");
        QGCCreateTileSetTask* task = new QGCCreateTileSetTask(set);
        //-- Create Tile Set (it will also create a list of tiles to download)
        connect(task, &QGCCreateTileSetTask::tileSetSaved, this, &MapEngineManager::_tileSetSaved);
        connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
        MapEngine::instance()->addTask(task);
    } else {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() <<  "MapEngineManager::startDownload() No Tiles to save";
#endif
    }
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_tileSetSaved(QGCCachedTileSet *set)
{
#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "New tile set saved (" << set->name() << "). Starting download...";
#endif

    _tileSets.append(set);
    emit tileSetsChanged();
    //-- Start downloading tiles
    set->createDownloadTask();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::saveSetting (const QString& key, const QString& value)
{
    QSettings settings;
    settings.beginGroup(kQmlOfflineMapKeyName);
    settings.setValue(key, value);
}

//-----------------------------------------------------------------------------
QString
MapEngineManager::loadSetting (const QString& key, const QString& defaultValue)
{
    QSettings settings;
    settings.beginGroup(kQmlOfflineMapKeyName);
    return settings.value(key, defaultValue).toString();
}

//-----------------------------------------------------------------------------
QStringList
MapEngineManager::mapList()
{
    return MapEngine::instance()->getMapNameList();
}
//-----------------------------------------------------------------------------
QStringList
MapEngineManager::mapProviderList()
{
    // Extract Provider name from MapName ( format : "Provider Type")
    QStringList mapList = MapEngine::instance()->getMapNameList();
    mapList.replaceInStrings(QRegExp("^([^\\ ]*) (.*)$"),"\\1");
    mapList.removeDuplicates();
    mapList.sort();
    return mapList;
}

//-----------------------------------------------------------------------------
QStringList
MapEngineManager::mapTypeList(QString provider)
{
    // Extract type name from MapName ( format : "Provider Type")
    QStringList mapList = MapEngine::instance()->getMapNameList();
    mapList = mapList.filter(QRegularExpression(provider));
    mapList.replaceInStrings(QRegExp("^([^\\ ]*) (.*)$"),"\\2");
    mapList.removeDuplicates();
    mapList.sort();
    return mapList;
}

//-----------------------------------------------------------------------------
quint32
MapEngineManager::maxMemCache()
{
    return MapEngine::instance()->getMaxMemCache();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::setMaxMemCache(quint32 size)
{
    MapEngine::instance()->setMaxMemCache(size);
}

//-----------------------------------------------------------------------------
quint32
MapEngineManager::maxDiskCache()
{
    return MapEngine::instance()->getMaxDiskCache();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::setMaxDiskCache(quint32 size)
{
    MapEngine::instance()->setMaxDiskCache(size);
}

//-----------------------------------------------------------------------------
void
MapEngineManager::deleteTileSet(QGCCachedTileSet* tileSet)
{
#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "Deleting tile set " << tileSet->name();
#endif

    //-- If deleting default set, delete it all
    if(tileSet->defaultSet()) {
        for(int i = 0; i < _tileSets.count(); i++ ) {
            QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
            if(set) {
                set->setDeleting(true);
            }
        }
        QGCResetTask* task = new QGCResetTask();
        connect(task, &QGCResetTask::resetCompleted, this, &MapEngineManager::_resetCompleted);
        connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
        MapEngine::instance()->addTask(task);
    } else {
        tileSet->setDeleting(true);
        QGCDeleteTileSetTask* task = new QGCDeleteTileSetTask(tileSet->setID());
        connect(task, &QGCDeleteTileSetTask::tileSetDeleted, this, &MapEngineManager::_tileSetDeleted);
        connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
        MapEngine::instance()->addTask(task);
    }
}

//-----------------------------------------------------------------------------
void
MapEngineManager::renameTileSet(QGCCachedTileSet* tileSet, QString newName)
{
    //-- Name must be unique
    int idx = 1;
    QString name = newName;
    while(findName(name)) {
        name = QString("%1 (%2)").arg(newName).arg(idx++);
    }

#ifdef DEBUG_LOCATION_PLUGIN
    qDebug() << "Renaming tile set " << tileSet->name() << "to" << name;
#endif

    tileSet->setName(name);
    QGCRenameTileSetTask* task = new QGCRenameTileSetTask(tileSet->setID(), name);
    connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
    MapEngine::instance()->addTask(task);
    emit tileSet->nameChanged();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_resetCompleted()
{
    //-- Reload sets
    loadTileSets();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_tileSetDeleted(quint64 setID)
{
    //-- Tile Set successfully deleted
    QGCCachedTileSet* setToDelete = nullptr;
    int i = 0;
    for(i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if (set && set->setID() == setID) {
            setToDelete = set;
            break;
        }
    }
    if(setToDelete) {
        _tileSets.removeAt(i);
        delete setToDelete;
    }
    emit tileSetsChanged();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::taskError(QGCMapTask::TaskType type, QString error)
{
    QString task;
    switch(type) {
    case QGCMapTask::taskFetchTileSets:
        task = "Fetch Tile Set";
        break;
    case QGCMapTask::taskCreateTileSet:
        task = "Create Tile Set";
        break;
    case QGCMapTask::taskGetTileDownloadList:
        task = "Get Tile Download List";
        break;
    case QGCMapTask::taskUpdateTileDownloadState:
        task = "Update Tile Download Status";
        break;
    case QGCMapTask::taskDeleteTileSet:
        task = "Delete Tile Set";
        break;
    case QGCMapTask::taskReset:
        task = "Reset Tile Sets";
        break;
    case QGCMapTask::taskExport:
        task = "Export Tile Sets";
        break;
    default:
        task = "Database Error";
        break;
    }
    QString serror = "Error in task: " + task;
    serror += "\nError description:\n";
    serror += error;
#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "MapEngineManager::_taskError()";
#endif
    setErrorMessage(serror);
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_updateTotals(quint32 totaltiles, quint64 totalsize, quint32 defaulttiles, quint64 defaultsize)
{
    for(int i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if (set && set->defaultSet()) {
            set->setSavedTileSize(totalsize);
            set->setSavedTileCount(totaltiles);
            set->setTotalTileCount(defaulttiles);
            set->setTotalTileSize(defaultsize);
            return;
        }
    }
    _updateDiskFreeSpace();
}

//-----------------------------------------------------------------------------
bool
MapEngineManager::findName(const QString& name)
{
    for(int i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if (set && set->name() == name) {
            return true;
        }
    }
    return false;
}

//-----------------------------------------------------------------------------
void
MapEngineManager::selectAll() {
    for(int i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if(set) {
            set->setSelected(true);
        }
    }
}

//-----------------------------------------------------------------------------
void
MapEngineManager::selectNone() {
    for(int i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if(set) {
            set->setSelected(false);
        }
    }
}

//-----------------------------------------------------------------------------
int
MapEngineManager::selectedCount() {
    int count = 0;
    for(int i = 0; i < _tileSets.count(); i++ ) {
        QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
        if(set && set->selected()) {
            count++;
        }
    }
    return count;
}

//-----------------------------------------------------------------------------
bool
MapEngineManager::importSets(QString path) {
    _importAction = ActionNone;
    emit importActionChanged();
    QString dir = path;
    if(dir.isEmpty()) {
#ifdef Q_OS_ANDROID
        //-- TODO: This has to be something fixed
        dir = QDir(QDir::homePath()).filePath(QString("export_%1.db").arg(QDateTime::currentDateTime().toTime_t()));
#else
        dir = QString(); //-- TODO: QGCQFileDialog::getOpenFileName(
        //    nullptr,
        //    "Import Tile Set",
        //    QDir::homePath(),
        //    "Tile Sets (*.qgctiledb)");
#endif
    }
    if(!dir.isEmpty()) {
        _importAction = ActionImporting;
        emit importActionChanged();
        QGCImportTileTask* task = new QGCImportTileTask(dir, _importReplace);
        connect(task, &QGCImportTileTask::actionCompleted, this, &MapEngineManager::_actionCompleted);
        connect(task, &QGCImportTileTask::actionProgress, this, &MapEngineManager::_actionProgressHandler);
        connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
        MapEngine::instance()->addTask(task);
        return true;
    }
    return false;
}

//-----------------------------------------------------------------------------
bool
MapEngineManager::exportSets(QString path) {
    _importAction = ActionNone;
    emit importActionChanged();
    QString dir = path;
    if(dir.isEmpty()) {
#ifdef Q_OS_ANDROID
        dir = QDir(QDir::homePath()).filePath(QString("export_%1.db").arg(QDateTime::currentDateTime().toTime_t()));
#else
        dir = QString(); //-- TODO: QGCQFileDialog::getSaveFileName(
        //    MainWindow::instance(),
        //    "Export Tile Set",
        //    QDir::homePath(),
        //    "Tile Sets (*.qgctiledb)",
        //    "qgctiledb",
        //    true);
#endif
    }
    if(!dir.isEmpty()) {
        QVector<QGCCachedTileSet*> sets;
        for(int i = 0; i < _tileSets.count(); i++ ) {
            QGCCachedTileSet* set = qobject_cast<QGCCachedTileSet*>(_tileSets.get(i));
            if(set->selected()) {
                sets.append(set);
            }
        }
        if(sets.count()) {
            _importAction = ActionExporting;
            emit importActionChanged();
            QGCExportTileTask* task = new QGCExportTileTask(sets, dir);
            connect(task, &QGCExportTileTask::actionCompleted, this, &MapEngineManager::_actionCompleted);
            connect(task, &QGCExportTileTask::actionProgress, this, &MapEngineManager::_actionProgressHandler);
            connect(task, &QGCMapTask::error, this, &MapEngineManager::taskError);
            MapEngine::instance()->addTask(task);
            return true;
        }
    }
    return false;
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_actionProgressHandler(int percentage)
{
    _actionProgress = percentage;
    emit actionProgressChanged();
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_actionCompleted()
{
    ImportAction oldState = _importAction;
    _importAction = ActionDone;
    emit importActionChanged();
    //-- If we just imported, reload it all
    if(oldState == ActionImporting) {
        loadTileSets();
    }
}

//-----------------------------------------------------------------------------
void
MapEngineManager::resetAction()
{
    _importAction = ActionNone;
    emit importActionChanged();
}

//-----------------------------------------------------------------------------
QString
MapEngineManager::getUniqueName()
{
    QString test = "Tile Set ";
    QString name;
    int count = 1;
    while (true) {
        name = test;
        name += QString::asprintf("%03d", count++);
        if(!findName(name))
            return name;
    }
}

//-----------------------------------------------------------------------------
void
MapEngineManager::_updateDiskFreeSpace()
{
    QString path = MapEngine::instance()->getCachePath();
    if(!path.isEmpty()) {
        QStorageInfo info(path);
        quint32 total = static_cast<quint32>(info.bytesTotal() / 1024);
        quint32 free  = static_cast<quint32>(info.bytesFree()  / 1024);

#ifdef DEBUG_LOCATION_PLUGIN
        qDebug() << info.rootPath() << "has" << free << "Mbytes available.";
#endif

        if(_freeDiskSpace != free) {
            _freeDiskSpace = free;
            _diskSpace = total;
            emit freeDiskSpaceChanged();
        }
    }
}
