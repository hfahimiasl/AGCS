#pragma once

#include <QObject>
#include <QGeoCoordinate>


class WaypointItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QGeoCoordinate   coordinate              READ getCoordinate              WRITE setCoordinate             NOTIFY
		   coordinateChanged)
	Q_PROPERTY(double           hoverTime               READ getHoverTime               WRITE setHoverTime              NOTIFY hoverTimeChanged)
	Q_PROPERTY(double           speed                   READ getSpeed                   WRITE setSpeed                  NOTIFY speedChanged)
	Q_PROPERTY(bool             relayActive             READ getRelayActive             WRITE setRelayActive            NOTIFY
		   relayActiveChanged)
	Q_PROPERTY(quint8           relayID                 READ getRelayID                 WRITE setRelayID                NOTIFY relayIDChanged)
	Q_PROPERTY(bool             relayStatus             READ getRelayStatus             WRITE setRelayStatus            NOTIFY
		   relayStatusChanged)
	Q_PROPERTY(bool             servoActive             READ getServoActive             WRITE setServoActive            NOTIFY
		   servoActiveChanged)
	Q_PROPERTY(quint8           servoID                 READ getServoID                 WRITE setServoID                NOTIFY servoIDChanged)
	Q_PROPERTY(quint16          servoPWM                READ getServoPWM                WRITE setServoPWM               NOTIFY servoPWMChanged)
	Q_PROPERTY(bool             gimbalActive            READ getGimbalActive            WRITE setGimbalActive           NOTIFY
		   gimbalActiveChanged)
	Q_PROPERTY(double           gimbalTilt              READ getGimbalTilt              WRITE setGimbalTilt             NOTIFY
		   gimbalTiltChanged)
	Q_PROPERTY(double           gimbalPan               READ getGimbalPan               WRITE setGimbalPan              NOTIFY gimbalPanChanged)
	Q_PROPERTY(bool             cameraTriggerActive     READ getCameraTriggerActive     WRITE setCameraTriggerActive    NOTIFY
		   cameraTriggerActiveChanged)
	Q_PROPERTY(bool             cameraTriggerStatus     READ getCameraTriggerStatus     WRITE setCameraTriggerStatus    NOTIFY
		   cameraTriggerStatusChanged)
	Q_PROPERTY(bool             cameraTriggerOnce       READ getCameraTriggerOnce       WRITE setCameraTriggerOnce      NOTIFY
		   cameraTriggerOnceChanged)
	Q_PROPERTY(double           cameraTriggerDistance   READ getCameraTriggerDistance   WRITE setCameraTriggerDistance  NOTIFY
		   cameraTriggerDistanceChanged)

public:
	explicit WaypointItem(QObject * = nullptr);

	QGeoCoordinate getCoordinate() const;
	void setCoordinate(const QGeoCoordinate &);

	double getHoverTime() const;
	void setHoverTime(const double &);

	double getSpeed() const;
	void setSpeed(const double &);

	bool getRelayActive() const;
	void setRelayActive(const bool &);

	quint8 getRelayID() const;
	void setRelayID(const quint8 &);

	bool getRelayStatus() const;
	void setRelayStatus(const bool &);

	bool getServoActive() const;
	void setServoActive(const bool &);

	quint8 getServoID() const;
	void setServoID(const quint8 &);

	quint16 getServoPWM() const;
	void setServoPWM(const quint16 &);

	bool getGimbalActive() const;
	void setGimbalActive(const bool &);

	double getGimbalTilt() const;
	void setGimbalTilt(const double &);

	double getGimbalPan() const;
	void setGimbalPan(const double &);

	bool getCameraTriggerActive() const;
	void setCameraTriggerActive(const bool &);

	bool getCameraTriggerStatus() const;
	void setCameraTriggerStatus(const bool &);

	bool getCameraTriggerOnce() const;
	void setCameraTriggerOnce(const bool &);

	double getCameraTriggerDistance() const;
	void setCameraTriggerDistance(const double &);

	void reset();

signals:
	void coordinateChanged();
	void hoverTimeChanged();
	void speedChanged();
	void relayActiveChanged();
	void relayIDChanged();
	void relayStatusChanged();
	void servoActiveChanged();
	void servoIDChanged();
	void servoPWMChanged();
	void gimbalActiveChanged();
	void gimbalTiltChanged();
	void gimbalPanChanged();
	void cameraTriggerActiveChanged();
	void cameraTriggerStatusChanged();
	void cameraTriggerOnceChanged();
	void cameraTriggerDistanceChanged();

private:
	QGeoCoordinate m_coordinate;
	double m_hover_time {qQNaN()};
	double m_speed {qQNaN()};
	bool m_relay_active {false};
	quint8 m_relay_id {UINT8_MAX};
	bool m_relay_status {false};
	bool m_servo_active {false};
	quint8 m_servo_id {UINT8_MAX};
	quint16 m_servo_pwm {UINT16_MAX};
	bool m_gimbal_active {false};
	double m_gimbal_tilt {qQNaN()};
	double m_gimbal_pan {qQNaN()};
	bool m_camera_trigger_active {false};
	bool m_camera_trigger_status {false};
	bool m_camera_trigger_once {false};
	double m_camera_trigger_distance {qQNaN()};
};
