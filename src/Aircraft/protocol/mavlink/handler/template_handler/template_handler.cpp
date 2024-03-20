#include "template_handler.h"


TEMPLATE::TEMPLATE(MAVLink *mavlink) :
	AbstractHandler(mavlink)
{
	variable.add("TEMPLATE_VARIABLE", 0.0, "This is a template");
}

void TEMPLATE::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_TEMPLATE) { return; }

	mavlink_template_message_t template_message;
	mavlink_msg_template_decode(&message, &template_message);

	variable.setValue("TEMPLATE_VARIABLE", template_message.varibale);
	variable.setText("TEMPLATE_VARIABLE", "This is a template");
}
