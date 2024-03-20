#include "HeartBeat.h"


HeartBeat::HeartBeat(MAVLink *mavlink) :
	AbstractHandler(mavlink),
	timer(new QTimer(this))
{
	variable.add("CUSTOM_MODE");
	variable.add("AIRCRAFT_TYPE", -1);
	variable.add("AUTOPILOT_TYPE", -1);
	variable.add("SYSTEM_STATUS");
	variable.add("MAVLINK_VERSION");
	variable.add("ARM_STATUS");
	variable.add("FLIGHT_TIME", 0.0, "00:00:00");

	QObject::connect(timer, &QTimer::timeout,
			 this, QOverload<>::of(&HeartBeat::send));

	timer->start(1000);
}

HeartBeat::~HeartBeat()
{
	delete timer;
}

void HeartBeat::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_HEARTBEAT) { return; }

	mavlink_heartbeat_t heartbeat {};
	mavlink_msg_heartbeat_decode(&message, &heartbeat);

	if (message.sysid == 0) { return; }

	mavlink->setAircraftSysID(message.sysid);
	mavlink->setAircraftCompID(message.compid);

	variable.setValue("CUSTOM_MODE", heartbeat.custom_mode, true);
	variable.setValue("SYSTEM_STATUS", heartbeat.system_status, true);
	variable.setValue("MAVLINK_VERSION", heartbeat.mavlink_version, true);
	variable.setValue("ARM_STATUS", heartbeat.base_mode & MAV_MODE_FLAG::MAV_MODE_FLAG_SAFETY_ARMED, true);

	updateAircraftType(heartbeat.type);
	updateAutopilotType(heartbeat.autopilot);
}

void HeartBeat::send()
{
	if (Link::instance()->isConnected()) {
		mavlink_message_t message {};

		mavlink_msg_heartbeat_pack(mavlink->getGCSSysID(),
					   mavlink->getGCSCompID(),
					   &message,
					   MAV_TYPE::MAV_TYPE_GCS,
					   MAV_AUTOPILOT::MAV_AUTOPILOT_INVALID,
					   MAV_MODE::MAV_MODE_PREFLIGHT,
					   0,
					   MAV_STATE::MAV_STATE_UNINIT);

		mavlink->write(message);

		const qint32 serial_baud_rate = Serial::instance()->isConnected() ? Serial::instance()->getBaudRate() : -1;

		mavlink_msg_request_data_stream_pack(MAVLink::instance()->getGCSSysID(),
						     MAVLink::instance()->getGCSCompID(),
						     &message,
						     MAVLink::instance()->getAircraftSysID(),
						     MAVLink::instance()->getAircraftCompID(),
						     MAV_DATA_STREAM::MAV_DATA_STREAM_ALL,
						     stream_rate_map.contains(serial_baud_rate) ? stream_rate_map.value(serial_baud_rate) : 10,
						     1);

		mavlink->write(message);

		//        mavlink_msg_autopilot_version_request_pack(MAVLink::instance()->getGCSSysID(),
		//                                                   MAVLink::instance()->getGCSCompID(),
		//                                                   &message,
		//                                                   MAVLink::instance()->getAircraftSysID(),
		//                                                   MAVLink::instance()->getAircraftCompID());

		//        MAVLink::instance()->write(message);

	} else {
		total_flight_time = 0;
		flight_time_offset = 0;
		flight_time_offset_init = false;
	}

	updateFlightTime();
}

void HeartBeat::updateAircraftType(uint8_t type)
{
	switch (type) {
	case MAV_TYPE::MAV_TYPE_FIXED_WING:
		variable.setValue("AIRCRAFT_TYPE", AIRCRAFT_TYPE::AIRCRAFT_TYPE_FIXEDWING);
		variable.setText("AIRCRAFT_TYPE", "FIXEDWING");
		break;

	case MAV_TYPE::MAV_TYPE_TRICOPTER:
	case MAV_TYPE::MAV_TYPE_QUADROTOR:
	case MAV_TYPE::MAV_TYPE_HEXAROTOR:
	case MAV_TYPE::MAV_TYPE_OCTOROTOR:
	case MAV_TYPE::MAV_TYPE_DECAROTOR:
	case MAV_TYPE::MAV_TYPE_DODECAROTOR:
		variable.setValue("AIRCRAFT_TYPE", AIRCRAFT_TYPE::AIRCRAFT_TYPE_MULTIROTOR);
		variable.setText("AIRCRAFT_TYPE", "MULTIROTOR");
		break;

	case MAV_TYPE::MAV_TYPE_VTOL_DUOROTOR:
	case MAV_TYPE::MAV_TYPE_VTOL_QUADROTOR:
	case MAV_TYPE::MAV_TYPE_VTOL_TILTROTOR:
	case MAV_TYPE::MAV_TYPE_VTOL_RESERVED2:
	case MAV_TYPE::MAV_TYPE_VTOL_RESERVED3:
	case MAV_TYPE::MAV_TYPE_VTOL_RESERVED4:
	case MAV_TYPE::MAV_TYPE_VTOL_RESERVED5:
		variable.setValue("AIRCRAFT_TYPE", AIRCRAFT_TYPE::AIRCRAFT_TYPE_VTOL);
		variable.setText("AIRCRAFT_TYPE", "VTOL");
		break;

	case MAV_TYPE::MAV_TYPE_COAXIAL:
	case MAV_TYPE::MAV_TYPE_HELICOPTER:
		variable.setValue("AIRCRAFT_TYPE", AIRCRAFT_TYPE::AIRCRAFT_TYPE_HELICOPTER);
		variable.setText("AIRCRAFT_TYPE", "HELICOPTER");
		break;

	default:
		variable.setValue("AIRCRAFT_TYPE", AIRCRAFT_TYPE::AIRCRAFT_TYPE_GENERIC);
		variable.setText("AIRCRAFT_TYPE", "GENERIC");
		break;
	}

	emit variable.notifyChanges("AIRCRAFT_TYPE");
}

void HeartBeat::updateAutopilotType(uint8_t autopilot)
{
	variable.setValue("AUTOPILOT_TYPE", autopilot);

	switch (autopilot) {
	case MAV_AUTOPILOT::MAV_AUTOPILOT_GENERIC:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_GENERIC");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_RESERVED:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_RESERVED");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_SLUGS:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_SLUGS");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_ARDUPILOTMEGA:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_ARDUPILOTMEGA");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_OPENPILOT:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_OPENPILOT");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_GENERIC_MISSION_FULL:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_GENERIC_MISSION_FULL");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_INVALID:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_INVALID");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_PPZ:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_PPZ");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_UDB:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_UDB");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_FP:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_FP");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_PX4:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_PX4");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_SMACCMPILOT:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_SMACCMPILOT");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_AUTOQUAD:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_AUTOQUAD");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_ARMAZILA:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_ARMAZILA");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_AEROB:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_AEROB");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_ASLUAV:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_ASLUAV");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_SMARTAP:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_SMARTAP");
		break;

	case MAV_AUTOPILOT::MAV_AUTOPILOT_AIRRAILS:
		variable.setText("AUTOPILOT_TYPE", "MAV_AUTOPILOT_AIRRAILS");
		break;
	}

	emit variable.notifyChanges("AUTOPILOT_TYPE");
}

void HeartBeat::updateFlightTime()
{
	if (MAV_STATE(uint8_t(variable.getValue("SYSTEM_STATUS"))) == MAV_STATE::MAV_STATE_ACTIVE) {
		if (!flight_time_offset_init) {
			flight_time_offset = total_flight_time;
			flight_time_offset_init = true;
		}

	} else {
		flight_time_offset_init = false;
	}

	if (flight_time_offset_init) {
		total_flight_time += 1;
	}

	const uint64_t flight_time = total_flight_time - flight_time_offset;

	QString flight_time_str = QString("%1:%2:%3")
				  .arg(flight_time / 3600, 2, 10, QChar('0'))
				  .arg((flight_time % 3600) / 60, 2, 10, QChar('0'))
				  .arg(flight_time % 60, 2, 10, QChar('0'));

	variable.setText("FLIGHT_TIME", flight_time_str, true);
}
