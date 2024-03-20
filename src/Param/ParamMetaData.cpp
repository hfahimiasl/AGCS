#include "ParamMetaData.h"


ParamMetaData::ParamMetaData()
{
	// empty
}

ParamMetaData *ParamMetaData::instance()
{
	static ParamMetaData self;
	return &self;
}

void ParamMetaData::load(const QString &address)
{
	QString current_category = QString();

	const QRegExp parameter_categories = QRegExp("ArduPlane|ArduCopter");

	// qDebug() << "loading meta data:" << address;

	QFile file(address);

	Q_ASSERT(file.exists());

	const bool success = file.open(QIODevice::ReadOnly);

	Q_UNUSED(success)
	Q_ASSERT(success);

	QXmlStreamReader stream_reader(file.readAll());

	file.close();

	if (stream_reader.hasError()) {
		// qCritical() << "badly formed xml, reading failed: " << stream_reader.errorString();
		return;
	}

	bool bad_fact = true;
	QStack<PARAM_XMLSTREAM> stream_status {};
	param_fact_s *fact_ptr = nullptr;

	stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_NONE);

	QMap<QString, QStringList> group_members;

	while (!stream_reader.atEnd()) {
		if (stream_reader.isStartElement()) {
			QString element = stream_reader.name().toString();

			if (element.isEmpty()) {
				// skip empty elements

			} else if (element == "paramfile") {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_NONE) {
					// qCritical() << "badly formed xml, paramfile matched";
				}

				stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_FILE);

			} else if (element == "vehicles") {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_FILE) {
					// qCritical() << "badly formed xml, vehicles matched";
					return;
				}

				stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_VEHICLES);

			} else if (element == "libraries") {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_FILE) {
					// qCritical() << "badly formed xml, libraries matched";
					return;
				}

				stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_LIBRARIES);

			} else if (element == "parameters") {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_VEHICLES && stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_LIBRARIES) {
					// qCritical() << "badly formed xml, parameters matched. but we don't have proper vehicle or libraries yet";
					return;
				}

				if (stream_reader.attributes().hasAttribute("name")) {
					const QString nameValue = stream_reader.attributes().value("name").toString();

					if (nameValue.contains(parameter_categories)) {
						stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETERS);
						current_category = nameValue;

					} else if (stream_status.top() == PARAM_XMLSTREAM::PARAM_XMLSTREAM_LIBRARIES) {
						stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETERS);

					} else {
						// qWarning() << "not interested in this block of parameters, skipping:" << nameValue;

						if (skipBlock(stream_reader, "parameters")) {
							// qCritical() << "something wrong with the xml, skip of the xml failed";
							return;
						}

						stream_reader.readNext();
						continue;
					}
				}

			}  else if (element == "param") {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETERS) {
					// qCritical() << "badly formed xml, element param matched. while we are not yet in parameters";
					return;
				}

				stream_status.push(PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETER);

				if (!stream_reader.attributes().hasAttribute("name")) {
					// qCritical() << "badly formed xml, parameter attribute name missing";
					return;
				}

				QString name = stream_reader.attributes().value("name").toString();

				if (name.contains(':')) {
					name = name.split(':').last();
				}

				const QString group = getGroupFromName(name);
				const QString category = stream_reader.attributes().value("user").toString();
				const QString short_description = stream_reader.attributes().value("humanName").toString();
				const QString long_description = stream_reader.attributes().value("documentation").toString();

				Q_ASSERT(!fact_ptr);

				if (meta_data.value(current_category).contains(name)) {
					// qWarning() << "duplicate parameter found:" << name;
					fact_ptr = meta_data.value(current_category).value(name);

				} else {
					fact_ptr = new param_fact_s();
					meta_data[current_category][name] = fact_ptr;
					group_members[group].append(name);
				}

				// qDebug() << "inserting metadata for field" << name;

				fact_ptr->group = group;
				fact_ptr->category = category;
				fact_ptr->short_description = short_description;
				fact_ptr->long_description = long_description;

			} else {
				if (stream_status.top() != PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETER) {
					// qCritical() << "badly formed xml, while reading parameter fields wrong state";
					return;
				}

				if (!bad_fact) {
					if (!parseAttributes(stream_reader, fact_ptr)) {
						// qCritical() << "badly formed xml, failed to read parameter attributes";
						return;
					}

					continue;
				}
			}

		} else if (stream_reader.isEndElement()) {
			const QString element = stream_reader.name().toString();

			if (element == "param" && stream_status.top() == PARAM_XMLSTREAM::PARAM_XMLSTREAM_PARAMETER) {
				// qDebug() << "done loading parameter";
				fact_ptr = nullptr;
				bad_fact = false;
				stream_status.pop();

			} else if (element == "parameters") {
				// qDebug() << "end of parameters for category: " << current_category;
				correctGroupMemberships(meta_data[current_category], group_members);
				group_members.clear();
				stream_status.pop();

			} else if (element == "vehicles") {
				// qDebug() << "vehicles end here, libraries will follow";
				stream_status.pop();
			}
		}

		stream_reader.readNext();
	}
}

QString ParamMetaData::getGroupFromName(const QString &name)
{
	return name.split('_').first().remove(QRegExp("[0-9]*$"));
}

bool ParamMetaData::skipBlock(QXmlStreamReader &stream_reader, const QString &blockName)
{
	QString element = QString();

	do {
		stream_reader.readNext();
		element = stream_reader.name().toString();

	} while ((element != blockName) && (stream_reader.isEndElement()));

	return !stream_reader.isEndDocument();
}

bool ParamMetaData::parseAttributes(QXmlStreamReader &stream_reader, param_fact_s *fact_ptr)
{
	QList<QPair<QString, QString>> values {};

	QString element = stream_reader.name().toString();

	while (!(element == "param" && stream_reader.isEndElement())) {
		if (element.isEmpty()) {
			// skip empty elements

		} else if (element == "field") {
			const QString attribute = stream_reader.attributes().value("name").toString();

			if (attribute == "Range") {
				const QString range = stream_reader.readElementText().trimmed();
				QStringList range_list = range.split(' ');

				if (range_list.count() != 2) {
					// qWarning() << "space seperator didn't work',trying 'to' separator";
					range_list = range.split("to");

					if (range_list.count() != 2) {
						// qWarning() << " 'to' seperaator didn't work', trying '-' as seperator";
						range_list = range.split('-');

						if (range_list.count() != 2) {
							// qCritical() << "something wrong with range, all three separators have failed" << range;
						}
					}
				}

				if (range_list.count() == 2) {
					fact_ptr->min = range_list.first().trimmed();
					fact_ptr->max = range_list.last().trimmed();

					if (fact_ptr->min.contains(' ')) {
						fact_ptr->min = fact_ptr->min.split(' ').first();
					}

					if (fact_ptr->max.contains(' ')) {
						fact_ptr->max = fact_ptr->max.split(' ').first();
					}

					// qDebug() << "attribute Range [" << fact_ptr->min << fact_ptr->max << "]";
				}

			} else if (attribute == "Increment") {
				fact_ptr->increment_size = stream_reader.readElementText();
				// qDebug() << "attribute Increment: " << fact_ptr->increment_size;

			} else if (attribute == "Units") {
				fact_ptr->units = stream_reader.readElementText();
				// qDebug() << "attribute Units: " << fact_ptr->units;

			} else if (attribute == "UnitText") {
				fact_ptr->unit_text = stream_reader.readElementText();
				// qDebug() << "attribute UnitText: " << fact_ptr->unit_text;

			} else if (attribute == "Bitmask") {
				const QString bitmask = stream_reader.readElementText();
				QStringList bitmask_list = bitmask.split(",");
				bool result = true;

				if (bitmask_list.count() > 0) {
					for (const QString &bitmask : bitmask_list) {
						const QStringList pair = bitmask.split(":");

						if (pair.count() == 2) {
							fact_ptr->bitmask.append(QPair<int, QString>(pair[0].toInt(), pair[1]));

						} else {
							// qCritical() << "bitmask parse failed:" << bitmask << "pair count:" << pair.count();
							result = false;
							break;
						}
					}
				}

				if (!result) {
					fact_ptr->bitmask.clear();
				}

				// qDebug() << "attribute Bitmask: " << fact_ptr->bitmask;

			} else if (attribute == "RebootRequired") {
				fact_ptr->reboot_required = stream_reader.readElementText().trimmed().compare("true", Qt::CaseInsensitive) == 0;
				// qDebug() << "attribute RebootRequired: " << fact_ptr->reboot_required;
			}

		} else if (element == "values") {
			// doing nothing individual value will follow anyway. May be used for sanity checking.

		} else if (element == "value") {
			const int code = stream_reader.attributes().value("code").toInt();
			const QString name = stream_reader.readElementText();
			fact_ptr->values.append(QPair<int, QString>(code, name));
			// qDebug() << "element value: " << fact_ptr->values;

		} else {
			// qWarning() << "unknown parameter element in XML: " << element;
		}

		stream_reader.readNext();
		element = stream_reader.name().toString();
	}

	return true;
}

void ParamMetaData::correctGroupMemberships(ParamFactMetaData &meta_data, QMap<QString, QStringList> &group_members)
{
	for (const QString &key : group_members.keys()) {
		if (group_members.value(key).count() == 1) {
			for (const QString &parameter : group_members.value(key)) {
				meta_data[parameter]->group = "GENERAL";
			}
		}
	}
}

param_fact_s *ParamMetaData::getFact(const QString &firmware_type, const QString &param)
{
	if (meta_data.value(firmware_type).contains(param)) {
		return meta_data.value(firmware_type).value(param);

	} else if (meta_data.value("libraries").contains(param)) {
		return meta_data.value("libraries").value(param);
	}

	// qCritical() << param << "not found";

	return nullptr;
}
