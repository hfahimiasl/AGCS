#include "UpgradeThread.h"


UpgradeThreadWorker::UpgradeThreadWorker(UpgradeThreadController *_thread_controller) :
	thread_controller(_thread_controller),
	bootloader(new Bootloader(false, this)),
	firmware_manager(new QNetworkAccessManager(this)),
	downloader(new Downloader(this)),
	image(new FirmwareImage(this)),
	permission(false)
{
	QObject::connect(thread_controller, &UpgradeThreadController::notifySetBaseURL,
			 this, &UpgradeThreadWorker::onSetBaseURL);

	QObject::connect(thread_controller, &UpgradeThreadController::notifySetPermission,
			 this, &UpgradeThreadWorker::onSetPermission);

	QObject::connect(bootloader->device, &Device::notifyChanges,
			 this, &UpgradeThreadWorker::onPortsChanged);

	QObject::connect(bootloader->device, &Device::notifyDisconnected,
	this, [ = ]() { cancel(); });

	QObject::connect(firmware_manager, &QNetworkAccessManager::finished,
			 this, &UpgradeThreadWorker::onFirmwareManagerFinished);

	QObject::connect(thread_controller, &UpgradeThreadController::notifyUpload,
			 this, &UpgradeThreadWorker::onDownloadRequest);

	QObject::connect(downloader, &Downloader::notifyFinished,
			 this, &UpgradeThreadWorker::onFirmwareDownloaded);
}

void UpgradeThreadWorker::onSetBaseURL(const QString &_base_url)
{
	base_url = _base_url;
}

void UpgradeThreadWorker::onSetPermission(const bool &_permission)
{
	permission = _permission;
}

void UpgradeThreadWorker::onPortsChanged(const QString &_port)
{
	if (!permission) { return; }

	emit thread_controller->notifyInfo(QString("درگاه %1 پیدا شد").arg(_port));

	if (bootloader->open(_port)) {
		uint32_t bl_version;
		uint32_t board_id;
		uint32_t flash_size;

		if (bootloader->getBoardInfo(bl_version, board_id, flash_size)) {
			port = _port;
			networkRequest(board_id);

		} else {
			emit thread_controller->notifyError(bootloader->errorString());
			bootloader->reboot();
			bootloader->close();
		}

	} else {
		emit thread_controller->notifyError(bootloader->errorString());
		bootloader->reboot();
		bootloader->close();
	}
}

void UpgradeThreadWorker::networkRequest(const uint32_t &board_id)
{
	firmware_manager->clearConnectionCache();
	QNetworkRequest request(QUrl(base_url + "/agcs/firmware/list"));
	Global::setRawHeader(request, Settings::instance()->get(SystemSettings::UserAccessToken).toString());
	firmware_manager->post(request, QString("{\"board_id\" : %1}").arg(board_id).toUtf8());
	emit thread_controller->notifyInfo(tr("در حال دریافت لیست فریمور ها"));
}

void UpgradeThreadWorker::onFirmwareManagerFinished(QNetworkReply *reply)
{
	QString url = reply->url().toString();
	uint code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toUInt();
	QString json = QString(reply->readAll());

	reply->close();

	QJsonDocument document = QJsonDocument::fromJson(json.toUtf8());
	QJsonObject jsonObj = document.object();

	// qDebug() << "firmware manager ( code" << code << ") ( url" << url << ") ( jsonArray " << jsonObj << ")";

	if (code == 200) {
		firmware_list.clear();
		QJsonArray jsonArray = jsonObj.value("record").toArray();

		for (auto i = jsonArray.constBegin() ; i != jsonArray.constEnd() ; ++i) {
			firmware_s firmware {};
			firmware.type = i->toObject().value("type").toString();
			firmware.name = i->toObject().value("name").toString();
			firmware.date = i->toObject().value("date").toString();
			firmware.provider = i->toObject().value("provider").toString();
			firmware.link = i->toObject().value("link").toString();
			firmware.version = i->toObject().value("version").toString();
			firmware_list.append(firmware);
		}

		emit thread_controller->notifyFirmwaresList(getTypes());

	} else if (code == 401 || code == 403) {
		UserAuthentication::instance()->refresh();

	} else {
		emit thread_controller->notifyError(QString("خطای ناشناخته (کد %1)").arg(code));
	}
}

QStringList UpgradeThreadWorker::getTypes()
{
	QStringList types;
	types.clear();

	for (uint8_t i = 0 ; i < firmware_list.size() ; i++) {
		types.append(firmware_list[i].type);
	}

	return types;
}

void UpgradeThreadWorker::onDownloadRequest(const QString &type)
{
	firmware_s firmware {};
	firmware.type = type;

	if (!permission || !firmware_list.contains(firmware)) { return; }

	QObject::disconnect(thread_controller, &UpgradeThreadController::notifyUpload,
			    this, &UpgradeThreadWorker::onDownloadRequest);

	QObject::disconnect(bootloader, &Bootloader::updateProgress,
			    thread_controller, &UpgradeThreadController::notifyProgress);

	QObject::connect(downloader, &Downloader::notifyProgress,
			 thread_controller, &UpgradeThreadController::notifyProgress);

	downloader->setURL(firmware_list[firmware_list.indexOf(firmware)].link);
	downloader->setDownloadDir(QStandardPaths::writableLocation(QStandardPaths::TempLocation));
	downloader->setFileName("firmware");
	downloader->start();

	emit thread_controller->notifyStart();
	emit thread_controller->notifyInfo(QString("شروع به دانلود فریمور %1 (ورژن %2)").arg(
			firmware_list[firmware_list.indexOf(firmware)].type).arg(firmware_list[firmware_list.indexOf(firmware)].version));
}

void UpgradeThreadWorker::onFirmwareDownloaded(const QString &url, const QString &path)
{
	Q_UNUSED(url)

	QObject::connect(bootloader, &Bootloader::updateProgress,
			 thread_controller, &UpgradeThreadController::notifyProgress);

	QObject::disconnect(downloader, &Downloader::notifyProgress,
			    thread_controller, &UpgradeThreadController::notifyProgress);

	if (bootloader && bootloader->device->port->isOpen()) {
		uint32_t bl_version;
		uint32_t board_id;
		uint32_t flash_size;

		if (bootloader->getBoardInfo(bl_version, board_id, flash_size)) {
			emit thread_controller->notifyInfo(QString("آیدی دستگاه             %1").arg(board_id));
			emit thread_controller->notifyInfo(QString("نسخه بوتلودر            %1").arg(bl_version));
			emit thread_controller->notifyInfo(QString("اندازه حافظه فلش      %1").arg(flash_size));

			if (image->load(path, board_id)) {
				upload(image);
				return;

			} else {
				emit thread_controller->notifyError(tr("عدم مطابقت فریمور با دستگاه"));
			}

		} else {
			emit thread_controller->notifyError(bootloader->errorString());
		}

	} else {
		emit thread_controller->notifyError(bootloader ? tr("عدم دسترسی به درگاه") : tr("خطای داخلی"));
	}

	bootloader->reboot();
	bootloader->close();

	QObject::connect(thread_controller, &UpgradeThreadController::notifyUpload,
			 this, &UpgradeThreadWorker::onDownloadRequest);
}

void UpgradeThreadWorker::upload(FirmwareImage *image)
{
	if (!bootloader->initFlashSequence()) {
		goto Error;
	}

	if (erase()) {
		emit thread_controller->notifyInfo(tr("در حال بارگذاری فریمور جدید"));

		if (bootloader->program(image)) {
			emit thread_controller->notifyInfo(tr("فریمور جدید بارگذاری شد"));

		} else {
			emit thread_controller->notifyError(QString("خطا در بارگذاری: %1").arg(bootloader->errorString()));
			goto Error;
		}

		emit thread_controller->notifyInfo(tr("در حال راستی آزمایی فریمور جدید"));

		if (bootloader->verify(image)) {
			emit thread_controller->notifyInfo(tr("راستی آزمایی انجام شد"));
			emit thread_controller->notifyComplete();

		} else {
			emit thread_controller->notifyError(QString("خطا در راستی آزمایی: %1").arg(bootloader->errorString()));
			goto Error;
		}
	}

	goto Exit;

Error:
	emit thread_controller->notifyError(bootloader->errorString());

Exit:
	emit thread_controller->notifyFirmwaresList({});
	emit thread_controller->notifyProgress(0);

	if (bootloader->device->port->isOpen()) {
		emit thread_controller->notifyInfo(tr("راه اندازی مجدد دستگاه"));
		bootloader->reboot();
	}

	bootloader->close();

	QObject::connect(thread_controller, &UpgradeThreadController::notifyUpload,
			 this, &UpgradeThreadWorker::onDownloadRequest);
}

bool UpgradeThreadWorker::erase()
{
	emit thread_controller->notifyInfo(tr("در حال پاک کردن فریمور قدیمی"));

	if (bootloader->erase()) {
		emit thread_controller->notifyInfo(tr("پاک کردن فریمور قدیمی انجام شد"));
		return true;
	}

	emit thread_controller->notifyError(bootloader->errorString());
	return false;
}

void UpgradeThreadWorker::cancel()
{
	QObject::disconnect(bootloader, &Bootloader::updateProgress,
			    thread_controller, &UpgradeThreadController::notifyProgress);

	QObject::disconnect(downloader, &Downloader::notifyProgress,
			    thread_controller, &UpgradeThreadController::notifyProgress);

	emit thread_controller->notifyFirmwaresList({});
	emit thread_controller->notifyInfo("لغو بارگذاری");
	emit thread_controller->notifyProgress(0);
	downloader->cancel();
	bootloader->close();
}

UpgradeThreadController::UpgradeThreadController(QObject *parent) :
	QObject(parent)
{
	worker_ptr = new UpgradeThreadWorker(this);
	worker_thread = new QThread(this);
	worker_ptr->moveToThread(worker_thread);
	worker_thread->start();
}

UpgradeThreadController::~UpgradeThreadController()
{
	worker_thread->quit();
	worker_thread->wait();
	delete worker_thread;
}
