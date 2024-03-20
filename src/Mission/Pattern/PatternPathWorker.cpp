#include "PatternPathWorker.h"


QList<QPair<QGeoCoordinate, QGeoCoordinate>> PatternPathWorker::update(const QList<QPointF> &corner, double grid_spacing, double grid_angle)
{
	if (corner.size() < 3) {
		return QList<QPair<QGeoCoordinate, QGeoCoordinate>>();
	}

	QPolygonF polygon;

	QGeoCoordinate tangent_origin(corner.at(0).x(), corner.at(0).y());

	for (int i = 0; i < corner.size(); i++) {
		double x = 0;
		double y = 0;
		double z = 0;

		if (i == 0) {
			x = 0;
			y = 0;

		} else {
			Geographical::convertGeoToNed(QGeoCoordinate(corner.at(i).x(), corner.at(i).y()), tangent_origin, &y, &x, &z);
		}

		polygon.append(QPointF(x, y));
	}

	polygon.append(polygon.at(0));

	if (qIsNaN(grid_spacing) || grid_spacing < 0.5) {
		grid_spacing = 1000000;
	}

	if (qIsNaN(grid_angle)) {
		grid_angle = 0;
	}

	clampGridAngle90(grid_angle);

	const QRectF bounding_rect = polygon.boundingRect();
	const QPointF bounding_center = bounding_rect.center();
	const double max_width = qMax(bounding_rect.width(), bounding_rect.height()) + 2000.0;
	const double half_width = max_width * 0.5;
	double transect_x = bounding_center.x() + half_width;
	const double transect_x_min = transect_x - max_width;
	const double transect_y_top = bounding_center.y() - half_width;
	const double transect_y_bottom = bounding_center.y() + half_width;

	QList<QLineF> raw_lines;

	while (transect_x > transect_x_min) {
		raw_lines.append(QLineF(rotatePoint(QPointF(transect_x, transect_y_top), bounding_center, grid_angle),
					rotatePoint(QPointF(transect_x, transect_y_bottom), bounding_center, grid_angle)));

		transect_x -= grid_spacing;
	}

	QList<QLineF> intersect_lines;

	intersectLinesWithPolygon(raw_lines, polygon, intersect_lines);

	if (intersect_lines.size() < 2) {
		QLineF first_line = raw_lines.first();
		first_line.translate(bounding_center - first_line.pointAt(0.5));
		raw_lines.clear();
		raw_lines.append(first_line);
		intersect_lines = raw_lines;
		intersectLinesWithPolygon(raw_lines, polygon, intersect_lines);
	}

	QList<QLineF> result_lines;

	adjustLinesDirection(intersect_lines, result_lines);

	QList<QList<QGeoCoordinate>> transects;

	for (const QLineF &line : result_lines) {
		QGeoCoordinate coord;
		QList<QGeoCoordinate> transect;
		Geographical::convertNedToGeo(line.p1().y(), line.p1().x(), 0, tangent_origin, &coord);
		transect.append(coord);
		Geographical::convertNedToGeo(line.p2().y(), line.p2().x(), 0, tangent_origin, &coord);
		transect.append(coord);
		transects.append(transect);
	}

	bool reverse_vertices = false;

	for (int i = 0; i < transects.size(); i++) {
		QList<QGeoCoordinate> transectVertices = transects.value(i);

		if (reverse_vertices) {
			QList<QGeoCoordinate> reversedVertices;

			for (int j = transectVertices.size() - 1 ; j >= 0 ; j--) {
				reversedVertices.append(transectVertices.value(j));
			}

			transectVertices = reversedVertices;
			reverse_vertices = false;

		} else {
			reverse_vertices = true;
		}

		transects[i] = transectVertices;
	}

	QList<QPair<QGeoCoordinate, QGeoCoordinate>> point_list;

	for (const QList<QGeoCoordinate> &i : transects) {
		point_list.append(QPair<QGeoCoordinate, QGeoCoordinate>(i.value(0), i.value(1)));
	}

	return point_list;
}

void PatternPathWorker::clampGridAngle90(double &gridAngle)
{
	if (gridAngle > 90.0) {
		gridAngle -= 180.0;

	} else if (gridAngle < -90.0) {
		gridAngle += 180;
	}
}

QPointF PatternPathWorker::rotatePoint(const QPointF &point, const QPointF &origin, const double &angle)
{
	const double radians = -angle * Geographical::kDegToRad;

	return QPointF(((point.x() - origin.x()) * cos(radians)) - ((point.y() - origin.y()) * sin(radians)) + origin.x(),
		       ((point.x() - origin.x()) * sin(radians)) + ((point.y() - origin.y()) * cos(radians)) + origin.y());
}

void PatternPathWorker::intersectLinesWithPolygon(const QList<QLineF> &raw_lines, const QPolygonF &polygon, QList<QLineF> &result_lines)
{
	result_lines.clear();

	for (const QLineF &i : raw_lines) {
		QList<QPointF> intersections;

		for (int j = 0; j < polygon.size() - 1; j++) {
			QLineF line(polygon.value(j), polygon.value(j + 1));
			QPointF intersect_point;

			const auto intersect = i.intersect(line, &intersect_point);

			if (intersect == QLineF::BoundedIntersection) {
				if (!intersections.contains(intersect_point)) {
					intersections.append(intersect_point);
				}
			}
		}

		if (intersections.size() > 1) {
			QPointF first_point;
			QPointF second_point;
			double max_distance = 0;

			for (const QPointF &i : intersections) {
				for (const QPointF &j : intersections) {
					const double current_distance =  QLineF(i, j).length();

					if (current_distance > max_distance) {
						first_point = i;
						second_point = j;
						max_distance = current_distance;
					}
				}
			}

			result_lines.append(QLineF(first_point, second_point));
		}
	}
}

void PatternPathWorker::adjustLinesDirection(const QList<QLineF> &raw_lines, QList<QLineF> &result_lines)
{
	double first_angle = 0;

	if (raw_lines.size() > 0) {
		first_angle = raw_lines.value(0).angle();
	}

	for (const QLineF &i : raw_lines) {
		QLineF adjusted_line;

		if (fabs(i.angle() - first_angle) > 1.0) {
			adjusted_line.setP1(i.p2());
			adjusted_line.setP2(i.p1());

		} else {
			adjusted_line = i;
		}

		result_lines.append(adjusted_line);
	}
}
