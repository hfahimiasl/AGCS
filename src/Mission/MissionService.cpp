#include "MissionService.h"


MissionService::MissionService(QObject *parent, QQmlApplicationEngine *engine) :
	QObject(parent),
	mission_item_model(new QGenericListModel<MissionItem>(true, this)),
	takeoff_item(new TakeoffItem(this)),
	waypoint_item(new WaypointItem(this)),
	land_item(new LandItem(this))
{
	qmlRegisterType<MissionItem>();
	qmlRegisterType<TakeoffItem>();
	qmlRegisterType<WaypointItem>();
	qmlRegisterType<LandItem>();

	mission_item_model->setEditable(true);

	engine->rootContext()->setContextProperty("MissionItemModel", mission_item_model);
	engine->rootContext()->setContextProperty("MissionService", this);
}

MissionService::~MissionService()
{
	clear();
	delete mission_item_model;
	delete takeoff_item;
	delete waypoint_item;
	delete land_item;
}

MissionService *MissionService::instance(QObject *parent, QQmlApplicationEngine *engine)
{
	static MissionService self(parent, engine);
	return &self;
}

int MissionService::size() const
{
	return mission_item_model->rowCount();
}

QModelIndex MissionService::indexOf(const quint16 &sequence)
{
	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() == sequence) {
			return mission_item_model->index(i);
		}
	}

	return QModelIndex();
}

QModelIndex MissionService::indexOf(const MAV_CMD &command)
{
	for (MissionItem *i : mission_item_model->objects()) {
		if (MAV_CMD(i->getCommand()) == command) {
			return mission_item_model->index(i);
		}
	}

	return QModelIndex();
}

bool MissionService::isExist(const quint16 &sequence)
{
	return indexOf(sequence).isValid();
}

void MissionService::insert(MissionItem *other)
{
	MissionItem *item = nullptr;

	const QModelIndex index = indexOf(other->getSequence());

	if (index.isValid()) {
		item = mission_item_model->object(index);

	} else {
		item = new MissionItem(mission_item_model);
		item->setSequence(other->getSequence());
	}

	bool visible = MissionService::kVisibleCommands.contains(MAV_CMD(other->getCommand()));

	if (other->getSequence() == 0 && qFuzzyCompare(other->getCoordinate().latitude(), 0)
	    && qFuzzyCompare(other->getCoordinate().longitude(), 0)) {
		visible = false;
	}

	item->setCoordinate(other->getCoordinate());
	item->setCommand(other->getCommand());
	item->setFrame(other->getFrame());
	item->setCurrent(other->getCurrent());
	item->setAutoContinue(other->getAutoContinue());
	item->setType(other->getType());
	item->setParam1(other->getParam1());
	item->setParam2(other->getParam2());
	item->setParam3(other->getParam3());
	item->setParam4(other->getParam4());
	item->setVisible(visible);

	updateLabel(item);

	if (index.isValid()) {
		mission_item_model->replaceObject(index, item);

	} else {
		mission_item_model->addObject(item);
	}

	notifyChanges();

	validationTakeoffCoordinate();
}

void MissionService::clear()
{
	for (MissionItem *i : mission_item_model->objects()) {
		delete mission_item_model->takeObject(mission_item_model->index(i));
	}

	notifyChanges();
}

MissionItem *MissionService::get(const quint16 &sequence)
{
	const QModelIndex index = indexOf(sequence);

	if (index.isValid()) {
		return mission_item_model->object(index);
	}

	return nullptr;
}

MissionItem *MissionService::getLastVisualItem()
{
	QList<MissionItem *> list = mission_item_model->objects();

	if (list.size()) {
		std::reverse(list.begin(), list.end());

		for (MissionItem *i : list) {
			if (kVisibleCommands.contains(MAV_CMD(i->getCommand()))) {
				return i;
			}
		}
	}

	return nullptr;
}

bool MissionService::remove(const quint16 &sequence, const quint16 &step)
{
	QList<quint16> sequence_list;

	for (quint16 i = sequence ; i < sequence + step ; i++) {
		sequence_list.append(i);
	}

	QList<QModelIndex> index_list;

	for (MissionItem *i : mission_item_model->objects()) {
		if (sequence_list.contains(i->getSequence())) {
			const QModelIndex index = mission_item_model->index(i);

			if (index.isValid()) {
				index_list.append(index);

			} else {
				qCritical() << "invalid index";
				return false;
			}
		}
	}

	if (index_list.size() != sequence_list.size()) {
		qCritical() << "mismatch of lists";
		return false;
	}

	for (const quint16 &i : sequence_list) {
		delete mission_item_model->takeObject(indexOf(i));
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() >= sequence + step) {
			i->setSequence(i->getSequence() - step);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	notifyChanges();

	return true;
}

TakeoffItem *MissionService::getRawTakeoff()
{
	takeoff_item->reset();
	return takeoff_item;
}

TakeoffItem *MissionService::getTakeoff()
{
	if (isTakeoffExist()) {
		takeoff_item->setCoordinate(QGeoCoordinate(get(0)->getCoordinate().latitude(), get(0)->getCoordinate().longitude(),
					    get(1)->getCoordinate().altitude()));
		return takeoff_item;
	}

	return nullptr;
}

void MissionService::appendTakeoff(TakeoffItem *takeoff_item)
{
	Q_ASSERT(takeoff_item);

	if (isTakeoffExist()) {
		qCritical() << "takeoff already exist";
		return;
	}

	if (size()) {
		qt_assert("internal error", __FILE__, __LINE__);
	}

	appendTakeoffPrivate(takeoff_item);
}

void MissionService::appendTakeoffPrivate(const TakeoffItem *takeoff_item)
{
	updateTakeoffPrivate(takeoff_item);
}

void MissionService::updateTakeoff(TakeoffItem *takeoff_item)
{
	Q_ASSERT(takeoff_item);

	if (!isTakeoffExist()) {
		qCritical() << "takeoff not found";
		return;
	}

	updateTakeoffPrivate(takeoff_item);
}

void MissionService::updateTakeoffPrivate(const TakeoffItem *takeoff_item)
{
	MissionItem mission_item;

	mission_item.setSequence(0);
	mission_item.setCoordinate(takeoff_item->getCoordinate());
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_WAYPOINT));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(0);
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(0);
	mission_item.setVisible(true);
	insert(&mission_item);

	mission_item.setSequence(1);
	mission_item.setCoordinate(QGeoCoordinate(0, 0, takeoff_item->getCoordinate().altitude()));
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_TAKEOFF));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL_RELATIVE_ALT));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(0);
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(0);
	mission_item.setVisible(false);
	insert(&mission_item);
}

bool MissionService::isTakeoffExist()
{
	return isExist(0) && isExist(1) && indexOf(MAV_CMD::MAV_CMD_NAV_TAKEOFF).isValid();
}

WaypointItem *MissionService::getRawWaypoint()
{
	waypoint_item->reset();
	return waypoint_item;
}

WaypointItem *MissionService::getWaypoint(const quint16 &sequence)
{
	QGeoCoordinate coordinate;
	double hover_time = qQNaN();
	double speed = MissionService::kDefaultSpeed;
	bool relay_active = false;
	quint8 relay_id = 1;
	bool relay_status = false;
	bool servo_active = false;
	quint8 servo_id = 1;
	quint16 servo_pwm = 1500;
	bool gimbal_active = false;
	double gimbal_tilt = 0;
	double gimbal_pan = 0;
	bool camera_trigger_active = false;
	bool camera_trigger_status = false;
	bool camera_trigger_once = false;
	double camera_trigger_distance = 0;

	bool found = false;

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() == 0 || i->getSequence() == 1) {
			continue;
		}

		if (i->getSequence() == sequence) {
			if (MAV_CMD(i->getCommand()) == MAV_CMD::MAV_CMD_NAV_WAYPOINT) {
				coordinate = i->getCoordinate();
				hover_time = i->getParam1();
				found = true;
				continue;

			} else {
				qCritical() << "sequence" << sequence << "is not a waypoint";
				break;
			}
		}

		if (!found) {
			continue;
		}

		if (kVisibleCommands.contains(MAV_CMD(i->getCommand()))) {
			break;
		}

		switch (MAV_CMD(i->getCommand())) {
		case MAV_CMD::MAV_CMD_DO_CHANGE_SPEED:
			speed = i->getParam2();
			break;

		case MAV_CMD::MAV_CMD_DO_SET_RELAY:
			relay_active = true;
			relay_id = quint8(i->getParam1());
			relay_status = qFuzzyCompare(i->getParam2(), 1);
			break;

		case MAV_CMD::MAV_CMD_DO_SET_SERVO:
			servo_active = true;
			servo_id = quint8(i->getParam1());
			servo_pwm = quint16(i->getParam2());
			break;

		case MAV_CMD::MAV_CMD_DO_MOUNT_CONTROL:
			gimbal_active = true;
			gimbal_tilt = i->getParam1();
			gimbal_pan = i->getParam3();
			break;

		case MAV_CMD::MAV_CMD_DO_SET_CAM_TRIGG_DIST:
			camera_trigger_active = true;
			camera_trigger_distance = i->getParam1();
			camera_trigger_once = qFuzzyCompare(camera_trigger_distance, 0) && qFuzzyCompare(i->getParam3(), 1);
			camera_trigger_status = camera_trigger_once || !qFuzzyCompare(camera_trigger_distance, 0);
			break;

		default:
			break;
		}
	}

	if (!found) {
		return nullptr;
	}

	waypoint_item->setCoordinate(coordinate);
	waypoint_item->setHoverTime(hover_time);
	waypoint_item->setSpeed(speed);
	waypoint_item->setRelayActive(relay_active);
	waypoint_item->setRelayID(relay_id);
	waypoint_item->setRelayStatus(relay_status);
	waypoint_item->setServoActive(servo_active);
	waypoint_item->setServoID(servo_id);
	waypoint_item->setServoPWM(servo_pwm);
	waypoint_item->setGimbalActive(gimbal_active);
	waypoint_item->setGimbalTilt(gimbal_tilt);
	waypoint_item->setGimbalPan(gimbal_pan);
	waypoint_item->setCameraTriggerActive(camera_trigger_active);
	waypoint_item->setCameraTriggerStatus(camera_trigger_status);
	waypoint_item->setCameraTriggerOnce(camera_trigger_once);
	waypoint_item->setCameraTriggerDistance(camera_trigger_distance);

	return waypoint_item;
}

bool MissionService::removeWaypoint(const quint16 &sequence)
{
	quint16 step = 1;

	bool found = false;

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() == 0 || i->getSequence() == 1) {
			continue;
		}

		if (i->getSequence() == sequence) {
			if (MAV_CMD(i->getCommand()) == MAV_CMD::MAV_CMD_NAV_WAYPOINT) {
				found = true;
				continue;

			} else {
				qCritical() << "sequence" << sequence << "is not a waypoint";
				break;
			}
		}

		if (!found) {
			continue;
		}

		const MAV_CMD command = MAV_CMD(i->getCommand());

		if (kVisibleCommands.contains(command) || command == MAV_CMD::MAV_CMD_NAV_RETURN_TO_LAUNCH) {
			break;

		} else {
			step++;
		}
	}

	if (!found) {
		return false;
	}

	return remove(sequence, step);
}

void MissionService::appendWaypoint(WaypointItem *waypoint_item)
{
	Q_ASSERT(waypoint_item);

	if (!isTakeoffExist()) {
		qCritical() << "takeoff not found";
		return;
	}

	if (isLandExist()) {
		qCritical() << "can not append waypoint after land";
		return;
	}

	if (isRTLExist()) {
		qCritical() << "can not append waypoint after RTL";
		return;
	}

	appendWaypointPrivate(waypoint_item);
}

void MissionService::appendWaypointPrivate(const WaypointItem *waypoint_item)
{
	MissionItem mission_item;
	mission_item.setSequence(quint16(size()));
	mission_item.setCoordinate(waypoint_item->getCoordinate());
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_WAYPOINT));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL_RELATIVE_ALT));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(waypoint_item->getHoverTime());
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(0);
	mission_item.setVisible(true);
	insert(&mission_item);

	updateCameraTriggerItem(waypoint_item, nullptr, mission_item.getSequence());
	updateGimbalItem(waypoint_item, nullptr, mission_item.getSequence());
	updateServoItem(waypoint_item, nullptr, mission_item.getSequence());
	updateRelayItem(waypoint_item, nullptr, mission_item.getSequence());
	updateSpeedItem(waypoint_item, nullptr, mission_item.getSequence());
}

void MissionService::updateWaypoint(WaypointItem *waypoint_item, const quint16 &sequence)
{
	Q_ASSERT(waypoint_item);

	if (!isTakeoffExist()) {
		qCritical() << "takeoff not found";
		return;
	}

	if (sequence == 0 || sequence == 1) {
		qCritical() << "sequence" << sequence << "is not a waypoint";
		return;
	}

	updateWaypointPrivate(waypoint_item, sequence);
}

void MissionService::updateWaypointPrivate(const WaypointItem *waypoint_item, const quint16 &sequence)
{
	MissionItem *main_item = nullptr;
	MissionItem *speed_item = nullptr;
	MissionItem *relay_item = nullptr;
	MissionItem *servo_item = nullptr;
	MissionItem *gimbal_item = nullptr;
	MissionItem *camera_trigger_item = nullptr;

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() == sequence) {
			if (MAV_CMD(i->getCommand()) == MAV_CMD::MAV_CMD_NAV_WAYPOINT) {
				main_item = i;
				continue;

			} else {
				qCritical() << "sequence" << sequence << "is not a waypoint";
				return;
			}
		}

		if (!main_item) {
			continue;
		}

		if (kVisibleCommands.contains(MAV_CMD(i->getCommand()))) {
			break;
		}

		switch (MAV_CMD(i->getCommand())) {
		case MAV_CMD::MAV_CMD_DO_CHANGE_SPEED:
			speed_item = i;
			break;

		case MAV_CMD::MAV_CMD_DO_SET_RELAY:
			relay_item = i;
			break;

		case MAV_CMD::MAV_CMD_DO_SET_SERVO:
			servo_item = i;
			break;

		case MAV_CMD::MAV_CMD_DO_MOUNT_CONTROL:
			gimbal_item = i;
			break;

		case MAV_CMD::MAV_CMD_DO_SET_CAM_TRIGG_DIST:
			camera_trigger_item = i;
			break;

		default:
			break;
		}
	}

	Q_ASSERT(main_item);

	MissionItem mission_item;
	mission_item.setSequence(main_item->getSequence());
	mission_item.setCoordinate(waypoint_item->getCoordinate());
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_WAYPOINT));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL_RELATIVE_ALT));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(waypoint_item->getHoverTime());
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(0);
	mission_item.setVisible(true);
	insert(&mission_item);

	updateCameraTriggerItem(waypoint_item, camera_trigger_item, mission_item.getSequence());
	updateGimbalItem(waypoint_item, gimbal_item, mission_item.getSequence());
	updateServoItem(waypoint_item, servo_item, mission_item.getSequence());
	updateRelayItem(waypoint_item, relay_item, mission_item.getSequence());
	updateSpeedItem(waypoint_item, speed_item, mission_item.getSequence());
}

void MissionService::updateSpeedItem(const WaypointItem *waypoint_item, MissionItem *speed_item, const quint16 &parent_sequence)
{
	if (qFuzzyCompare(waypoint_item->getSpeed(), MissionService::kDefaultSpeed)) {
		if (speed_item) {
			remove(speed_item->getSequence(), 1);
		}

		return;
	}

	if (speed_item) {
		speed_item->setParam2(waypoint_item->getSpeed());
		insert(speed_item);
		return;
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() > parent_sequence) {
			i->setSequence(i->getSequence() + 1);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	speed_item = new MissionItem(mission_item_model);

	speed_item->setSequence(parent_sequence + 1);
	speed_item->setCoordinate(QGeoCoordinate(0, 0, 0));
	speed_item->setCommand(quint16(MAV_CMD::MAV_CMD_DO_CHANGE_SPEED));
	speed_item->setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	speed_item->setCurrent(0);
	speed_item->setAutoContinue(1);
	speed_item->setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	speed_item->setParam1(1);
	speed_item->setParam2(waypoint_item->getSpeed());
	speed_item->setParam3(-1);
	speed_item->setParam4(0);
	speed_item->setVisible(false);

	updateLabel(speed_item);

	mission_item_model->insertObject(speed_item->getSequence(), speed_item);
}

void MissionService::updateRelayItem(const WaypointItem *waypoint_item, MissionItem *relay_item, const quint16 &parent_sequence)
{
	if (!waypoint_item->getRelayActive()) {
		if (relay_item) {
			remove(relay_item->getSequence(), 1);
		}

		return;
	}

	if (relay_item) {
		relay_item->setParam1(waypoint_item->getRelayID());
		relay_item->setParam2(waypoint_item->getRelayStatus());
		insert(relay_item);
		return;
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() > parent_sequence) {
			i->setSequence(i->getSequence() + 1);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	relay_item = new MissionItem(mission_item_model);

	relay_item->setSequence(parent_sequence + 1);
	relay_item->setCoordinate(QGeoCoordinate(0, 0, 0));
	relay_item->setCommand(quint16(MAV_CMD::MAV_CMD_DO_SET_RELAY));
	relay_item->setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	relay_item->setCurrent(0);
	relay_item->setAutoContinue(1);
	relay_item->setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	relay_item->setParam1(waypoint_item->getRelayID());
	relay_item->setParam2(waypoint_item->getRelayStatus());
	relay_item->setParam3(0);
	relay_item->setParam4(0);
	relay_item->setVisible(false);

	updateLabel(relay_item);

	mission_item_model->insertObject(relay_item->getSequence(), relay_item);
}

void MissionService::updateServoItem(const WaypointItem *waypoint_item, MissionItem *servo_item, const quint16 &parent_sequence)
{
	if (!waypoint_item->getServoActive()) {
		if (servo_item) {
			remove(servo_item->getSequence(), 1);
		}

		return;
	}

	if (servo_item) {
		servo_item->setParam1(waypoint_item->getServoID());
		servo_item->setParam2(waypoint_item->getServoPWM());
		insert(servo_item);
		return;
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() > parent_sequence) {
			i->setSequence(i->getSequence() + 1);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	servo_item = new MissionItem(mission_item_model);

	servo_item->setSequence(parent_sequence + 1);
	servo_item->setCoordinate(QGeoCoordinate(0, 0, 0));
	servo_item->setCommand(quint16(MAV_CMD::MAV_CMD_DO_SET_SERVO));
	servo_item->setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	servo_item->setCurrent(0);
	servo_item->setAutoContinue(1);
	servo_item->setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	servo_item->setParam1(waypoint_item->getServoID());
	servo_item->setParam2(waypoint_item->getServoPWM());
	servo_item->setParam3(0);
	servo_item->setParam4(0);
	servo_item->setVisible(false);

	updateLabel(servo_item);

	mission_item_model->insertObject(servo_item->getSequence(), servo_item);
}

void MissionService::updateGimbalItem(const WaypointItem *waypoint_item, MissionItem *gimbal_item, const quint16 &parent_sequence)
{
	if (!waypoint_item->getGimbalActive()) {
		if (gimbal_item) {
			remove(gimbal_item->getSequence(), 1);
		}

		return;
	}

	if (gimbal_item) {
		gimbal_item->setParam1(waypoint_item->getGimbalTilt());
		gimbal_item->setParam3(waypoint_item->getGimbalPan());
		insert(gimbal_item);
		return;
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() > parent_sequence) {
			i->setSequence(i->getSequence() + 1);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	gimbal_item = new MissionItem(mission_item_model);

	gimbal_item->setSequence(parent_sequence + 1);
	gimbal_item->setCoordinate(QGeoCoordinate(0, 0, 0));
	gimbal_item->setCommand(quint16(MAV_CMD::MAV_CMD_DO_MOUNT_CONTROL));
	gimbal_item->setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	gimbal_item->setCurrent(0);
	gimbal_item->setAutoContinue(1);
	gimbal_item->setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	gimbal_item->setParam1(waypoint_item->getGimbalTilt());
	gimbal_item->setParam2(0);
	gimbal_item->setParam3(waypoint_item->getGimbalPan());
	gimbal_item->setParam4(0);
	gimbal_item->setVisible(false);

	updateLabel(gimbal_item);

	mission_item_model->insertObject(gimbal_item->getSequence(), gimbal_item);
}

void MissionService::updateCameraTriggerItem(const WaypointItem *waypoint_item, MissionItem *camera_trigger_item,
		const quint16 &parent_sequence)
{
	if (!waypoint_item->getCameraTriggerActive()) {
		if (camera_trigger_item) {
			remove(camera_trigger_item->getSequence(), 1);
		}

		return;
	}

	if (camera_trigger_item) {
		camera_trigger_item->setParam1(waypoint_item->getCameraTriggerStatus()
					       && !waypoint_item->getCameraTriggerOnce() ? waypoint_item->getCameraTriggerDistance() : 0);
		camera_trigger_item->setParam3(waypoint_item->getCameraTriggerStatus() ? 1 : 0);
		insert(camera_trigger_item);
		return;
	}

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getSequence() > parent_sequence) {
			i->setSequence(i->getSequence() + 1);
			updateLabel(i);
			mission_item_model->replaceObject(mission_item_model->index(i), i);
		}
	}

	camera_trigger_item = new MissionItem(mission_item_model);

	camera_trigger_item->setSequence(parent_sequence + 1);
	camera_trigger_item->setCoordinate(QGeoCoordinate(0, 0, 0));
	camera_trigger_item->setCommand(quint16(MAV_CMD::MAV_CMD_DO_SET_CAM_TRIGG_DIST));
	camera_trigger_item->setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	camera_trigger_item->setCurrent(0);
	camera_trigger_item->setAutoContinue(1);
	camera_trigger_item->setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	camera_trigger_item->setParam1(waypoint_item->getCameraTriggerStatus()
				       && !waypoint_item->getCameraTriggerOnce() ? waypoint_item->getCameraTriggerDistance() : 0);
	camera_trigger_item->setParam2(0);
	camera_trigger_item->setParam3(waypoint_item->getCameraTriggerStatus() ? 1 : 0);
	camera_trigger_item->setParam4(0);
	camera_trigger_item->setVisible(false);

	updateLabel(camera_trigger_item);

	mission_item_model->insertObject(camera_trigger_item->getSequence(), camera_trigger_item);
}

LandItem *MissionService::getRawLand()
{
	land_item->reset();
	return land_item;
}

void MissionService::appendLand(LandItem *land_item)
{
	Q_ASSERT(land_item);

	if (!isTakeoffExist()) {
		qCritical() << "takeoff not found";
		return;
	}

	if (isLandExist()) {
		qCritical() << "land already exist";
		return;
	}

	if (isRTLExist()) {
		qCritical() << "can not append land after RTL";
		return;
	}

	appendLandPrivate(land_item);
}

void MissionService::appendLandPrivate(const LandItem *land_item)
{
	MissionItem mission_item;
	mission_item.setSequence(quint16(size()));
	mission_item.setCoordinate(QGeoCoordinate(land_item->getCoordinate().latitude(), land_item->getCoordinate().longitude(), 0));
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_LAND));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL_RELATIVE_ALT));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(0);
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(1);
	mission_item.setVisible(true);
	insert(&mission_item);
}

bool MissionService::isLandExist()
{
	return indexOf(MAV_CMD::MAV_CMD_NAV_LAND).isValid();
}

bool MissionService::removeLand()
{
	const QModelIndex index = indexOf(MAV_CMD::MAV_CMD_NAV_LAND);

	if (index.isValid()) {
		return remove(mission_item_model->object(index)->getSequence(), 1);
	}

	return false;
}

void MissionService::appendRTL()
{
	if (!isTakeoffExist()) {
		qCritical() << "takeoff not found";
		return;
	}

	if (isLandExist()) {
		qCritical() << "can not append RTL after land";
		return;
	}

	if (isRTLExist()) {
		qCritical() << "RTL already exist";
		return;
	}

	appendRTLPrivate();
}

void MissionService::appendRTLPrivate()
{
	MissionItem mission_item;
	mission_item.setSequence(quint16(size()));
	mission_item.setCoordinate(QGeoCoordinate(0, 0, 0));
	mission_item.setCommand(quint16(MAV_CMD::MAV_CMD_NAV_RETURN_TO_LAUNCH));
	mission_item.setFrame(quint8(MAV_FRAME::MAV_FRAME_GLOBAL));
	mission_item.setCurrent(0);
	mission_item.setAutoContinue(1);
	mission_item.setType(quint8(MAV_MISSION_TYPE::MAV_MISSION_TYPE_MISSION));
	mission_item.setParam1(0);
	mission_item.setParam2(0);
	mission_item.setParam3(0);
	mission_item.setParam4(0);
	mission_item.setVisible(false);
	insert(&mission_item);
}

bool MissionService::isRTLExist()
{
	return indexOf(MAV_CMD::MAV_CMD_NAV_RETURN_TO_LAUNCH).isValid();
}

bool MissionService::removeRTL()
{
	const QModelIndex index = indexOf(MAV_CMD::MAV_CMD_NAV_RETURN_TO_LAUNCH);

	if (index.isValid()) {
		return remove(mission_item_model->object(index)->getSequence(), 1);
	}

	return false;
}

void MissionService::select(const quint16 &sequence)
{
	const QModelIndex index = indexOf(sequence);

	if (!index.isValid()) {
		qCritical() << "sequence" << sequence << "not found";
		return;
	}

	const MissionItem *mission_item = mission_item_model->object(index);

	switch (MAV_CMD(mission_item->getCommand())) {
	case MAV_CMD::MAV_CMD_NAV_WAYPOINT:
		if (mission_item->getSequence() == 0) {
			emit takeoffSelected();
			return;
		}

		emit waypointSelected(sequence);
		break;

	case MAV_CMD::MAV_CMD_NAV_LAND:
		emit landSelected();
		break;

	default:
		qCritical() << "sequence" << sequence << "not supported";
		break;
	}
}

QVariantList MissionService::getPath()
{
	QVariantList list;

	for (MissionItem *i : mission_item_model->objects()) {
		if (i->getVisible()) {
			list.append(QVariant::fromValue(i->getCoordinate()));
		}
	}

	if (isTakeoffExist() && isRTLExist()) {
		list.append(list.first());
	}

	return list;
}

void MissionService::updateLabel(MissionItem *mission_item)
{
	Q_ASSERT(mission_item);

	QString label("");

	bool unicode_label = false;

	if (mission_item->getSequence() == 0) {
		label = "\uf5b0";
		unicode_label = true;

	} else if (MAV_CMD(mission_item->getCommand()) == MAV_CMD::MAV_CMD_NAV_LAND) {
		label = "\uf5af";
		unicode_label = true;
	}

	mission_item->setLabel(label);
	mission_item->setUnicodeLabel(unicode_label);
}

void MissionService::notifyChanges()
{
	emit takeoffExistChanged();
	emit landExistChanged();
	emit rtlExistChanged();
	emit pathChanged();
}

void MissionService::validationTakeoffCoordinate()
{
	if (size() == 2) {
		TakeoffItem *item = getTakeoff();

		if (item) {
			if (qFuzzyCompare(item->getCoordinate().latitude(), 0.0)
			    && qFuzzyCompare(item->getCoordinate().longitude(), 0.0)) {
				toast.warn(QObject::tr("عدم وجود سیگنال GPS برای تخمین موقعیت برخاست"), 5000);
			}

		} else {
			qCritical() << "takeoff not found";
			toast.warn(QObject::tr("عدم وجود نقطه برخاست"), 5000);
			toast.warn(QObject::tr("از درستی ماموریت خود اطمینان حاصل کنید"), 5000);
		}
	}
}

void MissionService::print()
{
	qInfo("-----------------------------------------------------------------------------------------------------------------------------------------------");
	qInfo("Mission Service");
	qInfo("-----------------------------------------------------------------------------------------------------------------------------------------------");
	qInfo("Sequence   Latitude      Longitude     Altitude   Command   Frame   Current   AutoContinue   Type   Param1   Param2   Param3   Param4   visible");
	qInfo("-----------------------------------------------------------------------------------------------------------------------------------------------");

	for (MissionItem *i : mission_item_model->objects()) {
		QString sequence = QString("%1").arg(i->getSequence());
		sequence.resize(11, QChar(' '));

		QString latitude = QString("%1").arg(i->getCoordinate().latitude(), 0, 'f', 7);
		latitude.resize(14, QChar(' '));

		QString longitude = QString("%1").arg(i->getCoordinate().longitude(), 0, 'f', 7);
		longitude.resize(14, QChar(' '));

		QString altitude = QString("%1").arg(i->getCoordinate().altitude(), 0, 'f', 2);
		altitude.resize(11, QChar(' '));

		QString command = QString("%1").arg(i->getCommand());
		command.resize(10, QChar(' '));

		QString frame = QString("%1").arg(i->getFrame());
		frame.resize(8, QChar(' '));

		QString current = QString("%1").arg(i->getCurrent());
		current.resize(10, QChar(' '));

		QString auto_continue = QString("%1").arg(i->getAutoContinue());
		auto_continue.resize(15, QChar(' '));

		QString type = QString("%1").arg(i->getType());
		type.resize(7, QChar(' '));

		QString param1 = QString("%1").arg(i->getParam1(), 0, 'f', 2);
		param1.resize(9, QChar(' '));

		QString param2 = QString("%1").arg(i->getParam2(), 0, 'f', 2);
		param2.resize(9, QChar(' '));

		QString param3 = QString("%1").arg(i->getParam3(), 0, 'f', 2);
		param3.resize(9, QChar(' '));

		QString param4 = QString("%1").arg(i->getParam4(), 0, 'f', 2);
		param4.resize(9, QChar(' '));

		QString visible = QString("%1").arg(i->getVisible() ? "true" : "false");
		visible.resize(7, QChar(' '));

		qInfo("%s", qPrintable(sequence
				       + latitude
				       + longitude
				       + altitude
				       + command
				       + frame
				       + current
				       + auto_continue
				       + type
				       + param1
				       + param2
				       + param3
				       + param4
				       + visible));
	}

	qInfo("-----------------------------------------------------------------------------------------------------------------------------------------------");
}
