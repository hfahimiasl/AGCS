#pragma once

#include <QJsonObject>
#include <QStringList>
#include <QMap>


class JsonHelper
{
public:
	typedef struct {
		const char *key;
		QJsonValue::Type type;
		bool required;
	}   KeyValidateInfo_t;

	static bool validateRequiredKeys(const QJsonObject &, const QStringList &, QString &);
	static bool validateKeyTypes(const QJsonObject &, const QStringList &, const QList<QJsonValue::Type> &, QString &);
	static bool validateKeys(const QJsonObject &, const QList<KeyValidateInfo_t> &, QString &);

private:
	static QString typeToString(const QJsonValue::Type &);
};
