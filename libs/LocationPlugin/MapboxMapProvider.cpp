#include "MapboxMapProvider.h"


MapboxMapProvider::MapboxMapProvider(const QString &_name, const quint32 &size, const QGeoMapType::MapStyle &type, QObject *parent)
    : MapProvider(QStringLiteral("https://www.mapbox.com/"), QStringLiteral("jpg"), size, type, parent)
    , name(_name)
{
    // empty
}

QString MapboxMapProvider::getURL(const int &x, const int &y, const int &zoom, QNetworkAccessManager *network_manager)
{
    Q_UNUSED(network_manager)

    // TODO = qgcApp()->toolbox()->settingsManager()->appSettings()->mapboxToken()->rawValue().toString();
    const QString token = "pk.eyJ1IjoiZGlydWF2IiwiYSI6ImNrcWJ6OXh2dzAzcGQydnA5cnBrczB4MnQifQ.zKj2APyCpgy79D9CWCq1nA";

    if (token.isEmpty()) {
#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << "token is empty";
#endif
        return QString();
    }

    if (name == QString("mapbox.custom")) {
        const QString account; // TODO = qgcApp()->toolbox()->settingsManager()->appSettings()->mapboxAccount()->rawValue().toString();
        const QString style; // TODO = qgcApp()->toolbox()->settingsManager()->appSettings()->mapboxStyle()->rawValue().toString();
        return kURLCustom.arg(account).arg(style).arg(zoom).arg(x).arg(y).arg(token);
    }

    return kURL.arg(name).arg(zoom).arg(x).arg(y).arg(token);
}
