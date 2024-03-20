#pragma once

#include <QLocale>
#include <QApplication>
#include <QNetworkRequest>


namespace Global
{
QString sizeToString(const quint64 &);

constexpr int operator "" _s(const unsigned long long seconds)
{
	return int(seconds * 1000ULL);
}

constexpr int operator "" _ms(const unsigned long long milliseconds)
{
	return int(milliseconds);
}

void setRawHeader(QNetworkRequest &, const QString &);
}
