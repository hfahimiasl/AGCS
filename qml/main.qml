import QtQuick 2.12
import QtQuick.Controls 2.12
import QtPositioning 5.12
import SystemSettings 2.6
import SystemUnits 1.0

import 'lib'
import 'map'
import 'model'
import 'object'
import 'page'


ApplicationWindow {
    id: app

    //    ResponsiveHelper {
    //          id: helperBar
    //          targetWindow: app
    //          anchors.left: parent.right
    //          anchors.leftMargin: 30
    //      }

    property bool is_params_download: false

    FontLoader {
        id: font_fa_bold
        source: 'qrc:/fonts/iranyekanwebboldfanum.ttf'
    }

    FontLoader {
        id: font_fa_black
        source: 'qrc:/fonts/iranyekanwebblackfanum.ttf'
    }

    FontLoader {
        id: font_fa_medium
        source: 'qrc:/fonts/iranyekanwebmediumfanum.ttf'
    }

    FontLoader {
        id: fontAwesome
        source: 'qrc:/fonts/Font Awesome 5 Pro-Solid-900.otf'
    }

    FontLoader {
        id: fontAwesome_regular
        source: 'qrc:/fonts/Font Awesome 5 Free-Regular-400.otf'
    }

    Display {
        id: idDisplay
    }

    Colors {
        id: theme
    }

    minimumWidth: idDisplay.minimumWidth
    minimumHeight: idDisplay.minimumHeight

    visible: true

    ObjectSignin {
        id: idLoginform
        anchors.centerIn: parent
        width: idSignupform.width
        height: idDisplay.getScaledHeight(0.275, 0.675)
    }

    ObjectRecoveryPassword {
        id: idRecoveryPassword
        anchors.centerIn: parent
        width: idLoginform.width
        height: idLoginform.height
    }

    ObjectSignup {
        id: idSignupform
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.4211, 0.8422)
    }

    ObjectUserProfile {
        id: idUserProfile
        anchors.centerIn: parent
        width: idLoginform.width
        height: idDisplay.getScaledHeight(0.175, 0.45)
    }

    ObjectLinkConnection {
        id: idLinkConnection
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.15, 0.35)
        height: idDisplay.getScaledHeight(0.175, 0.5)
    }

    ObjectArmDisarmController {
        id: idArmDisarmController
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.215, 0.45)
        height: idDisplay.getScaledHeight(0.275, 0.6)
    }

    ObjectTakeoffLandingController {
        id: idTakeoffLandingController
        anchors.centerIn: parent
        width: idArmDisarmController.width
        height: idArmDisarmController.height
    }

    ObjectMissionProcessController {
        id: idMissionProcessController
        anchors.centerIn: parent
        width: idArmDisarmController.width
        height: idArmDisarmController.height
    }

    Rectangle {
        anchors.fill: parent
        color: theme.background

        ObjectMap {
            id: idMapObject
            anchors.fill: parent
            visible: idMainPage.visible || idMissionPage.visible
        }

        ObjectMenu {
            id: idMenuView
            anchors.right: parent.right
            anchors.rightMargin: idDisplay.getScaledWidth(0.0025, 0.005)
            anchors.verticalCenter: parent.verticalCenter
            width: idDisplay.getScaledWidth(0.03, 0.09)
            height: idDisplay.isLargeDisplay ? idDisplay.minimumHeight * 0.9 : idDisplay.displayHeight * 0.875
        }

        // Just for debug map type
        // ComboBox {
        //     model: idMapObject.supportedMapTypes
        //     textRole: 'description'
        //     anchors.top: parent.top
        //     anchors.right: idMenuView.left
        //     onCurrentIndexChanged: {
        //         idMapObject.activeMapType = idMapObject.supportedMapTypes[currentIndex]
        //     }
        // }

        Item {
            id: idPageShow
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: idMenuView.left

            PageMain {
                id: idMainPage
                anchors.fill: parent
                color: 'transparent'
                visible: false
            }

            PageMission {
                id: idMissionPage
                anchors.fill: parent
                color: 'transparent'
                visible: false
            }

            PageAnalyze {
                id: idAnalyzePage
                anchors.fill: parent
                visible: false
            }
            
            PageOutput {
                id: idOutputPage
                anchors.fill: parent
                visible: false
            }

            PageInput {
                id: idInputPage
                anchors.fill: parent
                visible: false
            }

            PageCalibration {
                id: idCalibrationPage
                anchors.fill: parent
                visible: false
            }

            PageSettings {
                id: idSettingsPage
                anchors.fill: parent
                visible: false
            }

            PageSafety {
                id: idSafetyPage
                anchors.fill: parent
                visible: false
            }

            PageOptions {
                id: idOptionsPage
                anchors.fill: parent
                visible: false
            }

            PageParams {
                id: idParameterPage
                anchors.fill: parent
                visible: false
            }

            PageFrimware {
                id: idFrimwarePage
                anchors.fill: parent
                visible: false
            }

            PageSupport {
                id: idSupportPage
                anchors.fill: parent
                visible: false
            }
        }

        ObjectToastManager {
            id: toast
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: idDisplay.getScaledHeight(0.01, 0.01)
            anchors.leftMargin: anchors.bottomMargin
            width: idDisplay.getScaledWidth(0.205, 0.345)
            height: idDisplay.getScaledHeight(0.3, 0.4)

            ListModel {
                id: idToastListModel
            }
        }

        ModelProgressBar {
            id: idParamsDownloadProgress
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 4

            background: Rectangle {
                color: 'transparent'
            }

            contentItem: Item {
                Rectangle {
                    width: idParamsDownloadProgress.width * idParamsDownloadProgress.visualPosition
                    height: parent.height
                    color: '#00e04b'
                }
            }

            Connections {
                target: ParamService

                onNotifyProgress: {
                    idParamsDownloadProgress.value = progress
                }

                onNotifyDownloadComplete: {
                    idParamsDownloadProgress.value = 0
                    is_params_download = true
                }
            }

            Connections {
                target: MissionService

                onNotifyProgress: {
                    if (!is_params_download) {
                        return
                    }

                    idParamsDownloadProgress.value = progress
                }

                onNotifyDownloadComplete: {
                    idParamsDownloadProgress.value = 0
                }

                onNotifyUploadComplete: {
                    idParamsDownloadProgress.value = 0
                }
            }

            Connections {
                target: link

                onConnectionChanged: {
                    if (!connected) {
                        is_params_download = false
                        idParamsDownloadProgress.value = 0
                    }
                }
            }
        }

        ObjectQuestionManager {
            id: questions
            width: idDisplay.getScaledWidth(0.15, 0.3)
            height: idDisplay.getScaledHeight(0.375, 0.375)
            anchors.right: idPageShow.right
            anchors.top: idPageShow.top
        }

        ModelButton {
            id: idAircraftFollowButton
            anchors.bottom: parent.bottom
            anchors.right: idMenuView.left
            anchors.margins: idDisplay.getScaledHeight(0.01, 0.01)
            width: height
            height: idDisplay.getScaledHeight(0.035, 0.09)
            backgroundColor: 'transparent'
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(1.5, 2.75)
            borderColor: idMapObject.drag ? 'transparent' : theme.primary
            text: '\uf601'
            visible: false

            onPressed: {
                idMapObject.drag = !idMapObject.drag
            }

            Connections {
                target: variable

                onNotifyChanges: {
                    if (id === "GPS_RAW") {
                        const aircraft = {}
                        aircraft.coordinate = QtPositioning.coordinate(variable.getValue("GPS_RAW_LAT"), variable.getValue("GPS_RAW_LON"))
                        aircraft.isValid = aircraft.coordinate.isValid && parseInt(aircraft.coordinate.latitude) !== 0 && parseInt(aircraft.coordinate.longitude) !== 0
                        idAircraftFollowButton.visible = (idMainPage.visible || idMissionPage.visible) && aircraft.isValid
                    }
                }
            }

            Connections {
                target: link

                onConnectionChanged: {
                    if (!connected) {
                        idAircraftFollowButton.visible = false
                    }
                }
            }
        }

        ObjectInformationbox {
            id: idInformationRec
            visible: idMainPage.visible
        }
    }

    Component.onCompleted: {
        theme.setTheme(String(settings.get(SystemSettings.GUITheme)))
        idMenuView.visible = true
        idMainPage.visible = true
        idLinkConnection.visible = user_auth.isSignin()
    }

    Connections {
        target: questions

        onEvent: {
            if (accept && id.substring(0, 18) === 'change_current_wp_') {
                if (parseInt(variable.getValue('ARM_STATUS')) && autopilot.getFlightMode() === 'AUTO') {
                    autopilot.setCurrentWaypoint(parseInt(id.substring(18, id.length)))

                } else {
                    toast.error(qsTr('برای حرکت به این نقطه باید ماموریت را شروع کنید'), 5000)
                }
            }

            if (id === 'mission_superseded_question' && accept) {
                app.download()
            }
        }
    }

    Connections {
        target: settings

        onNotifyChanges: {
            if (key === SystemSettings.GUITheme) {
                theme.setTheme(String(settings.get(key)))
            }
        }
    }
}
