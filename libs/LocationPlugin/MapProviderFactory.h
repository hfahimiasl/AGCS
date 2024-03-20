#pragma once

#include <QObject>

#include "BingMapProvider.h"
#include "ElevationMapProvider.h"
#include "EsriMapProvider.h"
#include "GenericMapProvider.h"
#include "GoogleMapProvider.h"
#include "MapboxMapProvider.h"


class MapProviderFactory : public QObject
{
    Q_OBJECT

public:
    explicit MapProviderFactory();

    int getIDByType(const QString &);
    QString getTypeByID(const int &);

    bool isElevation(const int &);

    quint32 averageSizeForType(const QString &);

    MapTileSet_t getTileCount(const int &, const double &, const double &, const double &, const double &, const QString &);

    MapProvider *getMapProviderByID(const int &);

    QString getImageFormat(const QString &, const QByteArray &);
    QString getImageFormat(const int &, const QByteArray &);

    QNetworkRequest getTileURL(const QString &, const int &, const int &, const int &, QNetworkAccessManager *);
    QNetworkRequest getTileURL(const int &, const int &, const int &, const int &, QNetworkAccessManager *);

    QHash<QString, MapProvider *> getProviderTable() const { return provider_hash; }

private:
    QHash<QString, MapProvider *> provider_hash;
};
