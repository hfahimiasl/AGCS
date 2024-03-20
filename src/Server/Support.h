#pragma once

#include <QObject>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QApplication>
#include <QJsonArray>
#include <QDebug>

#include "UserAuthentication.h"

#include "src/System/Global.h"
#include "src/System/Settings.h"


class Support : public QObject
{
	Q_OBJECT
	Q_DISABLE_COPY(Support)

public:
	explicit Support();
	~Support();

	static Support *instance();

	void init(const QString &);

signals:
	void notifyTicketsList(const QList<QString> &id);
	void errorTicketsList();
	void notifyAddTicket();
	void errorAddTicket();
	void notifyTicketMessages(const QList<QString> &id);
	void errorTicketMessages();
	void notifyAddMessage();
	void errorAddMessage();
	void notifyPlans(const QList<QString> &id);
	void errorPlans();

public slots:
	void requestTicketsList();
	QString getTicketInfo(QString, QString);
	void requestAddTicket(QString, QString, QString);
	void requestTicketMessages(QString);
	QString getMessageInfo(QString, QString);
	void requestAddMessage(QString, QString);
	void requestPlans();
	QString getPlanInfo(QString);

private slots:
	void onTicketsListManagerFinished(QNetworkReply *);
	void onAddTicketManagerFinished(QNetworkReply *);
	void onTicketMessagesManagerFinished(QNetworkReply *);
	void onAddMessageManagerFinished(QNetworkReply *);
	void onPlansManagerFinished(QNetworkReply *);

private:
	QNetworkAccessManager *tickets_list_manager;
	QNetworkAccessManager *add_ticket_manager;
	QNetworkAccessManager *ticket_messages_manager;
	QNetworkAccessManager *add_message_manager;
	QNetworkAccessManager *plans_manager;

	QString base_url;

	QMap<QString, QMap<QString, QString>> tickets_list_map;
	QMap<QString, QMap<QString, QString>> ticket_messages_map;

	QMap<QString, QString> plans_map;

	const QMap<QString, QString> ticket_state_map {
		{"Open",            tr("باز")},
		{"Waiting",         tr("در انتظار پاسخ")},
		{"Close",           tr("بسته شده")},
		{"CustomerMessage", tr("پیام کاربر")},
		{"SupportMessage",  tr("پیام پشتیبان")},
	};

	QString ticket_messages_url;

	QString getFilteredMessage(QString);

	QString getPlanPrice(QString);
};
