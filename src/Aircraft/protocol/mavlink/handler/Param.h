#pragma once

#include <QObject>
#include <QTimer>

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"
#include "src/Aircraft/link/Link.h"
#include "src/Aircraft/autopilot/Autopilot.h"


class Param : public QObject, public AbstractHandler
{
	Q_OBJECT

public:
	explicit Param(MAVLink *);
	~Param() override;

	void handle(const mavlink_message_t &) override;

private slots:
	void init();
	void download();
	void paramSet(const QString &, const double &);
	void restoreDefault();
	void saveToFile();
	void loadFromFile();
	void timeout();

private:
	QTimer *timer {nullptr};
	CryptoGraphy *crypto {nullptr};
	int32_t last_insert_index {-1};
	QList<uint16_t> missing_list {};
	bool download_complete {false};
	bool restore_request {false};

	const uint16_t kInitTimeout {5000};
	const uint16_t kMissingTimeout {250};
	const QString kFileExtension {".param"};

	void deinit();
	void requestList();
	void requestRead(const uint16_t &);
};
