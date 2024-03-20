#pragma once

#include <QFile>
#include <QtMath>
#include <QBitArray>
#include <QElapsedTimer>

#include "LogItem.h"
#include "libs/mavlink/v2.0/common/mavlink.h"


class LogMetaData
{
public:
	LogMetaData(LogItem *);

	void advanceChunk();
	int getChunkBins() const;
	int getChunkSize() const;
	bool isChunkEquals(const bool &) const;

	LogItem *item {nullptr};
	quint32 current_chunk {0};
	QBitArray chunk_table;
	uint written {0};
	size_t rate_bytes {0};
	double rate_avg {0.0};
	QElapsedTimer elapsed;
	QString file_name;
	QFile file;

	constexpr static quint16 kBinsTable {512};
	constexpr static quint16 kChunkSize {LogMetaData::kBinsTable * MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN};
};
