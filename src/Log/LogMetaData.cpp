#include "LogMetaData.h"


LogMetaData::LogMetaData(LogItem *_item)
	: item(_item)
{
	// empty
}

void LogMetaData::advanceChunk()
{
	++current_chunk;
	chunk_table = QBitArray(getChunkBins(), false);
}

int LogMetaData::getChunkBins() const
{
	return qMin(qCeil((item->getSize() - qint64(current_chunk * LogMetaData::kChunkSize)) / double(MAVLINK_MSG_LOG_DATA_FIELD_DATA_LEN)),
		    int(LogMetaData::kBinsTable));
}

int LogMetaData::getChunkSize() const
{
	return qCeil(item->getSize() / double(LogMetaData::kChunkSize));
}

bool LogMetaData::isChunkEquals(const bool &val) const
{
	return chunk_table == QBitArray(chunk_table.size(), val);
}
