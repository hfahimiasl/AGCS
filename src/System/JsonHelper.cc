#include "JsonHelper.h"


bool JsonHelper::validateRequiredKeys(const QJsonObject &object, const QStringList &keys, QString &error)
{
    QString missing_keys;

    for (const QString &i : keys) {
        if (!object.contains(i)) {
            if (!missing_keys.isEmpty()) {
                missing_keys += QStringLiteral(", ");
            }

            missing_keys += i;
        }
    }

    if (missing_keys.size()) {
        error = QString("The following required keys are missing: %1").arg(missing_keys);
        return false;
    }

    return true;
}


bool JsonHelper::validateKeyTypes(const QJsonObject &object, const QStringList &keys, const QList<QJsonValue::Type> &types, QString &error)
{
    for (int i=0 ; i<types.size() ; ++i) {
        const QString &key = keys[i];

        if (object.contains(key)) {
            const QJsonValue &value = object[key];

            if (value.type() == QJsonValue::Null && types[i] == QJsonValue::Double) {
                continue;
            }

            if (value.type() != types[i]) {
                error = QString("Incorrect value type - key:type:expected %1:%2:%3").arg(key).arg(typeToString(value.type())).arg(typeToString(types[i]));
                return false;
            }
        }
    }

    return true;
}

bool JsonHelper::validateKeys(const QJsonObject& object, const QList<JsonHelper::KeyValidateInfo_t> &info, QString &error)
{
    QStringList key_list;
    QList<QJsonValue::Type> type_list;

    for (const JsonHelper::KeyValidateInfo_t &i : info) {
        if (i.required) {
            key_list.append(i.key);
        }
    }

    if (!validateRequiredKeys(object, key_list, error)) {
        return false;
    }

    key_list.clear();

    for (const JsonHelper::KeyValidateInfo_t &i : info) {
        key_list.append(i.key);
        type_list.append(i.type);
    }

    return validateKeyTypes(object, key_list, type_list, error);
}

QString JsonHelper::typeToString(const QJsonValue::Type &type)
{
    static const QMap<QJsonValue::Type, const char *> type_map {
        { QJsonValue::Null,         "QJsonValue::Null" },
        { QJsonValue::Bool,         "QJsonValue::Bool" },
        { QJsonValue::Double,       "QJsonValue::Double" },
        { QJsonValue::String,       "QJsonValue::String" },
        { QJsonValue::Array,        "QJsonValue::Array" },
        { QJsonValue::Object,       "QJsonValue::Object" },
        { QJsonValue::Undefined,    "QJsonValue::Undefined" }
    };

    for (const QJsonValue::Type &i : type_map.keys()) {
        if (i == type) {
            return type_map.value(type);
        }
    }

    return QString("Unknown type: %1").arg(type);
}
