#include "ArdupilotFrameHelper.h"


ArdupilotFrameHelper::ArdupilotFrameHelper()
{
	for (QString key : frame_class.keys()) {
		frame_class_param_base.insert(frame_class.value(key), key);
	}
}

ArdupilotFrameHelper *ArdupilotFrameHelper::instance()
{
	static ArdupilotFrameHelper ardupilot_frame_helper;
	return &ardupilot_frame_helper;
}

QString ArdupilotFrameHelper::getClass()
{
	QString ret;
	QVariant frame_class_param = ParamService::instance()->get("FRAME_CLASS")->getValue();
	ret = frame_class_param == QVariant::Invalid || !frame_class_param_base.contains(uint8_t(frame_class_param.toUInt()))
	      ? "N/A"
	      : frame_class_param_base.value(uint8_t(frame_class_param.toUInt()));
	return ret;
}

QString ArdupilotFrameHelper::getType()
{
	QString ret;
	QVariant frame_type_param = ParamService::instance()->get("FRAME_TYPE")->getValue();
	ret = frame_type_param == QVariant::Invalid || !frame_type_param_base.contains(uint8_t(frame_type_param.toUInt()))
	      ? "N/A"
	      : frame_type_param_base.value(uint8_t(frame_type_param.toUInt()));
	return ret;
}

bool ArdupilotFrameHelper::set(QString class_name, QString type_name)
{
	if (frame_class.contains(class_name)
	    && frame_type.contains(frame_class.value(class_name))
	    && frame_type.value(frame_class.value(class_name)).contains(type_name)) {
		emit ParamService::instance()->notifyUpload("FRAME_CLASS", frame_class.value(class_name));
		emit ParamService::instance()->notifyUpload("FRAME_TYPE", frame_type.value(frame_class.value(class_name)).value(type_name));
		return true;
	}

	return false;
}
