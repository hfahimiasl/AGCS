#pragma once

#include <stdlib.h>
#include <stdio.h>
#include <wchar.h>

#include <QMap>
#include <QFile>
#include <QDebug>
#include <QDateTime>
#include <QTextStream>
#include <QStandardPaths>


class Logger
{
public:
	~Logger();

	static void init();
	static void handler(QtMsgType, const QMessageLogContext &, const QString &);

private:
	static constexpr const char *kANSIColorReset    {"\u001b[0m"};
	static constexpr const char *kANSIColorBlack    {"\u001b[30m"};
	static constexpr const char *kANSIColorRed      {"\u001b[31m"};
	static constexpr const char *kANSIColorGreen    {"\u001b[32m"};
	static constexpr const char *kANSIColorYellow   {"\u001b[33m"};
	static constexpr const char *kANSIColorBlue     {"\u001b[34m"};
	static constexpr const char *kANSIColorMagenta  {"\u001b[35m"};
	static constexpr const char *kANSIColorCyan     {"\u001b[36m"};
	static constexpr const char *kANSIColorWhite    {"\u001b[37m"};

	static QFile log_file;
	static QTextStream log_stream;

	static FILE *stdout_stream;

	static const QMap<QtMsgType, QList<const char *>> color_map;
};

//#define LOG_FILE
#define LOG_TIME
#define LOG_LEVEL
#define LOG_CONTEXT
#define LOG_DEBUG
#define LOG_INFO
#define LOG_WARN
#define LOG_CRITICAL
#define LOG_FATAL
