#pragma once

#include <QObject>
#include <QMap>

#include "src/Aircraft/protocol/mavlink/MAVLink.h"


class ArdupilotFrameHelper : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ArdupilotFrameHelper)

public:
	explicit ArdupilotFrameHelper();

	static ArdupilotFrameHelper *instance();

	QString getClass();
	QString getType();

	bool set(QString, QString);

private:
	QMap<uint8_t, QString> frame_class_param_base;

	const QMap<uint8_t, QString> frame_type_param_base {
		{0,     "+"},
		{1,     "X"},
		{2,     "V"},
		{10,    "Y6B"},
		{11,    "Y6F"}
	};

	const QMap<QString, uint8_t> frame_class {
		{"QUAD",        1},
		{"Y6",          5},
		{"HEXA",        2},
		{"OCTO",        3},
		{"OCTOQUAD",    4},
	};

	const QMap<uint8_t, QMap<QString, uint8_t>> frame_type {
		{frame_class.value("QUAD"),     {{"+", 0}, {"X", 1}}},
		{frame_class.value("Y6"),       {{"A", 2}, {"B", 10},  {"F", 11}}},
		{frame_class.value("HEXA"),     {{"+", 0}, {"X", 1}}},
		{frame_class.value("OCTO"),     {{"+", 0}, {"X", 1}}},
		{frame_class.value("OCTOQUAD"), {{"X", 1}}}
	};
};
