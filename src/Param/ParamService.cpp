#include "ParamService.h"


ParamService::ParamService(QObject *parent, QQmlApplicationEngine *engine) :
	QObject(parent),
	other(new ParamItem(this)),
	model(new QGenericListModel<ParamItem>(true, nullptr))
{
	model->setEditable(true);

	qmlRegisterType<ParamItem>();

	engine->rootContext()->setContextProperty("ParamModel", model);
	engine->rootContext()->setContextProperty("ParamService", this);

	ParamMetaData::instance()->load(":/Param/arduplane.params.metadata.xml");
	ParamMetaData::instance()->load(":/Param/arducopter.params.metadata.xml");
}

ParamService::~ParamService()
{
	delete other;
	delete model;
}

ParamService *ParamService::instance(QObject *parent, QQmlApplicationEngine *engine)
{
	static ParamService self(parent, engine);
	return &self;
}

QModelIndex ParamService::indexOf(const QString &id)
{
	for (ParamItem *i : model->objects()) {
		if (i->getID() == id) {
			return model->index(i);
		}
	}

	return {};
}

bool ParamService::isExist(const QString &id)
{
	return indexOf(id).isValid();
}

int ParamService::count()
{
	return model->rowCount();
}

void ParamService::clear()
{
	model->resetModel({});
}

void ParamService::insert(const QString &id, const quint16 &index, const quint8 &type, const double &value)
{
	ParamItem *param = isExist(id) ? model->object(indexOf(id)) : new ParamItem(model);

	if (!param) {
		delete param;
		return;
	}

	bool decimal = false;
	QString type_text = QString();
	QVariant min_data_type = QVariant::Invalid;
	QVariant max_data_type = QVariant::Invalid;
	QVariant value_variant = QVariant::Invalid;

	switch (static_cast<MAV_PARAM_TYPE>(type)) {
	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_UINT8:
		decimal = false;
		type_text = "UINT8";
		min_data_type = QVariant::fromValue(static_cast<quint8>(std::numeric_limits<quint8>::min()));
		max_data_type = QVariant::fromValue(static_cast<quint8>(std::numeric_limits<quint8>::max()));
		value_variant = QVariant::fromValue(static_cast<quint8>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_INT8:
		decimal = false;
		type_text = "INT8";
		min_data_type = QVariant::fromValue(static_cast<char>(std::numeric_limits<char>::min()));
		max_data_type = QVariant::fromValue(static_cast<char>(std::numeric_limits<char>::max()));
		value_variant = QVariant::fromValue(static_cast<char>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_UINT16:
		decimal = false;
		type_text = "UINT16";
		min_data_type = QVariant::fromValue(static_cast<quint16>(std::numeric_limits<quint16>::min()));
		max_data_type = QVariant::fromValue(static_cast<quint16>(std::numeric_limits<quint16>::max()));
		value_variant = QVariant::fromValue(static_cast<quint16>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_INT16:
		decimal = false;
		type_text = "INT16";
		min_data_type = QVariant::fromValue(static_cast<qint16>(std::numeric_limits<qint16>::min()));
		max_data_type = QVariant::fromValue(static_cast<qint16>(std::numeric_limits<qint16>::max()));
		value_variant = QVariant::fromValue(static_cast<qint16>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_UINT32:
		decimal = false;
		type_text = "UINT32";
		min_data_type = QVariant::fromValue(static_cast<quint32>(std::numeric_limits<quint32>::min()));
		max_data_type = QVariant::fromValue(static_cast<quint32>(std::numeric_limits<quint32>::max()));
		value_variant = QVariant::fromValue(static_cast<quint32>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_INT32:
		decimal = false;
		type_text = "INT32";
		min_data_type = QVariant::fromValue(static_cast<qint32>(std::numeric_limits<qint32>::min()));
		max_data_type = QVariant::fromValue(static_cast<qint32>(std::numeric_limits<qint32>::max()));
		value_variant = QVariant::fromValue(static_cast<qint32>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_UINT64:
		decimal = false;
		type_text = "UINT64";
		min_data_type = QVariant::fromValue(static_cast<quint64>(std::numeric_limits<quint64>::min()));
		max_data_type = QVariant::fromValue(static_cast<quint64>(std::numeric_limits<quint64>::max()));
		value_variant = QVariant::fromValue(static_cast<quint64>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_INT64:
		decimal = false;
		type_text = "INT64";
		min_data_type = QVariant::fromValue(static_cast<qint64>(std::numeric_limits<qint64>::min()));
		max_data_type = QVariant::fromValue(static_cast<qint64>(std::numeric_limits<qint64>::max()));
		value_variant = QVariant::fromValue(static_cast<qint64>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_REAL32:
		decimal = true;
		type_text = "REAL32";
		min_data_type = QVariant::fromValue(static_cast<float>(std::numeric_limits<float>::min()));
		max_data_type = QVariant::fromValue(static_cast<float>(std::numeric_limits<float>::max()));
		value_variant = QVariant::fromValue(static_cast<float>(value));
		break;

	case MAV_PARAM_TYPE::MAV_PARAM_TYPE_REAL64:
		decimal = true;
		type_text = "REAL64";
		min_data_type = QVariant::fromValue(static_cast<double>(std::numeric_limits<double>::min()));
		max_data_type = QVariant::fromValue(static_cast<double>(std::numeric_limits<double>::max()));
		value_variant = QVariant::fromValue(static_cast<double>(value));
		break;

	default:
		decimal = true;
		type_text = "N/A";
		min_data_type = QVariant::fromValue(static_cast<double>(std::numeric_limits<double>::min()));
		max_data_type = QVariant::fromValue(static_cast<double>(std::numeric_limits<double>::max()));
		value_variant = QVariant::fromValue(static_cast<double>(value));
		// qWarning() << "unsupported param type";
		break;
	}

	if (!isExist(id)) {
		QString firmware = variable.getText("AIRCRAFT_TYPE");

		if (firmware == "FIXEDWING") {
			firmware = "ArduPlane";

		} else if (firmware == "MULTIROTOR") {
			firmware = "ArduCopter";
		}

		param_fact_s *fact = ParamMetaData::instance()->getFact(firmware, id);

		if (!fact) {
			fact = new param_fact_s();
			// qWarning() << id << "not found in" << firmware;
		}

		QVariant fact_min(QVariant::fromValue(fact->min.isEmpty() ? min_data_type : fact->min));
		fact_min.convert(static_cast<int>(value_variant.type()));

		QVariant fact_max(QVariant::fromValue(fact->max.isEmpty() ? max_data_type : fact->max));
		fact_max.convert(static_cast<int>(value_variant.type()));

		QVariant fact_increment_size(QVariant::fromValue(fact->increment_size.isEmpty()
					     ? QVariant::fromValue(decimal ? float(0.1) : int(1))
					     : fact->increment_size));

		fact_increment_size.convert(static_cast<int>(value_variant.type()));

		param->setIndex(index);
		param->setGroup(fact->group);
		param->setCategory(fact->category);
		param->setShortDescription(fact->short_description);
		param->setLongDescription(fact->long_description);
		param->setUnits(fact->units);
		param->setUnitText(fact->unit_text);
		param->setType(type);
		param->setTypeText(type_text);
		param->setDecimal(decimal);
		param->setMin(fact_min);
		param->setMax(fact_max);
		param->setIncrementSize(fact_increment_size);
		param->setRebootRequired(fact->reboot_required);
	}

	param->setValue(value_variant);

	if (isExist(id)) {
		model->replaceObject(indexOf(id), param);
		emit notifyChanges(param);

	} else {
		param->setID(id);
		model->addObject(param);
	}
}

ParamItem *ParamService::get(const QString &id)
{
	if (isExist(id)) {
		return model->object(indexOf(id));
	}

	return other;
}

ParamItem *ParamService::get(const int &row)
{
	const QModelIndex index = model->index(row, 0);

	if (index.isValid()) {
		return model->object(index);
	}

	return other;
}

void ParamService::print(const QString &id)
{
	if (id == "") {
		for (ParamItem *i : model->objects()) {
			print(i);
		}

		return;
	}

	if (isExist(id)) {
		print(model->object(indexOf(id)));

	} else {
		qCritical() << id << "not found";
	}
}

void ParamService::print(const ParamItem *param)
{
	// TODO: adjust spaces & print details

	qDebug() << param->getID() << param->getTypeText() << param->getValue();
}
