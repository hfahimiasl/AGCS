#include "WaypointItem.h"


WaypointItem::WaypointItem(QObject *parent) : QObject(parent)
{
	// empty
}

QGeoCoordinate WaypointItem::getCoordinate() const
{
	return m_coordinate;
}

void WaypointItem::setCoordinate(const QGeoCoordinate &coordinate)
{
	if (m_coordinate != coordinate) {
		m_coordinate = coordinate;
		emit coordinateChanged();
	}
}

double WaypointItem::getHoverTime() const
{
	return m_hover_time;
}

void WaypointItem::setHoverTime(const double &hover_time)
{
	if (!qFuzzyCompare(m_hover_time, hover_time)) {
		m_hover_time = hover_time;
		emit hoverTimeChanged();
	}
}

double WaypointItem::getSpeed() const
{
	return m_speed;
}

void WaypointItem::setSpeed(const double &speed)
{
	if (!qFuzzyCompare(m_speed, speed)) {
		m_speed = speed;
		emit speedChanged();
	}
}

bool WaypointItem::getRelayActive() const
{
	return m_relay_active;
}

void WaypointItem::setRelayActive(const bool &relay_active)
{
	if (m_relay_active != relay_active) {
		m_relay_active = relay_active;
		emit relayActiveChanged();
	}
}

quint8 WaypointItem::getRelayID() const
{
	return m_relay_id;
}

void WaypointItem::setRelayID(const quint8 &relay_id)
{
	if (m_relay_id != relay_id) {
		m_relay_id = relay_id;
		emit relayIDChanged();
	}
}

bool WaypointItem::getRelayStatus() const
{
	return m_relay_status;
}

void WaypointItem::setRelayStatus(const bool &relay_status)
{
	if (m_relay_status != relay_status) {
		m_relay_status = relay_status;
		emit relayStatusChanged();
	}
}

bool WaypointItem::getServoActive() const
{
	return m_servo_active;
}

void WaypointItem::setServoActive(const bool &servo_active)
{
	if (m_servo_active != servo_active) {
		m_servo_active = servo_active;
		emit servoActiveChanged();
	}
}

quint8 WaypointItem::getServoID() const
{
	return m_servo_id;
}

void WaypointItem::setServoID(const quint8 &servo_id)
{
	if (m_servo_id != servo_id) {
		m_servo_id = servo_id;
		emit servoIDChanged();
	}
}

quint16 WaypointItem::getServoPWM() const
{
	return m_servo_pwm;
}

void WaypointItem::setServoPWM(const quint16 &servo_pwm)
{
	if (m_servo_pwm != servo_pwm) {
		m_servo_pwm = servo_pwm;
		emit servoPWMChanged();
	}
}

bool WaypointItem::getGimbalActive() const
{
	return m_gimbal_active;
}

void WaypointItem::setGimbalActive(const bool &gimbal_active)
{
	if (m_gimbal_active != gimbal_active) {
		m_gimbal_active = gimbal_active;
		emit gimbalActiveChanged();
	}
}

double WaypointItem::getGimbalTilt() const
{
	return m_gimbal_tilt;
}

void WaypointItem::setGimbalTilt(const double &gimbal_tilt)
{
	if (!qFuzzyCompare(m_gimbal_tilt, gimbal_tilt)) {
		m_gimbal_tilt = gimbal_tilt;
		emit gimbalTiltChanged();
	}
}

double WaypointItem::getGimbalPan() const
{
	return m_gimbal_pan;
}

void WaypointItem::setGimbalPan(const double &gimbal_pan)
{
	if (!qFuzzyCompare(m_gimbal_pan, gimbal_pan)) {
		m_gimbal_pan = gimbal_pan;
		emit gimbalPanChanged();
	}
}

bool WaypointItem::getCameraTriggerActive() const
{
	return m_camera_trigger_active;
}

void WaypointItem::setCameraTriggerActive(const bool &camera_trigger_active)
{
	if (m_camera_trigger_active != camera_trigger_active) {
		m_camera_trigger_active = camera_trigger_active;
		emit cameraTriggerActiveChanged();
	}
}

bool WaypointItem::getCameraTriggerStatus() const
{
	return m_camera_trigger_status;
}

void WaypointItem::setCameraTriggerStatus(const bool &camera_trigger_status)
{
	if (m_camera_trigger_status != camera_trigger_status) {
		m_camera_trigger_status = camera_trigger_status;
		emit cameraTriggerStatusChanged();
	}
}

bool WaypointItem::getCameraTriggerOnce() const
{
	return m_camera_trigger_once;
}

void WaypointItem::setCameraTriggerOnce(const bool &camera_trigger_once)
{
	if (m_camera_trigger_once != camera_trigger_once) {
		m_camera_trigger_once = camera_trigger_once;
		emit cameraTriggerOnceChanged();
	}
}

double WaypointItem::getCameraTriggerDistance() const
{
	return m_camera_trigger_distance;
}

void WaypointItem::setCameraTriggerDistance(const double &camera_trigger_distance)
{
	if (!qFuzzyCompare(m_camera_trigger_distance, camera_trigger_distance)) {
		m_camera_trigger_distance = camera_trigger_distance;
		emit cameraTriggerDistanceChanged();
	}
}

void WaypointItem::reset()
{
	setCoordinate(QGeoCoordinate());
	setHoverTime(qQNaN());
	setSpeed(qQNaN());
	setRelayActive(false);
	setRelayID(UINT8_MAX);
	setRelayStatus(false);
	setServoActive(false);
	setServoID(UINT8_MAX);
	setServoPWM(UINT16_MAX);
	setGimbalActive(false);
	setGimbalTilt(qQNaN());
	setGimbalPan(qQNaN());
	setCameraTriggerActive(false);
	setCameraTriggerStatus(false);
	setCameraTriggerOnce(false);
	setCameraTriggerDistance(qQNaN());
}
