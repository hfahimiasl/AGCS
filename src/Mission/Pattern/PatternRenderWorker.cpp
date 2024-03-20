#include "PatternRenderWorker.h"


PatternRenderWorker::PatternRenderWorker(QObject *parent) :
	QObject(parent),
	agriculture_timer(new QTimer(this)),
	photography_timer(new QTimer(this)),
	agriculture_info(new AgricultureInfo(this)),
	photography_info(new PhotographyInfo(this))
{
	QObject::connect(agriculture_timer, &QTimer::timeout,
			 this, QOverload<>::of(&PatternRenderWorker::agricultureWorker));

	QObject::connect(photography_timer, &QTimer::timeout,
			 this, QOverload<>::of(&PatternRenderWorker::photographyWorker));
}

PatternRenderWorker::~PatternRenderWorker()
{
	delete agriculture_timer;
	delete photography_timer;
	delete agriculture_info;
	delete photography_info;
}

inline quint16 PatternRenderWorker::size() const
{
	return quint16(waypoint_pair_list.size());
}

inline bool PatternRenderWorker::inProgress() const
{
	return agriculture_timer->isActive() || photography_timer->isActive();
}

inline void PatternRenderWorker::reset()
{
	agriculture_timer->stop();
	photography_timer->stop();
	sequence = 0;
}

void PatternRenderWorker::render(const QList<QPair<QGeoCoordinate, QGeoCoordinate>> &pair_list, const AgricultureInfo *info,
				 const bool &notify)
{
	Q_ASSERT(info);

	if (!pair_list.size() || inProgress()) {
		return;
	}

	waypoint_pair_list = pair_list;
	*agriculture_info = *info;
	notification = notify;

	if (notification) {
		emit renderStarted();
	}

	agriculture_timer->start(kTimeout);
}

void PatternRenderWorker::agricultureWorker()
{
	if (sequence == waypoint_pair_list.size()) {
		reset();

		if (notification) {
			emit renderCompleted();
		}

		return;
	}

	WaypointItem *waypoint_item = nullptr;
	MissionService *mission_service = MissionService::instance();

	const QPair<QGeoCoordinate, QGeoCoordinate> pair = waypoint_pair_list.value(sequence);

	waypoint_item = mission_service->getRawWaypoint();
	waypoint_item->setCoordinate(QGeoCoordinate(pair.first.latitude(), pair.first.longitude(), agriculture_info->getAltitude()));
	waypoint_item->setHoverTime(0);
	waypoint_item->setSpeed(agriculture_info->getSpeed());
	waypoint_item->setRelayActive(false);
	waypoint_item->setServoActive(true);
	waypoint_item->setServoID(agriculture_info->getNozzleChannel());
	waypoint_item->setServoPWM(agriculture_info->getNozzleMax());
	waypoint_item->setGimbalActive(false);
	waypoint_item->setCameraTriggerActive(false);
	mission_service->appendWaypoint(waypoint_item);

	waypoint_item = mission_service->getRawWaypoint();
	waypoint_item->setCoordinate(QGeoCoordinate(pair.second.latitude(), pair.second.longitude(), agriculture_info->getAltitude()));
	waypoint_item->setHoverTime(0);
	waypoint_item->setSpeed(agriculture_info->getSpeed());
	waypoint_item->setRelayActive(false);
	waypoint_item->setServoActive(true);
	waypoint_item->setServoID(agriculture_info->getNozzleChannel());
	waypoint_item->setServoPWM(agriculture_info->getNozzleMin());
	waypoint_item->setGimbalActive(false);
	waypoint_item->setCameraTriggerActive(false);
	mission_service->appendWaypoint(waypoint_item);

	sequence++;

	if (notification) {
		emit renderProgress(sequence / double(size()));
	}
}

void PatternRenderWorker::render(const QList<QPair<QGeoCoordinate, QGeoCoordinate>> &pair_list, const PhotographyInfo *info,
				 const bool &notify)
{
	Q_ASSERT(info);

	if (!pair_list.size() || inProgress()) {
		return;
	}

	waypoint_pair_list = pair_list;
	*photography_info = *info;
	notification = notify;

	if (notification) {
		emit renderStarted();
	}

	photography_timer->start(kTimeout);
}

void PatternRenderWorker::photographyWorker()
{
	if (sequence == waypoint_pair_list.size()) {
		reset();

		if (notification) {
			emit renderCompleted();
		}

		return;
	}

	WaypointItem *waypoint_item = nullptr;
	MissionService *mission_service = MissionService::instance();

	const QPair<QGeoCoordinate, QGeoCoordinate> pair = waypoint_pair_list.value(sequence);

	waypoint_item = mission_service->getRawWaypoint();
	waypoint_item->setCoordinate(QGeoCoordinate(pair.first.latitude(), pair.first.longitude(), photography_info->getAltitude()));
	waypoint_item->setHoverTime(0);
	waypoint_item->setSpeed(photography_info->getSpeed());
	waypoint_item->setRelayActive(false);
	waypoint_item->setServoActive(false);
	waypoint_item->setGimbalActive(false);
	waypoint_item->setCameraTriggerActive(true);
	waypoint_item->setCameraTriggerStatus(true);
	waypoint_item->setCameraTriggerOnce(false);
	waypoint_item->setCameraTriggerDistance(photography_info->getCameraTriggerDistance());
	mission_service->appendWaypoint(waypoint_item);

	waypoint_item = mission_service->getRawWaypoint();
	waypoint_item->setCoordinate(QGeoCoordinate(pair.second.latitude(), pair.second.longitude(), photography_info->getAltitude()));
	waypoint_item->setHoverTime(0);
	waypoint_item->setSpeed(photography_info->getSpeed());
	waypoint_item->setRelayActive(false);
	waypoint_item->setServoActive(false);
	waypoint_item->setGimbalActive(false);
	waypoint_item->setCameraTriggerActive(true);
	waypoint_item->setCameraTriggerStatus(false);
	waypoint_item->setCameraTriggerOnce(false);
	waypoint_item->setCameraTriggerDistance(0);
	mission_service->appendWaypoint(waypoint_item);

	sequence++;

	if (notification) {
		emit renderProgress(sequence / double(size()));
	}
}

void PatternRenderWorker::cancel()
{
	if (!inProgress()) {
		return;
	}

	reset();

	if (notification) {
		emit renderCanceled();
	}
}
