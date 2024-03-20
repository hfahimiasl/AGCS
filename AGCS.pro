QT += \
    gui \
    location \
    network \
    opengl \
    positioning \
    qml \
    quick \
    quickcontrols2 \
    quickwidgets \
    svg \
    widgets \
    xml \
    core-private \
    websockets

CONFIG += \
        qt \
        c++11 \
        thread \
        silent \
        qtquickcompiler \
        use_gold_linker  # better link speed

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

include($$PWD/libs/QObjectListModel/QObjectListModel.pri)

# location plugin
include($$PWD/libs/LocationPlugin/LocationPlugin.pri)

HEADERS += \
    src/System/QmlObjectListModel.h \
    src/System/JsonHelper.h \
    libs/LocationPlugin/QMLControl/MapEngineManager.h

SOURCES += \
    src/System/QmlObjectListModel.cc \
    src/System/JsonHelper.cc \
    libs/LocationPlugin/QMLControl/MapEngineManager.cc

LOCATION_PLUGIN_DESTDIR = $${OUT_PWD}/libs/LocationPlugin
LOCATION_PLUGIN_NAME = GeoServicePlugin

macx {
    QT += serialport
}

windows {
    QT += serialport

    contains(QT_ARCH, x86_64) {
        LIBS += \
            -L$$PWD/libs/openssl/win64 -llibcrypto-1_1-x64 \
            -L$$PWD/libs/openssl/win64 -llibssl-1_1-x64

    } else {
        LIBS += \
            -L$$PWD/libs/openssl/win32 -llibcrypto-1_1 \
            -L$$PWD/libs/openssl/win32 -llibssl-1_1
    }

    RC_ICONS = resources/images/logo-exe.ico
}

android {
    include($$PWD/Android.pri)
}

SOURCES += \
    src/main.cpp \
    src/Server/Server.cpp \
    src/Server/InternalLog.cpp \
    src/Server/Support.cpp \
    src/Server/UpdateChecker.cpp \
    src/Server/UserAuthentication.cpp \
    src/Server/UserScheduling.cpp \
    src/System/CryptoGraphy.cpp \
    src/System/Downloader.cpp \
    src/System/Geographical.cpp \
    src/System/Global.cpp \
    src/System/Logger.cpp \
    src/System/RunGuard.cpp \
    src/System/Scheduler.cpp \
    src/System/Settings.cpp \
    src/System/SystemSettings.cpp \
    src/System/SystemUnits.cpp \
    src/System/Clock.cpp \
    src/System/Toast.cpp \
    src/System/Units.cpp \
    src/System/Variable.cpp \
    src/System/WebSocket.cpp \
    src/Firmware/Bootloader.cpp \
    src/Firmware/Device.cpp \
    src/Firmware/FirmwareImage.cpp \
    src/Firmware/UpgradeThread.cpp \
    src/Aircraft/link/AbstractLink.cpp \
    src/Aircraft/link/Link.cpp \
    src/Aircraft/link/Serial.cpp \
    src/Aircraft/link/TCP.cpp \
    src/Aircraft/link/UDP.cpp \
    src/Aircraft/protocol/mavlink/MAVLink.cpp \
    src/Aircraft/protocol/mavlink/MAVLinkHandler.cpp \
    src/Aircraft/protocol/mavlink/AbstractHandler.cpp \
    src/Aircraft/protocol/mavlink/handler/Altitude.cpp \
    src/Aircraft/protocol/mavlink/handler/Attitude.cpp \
    src/Aircraft/protocol/mavlink/handler/AutopilotVersion.cpp \
    src/Aircraft/protocol/mavlink/handler/BatteryStatus.cpp \
    src/Aircraft/protocol/mavlink/handler/GlobalPositionInt.cpp \
    src/Aircraft/protocol/mavlink/handler/GPS.cpp \
    src/Aircraft/protocol/mavlink/handler/HeartBeat.cpp \
    src/Aircraft/protocol/mavlink/handler/HomePosition.cpp \
    src/Aircraft/protocol/mavlink/handler/LocalPositionNED.cpp \
    src/Aircraft/protocol/mavlink/handler/Mission.cpp \
    src/Aircraft/protocol/mavlink/handler/MountStatus.cpp \
    src/Aircraft/protocol/mavlink/handler/Param.cpp \
    src/Aircraft/protocol/mavlink/handler/PositionTargetGlobalInt.cpp \
    src/Aircraft/protocol/mavlink/handler/RawIMU.cpp \
    src/Aircraft/protocol/mavlink/handler/RemoteControl.cpp \
    src/Aircraft/protocol/mavlink/handler/ScaledIMU.cpp \
    src/Aircraft/protocol/mavlink/handler/ServoOutput.cpp \
    src/Aircraft/protocol/mavlink/handler/StatusText.cpp \
    src/Aircraft/protocol/mavlink/handler/SystemStatus.cpp \
    src/Aircraft/protocol/mavlink/handler/TerrainReport.cpp \
    src/Aircraft/protocol/mavlink/handler/VFR.cpp \
    src/Aircraft/autopilot/Autopilot.cpp \
    src/Aircraft/autopilot/AbstractAutopilot.cpp \
    src/Aircraft/autopilot/ardupilot/Ardupilot.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotBatteryHelper.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotCalibrationHelper.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotFrameHelper.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotModeHelper.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotNavigationHelper.cpp \
    src/Aircraft/autopilot/ardupilot/ArdupilotOutputHelper.cpp \
    src/Airspace/AirportItem.cpp \
    src/Airspace/AirspaceService.cpp \
    src/Airspace/AirTrafficItem.cpp \
    src/Airspace/AreaItem.cpp \
    src/Param/ParamItem.cpp \
    src/Param/ParamMetaData.cpp \
    src/Param/ParamService.cpp \
    src/Mission/LandItem.cpp \
    src/Mission/MissionItem.cpp \
    src/Mission/MissionService.cpp \
    src/Mission/TakeoffItem.cpp \
    src/Mission/WaypointItem.cpp \
    src/Mission/Pattern/AgricultureInfo.cpp \
    src/Mission/Pattern/PatternGroupItem.cpp \
    src/Mission/Pattern/PatternPathWorker.cpp \
    src/Mission/Pattern/PatternRenderWorker.cpp \
    src/Mission/Pattern/PatternService.cpp \
    src/Mission/Pattern/PatternSingleItem.cpp \
    src/Mission/Pattern/PhotographyInfo.cpp \
    src/Log/LogItem.cpp \
    src/Log/LogMetaData.cpp \
    src/Log/LogModel.cpp \
    src/Log/LogService.cpp

HEADERS += \
    src/platform_common.h \
    src/Server/Server.h \
    src/Server/InternalLog.h \
    src/Server/Support.h \
    src/Server/UpdateChecker.h \
    src/Server/UserAuthentication.h \
    src/Server/UserScheduling.h \
    src/System/CryptoGraphy.h \
    src/System/Global.h \
    src/System/Downloader.h \
    src/System/Geographical.h \
    src/System/Logger.h \
    src/System/RunGuard.h \
    src/System/Scheduler.h \
    src/System/Settings.h \
    src/System/SystemSettings.h \
    src/System/SystemUnits.h \
    src/System/Clock.h \
    src/System/Toast.h \
    src/System/Units.h \
    src/System/Variable.h \
    src/System/WebSocket.h \
    src/Firmware/Bootloader.h \
    src/Firmware/Device.h \
    src/Firmware/FirmwareImage.h \
    src/Firmware/UpgradeThread.h \
    src/Aircraft/link/AbstractLink.h \
    src/Aircraft/link/Link.h \
    src/Aircraft/link/Serial.h \
    src/Aircraft/link/TCP.h \
    src/Aircraft/link/UDP.h \
    src/Aircraft/protocol/mavlink/MAVLink.h \
    src/Aircraft/protocol/mavlink/MAVLinkProtocolHelpers.h \
    src/Aircraft/protocol/mavlink/MAVLinkHandler.h \
    src/Aircraft/protocol/mavlink/AbstractHandler.h \
    src/Aircraft/protocol/mavlink/handler/Altitude.h \
    src/Aircraft/protocol/mavlink/handler/Attitude.h \
    src/Aircraft/protocol/mavlink/handler/AutopilotVersion.h \
    src/Aircraft/protocol/mavlink/handler/BatteryStatus.h \
    src/Aircraft/protocol/mavlink/handler/GlobalPositionInt.h \
    src/Aircraft/protocol/mavlink/handler/GPS.h \
    src/Aircraft/protocol/mavlink/handler/HeartBeat.h \
    src/Aircraft/protocol/mavlink/handler/HomePosition.h \
    src/Aircraft/protocol/mavlink/handler/LocalPositionNED.h \
    src/Aircraft/protocol/mavlink/handler/Mission.h \
    src/Aircraft/protocol/mavlink/handler/MountStatus.h \
    src/Aircraft/protocol/mavlink/handler/Param.h \
    src/Aircraft/protocol/mavlink/handler/PositionTargetGlobalInt.h \
    src/Aircraft/protocol/mavlink/handler/RawIMU.h \
    src/Aircraft/protocol/mavlink/handler/RemoteControl.h \
    src/Aircraft/protocol/mavlink/handler/ScaledIMU.h \
    src/Aircraft/protocol/mavlink/handler/ServoOutput.h \
    src/Aircraft/protocol/mavlink/handler/StatusText.h \
    src/Aircraft/protocol/mavlink/handler/SystemStatus.h \
    src/Aircraft/protocol/mavlink/handler/TerrainReport.h \
    src/Aircraft/protocol/mavlink/handler/VFR.h \
    src/Aircraft/autopilot/Autopilot.h \
    src/Aircraft/autopilot/AbstractAutopilot.h \
    src/Aircraft/autopilot/ardupilot/Ardupilot.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotBatteryHelper.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotCalibrationHelper.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotFrameHelper.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotModeHelper.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotNavigationHelper.h \
    src/Aircraft/autopilot/ardupilot/ArdupilotOutputHelper.h \
    src/Airspace/AirportItem.h \
    src/Airspace/AirspaceService.h \
    src/Airspace/AirTrafficItem.h \
    src/Airspace/AreaItem.h \
    src/Param/ParamFact.h \
    src/Param/ParamItem.h \
    src/Param/ParamMetaData.h \
    src/Param/ParamService.h \
    src/Mission/LandItem.h \
    src/Mission/MissionItem.h \
    src/Mission/MissionService.h \
    src/Mission/TakeoffItem.h \
    src/Mission/WaypointItem.h \
    src/Mission/Pattern/AgricultureInfo.h \
    src/Mission/Pattern/PatternGroupItem.h \
    src/Mission/Pattern/PatternPathWorker.h \
    src/Mission/Pattern/PatternRenderWorker.h \
    src/Mission/Pattern/PatternService.h \
    src/Mission/Pattern/PatternSingleItem.h \
    src/Mission/Pattern/PhotographyInfo.h \
    src/Log/LogAckCode.h \
    src/Log/LogItem.h \
    src/Log/LogMetaData.h \
    src/Log/LogModel.h \
    src/Log/LogService.h

RESOURCES += \
    qml/qml.qrc \
    resources/font.qrc \
    resources/images.qrc \
    resources/js.qrc \
    src/Param/resources.qrc

TRANSLATIONS += \
    AGCS_fa_IR.ts

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
