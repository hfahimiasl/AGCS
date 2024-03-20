#pragma once

#include <QObject>
#include <QGeoCoordinate>
#include <QPolygonF>
#include <QLineF>

#include "src/System/Geographical.h"


class PatternPathWorker
{
public:
	QList<QPair<QGeoCoordinate, QGeoCoordinate>> update(const QList<QPointF> &, double, double);

private:
	void clampGridAngle90(double &);
	QPointF rotatePoint(const QPointF &, const QPointF &, const double &);
	void intersectLinesWithPolygon(const QList<QLineF> &, const QPolygonF &, QList<QLineF> &);
	void adjustLinesDirection(const QList<QLineF> &, QList<QLineF> &);
};
