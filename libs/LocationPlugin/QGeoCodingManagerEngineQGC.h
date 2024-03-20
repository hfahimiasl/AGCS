#pragma once

#include <QUrlQuery>
#include <QGeoAddress>
#include <QGeoRectangle>
#include <QGeoCodeReply>
#include <QGeoServiceProvider>
#include <QGeoCodingManagerEngine>
#include <QNetworkAccessManager>


QT_BEGIN_NAMESPACE

class QGeoCodingManagerEngineQGC : public QGeoCodingManagerEngine
{
    Q_OBJECT

public:
    QGeoCodingManagerEngineQGC(const QVariantMap &parameters, QGeoServiceProvider::Error *error, QString *errorString);
    ~QGeoCodingManagerEngineQGC() override;

    QGeoCodeReply *geocode(const QGeoAddress &, const QGeoShape &) Q_DECL_OVERRIDE;
    QGeoCodeReply *geocode(const QString &, int, int, const QGeoShape &) Q_DECL_OVERRIDE;
    QGeoCodeReply *reverseGeocode(const QGeoCoordinate &, const QGeoShape &) Q_DECL_OVERRIDE;

private Q_SLOTS:
    void replyFinished();
    void replyError(QGeoCodeReply::Error, const QString &);

private:
    QNetworkAccessManager *network_manager {nullptr};
    QByteArray user_agent;
};

QT_END_NAMESPACE
