#include "LogItem.h"


LogItem::LogItem(QObject *parent)
	: QObject(parent)
{
	// empty
}

quint16 LogItem::getID() const
{
	return m_id;
}

void LogItem::setID(const quint16 &id)
{
	if (m_id != id) {
		m_id = id;
		emit idChanged();
	}
}

QDateTime LogItem::getTime() const
{
	return m_time;
}

void LogItem::setTime(const QDateTime &time)
{
	if (m_time != time) {
		m_time = time;
		emit timeChanged();
	}
}

quint32 LogItem::getSize() const
{
	return m_size;
}

void LogItem::setSize(const quint32 &size)
{
	if (m_size != size) {
		m_size = size;
		emit sizeChanged();
	}
}

QString LogItem::getSizeString() const
{
	return m_size_string;
}

void LogItem::setSizeString(const QString &size_string)
{
	if (m_size_string != size_string) {
		m_size_string = size_string;
		emit sizeStringChanged();
	}
}

bool LogItem::getReceived() const
{
	return m_received;
}

void LogItem::setReceived(const bool &received)
{
	if (m_received != received) {
		m_received = received;
		emit receivedChanged();
	}
}

bool LogItem::getSelected() const
{
	return m_selected;
}

void LogItem::setSelected(const bool &selected)
{
	if (m_selected != selected) {
		m_selected = selected;
		emit selectedChanged();
	}
}

LogAckCode::Enum LogItem::getAck() const
{
	return m_ack;
}

void LogItem::setAck(const LogAckCode::Enum &ack)
{
	if (m_ack != ack) {
		m_ack = ack;
		emit ackChanged();
	}
}

double LogItem::getProgress() const
{
	return m_progress;
}

void LogItem::setProgress(const double &progress)
{
	if (!qFuzzyCompare(m_progress, progress)) {
		m_progress = progress;
		emit progressChanged();
	}
}

QString LogItem::getRate() const
{
	return m_rate;
}

void LogItem::setRate(const QString &rate)
{
	if (m_rate != rate) {
		m_rate = rate;
		emit rateChanged();
	}
}
