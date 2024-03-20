#include "Support.h"


Support::Support() :
	tickets_list_manager(new QNetworkAccessManager()),
	add_ticket_manager(new QNetworkAccessManager()),
	ticket_messages_manager(new QNetworkAccessManager()),
	add_message_manager(new QNetworkAccessManager()),
	plans_manager(new QNetworkAccessManager())
{
	QObject::connect(tickets_list_manager, &QNetworkAccessManager::finished,
			 this, &Support::onTicketsListManagerFinished);

	QObject::connect(add_ticket_manager, &QNetworkAccessManager::finished,
			 this, &Support::onAddTicketManagerFinished);

	QObject::connect(ticket_messages_manager, &QNetworkAccessManager::finished,
			 this, &Support::onTicketMessagesManagerFinished);

	QObject::connect(add_message_manager, &QNetworkAccessManager::finished,
			 this, &Support::onAddMessageManagerFinished);

	QObject::connect(plans_manager, &QNetworkAccessManager::finished,
			 this, &Support::onPlansManagerFinished);
}

Support::~Support()
{
	delete tickets_list_manager;
	delete add_ticket_manager;
	delete ticket_messages_manager;
	delete add_message_manager;
	delete plans_manager;
}

Support *Support::instance()
{
	static Support self;
	return &self;
}

void Support::init(const QString &url)
{
	base_url = url;
}

void Support::requestTicketsList()
{
	tickets_list_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/support/ticket/list"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	tickets_list_manager->get(request);
}

void Support::onTicketsListManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint16_t code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "tickets list manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		tickets_list_map.clear();

		QJsonArray jsonArray = jsonObj.value("record").toArray();

		for (auto i = jsonArray.constBegin() ; i != jsonArray.constEnd() ; ++i) {
			const QJsonObject jsonObj = i->toObject();

			tickets_list_map.insert(jsonObj.value("id").toString(), {
				{
					"user", jsonObj.value("user").toObject().value("first_name").toString()
					+ " "
					+ jsonObj.value("user").toObject().value("last_name").toString()
				},
				{"subject", jsonObj.value("subject").toString()},
				{"product", jsonObj.value("product").toString()},
				{"type", jsonObj.value("type").toString()},
				{"state", jsonObj.value("state").toString()},
				{
					"support_user", jsonObj.value("support_user").toObject().value("first_name").toString()
					+ " "
					+ jsonObj.value("support_user").toObject().value("last_name").toString()
				},
				{"createdAt", jsonObj.value("createdAt").toString()},
				{"updatedAt", jsonObj.value("updatedAt").toString()}
			});
		}

		emit notifyTicketsList(tickets_list_map.keys());

	} else {
		if (code == 401 || code == 403) {
			UserAuthentication::instance()->refresh();
		}

		emit errorTicketsList();
	}
}

QString Support::getTicketInfo(QString id, QString key)
{
	if (tickets_list_map.contains(id) && tickets_list_map.value(id).contains(key)) {
		if (key == "state") {
			if (ticket_state_map.contains(tickets_list_map.value(id).value(key))) {
				const QString state = tickets_list_map.value(id).value(key);

				if (state == "CustomerMessage") {
					return ticket_state_map.value(state)
					       + " ("
					       + tickets_list_map.value(id).value("user")
					       + ")";
				}

				if (state == "SupportMessage") {
					return ticket_state_map.value(state)
					       + " ("
					       + tickets_list_map.value(id).value("support_user")
					       + ")";
				}

				if (state == "Open") {
					return ticket_state_map.value(state)
					       + " ("
					       + tickets_list_map.value(id).value("user")
					       + ")";
				}

				return ticket_state_map.value(state);

			} else {
				return "N/A";
			}

		}

		return tickets_list_map.value(id).value(key);
	}

	return "N/A";
}

void Support::requestAddTicket(QString subject, QString type, QString text)
{
	add_ticket_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/support/ticket/create"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	const QString body = "{\"subject\":\"" + subject +
			     "\",\"type\":\"" + type +
			     "\",\"message\":\"" + getFilteredMessage(text) +
			     "\",\"product\":\"" + ("نرم افزار agcs") +
			     "\"}";
	add_ticket_manager->post(request, body.toUtf8());
}

void Support::onAddTicketManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint16_t code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "add ticket manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 201) {
		emit notifyAddTicket();

	} else {
		if (code == 401 || code == 403) {
			UserAuthentication::instance()->refresh();
		}

		emit errorAddTicket();
	}
}

void Support::requestTicketMessages(QString id)
{
	ticket_messages_manager->clearConnectionCache();
	ticket_messages_url = base_url + "/support/message/" + id + "/list";
	QNetworkRequest request(QUrl(base_url + "/support/message/" + id + "/list"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	ticket_messages_manager->get(request);
}

void Support::onTicketMessagesManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint16_t code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	if (url != ticket_messages_url) { return; }

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "ticket messages manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		ticket_messages_map.clear();

		QJsonArray jsonArray = jsonObj.value("record").toArray();

		for (auto i = jsonArray.constBegin() ; i != jsonArray.constEnd() ; ++i) {
			const QJsonObject jsonObj = i->toObject();

			ticket_messages_map.insert(jsonObj.value("id").toString(), {
				{"user", jsonObj.value("user").toString()},
				{"ticket", jsonObj.value("ticket").toString()},
				{"message", jsonObj.value("message").toString()},
				{"sentAt", jsonObj.value("sentAt").toString()}
			});
		}

		emit notifyTicketMessages(ticket_messages_map.keys());

	} else {
		if (code == 401 || code == 403) {
			UserAuthentication::instance()->refresh();
		}

		emit errorTicketMessages();
	}
}

QString Support::getMessageInfo(QString id, QString key)
{
	if (ticket_messages_map.contains(id) && ticket_messages_map.value(id).contains(key)) {
		return ticket_messages_map.value(id).value(key);
	}

	return "N/A";
}

void Support::requestAddMessage(QString id, QString message)
{
	add_message_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/support/message/" + id + "/create"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	const QString body = "{\"message\":\"" + getFilteredMessage(message) + "\"}";
	add_message_manager->post(request, body.toUtf8());
}

void Support::onAddMessageManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint16_t code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	// qDebug() << "add message manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 201) {
		emit notifyAddMessage();

	} else {
		if (code == 401 || code == 403) {
			UserAuthentication::instance()->refresh();
		}

		emit errorAddMessage();
	}
}

QString Support::getFilteredMessage(QString str)
{
	for (int i = 0 ; i < str.length() ; i++) {
		if (str[i] == '\xa') {
			str[i] = '\\';
			str.insert(i + 1, 'n');

		} else if (str[i] == '"') {
			str.insert(i, '\\');
			i++;
		}
	}

	return str;
}

void Support::requestPlans()
{
	plans_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/support/plans"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	plans_manager->get(request);
}

void Support::onPlansManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint16_t code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "plans manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		jsonObj = jsonObj.value("plans").toObject();

		plans_map.clear();
		plans_map.insert("base", getPlanPrice(jsonObj.value("base").toString()));
		plans_map.insert("bronze", getPlanPrice(jsonObj.value("bronze").toString()));
		plans_map.insert("silver", getPlanPrice(jsonObj.value("silver").toString()));
		plans_map.insert("palladium", getPlanPrice(jsonObj.value("palladium").toString()));
		plans_map.insert("gold", getPlanPrice(jsonObj.value("gold").toString()));
		plans_map.insert("platinum", getPlanPrice(jsonObj.value("platinum").toString()));

		emit notifyPlans(jsonObj.keys());

	} else {
		if (code == 401 || code == 403) {
			UserAuthentication::instance()->refresh();
		}

		emit errorPlans();
	}
}

QString Support::getPlanInfo(QString key)
{
	if (plans_map.contains(key)) {
		return plans_map.value(key);
	}

	return "N/A";
}

QString Support::getPlanPrice(QString value)
{
	return value == "0" ? tr("رایگان") : (value == "call_me" ? QObject::tr("تماس بگیرید") :
			QString("%1 تومان در ماه").arg(value));
}
