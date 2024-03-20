#include "InternalLog.h"


InternalLog::InternalLog()
{
	if (prepareDir()) {
		loadLocal();

	} else {
		// qCritical() << "prepare failed";
		return;
	}

	QObject::connect(&timer, &QTimer::timeout, this, [ = ]() {
		log(true);
	});

	QObject::connect(&variable, &Variable::notifyChanges, this, [ = ](const QString & id) {
		if (id == "ARM_STATUS") {
			const bool active = timer.isActive();

			if (qFuzzyCompare(variable.getValue(id), 0.0)) {
				if (active) {
					timer.stop();
					terminate();
				}

			} else if (!active) {
				if (!prepareFile()) {
					// qCritical() << "prepare failed";
					return;
				}

				timer.start(InternalLog::kTimeout);
			}
		}
	});

	QObject::connect(Link::instance(), &Link::connectionChanged, this, [ = ](const bool & connected) {
		if (!connected) {
			terminate();
		}
	});

	QObject::connect(Server::instance(), &Server::connectedChanged, this, [ = ](const bool & connected) {
		if (connected) {
			loadLocal();
			upload();
		}
	});
}

InternalLog::~InternalLog()
{
	terminate();
}

InternalLog *InternalLog::instance()
{
	static InternalLog self;
	return &self;
}

void InternalLog::init(const QString &url)
{
	base_url = url;
}

void InternalLog::log(const bool &comma)
{
	flight_time = variable.getText("FLIGHT_TIME");

	const double altitude = variable.getValue("GLOBAL_POSITION_INT_RELATIVE_ALT") / 1.0e3;

	if (altitude > max_altitude) {
		max_altitude = altitude;
	}

	const double latitude = variable.getValue("GPS_RAW_LAT");
	const double longitude = variable.getValue("GPS_RAW_LON");

	static QGeoCoordinate last_coordinate(latitude, longitude);

	const QGeoCoordinate coordinate(latitude, longitude);

	if (coordinate != last_coordinate) {
		if (coordinate.isValid()) {
			flight_length += coordinate.distanceTo(last_coordinate);
		}

		last_coordinate = coordinate;
	}

	file->write("\t\t{\n");
	file->write(getDataFormat(3).arg("timestamp").arg(quint64(Clock::getTime() / 1e3)).toUtf8());
	file->write(getDataFormat(3).arg("altitude").arg(altitude).toUtf8());
	file->write(getDataFormat(3).arg("distance").arg(variable.getValue("AIRCRAFT_3D_DISTANCE")).toUtf8());
	file->write(getDataFormat(3).arg("vertical_speed").arg(variable.getValue("AIRCRAFT_VERTICAL_SPEED")).toUtf8());
	file->write(getDataFormat(3).arg("horizontal_speed").arg(variable.getValue("AIRCRAFT_HORIZONTAL_SPEED")).toUtf8());
	file->write(getDataFormat(3).arg("flight_time").arg(flight_time).toUtf8());
	file->write(getDataFormat(3).arg("battery_voltage").arg(variable.getValue("BATTERY1_VOLTAGE")).toUtf8());
	file->write(getDataFormat(3).arg("flight_mode").arg(Autopilot::instance()->getFlightMode()).toUtf8());

	file->write("\t\t\t\"attitude\": {\n");
	file->write(getDataFormat(4).arg("roll").arg(variable.getValue("ATTITUDE_ROLL") * -57.2958).toUtf8());
	file->write(getDataFormat(4).arg("pitch").arg(variable.getValue("ATTITUDE_PITCH") * 57.2958).toUtf8());
	file->write(getDataFormat(4, false).arg("heading").arg(variable.getValue("AIRCRAFT_HEADING")).toUtf8());
	file->write("\t\t\t},\n");

	file->write("\t\t\t\"gps\": {\n");
	file->write(getDataFormat(4).arg("latitude").arg(latitude).toUtf8());
	file->write(getDataFormat(4).arg("longitude").arg(longitude).toUtf8());
	file->write(getDataFormat(4).arg("altitude").arg(variable.getValue("GPS_RAW_ALT")).toUtf8());
	file->write(getDataFormat(4, false).arg("satellites_visible").arg(variable.getValue("GPS_RAW_SATELLITES_VISIBLE")).toUtf8());
	file->write("\t\t\t}\n");

	file->write(QString("\t\t}%1\n").arg(comma ? "," : "").toUtf8());
}

bool InternalLog::prepareDir()
{
	const QDir dir(InternalLog::kSaveDirPath);

	if (!dir.exists()) {
		if (!dir.mkdir(".")) {
			// qCritical() << "mkdir failed";
			return false;
		}
	}

	return true;
}

bool InternalLog::prepareFile()
{
	if (!file) {
		file = new QFile();
	}

	const QString user_auth_id = Settings::instance()->get(SystemSettings::UserAuthID).toString();
	const QString uuid = QUuid::createUuid().toString(QUuid::Id128);
	file->setFileName(InternalLog::kSaveDirPath + "/" + user_auth_id + uuid + InternalLog::kFileExtension);

	if (!file->open(QIODevice::WriteOnly | QFile::Text | QFile::Truncate)) {
		qCritical() << "open failed";
		delete file;
		file = nullptr;
		return false;
	}

	const QByteArray secret = QCryptographicHash::hash(Settings::instance()->get(SystemSettings::UserAuthID).toString().toLocal8Bit(),
				  QCryptographicHash::Md5);

	file->write("{\n" + getDataFormat(1).arg("secret").arg(QString(secret.toBase64())).toUtf8());
	file->write("\t\"drone_information\": {\n");
	file->write(getDataFormat(2).arg("firmware_version_number").arg(variable.getText("AUTOPILOT_VERSION_NUMBER")).toUtf8());
	file->write(getDataFormat(2).arg("firmware_version_type").arg(variable.getText("AUTOPILOT_VERSION_TYPE")).toUtf8());
	file->write(getDataFormat(2).arg("firmware_version_git_hash").arg(variable.getText("AUTOPILOT_VERSION_GIT_HASH")).toUtf8());
	file->write(getDataFormat(2).arg("firmware_type").arg(variable.getText("AUTOPILOT_TYPE").split("_").last().toLower()).toUtf8());
	file->write(getDataFormat(2, false).arg("aircraft_type").arg(variable.getText("AIRCRAFT_TYPE").toLower()).toUtf8());
	file->write("\t},\n\t\"software_information\": {\n");
	file->write(getDataFormat(2).arg("version").arg(QApplication::applicationVersion()).toUtf8());
	file->write(getDataFormat(2).arg("platform").arg(QSysInfo::productType() + "_" + QSysInfo::currentCpuArchitecture()).toUtf8());
	file->write(getDataFormat(2, false).arg("hid").arg(QString(QSysInfo::machineUniqueId())).toUtf8());
	file->write("\t},\n\t\"log\": [\n");

	return true;
}

void InternalLog::terminate()
{
	timer.stop();

	if (file) {
		analyze();
		file->write("\t]\n}\n");
		file->close();
		delete file;
		file = nullptr;
		loadLocal();
		upload();
	}
}

void InternalLog::analyze()
{
	file->write("\t\t{\n");
	file->write(getDataFormat(3).arg("date").arg(QDateTime::currentDateTime().toString(Qt::ISODateWithMs)).toUtf8());
	file->write(getDataFormat(3).arg("flight_time").arg(flight_time).toUtf8());
	file->write(getDataFormat(3).arg("max_altitude").arg(max_altitude).toUtf8());
	file->write(getDataFormat(3, false).arg("flight_length").arg(flight_length).toUtf8());
	file->write("\t\t}\n");

	flight_time = "";
	max_altitude = 0;
	flight_length = 0;
}

QString InternalLog::getDataFormat(const uint8_t &tabs, const bool &comma)
{
	QString format;

	for (uint8_t i = 0 ; i < tabs ; ++i) {
		format.append("\t");
	}

	return format.append(QString("\"%1\": \"%2\"") + (comma ? ",\n" : "\n"));
}

void InternalLog::loadLocal()
{
	file_list.clear();
	file_list = QDir(InternalLog::kSaveDirPath).entryInfoList(QStringList() << "*.log", QDir::Files | QDir::Readable, QDir::Time);
}

void InternalLog::upload()
{
	if (file_list.isEmpty()) {
		// qWarning() << "nothing to upload";
		return;
	}

	QFile *tmp_file = new QFile(file_list.takeLast().absoluteFilePath());

	if (!tmp_file->open(QIODevice::ReadOnly)) {
		// qCritical() << "open failed";
		upload();
		return;
	}

	QHttpPart textPart;
	textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"name\""));
	textPart.setBody("log file");

	QHttpPart imagePart;
	imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
			    QVariant(QString("form-data; name=\"file\"; filename=\"%1\"").arg(QFileInfo(tmp_file->fileName()).fileName())));
	imagePart.setBodyDevice(tmp_file);

	QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
	tmp_file->setParent(multiPart);

	multiPart->append(textPart);
	multiPart->append(imagePart);

	QNetworkRequest request(QUrl(base_url + "/agcs/log"));
	request.setRawHeader("Authorization", Settings::instance()->get(SystemSettings::UserAccessToken).toString().toUtf8());
	request.setRawHeader("User-Agent", QString("(%1; %2) %3/%4 (%5)")
			     .arg(QSysInfo::prettyProductName())
			     .arg(QSysInfo::currentCpuArchitecture())
			     .arg("AGCS")
			     .arg(QApplication::applicationVersion())
			     .arg("Nokia; Qt").toUtf8());
	QNetworkAccessManager *access_manager = new QNetworkAccessManager();
	QNetworkReply *reply = access_manager->post(request, multiPart);
	multiPart->setParent(reply);

	// qDebug() << "start uploading...";

	QObject::connect(reply, &QNetworkReply::finished, this, [ = ]() {
		QString url = reply->url().toString();
		uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
		QString json = QString(reply->readAll());

		reply->close();
		reply->deleteLater();

		QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
		QJsonObject jsonObj = document.object();

		// qDebug() << "upload manager ( code" << code << ") ( url" << url << ") ( json " << json << ")";

		if (code == 200 || (code == 500 && jsonObj.value("info").toString() == "ERROR_DUPLICATE_LOG")) {
			if (!tmp_file->remove()) {
				// qCritical() << "remove failed";
			}
		}

		upload();
	});
}
