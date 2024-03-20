#pragma once

#include <QObject>
#include <QGeoCoordinate>


class MissionItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(quint16          sequence        READ getSequence        WRITE setSequence       NOTIFY sequenceChanged)
	Q_PROPERTY(QGeoCoordinate   coordinate      READ getCoordinate      WRITE setCoordinate     NOTIFY coordinateChanged)
	Q_PROPERTY(quint16          command         READ getCommand         WRITE setCommand        NOTIFY commandChanged)
	Q_PROPERTY(quint8           frame           READ getFrame           WRITE setFrame          NOTIFY frameChanged)
	Q_PROPERTY(quint8           current         READ getCurrent         WRITE setCurrent        NOTIFY currentChanged)
	Q_PROPERTY(quint8           autoContinue    READ getAutoContinue    WRITE setAutoContinue   NOTIFY autoContinueChanged)
	Q_PROPERTY(quint8           type            READ getType            WRITE setType           NOTIFY typeChanged)
	Q_PROPERTY(double           param1          READ getParam1          WRITE setParam1         NOTIFY param1Changed)
	Q_PROPERTY(double           param2          READ getParam2          WRITE setParam2         NOTIFY param2Changed)
	Q_PROPERTY(double           param3          READ getParam3          WRITE setParam3         NOTIFY param3Changed)
	Q_PROPERTY(double           param4          READ getParam4          WRITE setParam4         NOTIFY param4Changed)
	Q_PROPERTY(QString          label           READ getLabel           WRITE setLabel          NOTIFY labelChanged)
	Q_PROPERTY(bool             unicodeLabel    READ getUnicodeLabel    WRITE setUnicodeLabel   NOTIFY unicodeLabelChanged)
	Q_PROPERTY(bool             visible         READ getVisible         WRITE setVisible        NOTIFY visibleChanged)

public:
	explicit MissionItem(QObject * = nullptr);

	quint16 getSequence() const;
	void setSequence(const quint16 &);

	QGeoCoordinate getCoordinate() const;
	void setCoordinate(const QGeoCoordinate &);

	quint16 getCommand() const;
	void setCommand(const quint16 &);

	quint8 getFrame() const;
	void setFrame(const quint8 &);

	quint8 getCurrent() const;
	void setCurrent(const quint8 &);

	quint8 getAutoContinue() const;
	void setAutoContinue(const quint8 &);

	quint8 getType() const;
	void setType(const quint8 &);

	double getParam1() const;
	void setParam1(const double &);

	double getParam2() const;
	void setParam2(const double &);

	double getParam3() const;
	void setParam3(const double &);

	double getParam4() const;
	void setParam4(const double &);

	QString getLabel() const;
	void setLabel(const QString &);

	bool getUnicodeLabel() const;
	void setUnicodeLabel(const bool &);

	bool getVisible() const;
	void setVisible(const bool &);

signals:
	void sequenceChanged();
	void coordinateChanged();
	void commandChanged();
	void frameChanged();
	void currentChanged();
	void autoContinueChanged();
	void typeChanged();
	void param1Changed();
	void param2Changed();
	void param3Changed();
	void param4Changed();
	void labelChanged();
	void unicodeLabelChanged();
	void visibleChanged();

private:
	quint16 m_sequence {UINT16_MAX};
	QGeoCoordinate m_coordinate;
	quint16 m_command {UINT16_MAX};
	quint8 m_frame {UINT8_MAX};
	quint8 m_current {UINT8_MAX};
	quint8 m_auto_continue {UINT8_MAX};
	quint8 m_type {UINT8_MAX};
	double m_param1 {qQNaN()};
	double m_param2 {qQNaN()};
	double m_param3 {qQNaN()};
	double m_param4 {qQNaN()};
	QString m_label {};
	bool m_unicode_label {false};
	bool m_visible {false};
};
