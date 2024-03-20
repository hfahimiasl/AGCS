#pragma once

#include <QObject>
#include <QTimer>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>

#include "LogAckCode.h"
#include "LogItem.h"
#include "LogModel.h"
#include "LogMetaData.h"

#include "src/Aircraft/link/Link.h"
#include "src/Aircraft/protocol/mavlink/MAVLink.h"


using namespace Global;


class LogService : public QObject
{
	Q_OBJECT
	Q_PROPERTY(LogModel    *model               READ getModel           NOTIFY modelChanged)
	Q_PROPERTY(bool         logEntryInProgress  READ logEntryInProgress NOTIFY requestLogEntryChanged)
	Q_PROPERTY(bool         logDataInProgress   READ logDataInProgress  NOTIFY requestLogDataChanged)

public:
	explicit LogService();
	~LogService();

	static LogService *instance();

	LogModel *getModel();
	bool logEntryInProgress() const;
	bool logDataInProgress() const;

signals:
	void requestLogEntryChanged();
	void requestLogDataChanged();
	void modelChanged();
	void selectedChanged();

public slots:
	void refresh();
	void download();
	void erase();
	void cancel();

private slots:
	void logEntry(mavlink_log_entry_t);
	void logData(mavlink_log_data_t);

private:
	static constexpr quint16 kTimeout {500_ms};
	static constexpr quint8 kGUIRate {50_ms};
	static constexpr quint8 kMaxRetry {10};

	LogMetaData *meta_data {nullptr};
	LogModel *model {nullptr};
	QTimer *timer {nullptr};
	bool request_log_entry {false};
	bool request_log_data {false};
	uint8_t retry {0};
	int ardupilot_one_based {0};
	QString download_path;

	bool isLogEntryComplete();
	bool isChunkComplete() const;
	bool isLogDataComplete() const;
	void findMissingLogEntry();
	void receiveAllLogEntry();
	void findMissingLogData();
	void receiveAllLogData();
	void updateLogDataRate();
	void resetSelected(const bool &);
	void requestLogList(const uint16_t &, const uint16_t &);
	void requestLogData(const uint16_t &, const uint32_t &, const uint32_t &, const uint8_t & = 0);
	bool prepareLogFile();
	void setLogEntryStatus(const bool &);
	void setLogDataStatus(const bool &);

	LogItem *getNextSelected();
};
