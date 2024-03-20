#include "MAVLink.h"


MAVLink::MAVLink() :
	gcs_sysid(255),
	gcs_compid(MAV_COMPONENT::MAV_COMP_ID_MISSIONPLANNER),
	aircraft_sysid(0),
	aircraft_compid(0)
{}

MAVLink::~MAVLink()
{
	while (!list.isEmpty()) {
		list.takeLast();
	}
}

MAVLink *MAVLink::instance()
{
	static MAVLink mavlink;
	return &mavlink;
}

void MAVLink::addHandler(AbstractHandler *handler)
{
	list.append(handler);
}

void MAVLink::setGCSSysID(uint8_t id)
{
	gcs_sysid = id;
}

void MAVLink::setGCSCompID(uint8_t id)
{
	gcs_compid = id;
}

void MAVLink::setAircraftSysID(uint8_t id)
{
	aircraft_sysid = id;
}

void MAVLink::setAircraftCompID(uint8_t id)
{
	aircraft_compid = id;
}

uint8_t MAVLink::getGCSSysID() const
{
	return gcs_sysid;
}

uint8_t MAVLink::getGCSCompID() const
{
	return gcs_compid;
}

uint8_t MAVLink::getAircraftSysID() const
{
	return aircraft_sysid;
}

uint8_t MAVLink::getAircraftCompID() const
{
	return aircraft_compid;
}

void MAVLink::write(mavlink_message_t &message)
{
	uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
	uint16_t lenght = mavlink_msg_to_send_buffer(buffer, &message);

	if (lenght) {
		emit notifyWrite(QByteArray((const char *)buffer, lenght));
	}
}

void MAVLink::writeCommandAck(uint16_t command, uint8_t result, uint8_t progress, int32_t result_param2)
{
	mavlink_message_t message;
	mavlink_msg_command_ack_pack(gcs_sysid,
				     gcs_compid,
				     &message,
				     command,
				     result,
				     progress,
				     result_param2,
				     aircraft_sysid,
				     aircraft_compid);
	write(message);
}

void MAVLink::writeCommandLong(uint16_t command, uint8_t confirmation, float param1, float param2, float param3,
			       float param4, float param5, float param6, float param7)
{
	mavlink_message_t message;
	mavlink_msg_command_long_pack(gcs_sysid,
				      gcs_compid,
				      &message,
				      aircraft_sysid,
				      aircraft_compid,
				      command,
				      confirmation,
				      param1,
				      param2,
				      param3,
				      param4,
				      param5,
				      param6,
				      param7);
	write(message);
}

void MAVLink::read(const QByteArray &data)
{
	mavlink_message_t message;
	mavlink_status_t status;

	for (int i = 0 ; i < data.length() ; ++i) {
		if (mavlink_parse_char(MAVLINK_COMM_0, quint8(data[i]), &message, &status)) {
			for (AbstractHandler *handler : list) {
				handler->handle(message);
			}

			emit notifyRead(message);
		}
	}
}
