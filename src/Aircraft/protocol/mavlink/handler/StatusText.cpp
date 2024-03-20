#include "StatusText.h"


StatusText::StatusText(MAVLink *mavlink) : AbstractHandler(mavlink) {}

void StatusText::handle(const mavlink_message_t &message)
{
	if (message.msgid != MAVLINK_MSG_ID_STATUSTEXT) { return; }

	mavlink_statustext_t status_text {};
	mavlink_msg_statustext_decode(&message, &status_text);

	const QString text = QByteArray(status_text.text, MAVLINK_MSG_STATUSTEXT_FIELD_TEXT_LEN).trimmed();

	status_text.severity == 6 ? toast.info(text, 5000) : toast.error(text, 5000);
}
