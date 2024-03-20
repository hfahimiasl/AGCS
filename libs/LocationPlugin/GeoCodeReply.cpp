#include "GeoCodeReply.h"


JsonMonger::JsonMonger()
{
    geo_code_map.insert("street_address",               GeoCodeReply::StreetAddress);
    geo_code_map.insert("route",                        GeoCodeReply::Route);
    geo_code_map.insert("intersection",                 GeoCodeReply::Intersection);
    geo_code_map.insert("political",                    GeoCodeReply::Political);
    geo_code_map.insert("country",                      GeoCodeReply::Country);
    geo_code_map.insert("administrative_area_level_1",  GeoCodeReply::AdministrativeAreaLevel1);
    geo_code_map.insert("administrative_area_level_2",  GeoCodeReply::AdministrativeAreaLevel2);
    geo_code_map.insert("administrative_area_level_3",  GeoCodeReply::AdministrativeAreaLevel3);
    geo_code_map.insert("colloquial_area",              GeoCodeReply::ColloquialArea);
    geo_code_map.insert("locality",                     GeoCodeReply::Locality);
    geo_code_map.insert("sublocality",                  GeoCodeReply::Sublocality);
    geo_code_map.insert("sublocality_level_1",          GeoCodeReply::SublocalityLevel1);
    geo_code_map.insert("sublocality_level_2",          GeoCodeReply::SublocalityLevel2);
    geo_code_map.insert("sublocality_level_3",          GeoCodeReply::SublocalityLevel3);
    geo_code_map.insert("sublocality_level_4",          GeoCodeReply::SublocalityLevel4);
    geo_code_map.insert("sublocality_level_5",          GeoCodeReply::SublocalityLevel5);
    geo_code_map.insert("neighborhood",                 GeoCodeReply::Neighborhood);
    geo_code_map.insert("premise",                      GeoCodeReply::Premise);
    geo_code_map.insert("subpremise",                   GeoCodeReply::Subpremise);
    geo_code_map.insert("postal_code",                  GeoCodeReply::PostalCode);
    geo_code_map.insert("natural_feature",              GeoCodeReply::NaturalFeature);
    geo_code_map.insert("airport",                      GeoCodeReply::Airport);
    geo_code_map.insert("park",                         GeoCodeReply::Park);
    geo_code_map.insert("point_of_interest",            GeoCodeReply::PointOfInterest);
    geo_code_map.insert("floor",                        GeoCodeReply::Floor);
    geo_code_map.insert("establishment",                GeoCodeReply::Establishment);
    geo_code_map.insert("parking",                      GeoCodeReply::Parking);
    geo_code_map.insert("post_box",                     GeoCodeReply::PostBox);
    geo_code_map.insert("postal_town",                  GeoCodeReply::PostalTown);
    geo_code_map.insert("room indicates",               GeoCodeReply::RoomIndicates);
    geo_code_map.insert("street_number",                GeoCodeReply::StreetNumber);
    geo_code_map.insert("bus_station",                  GeoCodeReply::BusStation);
    geo_code_map.insert("train_station",                GeoCodeReply::TrainStation);
    geo_code_map.insert("transit_station",              GeoCodeReply::TransitStation);
}

QSet<GeoCodeReply::GeoCodeType> JsonMonger::jsonToGeoCodeType(const QJsonArray &array)
{
    QSet<GeoCodeReply::GeoCodeType> result;

    for (int i=0; i<array.size(); ++i) {
        result |= getCode(array.at(i).toString());
    }

    return result;
}

GeoCodeReply::GeoCodeType JsonMonger::getCode(const QString &key)
{
    return geo_code_map.value(key, GeoCodeReply::GeoCodeTypeUnknown);
}


GeoCodeReply::GeoCodeReply(QNetworkReply *_reply, QObject *parent)
    : QGeoCodeReply(parent)
    , reply(_reply)
    , json_monger(new JsonMonger())
{
    QObject::connect(reply, &QNetworkReply::finished, this, &GeoCodeReply::networkReplyFinished);
    QObject::connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(networkReplyError(QNetworkReply::NetworkError)));

    setLimit(1);
    setOffset(0);
}

GeoCodeReply::~GeoCodeReply()
{
    if (reply) {
        delete reply;
    }

    delete json_monger;
}

void GeoCodeReply::abort()
{
    if (!reply) {
        return;
    }

    reply->abort();
    reply->deleteLater();
    reply = nullptr;
}

void GeoCodeReply::networkReplyFinished()
{
    if (!reply) {
        return;
    }

    if (reply->error() != QNetworkReply::NoError) {
        return;
    }

    const QJsonObject object = QJsonDocument::fromJson(reply->readAll()).object();

    if (object.value("status") != "OK") {
        const QString error = object.value("status").toString();

#ifdef DEBUG_LOCATION_PLUGIN
        qWarning() << reply->url() << "returned" << error;
#endif

        setError(QGeoCodeReply::CommunicationError, error);
        reply->deleteLater();
        reply = nullptr;
        return;
    }

    QList<QGeoLocation> location_list;

    const QJsonArray results = object.value("results").toArray();

    for (int i=0; i<results.size(); ++i) {
        if (!results[i].isObject()) {
            continue;
        }

        QGeoAddress address;

        const QJsonObject geo_code = results[i].toObject();

        if (geo_code.contains("formatted_address")) {
            address.setText(geo_code.value("formatted_address").toString());
        }

        if (geo_code.contains("address_components")) {
            const QJsonArray address_components = geo_code.value("address_components").toArray();

            for (int j=0; j<address_components.size(); ++j) {
                if (!address_components[j].isObject()) {
                    continue;
                }

                const QJsonObject component_object = address_components[j].toObject();

                if (!component_object.contains("types")) {
                    continue;
                }

                const QSet<GeoCodeReply::GeoCodeType> types = json_monger->jsonToGeoCodeType(component_object.value("types").toArray());

                const QString short_name = component_object["short_name"].toString();
                const QString long_name = component_object["long_name"].toString();

                if (types.contains(Country)) {
                    address.setCountry(long_name);
                    address.setCountryCode(short_name);

                } else if (types.contains(AdministrativeAreaLevel1)) {
                    address.setState(long_name);

                } else if (types.contains(AdministrativeAreaLevel2)) {
                    address.setCounty(long_name);

                } else if (types.contains(Locality)) {
                    address.setCity(long_name);

                } else if (types.contains(Sublocality)) {
                    address.setDistrict(long_name);

                } else if (types.contains(PostalCode)) {
                    address.setPostalCode(long_name);

                } else if (types.contains(StreetAddress) || types.contains(Route) || types.contains(Intersection)) {
                    address.setStreet(long_name);
                }
            }
        }

        QGeoCoordinate coordinate;
        QGeoRectangle bounding_box;

        if (geo_code.contains("geometry")) {
            const QJsonObject geometry = geo_code.value("geometry").toObject();

            if (geometry.contains("location")) {
                const QJsonObject location = geometry.value("location").toObject();
                coordinate.setLatitude(location.value("lat").toDouble());
                coordinate.setLongitude(location.value("lng").toDouble());
            }

            if (geometry.contains("bounds")) {
                const QJsonObject bounds = geometry.value("bounds").toObject();
                const QJsonObject north_east = bounds.value("northeast").toObject();
                const QJsonObject south_west = bounds.value("southwest").toObject();
                const QGeoCoordinate top_right(north_east.value("lat").toDouble(), north_east.value("lng").toDouble());
                const QGeoCoordinate bottom_left(south_west.value("lat").toDouble(), south_west.value("lng").toDouble());
                bounding_box.setTopRight(top_right);
                bounding_box.setBottomLeft(bottom_left);
            }
        }

        QGeoLocation location;
        location.setAddress(address);
        location.setCoordinate(coordinate);
        location.setBoundingBox(bounding_box);

        location_list.append(location);
    }

    setLocations(location_list);
    setFinished(true);

    reply->deleteLater();
    reply = nullptr;
}

void GeoCodeReply::networkReplyError(QNetworkReply::NetworkError error)
{
    Q_UNUSED(error)

    if (!reply) {
        return;
    }

    setError(QGeoCodeReply::CommunicationError, reply->errorString());
    reply->deleteLater();
    reply = nullptr;
}
