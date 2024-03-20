#pragma once

#include <QObject>


class PhotographyInfo : public QObject
{
	Q_OBJECT
	Q_PROPERTY(double altitude                  READ getAltitude                WRITE setAltitude                   NOTIFY altitudeChanged)
	Q_PROPERTY(double speed                     READ getSpeed                   WRITE setSpeed                      NOTIFY speedChanged)
	Q_PROPERTY(double angle                     READ getAngle                   WRITE setAngle                      NOTIFY angleChanged)
	Q_PROPERTY(double spacing                   READ getSpacing                 WRITE setSpacing                    NOTIFY spacingChanged)
	Q_PROPERTY(double cameraTriggerDistance     READ getCameraTriggerDistance   WRITE setCameraTriggerDistance      NOTIFY
		   cameraTriggerDistanceChanged)

public:
	explicit PhotographyInfo(QObject * = nullptr);

	double getAltitude() const;
	void setAltitude(const double &);

	double getSpeed() const;
	void setSpeed(const double &);

	double getAngle() const;
	void setAngle(const double &);

	double getSpacing() const;
	void setSpacing(const double &);

	double getCameraTriggerDistance() const;
	void setCameraTriggerDistance(const double &);

	void operator=(const PhotographyInfo &);

signals:
	void altitudeChanged();
	void speedChanged();
	void angleChanged();
	void spacingChanged();
	void cameraTriggerDistanceChanged();

private:
	double m_altitude {qQNaN()};
	double m_speed {qQNaN()};
	double m_angle {qQNaN()};
	double m_spacing {qQNaN()};
	double m_camera_trigger_distance {qQNaN()};
};
