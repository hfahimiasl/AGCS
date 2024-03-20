#include <QCoreApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QObject>
#include <QDesktopServices>
#include <QQmlContext>
#include <QIcon>
#include <QtQml>
#include <QMessageBox>
#include <QQuickWindow>

#include <GeoServicePlugin.h>
#include <MapEngineManager.h>

#include "platform_common.h"

#include "Server/Server.h"

#include "src/Aircraft/link/Link.h"
#include "src/Aircraft/protocol/mavlink/MAVLinkHandler.h"
#include "src/Aircraft/autopilot/Autopilot.h"

#include "src/Log/LogService.h"


#ifdef Q_OS_ANDROID
#include <jni.h>
#include <QtAndroid>
#include <QtAndroidExtras/QAndroidJniEnvironment>

#include "libs/qtandroidserialport/qserialport.h"
#include "libs/qtandroidserialport/qserialportinfo.h"


static jobject _class_loader = nullptr;
static jobject _context = nullptr;


extern "C" {
	void gst_amc_jni_set_java_vm(JavaVM *java_vm);

	jobject gst_android_get_application_class_loader(void)
	{
		return _class_loader;
	}
}


static void gst_android_init(JNIEnv *env, jobject context)
{
	jobject class_loader = nullptr;

	jclass context_cls = env->GetObjectClass(context);

	if (!context_cls) {
		return;
	}

	jmethodID get_class_loader_id = env->GetMethodID(context_cls, "getClassLoader", "()Ljava/lang/ClassLoader;");

	if (env->ExceptionCheck()) {
		env->ExceptionDescribe();
		env->ExceptionClear();
		return;
	}

	class_loader = env->CallObjectMethod(context, get_class_loader_id);

	if (env->ExceptionCheck()) {
		env->ExceptionDescribe();
		env->ExceptionClear();
		return;
	}

	_context = env->NewGlobalRef(context);
	_class_loader = env->NewGlobalRef(class_loader);
}


static const char kJniClassName[] {"org/adlanpaya/agcs/AGCSActivity"};


void setNativeMethods(void)
{
	JNINativeMethod javaMethods[] {
		{"nativeInit", "()V", reinterpret_cast<void *>(gst_android_init)}
	};

	QAndroidJniEnvironment jniEnv {};

	if (jniEnv->ExceptionCheck()) {
		jniEnv->ExceptionDescribe();
		jniEnv->ExceptionClear();
	}

	jclass objectClass = jniEnv->FindClass(kJniClassName);

	if (!objectClass) {
		qWarning() << "Couldn't find class:" << kJniClassName;
		return;
	}

	jint val = jniEnv->RegisterNatives(objectClass, javaMethods, sizeof(javaMethods) / sizeof(javaMethods[0]));

	if (val < 0) {
		qWarning() << "Error registering methods: " << val;

	} else {
		qDebug() << "Main Native Functions Registered";
	}

	if (jniEnv->ExceptionCheck()) {
		jniEnv->ExceptionDescribe();
		jniEnv->ExceptionClear();
	}
}

jint JNI_OnLoad(JavaVM *vm, void *reserved)
{
	Q_UNUSED(reserved)

	JNIEnv *env {nullptr};

	if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) {
		return -1;
	}

	setNativeMethods();

	QSerialPort::setNativeMethods();

	return JNI_VERSION_1_6;
}

bool checkAndroidWritePermission()
{
	QtAndroid::PermissionResult result = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");

	if (result == QtAndroid::PermissionResult::Denied) {
		QtAndroid::requestPermissionsSync(QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE");
		result = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");

		if (result == QtAndroid::PermissionResult::Denied) {
			return false;
		}
	}

	return true;
}
#endif


int main(int argc, char *argv[])
{
	Q_IMPORT_PLUGIN(GeoServicePlugin)

	Logger::init();

	// TODO: set to Qt::AA_UseHighDpiPixmaps and refactor android ui
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

	QApplication *app = new QApplication(argc, argv);

	app->setApplicationVersion("1.4.0");
	app->setOrganizationDomain("adlanpaya.ir");
	app->setOrganizationName(QObject::tr("شرکت آدلان پایا"));
	app->setApplicationName(QString("ایستگاه زمینی آدلان پایا - %1").arg(app->applicationVersion()));

	MapEngine::instance()->init();

	Settings::instance()->init();

	if (UpdateChecker::instance()->compare(app->applicationVersion(),
					       Settings::instance()->get(SystemSettings::ServerLatestVersion).toString())
	    && Settings::instance()->get(SystemSettings::ServerMandatoryUpdate).toBool()) {
		QMessageBox::information(nullptr,
					 QObject::tr("ایستگاه زمینی آدلان پایا"),
					 QString("نرم افزار خود را <a href=\"%1\">از اینجا</a> آپدیت کنید")
					 .arg(Settings::instance()->get(SystemSettings::ServerDownloadLink).toString()),
					 QMessageBox::StandardButton::Ok);
		return -1;
	}

	Server::instance()->init();

#if !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID)

	if (!RunGuard::instance()->isExecutable()) {
		QMessageBox::information(nullptr, QObject::tr("ایستگاه زمینی آدلان پایا"),
					 QObject::tr("هم اکنون در حال اجرا است!"), QMessageBox::StandardButton::Ok);
		return -1;
	}

#endif

	QQmlApplicationEngine *engine = new QQmlApplicationEngine(app);

	ParamService::instance(nullptr, engine);
	MissionService::instance(nullptr, engine);
	PatternService::instance(nullptr, engine);
	AirspaceService::instance(nullptr, engine);

	Scheduler::instance()->init();

	MAVLinkHandler::instance()->build();

	MapEngineManager map_engine;
	engine->rootContext()->setContextProperty("MapEngine", &map_engine);

	engine->rootContext()->setContextProperty("Server", Server::instance());
	engine->rootContext()->setContextProperty("support", Support::instance());
	engine->rootContext()->setContextProperty("user_auth", UserAuthentication::instance());
	engine->rootContext()->setContextProperty("firmware", Server::instance()->firmware_controller);
	engine->rootContext()->setContextProperty("system_toast", &toast);
	engine->rootContext()->setContextProperty("settings", Settings::instance());
	engine->rootContext()->setContextProperty("units", Units::instance());
	engine->rootContext()->setContextProperty("scheduler", Scheduler::instance());
	engine->rootContext()->setContextProperty("variable", &variable);
	engine->rootContext()->setContextProperty("link", Link::instance());
	engine->rootContext()->setContextProperty("autopilot", Autopilot::instance());
	engine->rootContext()->setContextProperty("LogService", LogService::instance());

	app->setWindowIcon(QIcon(":/images/logo-48.png"));

	engine->load(QUrl(QStringLiteral("qrc:/main.qml")));

	Q_ASSERT(static_cast<QQuickWindow *>(engine->rootObjects().first()) != nullptr);

#ifdef Q_OS_ANDROID
	checkAndroidWritePermission();
#endif

	const int ret = app->exec();

	delete engine;
	delete app;

	MapEngine::destroy();

	// ret ? qCritical("exit code %d", ret) : qInfo("exit code %d", ret);

	return ret;
}
