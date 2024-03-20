#pragma once

#include <QObject>
#include <QTimer>

#include "src/Aircraft/protocol/mavlink/AbstractHandler.h"
#include "src/Aircraft/link/Link.h"
#include "src/System/Global.h"
#include "src/System/Toast.h"


using namespace Global;

class Mission : public QObject, public AbstractHandler
{
	Q_OBJECT

public:
	explicit Mission(MAVLink *);
	~Mission() override;

	void handle(const mavlink_message_t &) override;

private slots:
	void download();
	void downloadTimeout();
	void upload();
	void uploadTimeout();

private:
	enum MISSION_DOWNLOAD_OPERATION {
		MISSION_DOWNLOAD_OPERATION_REQUEST_DOWNLOAD,
		MISSION_DOWNLOAD_OPERATION_REQUEST_LIST,
		MISSION_DOWNLOAD_OPERATION_REQUEST_ITEM
	}   download_operation { MISSION_DOWNLOAD_OPERATION::MISSION_DOWNLOAD_OPERATION_REQUEST_DOWNLOAD };

	QTimer *download_timer {nullptr};

	static constexpr quint16 kDownloadTimeout {1_s};

	quint8 download_retries {0};

	qint32 last_seq {-1};

	mavlink_mission_count_t mission_count {};

	QList<quint16> acceptable_commands {
		MAV_CMD::MAV_CMD_NAV_WAYPOINT,
		MAV_CMD::MAV_CMD_NAV_RETURN_TO_LAUNCH
	};

	bool downloadInProgress() const;
	void requestList();
	void handleCount(const mavlink_message_t &);
	void requestItem(const quint16 &);
	void handleItem(const mavlink_message_t &);
	void downloadResult(const bool &);

	enum MISSION_UPLOAD_OPERATION {
		MISSION_UPLOAD_OPERATION_REQUEST_UPLOAD,
		MISSION_UPLOAD_OPERATION_SEND_COUNT,
		MISSION_UPLOAD_OPERATION_SEND_ITEM,
		MISSION_UPLOAD_OPERATION_PEND_REQUEST
	}   upload_operation { MISSION_UPLOAD_OPERATION::MISSION_UPLOAD_OPERATION_REQUEST_UPLOAD };

	QTimer *upload_timer {nullptr};

	static constexpr quint16 kUploadTimeout {2_s};

	quint8 upload_retries {0};

	bool uploadInProgress() const;
	void sendCount();
	void handleRequest(const mavlink_message_t &);
	void sendItem(const quint16 &);
	void handleACK(const mavlink_message_t &);
	void uploadResult(const bool &);

	QString resultToString(const MAV_MISSION_RESULT &);

	void handleCurrent(const mavlink_message_t &);
	void handleItemReached(const mavlink_message_t &);

	void setCurrentWaypoint(const quint16 &);
};
