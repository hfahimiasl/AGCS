#pragma once

#include <QObject>


class LogAckCode : public QObject
{
	Q_OBJECT

public:
	enum Enum {
		Available,
		Cancel,
		Download,
		Error,
		InProgress,
		Waiting
	};

	Q_ENUM(Enum)
};

Q_DECLARE_METATYPE(LogAckCode::Enum)
