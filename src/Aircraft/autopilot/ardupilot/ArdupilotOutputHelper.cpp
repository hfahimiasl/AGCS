#include "ArdupilotOutputHelper.h"


ArdupilotOutputHelper::ArdupilotOutputHelper()
{
	for (const QString &key : output_function.keys()) {
		output_function_param_base.insert(output_function.value(key), key);
	}

	for (const QString &key : camera_trigger_type.keys()) {
		camera_trigger_type_param_base.insert(camera_trigger_type.value(key), key);
	}

	for (const QString &key : camera_trigger_relay_pin.keys()) {
		camera_trigger_relay_pin_param_base.insert(camera_trigger_relay_pin.value(key), key);
	}

	for (const QString &key : camera_trigger_servo_pin.keys()) {
		camera_trigger_servo_pin_param_base.insert(camera_trigger_servo_pin.value(key), key);
	}
}

ArdupilotOutputHelper *ArdupilotOutputHelper::instance()
{
	static ArdupilotOutputHelper ardupilot_output_helper;
	return &ardupilot_output_helper;
}

int16_t ArdupilotOutputHelper::getRate()
{
	const QVariant param = ParamService::instance()->get("SERVO_RATE")->getValue();
	return param == QVariant::Invalid ? -1 : int16_t(param.toUInt());
}

void ArdupilotOutputHelper::setRate(uint16_t rate)
{
	emit ParamService::instance()->notifyUpload("SERVO_RATE", rate < 25 ? 25 : (rate > 400 ? 400 : rate));
}

int16_t ArdupilotOutputHelper::getMin(uint8_t channel)
{
	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("SERVO%1_MIN").arg(channel))->getValue();

		if (param != QVariant::Invalid) {
			return int16_t(param.toUInt());
		}
	}

	return -1;
}

void ArdupilotOutputHelper::setMin(uint8_t channel, uint16_t min)
{
	if (channel != 0 && channel <= 16) {
		emit ParamService::instance()->notifyUpload(QString("SERVO%1_MIN").arg(channel), min < 500 ? 500 : (min > 2200 ? 2200 : min));
	}
}

int16_t ArdupilotOutputHelper::getMax(uint8_t channel)
{
	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("SERVO%1_MAX").arg(channel))->getValue();

		if (param != QVariant::Invalid) {
			return int16_t(param.toUInt());
		}
	}

	return -1;
}

void ArdupilotOutputHelper::setMax(uint8_t channel, uint16_t max)
{
	if (channel != 0 && channel <= 16) {
		emit ParamService::instance()->notifyUpload(QString("SERVO%1_MAX").arg(channel), max < 800 ? 800 : (max > 2200 ? 2200 : max));
	}
}

int16_t ArdupilotOutputHelper::getTrim(uint8_t channel)
{
	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("SERVO%1_TRIM").arg(channel))->getValue();

		if (param != QVariant::Invalid) {
			return int16_t(param.toUInt());
		}
	}

	return -1;
}

void ArdupilotOutputHelper::setTrim(uint8_t channel, uint16_t trim)
{
	if (channel != 0 && channel <= 16) {
		emit ParamService::instance()->notifyUpload(QString("SERVO%1_TRIM").arg(channel), trim < 800 ? 800 : (trim > 2200 ? 2200 : trim));
	}
}

bool ArdupilotOutputHelper::isReversed(uint8_t channel)
{
	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("SERVO%1_REVERSED").arg(channel))->getValue();

		if (param != QVariant::Invalid) {
			return int16_t(param.toUInt());
		}
	}

	return false;
}

void ArdupilotOutputHelper::setReversed(uint8_t channel, bool reversed)
{
	if (channel != 0 && channel <= 16) {
		emit ParamService::instance()->notifyUpload(QString("SERVO%1_REVERSED").arg(channel), reversed);
	}
}

QString ArdupilotOutputHelper::getFunction(uint8_t channel)
{
	QString ret = "N/A";

	if (channel != 0 && channel <= 16) {
		const QVariant param = ParamService::instance()->get(QString("SERVO%1_FUNCTION").arg(channel))->getValue();

		if (param != QVariant::Invalid && output_function_param_base.contains(uint8_t(param.toUInt()))) {
			ret = output_function_param_base.value(uint8_t(param.toUInt()));
		}
	}

	return ret;
}

QList<QString> ArdupilotOutputHelper::getAllFunctions()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : output_function.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotOutputHelper::setFunction(uint8_t channel, QString function)
{
	if (channel != 0 && channel <= 16) {
		if (output_function.contains(function)) {
			emit ParamService::instance()->notifyUpload(QString("SERVO%1_FUNCTION").arg(channel), output_function[function]);
		}
	}
}

QString ArdupilotOutputHelper::getCameraTriggerType()
{
	QString ret = "N/A";

	const QVariant param = ParamService::instance()->get("CAM_TRIGG_TYPE")->getValue();

	if (param != QVariant::Invalid && camera_trigger_type_param_base.contains(uint8_t(param.toUInt()))) {
		ret = camera_trigger_type_param_base.value(uint8_t(param.toUInt()));
	}

	return ret;
}

QList<QString> ArdupilotOutputHelper::getAllCameraTriggerTypes()
{
	QList<QString> list;
	list.clear();

	for (const QString &key : camera_trigger_type.keys()) {
		list.append(key);
	}

	return list;
}

void ArdupilotOutputHelper::setCameraTriggerType(QString type)
{
	if (camera_trigger_type.contains(type)) {
		setCameraTriggerPin("Disabled");

		emit ParamService::instance()->notifyUpload("CAM_TRIGG_TYPE", camera_trigger_type.value(type));
	}
}

QString ArdupilotOutputHelper::getCameraTriggerPin()
{
	const QString type = getCameraTriggerType();

	if (type == "Relay") {
		const QVariant param = ParamService::instance()->get("RELAY_PIN")->getValue();

		if (param != QVariant::Invalid && camera_trigger_relay_pin_param_base.contains(int8_t(param.toInt()))) {
			return camera_trigger_relay_pin_param_base.value(int8_t(param.toInt()));
		}

	} else if (type == "Servo") {
		for (uint8_t i = 1 ; i <= 16 ; i++) {
			if (getFunction(i) == "camera_trigger") {
				return camera_trigger_servo_pin_param_base.value(i);
			}
		}

		return camera_trigger_servo_pin_param_base.value(0);
	}

	return "N/A";
}

QList<QString> ArdupilotOutputHelper::getAllCameraTriggerPins()
{
	QList<QString> list;
	list.clear();

	const QString type = getCameraTriggerType();

	if (type == "Relay") {
		for (const QString &key : camera_trigger_relay_pin.keys()) {
			list.append(key);
		}

	} else if (type == "Servo") {
		for (const QString &key : camera_trigger_servo_pin.keys()) {
			list.append(key);
		}
	}

	return list;
}

void ArdupilotOutputHelper::setCameraTriggerPin(QString pin)
{
	const QString type = getCameraTriggerType();

	if (type == "Relay") {
		if (camera_trigger_relay_pin.contains(pin)) {
			emit ParamService::instance()->notifyUpload("RELAY_PIN", camera_trigger_relay_pin.value(pin));
		}

	} else if (type == "Servo") {
		if (camera_trigger_servo_pin.contains(pin)) {
			for (const QString &key : camera_trigger_servo_pin.keys()) {
				if (getFunction(camera_trigger_servo_pin.value(key)) == "camera_trigger") {
					setFunction(camera_trigger_servo_pin.value(key), "Disabled");
				}
			}

			if (camera_trigger_servo_pin.value(pin) != 0) {
				setFunction(camera_trigger_servo_pin.value(pin), "camera_trigger");
			}
		}
	}
}
