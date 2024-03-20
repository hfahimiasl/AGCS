#include "Logger.h"

QFile Logger::log_file;

QTextStream Logger::log_stream(&Logger::log_file);

FILE *Logger::stdout_stream = stdout;

const QMap<QtMsgType, QList<const char *>> Logger::color_map {
	{QtMsgType::QtDebugMsg,     {"DEBUG",   Logger::kANSIColorGreen,    Logger::kANSIColorGreen,    Logger::kANSIColorGreen}},
	{QtMsgType::QtInfoMsg,      {"INFO",    Logger::kANSIColorGreen,    Logger::kANSIColorReset,    Logger::kANSIColorReset}},
	{QtMsgType::QtWarningMsg,   {"WARN",    Logger::kANSIColorYellow,   Logger::kANSIColorYellow,   Logger::kANSIColorYellow}},
	{QtMsgType::QtCriticalMsg,  {"ERROR",   Logger::kANSIColorRed,      Logger::kANSIColorRed,      Logger::kANSIColorRed}},
	{QtMsgType::QtFatalMsg,     {"FATAL",   Logger::kANSIColorRed,      Logger::kANSIColorRed,      Logger::kANSIColorRed}}
};

Logger::~Logger()
{
#ifdef LOG_FILE
	Logger::log_stream.flush();
	Logger::log_file.close();
#endif
}

void Logger::init()
{
#ifdef Q_OS_WIN
	std::system(" ");
#endif

	qInstallMessageHandler(Logger::handler);

#ifdef LOG_FILE
	const QString file_name = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation) + QString("/agcs-%1.log").arg(
					  QDateTime::currentDateTime().toString("MM-dd-yyyy-hh-mm-ss"));

	if (QFile::exists(file_name)) {
		qCritical() << "log file already exist";
		return;
	}

	Logger::log_file.setFileName(file_name);

	if (!Logger::log_file.open(QIODevice::WriteOnly | QIODevice::Text)) {
		qCritical() << "failed to create log file";
	}

#endif
}

void Logger::handler(QtMsgType type, const QMessageLogContext &context, const QString &message)
{
	switch (type) {
	case QtMsgType::QtDebugMsg:
#ifndef LOG_DEBUG
		return;
#else
		break;
#endif

	case QtMsgType::QtInfoMsg:
#ifndef LOG_INFO
		return;
#else
		break;
#endif

	case QtMsgType::QtWarningMsg:
#ifndef LOG_WARN
		return;
#else
		break;
#endif

	case QtMsgType::QtCriticalMsg:
#ifndef LOG_CRITICAL
		return;
#else
		break;
#endif

	case QtMsgType::QtFatalMsg:
#ifndef LOG_FATAL
		return;
#else
		break;
#endif
	}

	fputs(Logger::kANSIColorReset, Logger::stdout_stream);

#ifdef LOG_TIME
	const QString date = QDateTime::currentDateTime().toString("hh:mm:ss ");

	fputs(qPrintable(date), Logger::stdout_stream);

#ifdef LOG_FILE

	if (Logger::log_file.isOpen()) {
		Logger::log_stream << date;
	}

#endif
#endif

#ifdef LOG_LEVEL
	fprintf(Logger::stdout_stream, "(%s%5s%s) ", Logger::color_map.value(type).at(1), Logger::color_map.value(type).at(0),
		Logger::kANSIColorReset);

#ifdef LOG_FILE

	if (Logger::log_file.isOpen()) {
		Logger::log_stream << QString("(%1) ").arg(Logger::color_map.value(type).at(0));
	}

#endif
#endif

#ifdef LOG_CONTEXT

	if (context.file) {
		const QString file = QString(context.file).split('\\').last().split('/').last();

		fprintf(Logger::stdout_stream, "(%s%s %u%s) ", Logger::color_map.value(type).at(2), qPrintable(file), context.line,
			Logger::kANSIColorReset);

#ifdef LOG_FILE

		if (Logger::log_file.isOpen()) {
			Logger::log_stream << QString("(%1 %2) ").arg(file).arg(context.line);
		}

#endif

	} else {
		fprintf(Logger::stdout_stream, "(%sSYSTEM%s) ", Logger::color_map.value(type).at(2), Logger::kANSIColorReset);

#ifdef LOG_FILE

		if (Logger::log_file.isOpen()) {
			Logger::log_stream << "(SYSTEM) ";
		}

#endif
	}

#else
	Q_UNUSED(context)
#endif

	fprintf(Logger::stdout_stream, "%s%s%s\n", color_map.value(type).at(3), qPrintable(message), Logger::kANSIColorReset);
	fflush(Logger::stdout_stream);

#ifdef LOG_FILE

	if (Logger::log_file.isOpen()) {
		Logger::log_stream << QString("%1\n").arg(message);
		Logger::log_stream.flush();
	}

#endif
}
