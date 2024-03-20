#pragma once

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QGeoAddress>
#include <QGeoLocation>
#include <QGeoRectangle>
#include <QGeoCoordinate>
#include <QGeoCodeReply>
#include <QNetworkReply>


class JsonMonger;


class GeoCodeReply : public QGeoCodeReply
{
    Q_OBJECT

public:
    explicit GeoCodeReply(QNetworkReply *, QObject * = nullptr);
    ~GeoCodeReply();

    void abort();

    enum GeoCodeType {
        GeoCodeTypeUnknown,
        StreetAddress, // indicates a precise street address.
        Route, // indicates a named route (such as "US 101").
        Intersection, // indicates a major intersection, usually of two major roads.
        Political, // indicates a political entity. Usually, this type indicates a polygon of some civil administration.
        Country, // indicates the national political entity, and is typically the highest order type returned by the Geocoder.
        AdministrativeAreaLevel1, // indicates a first-order civil entity below the country level. Within the United States, these administrative levels are states.
        AdministrativeAreaLevel2, // indicates a second-order civil entity below the country level. Within the United States, these administrative levels are counties.
        AdministrativeAreaLevel3, // indicates a third-order civil entity below the country level. This type indicates a minor civil division.
        ColloquialArea, // indicates a commonly-used alternative name for the entity.
        Locality, // indicates an incorporated city or town political entity.
        Sublocality, // indicates a first-order civil entity below a locality. For some locations may receive one of the additional types: sublocality_level_1 through to sublocality_level_5. Each sublocality level is a civil entity. Larger numbers indicate a smaller geographic area.
        SublocalityLevel1,
        SublocalityLevel2,
        SublocalityLevel3,
        SublocalityLevel4,
        SublocalityLevel5,
        Neighborhood, // indicates a named neighborhood
        Premise, // indicates a named location, usually a building or collection of buildings with a common name
        Subpremise, // indicates a first-order entity below a named location, usually a singular building within a collection of buildings with a common name
        PostalCode, // indicates a postal code as used to address postal mail within the country.
        NaturalFeature, // indicates a prominent natural feature.
        Airport, // indicates an airport.
        Park, // indicates a named park.
        PointOfInterest, // indicates a named point of interest. Typically, these "POI"s are prominent local entities that don't easily fit in another category such as "Empire State Building" or "Statue of Liberty."
        Floor, // indicates the floor of a building address.
        Establishment, // typically indicates a place that has not yet been categorized.
        Parking, // indicates a parking lot or parking structure.
        PostBox, // indicates a specific postal box.
        PostalTown, // indicates a grouping of geographic areas, such as locality and sublocality, used for mailing addresses in some countries.
        RoomIndicates, // the room of a building address.
        StreetNumber, // indicates the precise street number.
        BusStation, //  indicate the location of a bus stop.
        TrainStation, //  indicate the location of a train stop.
        TransitStation, // indicate the location of a public transit stop.
    };

private slots:
    void networkReplyFinished();
    void networkReplyError(QNetworkReply::NetworkError);

private:
    QNetworkReply *reply {nullptr};
    JsonMonger *json_monger {nullptr};
};


class JsonMonger
{
public:
    JsonMonger();

    QSet<GeoCodeReply::GeoCodeType> jsonToGeoCodeType(const QJsonArray &);

private:
    QMap<QString, GeoCodeReply::GeoCodeType> geo_code_map;

    GeoCodeReply::GeoCodeType getCode(const QString &);
};
