#pragma once

#include <cmath>
#include <QGeoCoordinate>


namespace Geographical
{
void convertGeoToNed(const QGeoCoordinate &, const QGeoCoordinate &, double *, double *, double *);
void convertNedToGeo(const double &, const double &, const double &, const QGeoCoordinate &, QGeoCoordinate *);

const double kDegToRad {M_PI / 180.0};
const double kRadToDeg {180.0 / M_PI};
const double kEarthRadius {6371000};
const double kEpsilon {std::numeric_limits<double>::epsilon()};
};
