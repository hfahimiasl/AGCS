#include "UserAuthentication.h"


UserAuthentication::UserAuthentication() :
	validation_timer(new QTimer(this)),
	ttl_timer(new QTimer(this)),
	validation_manager(new QNetworkAccessManager(this)),
	signup_manager(new QNetworkAccessManager(this)),
	signin_manager(new QNetworkAccessManager(this)),
	reset_password_manager(new QNetworkAccessManager(this)),
	refresh_manager(new QNetworkAccessManager(this))
{
	QObject::connect(validation_manager, &QNetworkAccessManager::finished,
			 this, &UserAuthentication::validationManagerFinished);

	QObject::connect(signup_manager, &QNetworkAccessManager::finished,
			 this, &UserAuthentication::signupManagerFinished);

	QObject::connect(signin_manager, &QNetworkAccessManager::finished,
			 this, &UserAuthentication::signinManagerFinished);

	QObject::connect(reset_password_manager, &QNetworkAccessManager::finished,
			 this, &UserAuthentication::resetPasswordManagerFinished);

	QObject::connect(refresh_manager, &QNetworkAccessManager::finished,
			 this, &UserAuthentication::refreshManagerFinished);

	QObject::connect(ttl_timer, &QTimer::timeout, this, [ = ]() {
		const QVariant user_ttl = Settings::instance()->get(SystemSettings::UserTTL);

		if (user_ttl != QVariant::Invalid) {
			const qint64 ttl = qvariant_cast<qint64>(user_ttl);

			if (ttl <= 0) {
				logout();
				toast.warn(("اعتبار حساب کاربری شما به اتمام رسیده است. لطفا برای شارژ مجدد حساب خود اقدام نمایید."),
					   10000);
				return;
			}

			Settings::instance()->set(SystemSettings::UserTTL, ttl - 1);
		}
	});
}

UserAuthentication::~UserAuthentication()
{
	Settings::instance()->set(SystemSettings::QuitClock, Clock::getTime());
}

UserAuthentication *UserAuthentication::instance()
{
	static UserAuthentication self;
	return &self;
}

void UserAuthentication::init(const QString &url)
{
	base_url = url;

	QObject::connect(validation_timer, &QTimer::timeout, this, QOverload<>::of(&UserAuthentication::validation));

	if (isSignin()) {
		if (!offlineTimeValidation()) {
			logout();
			toast.warn(("اعتبار حساب کاربری شما به اتمام رسیده است. لطفا برای شارژ مجدد حساب خود اقدام نمایید."),
				   10000);
			return;
		}

		validation_timer->start(UserAuthentication::kValidationTimeout);
		ttl_timer->start(UserAuthentication::kTTLTimeout);
		validation();
	}
}

bool UserAuthentication::isSignin()
{
	return Settings::instance()->get(SystemSettings::UserAccessToken).toString().length() > 20;
}

void UserAuthentication::validation()
{
	validation_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/auth/info"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	validation_manager->get(request);
}

void UserAuthentication::validationManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "validation manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	// "accesses":[]
	// "active":true
	// "address":""
	// "avatar":"https://agcs.adlanpaya.ir/public/img/default_avatar.jpg"
	// "balance":0
	// "bio":""
	// "birth_day":null
	// "createdAt":"2021-07-19T16:58:31.403Z"
	// "email":"dir.uav@gmail.com"
	// "email_verify":true
	// "exp":1627020164
	// "father_name":""
	// "first_name":"????"
	// "iat":1626933764
	// "id":"60f5af3790821a3b9115b9e1"
	// "last_name":"?????"
	// "last_signin":"2021-07-22T06:02:44.459Z"
	// "national_code":""
	// "phone":"09302161068"
	// "phone_verify":false
	// "updatedAt":"2021-07-22T06:02:44.460Z"

	switch (code) {
	case 0:
		emit notifyError(QObject::tr("خطا در برقراری ارتباط"));
		break;

	case 200: {
			const QJsonObject record = jsonObj.value("record").toObject();

			if (!accountValidation(record, jsonObj.value("timestamp").toString())) {
				logout();
				return;
			}

			Settings::instance()->set(SystemSettings::UserAuthAccesses,     record.value("accesses").toString());
			Settings::instance()->set(SystemSettings::UserAuthActive,       record.value("active").toBool());
			Settings::instance()->set(SystemSettings::UserAuthAddress,      record.value("address").toString());
			Settings::instance()->set(SystemSettings::UserAuthAvatar,       record.value("avatar").toString());
			Settings::instance()->set(SystemSettings::UserAuthBalance,      record.value("balance").toInt());
			Settings::instance()->set(SystemSettings::UserAuthBio,          record.value("bio").toString());
			Settings::instance()->set(SystemSettings::UserAuthBirthday,     record.value("birth_day").toString());
			Settings::instance()->set(SystemSettings::UserAuthCreatedAt,    record.value("createdAt").toString());
			Settings::instance()->set(SystemSettings::UserAuthEmail,        record.value("email").toString());
			Settings::instance()->set(SystemSettings::UserAuthEmailVerify,  record.value("email_verify").toBool());
			Settings::instance()->set(SystemSettings::UserAuthEXP,          record.value("exp").toInt());
			Settings::instance()->set(SystemSettings::UserAuthFatherName,   record.value("father_name").toString());
			Settings::instance()->set(SystemSettings::UserAuthFirstName,    record.value("first_name").toString());
			Settings::instance()->set(SystemSettings::UserAuthIAT,          record.value("iat").toInt());
			Settings::instance()->set(SystemSettings::UserAuthID,           record.value("id").toString());
			Settings::instance()->set(SystemSettings::UserAuthLastName,     record.value("last_name").toString());
			Settings::instance()->set(SystemSettings::UserAuthLastSignIn,   record.value("last_signin").toString());
			Settings::instance()->set(SystemSettings::UserAuthNationalCode, record.value("national_code").toString());
			Settings::instance()->set(SystemSettings::UserAuthPhone,        record.value("phone").toString());
			Settings::instance()->set(SystemSettings::UserAuthPhoneVerify,  record.value("phone_verify").toBool());
			Settings::instance()->set(SystemSettings::UserAuthUpdatedAt,    record.value("updatedAt").toString());
			emit notifyValidation();
			break;
		}

	case 401:
	case 403:
		refresh();
		break;

	default:
		emit notifyError(jsonObj.value("message").toString());
		break;
	}
}

void UserAuthentication::signup(QString first_name, QString last_name, QString email, QString password, QString phone,
				QString address, QString national_code, QString birthday, QString father_name)
{
	signup_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/auth/signup"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	QString body = "{\"first_name\" : \"" + first_name
		       + "\",\"last_name\" : \"" + last_name
		       + "\",\"password\" : \"" + password
		       + "\",\"email\" : \"" + email
		       + "\",\"phone\" : \"" + phone
		       + "\",\"address\" : \"" + address
		       + "\",\"national_code\" : \"" + national_code
		       + "\",\"birth_day\" : \"" + birthday
		       + "\",\"father_name\" : \"" + father_name
		       + "\"}";
	signup_manager->post(request, body.toUtf8());
}

void UserAuthentication::signupManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "signup manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 201) {
		emit notifySignup();

	} else {
		emit notifyError(jsonObj.value("message").toString());
	}
}

void UserAuthentication::signin(QString username, QString password)
{
	signin_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/auth/signin"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	QString body = "{\"username\":\"" + username
		       + "\",\"password\":\"" + password
		       + "\"}";
	signin_manager->post(request, body.toUtf8());
}

void UserAuthentication::signinManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "signin manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	switch (code) {
	case 0:
		emit notifyError(QObject::tr("خطا در برقراری ارتباط"));
		break;

	case 200: {
			const QJsonObject record = jsonObj.value("record").toObject();

			if (!accountValidation(record.value("user").toObject(), jsonObj.value("timestamp").toString())) {
				return;
			}

			Settings::instance()->set(SystemSettings::UserAccessToken, QString("Bearer %1").arg(record.value("token").toString()));
			Settings::instance()->set(SystemSettings::UserRefreshToken, record.value("refresh").toString());
			validation_timer->start(UserAuthentication::kValidationTimeout);
			ttl_timer->start(UserAuthentication::kTTLTimeout);
			validation();
			emit notifySignin();
			break;
		}

	default:
		emit notifyError(jsonObj.value("message").toString());
		break;
	}
}

void UserAuthentication::logout()
{
	validation_timer->stop();
	ttl_timer->stop();
	resetSettings();
	emit notifyLogout();
}

void UserAuthentication::resetPassword(QString email)
{
	signin_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/auth/reset-password-email"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	QString body = "{\"email\":\"" + email + "\"}";
	reset_password_manager->post(request, body.toUtf8());
}

void UserAuthentication::resetPasswordManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "reset manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	switch (code) {
	case 0:
		emit notifyError(QObject::tr("خطا در برقراری ارتباط"));
		break;

	case 200:
		emit notifyResetPassword();
		break;

	default:
		emit notifyError(jsonObj.value("message").toString());
		break;
	}
}

void UserAuthentication::resetSettings()
{
	Settings::instance()->set(SystemSettings::UserTTL,              0);
	Settings::instance()->set(SystemSettings::UserAccessToken,      "");
	Settings::instance()->set(SystemSettings::UserRefreshToken,     "");
	Settings::instance()->set(SystemSettings::UserAuthAccesses,     "");
	Settings::instance()->set(SystemSettings::UserAuthActive,       false);
	Settings::instance()->set(SystemSettings::UserAuthAddress,      "");
	Settings::instance()->set(SystemSettings::UserAuthAvatar,       "");
	Settings::instance()->set(SystemSettings::UserAuthBalance,      0);
	Settings::instance()->set(SystemSettings::UserAuthBio,          "");
	Settings::instance()->set(SystemSettings::UserAuthBirthday,     "");
	Settings::instance()->set(SystemSettings::UserAuthCreatedAt,    "");
	Settings::instance()->set(SystemSettings::UserAuthEmail,        "");
	Settings::instance()->set(SystemSettings::UserAuthEmailVerify,  false);
	Settings::instance()->set(SystemSettings::UserAuthEXP,          0);
	Settings::instance()->set(SystemSettings::UserAuthFatherName,   "");
	Settings::instance()->set(SystemSettings::UserAuthFirstName,    "");
	Settings::instance()->set(SystemSettings::UserAuthIAT,          0);
	Settings::instance()->set(SystemSettings::UserAuthID,           "");
	Settings::instance()->set(SystemSettings::UserAuthLastName,     "");
	Settings::instance()->set(SystemSettings::UserAuthLastSignIn,   "");
	Settings::instance()->set(SystemSettings::UserAuthNationalCode, "");
	Settings::instance()->set(SystemSettings::UserAuthPhone,        "");
	Settings::instance()->set(SystemSettings::UserAuthPhoneVerify,  false);
	Settings::instance()->set(SystemSettings::UserAuthUpdatedAt,    "");
}

void UserAuthentication::refresh()
{
	if (!isSignin()) {
		return;
	}

	refresh_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/auth/refresh"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	QString body = "{\"token\":\"" + Settings::instance()->get(SystemSettings::UserRefreshToken).toString() + "\"}";
	refresh_manager->post(request, body.toUtf8());
}

void UserAuthentication::refreshManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "refresh manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

	if (code == 200) {
		Settings::instance()->set(SystemSettings::UserAccessToken,
					  QString("Bearer %1").arg(jsonObj.value("record").toObject().value("token").toString()));
		Settings::instance()->set(SystemSettings::UserRefreshToken,
					  jsonObj.value("record").toObject().value("refresh").toString());

	} else {
		logout();
		toast.warn(QObject::tr("لطفا مجددا وارد شوید"), 10000);
	}
}

bool UserAuthentication::offlineTimeValidation()
{
	const QVariant user_ttl = Settings::instance()->get(SystemSettings::UserTTL);
	const QVariant quit_clock = Settings::instance()->get(SystemSettings::QuitClock);

	if (user_ttl == QVariant::Invalid || quit_clock == QVariant::Invalid) {
		return false;
	}

	qint64 ttl = qvariant_cast<qint64>(user_ttl);

	ttl -= (Clock::getTime() - qvariant_cast<quint64>(quit_clock)) / 1000000ULL;

	Settings::instance()->set(SystemSettings::UserTTL, ttl);

	return ttl > 0;
}

bool UserAuthentication::accountValidation(QJsonObject json, QString timestamp)
{
	const QString message = QString("حساب خود را <a href=\"%1\">از اینجا</a> شارژ کنید").arg(
					UserAuthentication::kChargeURL);

	if (!json.contains("additionals")) {
		emit notifyError(message);
		return false;
	}

	json = json.value("additionals").toObject();

	if (!json.contains("agcs")) {
		emit notifyError(message);
		return false;
	}

	json = json.value("agcs").toObject();

	if (!json.contains("end")) {
		emit notifyError("لطفا بعدا تلاش کنید");
		return false;
	}

	const QDateTime end(QDateTime::fromString(json.value("end").toString(), Qt::ISODateWithMs));

	if (!end.isValid() || timestamp.isEmpty()) {
		emit notifyError("لطفا بعدا تلاش کنید");
		return false;
	}

	const qint64 now = qvariant_cast<qint64>(QVariant::fromValue(timestamp));

	if (now <= 0) {
		emit notifyError("لطفا بعدا تلاش کنید");
		return false;
	}

	const qint64 delta = end.toSecsSinceEpoch() - now;

	Settings::instance()->set(SystemSettings::UserTTL, delta);

	if (delta <= 0) {
		emit notifyError(message);
		return false;
	}

	return true;
}
