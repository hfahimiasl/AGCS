#pragma once

#include <QObject>
#include <QMap>
#include <QFile>
#include <QStack>
#include <QXmlStreamReader>
#include <QDebug>

#include "ParamFact.h"


class ParamMetaData : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(ParamMetaData)

public:
	explicit ParamMetaData();

	static ParamMetaData *instance();

	void load(const QString &);

	param_fact_s *getFact(const QString &, const QString &);

private:
	enum PARAM_XMLSTREAM {
		PARAM_XMLSTREAM_NONE,
		PARAM_XMLSTREAM_FILE,
		PARAM_XMLSTREAM_VEHICLES,
		PARAM_XMLSTREAM_LIBRARIES,
		PARAM_XMLSTREAM_PARAMETERS,
		PARAM_XMLSTREAM_VERSION,
		PARAM_XMLSTREAM_GROUP,
		PARAM_XMLSTREAM_PARAMETER,
		PARAM_XMLSTREAM_DONE
	};

	QMap<QString, ParamFactMetaData> meta_data {};

	QString getGroupFromName(const QString &);
	bool skipBlock(QXmlStreamReader &, const QString &);
	bool parseAttributes(QXmlStreamReader &, param_fact_s *);
	void correctGroupMemberships(ParamFactMetaData &, QMap<QString, QStringList> &);
};
