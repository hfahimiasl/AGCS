#pragma once

#include <QObject>
#include <QTimer>
#include <QDir>
#include <QStandardPaths>
#include <QUuid>
#include <QFile>
#include <QHttpPart>
#include <QCryptographicHash>

#include "src/System/Global.h"
#include "src/System/Clock.h"
#include "src/System/Variable.h"
#include "src/System/Settings.h"
#include "src/Aircraft/link/Link.h"
#include "src/Aircraft/autopilot/Autopilot.h"
#include "src/Server/Server.h"


using namespace Global;

class InternalLog : public QObject
{
	Q_OBJECT

public:
	explicit InternalLog();

	~InternalLog();

	static InternalLog *instance();

	void init(const QString &);

private slots:
	void log(const bool &);

private:
	QFile *file {nullptr};

	QTimer timer;
	QString base_url;

	QString flight_time;
	double max_altitude {0};
	double flight_length {0};

	QFileInfoList file_list;

	static constexpr uint16_t kTimeout {200_ms};
	static constexpr const char *kDirName {"AGCS"};
	static constexpr const char *kFileExtension {".log"};

	const QString kSaveDirPath {QStandardPaths::writableLocation(QStandardPaths::TempLocation) + "/" + InternalLog::kDirName};

	bool prepareDir();
	bool prepareFile();
	void terminate();
	void analyze();

	QString getDataFormat(const uint8_t &, const bool & = true);

	void loadLocal();
	void upload();
};
