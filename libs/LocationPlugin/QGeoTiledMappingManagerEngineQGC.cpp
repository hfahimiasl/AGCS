/****************************************************************************
**
** Copyright (C) 2013 Aaron McCarthy <mccarthy.aaron@gmail.com>
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtLocation module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
** 2015.4.4
** Adapted for use with QGroundControl
**
** Gus Grubba <gus@auterion.com>
**
****************************************************************************/

#include "MapEngine.h"
#include "QGeoTiledMappingManagerEngineQGC.h"
#include "GeoTileFetcher.h"

#include <QtLocation/private/qgeocameracapabilities_p.h>
#include <QtLocation/private/qgeomaptype_p.h>
#include <QtLocation/private/qgeotiledmap_p.h>
#include <QtLocation/private/qgeofiletilecache_p.h>

#include <QDir>
#include <QStandardPaths>

//-----------------------------------------------------------------------------
QGeoTiledMapQGC::QGeoTiledMapQGC(QGeoTiledMappingManagerEngine *engine, QObject *parent)
    : QGeoTiledMap(engine, parent)
{

}

//-----------------------------------------------------------------------------
QGeoTiledMappingManagerEngineQGC::QGeoTiledMappingManagerEngineQGC(const QVariantMap &parameters, QGeoServiceProvider::Error *error, QString *errorString)
:   QGeoTiledMappingManagerEngine()
{

    QGeoCameraCapabilities cameraCaps;
    cameraCaps.setMinimumZoomLevel(QGeoTiledMappingManagerEngineQGC::kMinimumZoomLevel);
    cameraCaps.setMaximumZoomLevel(QGeoTiledMappingManagerEngineQGC::kMaximumZoomLevel);
    cameraCaps.setSupportsBearing(true);
    setCameraCapabilities(cameraCaps);

    setTileSize(QSize(256, 256));

    /*
     * Google and Bing don't seem kosher at all. This was based on original code from OpenPilot and heavily modified to be used in QGC.
     */

    QList<QGeoMapType> mapList;
    QHashIterator<QString, MapProvider*> i(MapEngine::instance()->urlFactory()->getProviderTable());

    while (i.hasNext()) {
        i.next();

        if(!i.value()->isElevationProvider()){
            mapList.append(QGeoMapType(i.value()->getMapStyle(), i.key(), i.key(), false, false, MapEngine::instance()->urlFactory()->getIDByType(i.key()), QByteArray("AdlanPaya"), cameraCaps));
		}
    }

    setSupportedMapTypes(mapList);

    //-- Users (QML code) can define a different user agent
    if (parameters.contains(QStringLiteral("useragent"))) {
        MapEngine::instance()->setUserAgent(parameters.value(QStringLiteral("useragent")).toString().toLatin1());
    }

    _setCache(parameters);

    setTileFetcher(new GeoTileFetcher(this));

    *error = QGeoServiceProvider::NoError;
    errorString->clear();
}

//-----------------------------------------------------------------------------
QGeoTiledMappingManagerEngineQGC::~QGeoTiledMappingManagerEngineQGC()
{
}

//-----------------------------------------------------------------------------
QGeoMap*
QGeoTiledMappingManagerEngineQGC::createMap()
{
    return new QGeoTiledMapQGC(this);
}

//-----------------------------------------------------------------------------
void
QGeoTiledMappingManagerEngineQGC::_setCache(const QVariantMap &parameters)
{
    QString cacheDir;
    if (parameters.contains(QStringLiteral("mapping.cache.directory")))
        cacheDir = parameters.value(QStringLiteral("mapping.cache.directory")).toString();
    else {
        cacheDir = MapEngine::instance()->getCachePath();
        if(!QFileInfo::exists(cacheDir)) {
            if(!QDir::root().mkpath(cacheDir)) {
#ifdef DEBUG_LOCATION_PLUGIN
                qWarning() << "Could not create mapping disk cache directory: " << cacheDir;
#endif
                cacheDir = QDir::homePath() + QStringLiteral("/.adlanpayamapscache/");
            }
        }
    }
    if(!QFileInfo::exists(cacheDir)) {
        if(!QDir::root().mkpath(cacheDir)) {
#ifdef DEBUG_LOCATION_PLUGIN
            qWarning() << "Could not create mapping disk cache directory: " << cacheDir;
#endif
            cacheDir.clear();
        }
    }
    //-- Memory Cache
    uint32_t memLimit = 0;
    if (parameters.contains(QStringLiteral("mapping.cache.memory.size"))) {
      bool ok = false;
      memLimit = parameters.value(QStringLiteral("mapping.cache.memory.size")).toString().toUInt(&ok);
      if (!ok)
          memLimit = 0;
    }
    if(!memLimit)
    {
        //-- Value saved in MB
        memLimit = MapEngine::instance()->getMaxMemCache() * (1024 * 1024);
    }
    //-- It won't work with less than 1M of memory cache
    if(memLimit < 1024 * 1024)
        memLimit = 1024 * 1024;
    //-- On the other hand, Qt uses signed 32-bit integers. Limit to 1G to round it down (you don't need more than that).
    if(memLimit > 1024 * 1024 * 1024)
        memLimit = 1024 * 1024 * 1024;
    //-- Disable Qt's disk cache (sort of)
    QAbstractGeoTileCache *pTileCache = new QGeoFileTileCache(cacheDir);
    setTileCache(pTileCache);
    if(pTileCache)
    {
        //-- We're basically telling it to use 100k of disk for cache. It doesn't like
        //   values smaller than that and I could not find a way to make it NOT cache.
        //   We handle our own disk caching elsewhere.
        pTileCache->setMaxDiskUsage(1024 * 100);
        pTileCache->setMaxMemoryUsage(memLimit);
    }
}
