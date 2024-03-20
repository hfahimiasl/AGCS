#pragma once

#include <QTimer>
#include <QNetworkAccessManager>
#include <QtLocation/private/qgeotilefetcher_p.h>

#include "MapEngine.h"
#include "QGeoMapReplyQGC.h"


class GeoTileFetcher : public QGeoTileFetcher
{
    Q_OBJECT

public:
    explicit GeoTileFetcher(QGeoTiledMappingManagerEngine * = nullptr);
    ~GeoTileFetcher();

private:
    QTimer *timer {nullptr};
    QNetworkAccessManager *network_manager {nullptr};

    static constexpr quint16 timeout {5000};

    QGeoTiledMapReply *getTileImage(const QGeoTileSpec &);
};
