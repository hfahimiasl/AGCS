#include "GoogleMapProvider.h"
#include "MapEngine.h"


GoogleMapProvider::GoogleMapProvider(const QString &format, const quint32 &size, const QGeoMapType::MapStyle &type, QObject *parent)
    : MapProvider(QStringLiteral("https://www.google.com/maps/preview"), format, size, type, parent)
{
    map_version = QStringLiteral("m@354000000");
    satellite_version = QStringLiteral("692");
    labels_version = QStringLiteral("h@336");
    terrain_version = QStringLiteral("t@354,r@354000000");
    hybrid_version = QStringLiteral("y");
    word_sec = QStringLiteral("Galileo");
}

GoogleMapProvider::~GoogleMapProvider()
{
    if (network_reply) {
        network_reply->deleteLater();
    }
}

void GoogleMapProvider::networkReplyError(QNetworkReply::NetworkError error)
{
#ifdef DEBUG_LOCATION_PLUGIN
    qWarning() << "Could not connect to google maps. Error:" << error;
#else
    Q_UNUSED(error)
#endif

    if (network_reply) {
        network_reply->deleteLater();
        network_reply = nullptr;
    }
}

void GoogleMapProvider::googleVersionCompleted()
{
    if (!network_reply || (network_reply->error() != QNetworkReply::NoError)) {
#ifdef DEBUG_LOCATION_PLUGIN
        qDebug() << "error collecting Google maps version info";
#endif
        return;
    }

    const QString html = QString(network_reply->readAll());

#if defined(DEBUG_GOOGLE_MAPS)
    QString filename = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    filename += QStringLiteral("/google.output");
    QFile file(filename);

    if (file.open(QIODevice::ReadWrite)) {
        QTextStream stream(&file);
        stream << html << endl;
    }
#endif

    QRegExp reg(QStringLiteral("\"*https?://mt\\D?\\d..*/vt\\?lyrs=m@(\\d*)"), Qt::CaseInsensitive);

    if (reg.indexIn(html) != -1) {
        map_version = QString(QStringLiteral("m@%1")).arg(reg.capturedTexts().value(1, QString()));
    }

    reg = QRegExp(QStringLiteral("\"*https?://khm\\D?\\d.googleapis.com/kh\\?v=(\\d*)"), Qt::CaseInsensitive);

    if (reg.indexIn(html) != -1) {
        satellite_version = reg.capturedTexts().value(1);
    }

    reg = QRegExp(QStringLiteral("\"*https?://mt\\D?\\d..*/vt\\?lyrs=t@(\\d*),r@(\\d*)"), Qt::CaseInsensitive);

    if (reg.indexIn(html) != -1) {
        const QStringList gc = reg.capturedTexts();
        terrain_version = QString(QStringLiteral("t@%1,r@%2")).arg(gc.value(1), gc.value(2));
    }

    network_reply->deleteLater();
    network_reply = nullptr;
}

void GoogleMapProvider::replyDestroyed()
{
    network_reply = nullptr;
}

void GoogleMapProvider::getSecGoogleWords(const int &x, const int &y, QString &sec1, QString &sec2) const
{
    const int seclen = ((x * 3) + y) % 8;

    sec2 = word_sec.left(seclen);

    if (y >= 10000 && y < 100000) {
        sec1 = QStringLiteral("&s=");

    } else {
        sec1 = QStringLiteral("");
    }
}

void GoogleMapProvider::tryCorrectGoogleVersions(QNetworkAccessManager *network_manager)
{
    QMutexLocker locker(&mutex);

    if (version_retrieved) {
        return;
    }

    version_retrieved = true;

    if (!network_manager) {
        return;
    }

    const QNetworkProxy proxy = network_manager->proxy();

    QNetworkProxy temp_proxy;
    temp_proxy.setType(QNetworkProxy::DefaultProxy);
    network_manager->setProxy(temp_proxy);

    QNetworkRequest network_request;
    QSslConfiguration ssl_conf = network_request.sslConfiguration();
    ssl_conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    network_request.setSslConfiguration(ssl_conf);
    network_request.setUrl(QUrl(QStringLiteral("http://maps.google.com/maps/api/js?v=3.2&sensor=false")));
    network_request.setRawHeader("User-Agent", MapEngine::instance()->userAgent().toLatin1());
    network_reply = network_manager->get(network_request);

    QObject::connect(network_reply, &QNetworkReply::finished, this, &GoogleMapProvider::googleVersionCompleted);
    QObject::connect(network_reply, &QNetworkReply::destroyed, this, &GoogleMapProvider::replyDestroyed);

#if QT_VERSION < QT_VERSION_CHECK(5, 15, 0)
    QObject::connect(network_reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error), this, &GoogleMapProvider::networkReplyError);
#else
    QObject::connect(network_reply, &QNetworkReply::errorOccurred, this, &GoogleMapProvider::networkReplyError);
#endif

    network_manager->setProxy(proxy);
}

QString GoogleStreetMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    QString sec1;
    QString sec2;
    getSecGoogleWords(x, y, sec1, sec2);
    tryCorrectGoogleVersions(network_manager);
    static const QString server("mt");
    static const QString request("vt");
    return QString(QStringLiteral("http://%1%2.google.com/%3/lyrs=%4&hl=%5&x=%6%7&y=%8&z=%9&s=%10"))
            .arg(server)
            .arg(_getServerNum(x, y, 4))
            .arg(request)
            .arg(map_version)
            .arg(_language)
            .arg(x)
            .arg(sec1)
            .arg(y)
            .arg(zoom)
            .arg(sec2);
}

QString GoogleSatelliteMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    QString sec1;
    QString sec2;
    getSecGoogleWords(x, y, sec1, sec2);
    tryCorrectGoogleVersions(network_manager);
    static const QString server("khm");
    static const QString request("kh");
    return QString(QStringLiteral("http://%1%2.google.com/%3/v=%4&hl=%5&x=%6%7&y=%8&z=%9&s=%10"))
            .arg(server)
            .arg(_getServerNum(x, y, 4))
            .arg(request)
            .arg(satellite_version)
            .arg(_language)
            .arg(x)
            .arg(sec1)
            .arg(y)
            .arg(zoom)
            .arg(sec2);
}

QString GoogleLabelsMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    QString sec1;
    QString sec2;
    getSecGoogleWords(x, y, sec1, sec2);
    tryCorrectGoogleVersions(network_manager);
    static const QString server("mts");
    static const QString request("vt");
    return QString(QStringLiteral("http://%1%2.google.com/%3/lyrs=%4&hl=%5&x=%6%7&y=%8&z=%9&s=%10"))
            .arg(server)
            .arg(_getServerNum(x, y, 4))
            .arg(request)
            .arg(labels_version)
            .arg(_language)
            .arg(x)
            .arg(sec1)
            .arg(y)
            .arg(zoom)
            .arg(sec2);
}

QString GoogleTerrainMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    QString sec1;
    QString sec2;
    getSecGoogleWords(x, y, sec1, sec2);
    tryCorrectGoogleVersions(network_manager);
    static const QString server("mt");
    static const QString request("vt");
    return QString(QStringLiteral("http://%1%2.google.com/%3/v=%4&hl=%5&x=%6%7&y=%8&z=%9&s=%10"))
            .arg(server)
            .arg(_getServerNum(x, y, 4))
            .arg(request)
            .arg(terrain_version)
            .arg(_language)
            .arg(x)
            .arg(sec1)
            .arg(y)
            .arg(zoom)
            .arg(sec2);
}

QString GoogleHybridMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    QString sec1;
    QString sec2;
    getSecGoogleWords(x, y, sec1, sec2);
    tryCorrectGoogleVersions(network_manager);
    static const QString server("mt");
    static const QString request("vt");
    return QString(QStringLiteral("http://%1%2.google.com/%3/lyrs=%4&hl=%5&x=%6%7&y=%8&z=%9&s=%10"))
            .arg(server)
            .arg(_getServerNum(x, y, 4))
            .arg(request)
            .arg(hybrid_version)
            .arg(_language)
            .arg(x)
            .arg(sec1)
            .arg(y)
            .arg(zoom)
            .arg(sec2);
}
