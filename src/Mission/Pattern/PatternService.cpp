#include "PatternService.h"


PatternService::PatternService(QObject *parent, QQmlApplicationEngine *engine) :
	QObject(parent),
	corner_model(new QGenericListModel<PatternGroupItem>(true, this)),
	insert_point_model(new QGenericListModel<PatternGroupItem>(true, this)),
	polygon_center(new PatternSingleItem(this)),
	start_point(new PatternSingleItem(this)),
	end_point(new PatternSingleItem(this)),
	agriculture_info(new AgricultureInfo(this)),
	photography_info(new PhotographyInfo(this)),
	path_worker(new PatternPathWorker()),
	render_worker(new PatternRenderWorker(this))
{
	qmlRegisterType<PatternSingleItem>();
	qmlRegisterType<PatternGroupItem>();
	qmlRegisterType<AgricultureInfo>();
	qmlRegisterType<PhotographyInfo>();

	corner_model->setEditable(true);
	insert_point_model->setEditable(true);

	engine->rootContext()->setContextProperty("PatternCornerModel", corner_model);
	engine->rootContext()->setContextProperty("PatternInsertPointModel", insert_point_model);
	engine->rootContext()->setContextProperty("PatternService", this);

	QObject::connect(render_worker, &PatternRenderWorker::renderStarted,
			 this, &PatternService::renderStarted);

	QObject::connect(render_worker, &PatternRenderWorker::renderCanceled,
			 this, &PatternService::renderCanceled);

	QObject::connect(render_worker, &PatternRenderWorker::renderCompleted,
			 this, &PatternService::renderCompleted);

	QObject::connect(render_worker, &PatternRenderWorker::renderProgress,
			 this, &PatternService::renderProgress);
}

PatternService::~PatternService()
{
	clear();
	delete corner_model;
	delete insert_point_model;
	delete polygon_center;
	delete start_point;
	delete end_point;
	delete agriculture_info;
	delete photography_info;
	delete path_worker;
	delete render_worker;
}

PatternService *PatternService::instance(QObject *parent, QQmlApplicationEngine *engine)
{
	static PatternService self(parent, engine);
	return &self;
}

int PatternService::cornerSize() const
{
	return corner_model->rowCount();
}

QModelIndex PatternService::indexOfCorner(const quint16 &sequence)
{
	for (PatternGroupItem *i : corner_model->objects()) {
		if (i->getSequence() == sequence) {
			return corner_model->index(i);
		}
	}

	return QModelIndex();
}

void PatternService::appendCorner(const QGeoCoordinate &coordinate)
{
	PatternGroupItem *ptr = new PatternGroupItem(corner_model);
	ptr->setSequence(quint16(cornerSize()));
	ptr->setCoordinate(coordinate);
	corner_model->addObject(ptr);
	notifyAndUpdate();
}

void PatternService::insertCorner(const quint16 &sequence, const QGeoCoordinate &coordinate)
{
	if (sequence > cornerSize()) {
		qCritical() << "sequence must be less than model size";
		return;
	}

	for (PatternGroupItem *i : corner_model->objects()) {
		if (i->getSequence() >= sequence) {
			i->setSequence(i->getSequence() + 1);
			corner_model->replaceObject(corner_model->index(i), i);
		}
	}

	PatternGroupItem *ptr = new PatternGroupItem(corner_model);
	ptr->setSequence(sequence);
	ptr->setCoordinate(coordinate);
	corner_model->insertObject(sequence, ptr);
	notifyAndUpdate();
}

void PatternService::updateCorner(const quint16 &sequence, const QGeoCoordinate &coordinate)
{
	const QModelIndex index = indexOfCorner(sequence);

	if (!index.isValid()) {
		qCritical() << "sequence" << sequence << "not found";
		return;
	}

	PatternGroupItem *ptr = corner_model->object(index);
	ptr->setCoordinate(coordinate);
	corner_model->replaceObject(index, ptr);
	notifyAndUpdate();
}

void PatternService::selectCorner(const quint16 &sequence)
{
	if (indexOfCorner(sequence).isValid()) {
		emit cornerSelected(sequence);

	} else {
		qCritical() << "sequence" << sequence << "not found";
	}
}

void PatternService::removeCorner(const quint16 &sequence)
{
	const QModelIndex index = indexOfCorner(sequence);

	if (!index.isValid()) {
		qCritical() << "sequence" << sequence << "not found";
		return;
	}

	delete corner_model->takeObject(index);

	for (PatternGroupItem *i : corner_model->objects()) {
		if (i->getSequence() > sequence) {
			i->setSequence(i->getSequence() - 1);
			corner_model->replaceObject(corner_model->index(i), i);
		}
	}

	notifyAndUpdate();
}

inline int PatternService::insertPointSize() const
{
	return insert_point_model->rowCount();
}

QModelIndex PatternService::indexOfInsertPoint(const quint16 &sequence)
{
	for (PatternGroupItem *i : insert_point_model->objects()) {
		if (i->getSequence() == sequence) {
			return insert_point_model->index(i);
		}
	}

	return QModelIndex();
}

void PatternService::insertInsertPoint(const PatternGroupItem &item)
{
	PatternGroupItem *ptr = nullptr;

	const QModelIndex index = indexOfInsertPoint(item.getSequence());

	if (index.isValid()) {
		ptr = insert_point_model->object(index);

	} else {
		ptr = new PatternGroupItem(insert_point_model);
		ptr->setSequence(item.getSequence());
	}

	ptr->setCoordinate(item.getCoordinate());

	if (index.isValid()) {
		insert_point_model->replaceObject(index, ptr);

	} else {
		insert_point_model->addObject(ptr);
	}
}

void PatternService::clear()
{
	clearCorner();
	clearInsertPoint();
	notifyAndUpdate();
}

void PatternService::clearCorner()
{
	for (PatternGroupItem *i : corner_model->objects()) {
		delete corner_model->takeObject(corner_model->index(i));
	}
}

void PatternService::clearInsertPoint()
{
	for (PatternGroupItem *i : insert_point_model->objects()) {
		delete insert_point_model->takeObject(insert_point_model->index(i));
	}
}

PatternGroupItem *PatternService::getCornerItem(const quint16 &sequence)
{
	const QModelIndex index = indexOfCorner(sequence);

	if (index.isValid()) {
		return corner_model->object(index);
	}

	return nullptr;
}

PatternSingleItem *PatternService::getPolygonCenter() const
{
	return polygon_center;
}

PatternSingleItem *PatternService::getStartPoint() const
{
	return start_point;
}

PatternSingleItem *PatternService::getEndPoint() const
{
	return end_point;
}

AgricultureInfo *PatternService::getAgricultureInfo() const
{
	return agriculture_info;
}

PhotographyInfo *PatternService::getPhotographyInfo() const
{
	return photography_info;
}

QVariantList PatternService::getPolygonPath()
{
	QVariantList list;

	for (PatternGroupItem *i : corner_model->objects()) {
		list.append(QVariant::fromValue(i->getCoordinate()));
	}

	return list;
}

QVariantList PatternService::getPolylinePath()
{
	QVariantList list;

	const MissionItem *last_visual_item = MissionService::instance()->getLastVisualItem();

	if (last_visual_item) {
		list.append(QVariant::fromValue(last_visual_item->getCoordinate()));
	}

	for (const QPair<QGeoCoordinate, QGeoCoordinate> &i : waypoint_pair_list) {
		list.append(QVariant::fromValue(i.first));
		list.append(QVariant::fromValue(i.second));
	}

	return list;
}

void PatternService::moveTo(const QGeoCoordinate &coordinate)
{
	const QPointF delta(coordinate.latitude() - polygon_center->getCoordinate().latitude(),
			    coordinate.longitude() - polygon_center->getCoordinate().longitude());

	for (PatternGroupItem *i : corner_model->objects()) {
		i->setCoordinate(QGeoCoordinate(i->getCoordinate().latitude() + delta.x(), i->getCoordinate().longitude() + delta.y()));
		corner_model->replaceObject(corner_model->index(i), i);
	}

	notifyAndUpdate();
}

void PatternService::notifyAndUpdate()
{
	const int corner_size = cornerSize();

	if (corner_size < insertPointSize()) {
		clearInsertPoint();
	}

	QPolygonF polygon;

	QList<QGeoCoordinate> line_point;

	for (PatternGroupItem *i : corner_model->objects()) {
		line_point.append(i->getCoordinate());

		if (line_point.size() == 2) {
			QLineF line;
			line.setP1(QPointF(line_point.value(0).latitude(), line_point.value(0).longitude()));
			line.setP2(QPointF(line_point.value(1).latitude(), line_point.value(1).longitude()));

			PatternGroupItem item;
			item.setSequence(i->getSequence() - 1);
			item.setCoordinate(QGeoCoordinate(line.center().x(), line.center().y()));
			insertInsertPoint(item);

			line_point.removeFirst();
		}

		if (corner_size > 2 && i->getSequence() == corner_size - 1) {
			line_point.append(getCornerItem(0)->getCoordinate());

			QLineF line;
			line.setP1(QPointF(line_point.value(0).latitude(), line_point.value(0).longitude()));
			line.setP2(QPointF(line_point.value(1).latitude(), line_point.value(1).longitude()));

			PatternGroupItem item;
			item.setSequence(quint16(corner_size - 1));
			item.setCoordinate(QGeoCoordinate(line.center().x(), line.center().y()));
			insertInsertPoint(item);
		}

		polygon.append(QPointF(i->getCoordinate().latitude(), i->getCoordinate().longitude()));
	}

	polygon_center->setVisible(corner_size ? true : false);
	const QPointF bounding_center = polygon.boundingRect().center();
	polygon_center->setCoordinate(QGeoCoordinate(bounding_center.x(), bounding_center.y()));

	emit polygonPathChanged();

	buildPath();
}

void PatternService::setGridSpacing(const double &spacing)
{
	if (!qFuzzyCompare(grid_spacing, spacing)) {
		grid_spacing = spacing;
		buildPath();
	}
}

void PatternService::setGridAngle(const double &angle)
{
	if (!qFuzzyCompare(grid_angle, angle)) {
		grid_angle = angle;
		buildPath();
	}
}

void PatternService::buildPath()
{
	QList<QPointF> list;

	for (PatternGroupItem *i : corner_model->objects()) {
		list.append(QPointF(i->getCoordinate().latitude(), i->getCoordinate().longitude()));
	}

	waypoint_pair_list = path_worker->update(list, grid_spacing, grid_angle);

	if (waypoint_pair_list.size()) {
		start_point->setVisible(true);
		start_point->setCoordinate(waypoint_pair_list.first().first);
		end_point->setVisible(true);
		end_point->setCoordinate(waypoint_pair_list.last().second);

	} else {
		start_point->setVisible(false);
		end_point->setVisible(false);
	}

	emit polylinePathChanged();
}

void PatternService::updateAgricultureInfo()
{
	setGridSpacing(agriculture_info->getBoomLength());
	setGridAngle(agriculture_info->getAngle());
}

void PatternService::renderAgriculturePattern()
{
	MissionService *mission_service = MissionService::instance();

	if (!mission_service->isTakeoffExist()) {
		TakeoffItem *takeoff_item = mission_service->getRawTakeoff();
		takeoff_item->setCoordinate(QGeoCoordinate(waypoint_pair_list.value(0).first.latitude(),
					    waypoint_pair_list.value(0).first.longitude(),
					    agriculture_info->getAltitude()));
		mission_service->appendTakeoff(takeoff_item);
	}

	render_worker->render(waypoint_pair_list, agriculture_info, waypoint_pair_list.size() > 10);
}

double PatternService::photographyCalculation(const double &altitude, const double &sensor_size, const double &focal_length,
		const double &overlap) const
{
	return (1.0 - (overlap / 100.0)) * altitude * sensor_size / focal_length;
}

void PatternService::updatePhotographyInfo()
{
	setGridSpacing(photography_info->getSpacing());
	setGridAngle(photography_info->getAngle());
}

void PatternService::renderPhotographyPattern()
{
	MissionService *mission_service = MissionService::instance();

	if (!mission_service->isTakeoffExist()) {
		TakeoffItem *takeoff_item = mission_service->getRawTakeoff();
		takeoff_item->setCoordinate(QGeoCoordinate(waypoint_pair_list.value(0).first.latitude(),
					    waypoint_pair_list.value(0).first.longitude(),
					    photography_info->getAltitude()));
		mission_service->appendTakeoff(takeoff_item);
	}

	render_worker->render(waypoint_pair_list, photography_info, waypoint_pair_list.size() > 10);
}

void PatternService::cancelRenderProcess() const
{
	render_worker->cancel();
}
