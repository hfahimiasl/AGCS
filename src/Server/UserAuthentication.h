#pragma once

#include <QObject>
#include <QTimer>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include <QApplication>
#include <QJsonArray>

#include "src/System/Settings.h"
#include "src/System/Global.h"
#include "src/System/Clock.h"
#include "src/System/Toast.h"

using namespace Global;

class UserAuthentication : public QObject
{
	Q_OBJECT

public:
	explicit UserAuthentication();
	~UserAuthentication();

	static UserAuthentication *instance();

	void init(const QString &);

	void resetSettings();

signals:
	void notifyValidation();
	void notifyError(QString error);
	void notifySignup();
	void notifySignin();
	void notifyLogout();
	void notifyResetPassword();

public slots:
	bool isSignin();
	void validation();
	void signup(QString, QString, QString, QString, QString, QString, QString, QString, QString);
	void signin(QString, QString);
	void logout();
	void resetPassword(QString);
	void refresh();

private slots:
	void validationManagerFinished(QNetworkReply *);
	void signupManagerFinished(QNetworkReply *);
	void signinManagerFinished(QNetworkReply *);
	void resetPasswordManagerFinished(QNetworkReply *);
	void refreshManagerFinished(QNetworkReply *);

private:
	QTimer *validation_timer {nullptr};
	QTimer *ttl_timer {nullptr};

	QNetworkAccessManager *validation_manager {nullptr};
	QNetworkAccessManager *signup_manager {nullptr};
	QNetworkAccessManager *signin_manager {nullptr};
	QNetworkAccessManager *reset_password_manager {nullptr};
	QNetworkAccessManager *refresh_manager {nullptr};

	QString base_url;

	static constexpr const char *kChargeURL {"https://account.adlanpaya.ir/buy-agcs"};

	static constexpr quint16 kValidationTimeout {60_s};
	static constexpr quint16 kTTLTimeout {1_s};

	bool offlineTimeValidation();
	bool accountValidation(QJsonObject, QString);
};
