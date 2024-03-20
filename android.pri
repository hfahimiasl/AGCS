include($$PWD/libs/openssl/android/openssl.pri)

include($$PWD/libs/qtandroidserialport/qtandroidserialport.pri)

QT += androidextras

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

DISTFILES += \
    $$PWD/android/AndroidManifest.xml \
    $$PWD/android/build.gradle \
    $$PWD/android/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/android/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/android/gradlew \
    $$PWD/android/gradlew.bat \
    $$PWD/android/res/values/libs.xml

OTHER_FILES += \
    $$PWD/android/res/xml/device_filter.xml \
    $$PWD/android/src/com/hoho/android/usbserial/driver/CdcAcmSerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/CommonUsbSerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/Cp2102SerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/FtdiSerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/ProlificSerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/UsbId.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/UsbSerialDriver.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/UsbSerialProber.java \
    $$PWD/android/src/com/hoho/android/usbserial/driver/UsbSerialRuntimeException.java \
    $$PWD/android/src/org/adlanpaya/agcs/AGCSActivity.java \
    $$PWD/android/src/org/adlanpaya/agcs/UsbIoManager.java \
    $$PWD/android/src/org/adlanpaya/agcs/TaiSync.java \
    $$PWD/android/src/org/freedesktop/gstreamer/androidmedia/GstAhcCallback.java \
    $$PWD/android/src/org/freedesktop/gstreamer/androidmedia/GstAhsCallback.java \
    $$PWD/android/src/org/freedesktop/gstreamer/androidmedia/GstAmcOnFrameAvailableListener.java
