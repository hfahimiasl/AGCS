#pragma once

#include <QObject>
#include <QDateTime>

#include "LogAckCode.h"


class LogItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(quint16          id          READ getID                              NOTIFY idChanged)
	Q_PROPERTY(QDateTime        time        READ getTime                            NOTIFY timeChanged)
	Q_PROPERTY(quint32          size        READ getSize                            NOTIFY sizeChanged)
	Q_PROPERTY(QString          sizeString  READ getSizeString                      NOTIFY sizeStringChanged)
	Q_PROPERTY(bool             received    READ getReceived                        NOTIFY receivedChanged)
	Q_PROPERTY(bool             selected    READ getSelected    WRITE setSelected   NOTIFY selectedChanged)
	Q_PROPERTY(LogAckCode::Enum ack         READ getAck                             NOTIFY ackChanged)
	Q_PROPERTY(double           progress    READ getProgress                        NOTIFY progressChanged)
	Q_PROPERTY(QString          rate        READ getRate                            NOTIFY rateChanged)

public:
	LogItem(QObject * = nullptr);

	quint16 getID() const;
	void setID(const quint16 &);

	QDateTime getTime() const;
	void setTime(const QDateTime &);

	quint32 getSize() const;
	void setSize(const quint32 &);

	QString getSizeString() const;
	void setSizeString(const QString &);

	bool getReceived() const;
	void setReceived(const bool &);

	bool getSelected() const;
	void setSelected(const bool &);

	LogAckCode::Enum getAck() const;
	void setAck(const LogAckCode::Enum &);

	double getProgress() const;
	void setProgress(const double &);

	QString getRate() const;
	void setRate(const QString &);

signals:
	void idChanged();
	void timeChanged();
	void sizeChanged();
	void sizeStringChanged();
	void receivedChanged();
	void selectedChanged();
	void ackChanged();
	void progressChanged();
	void rateChanged();

private:
	quint16 m_id {UINT16_MAX};
	QDateTime m_time;
	quint32 m_size {UINT32_MAX};
	QString m_size_string {"N/A"};
	bool m_received {false};
	bool m_selected {false};
	LogAckCode::Enum m_ack {LogAckCode::Enum::Waiting};
	double m_progress {0.0};
	QString m_rate {"0/s"};
};
