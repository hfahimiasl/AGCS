import QtQuick 2.12

import '../model'
import '../object'


ModelPagetype {
    id: idPageSettings

    property bool paramsDownload: false

    states: [
        State {
            name: 'disconnect'
            PropertyChanges { target: idAircraftConnectionText; visible: true }
            PropertyChanges { target: idAircraftConnectionText; text: qsTr('برای نمایش تنظیمات دستگاه را متصل کنید') }
            PropertyChanges { target: idSettingsCommands; visible: false }
            PropertyChanges { target: idAircraftSettings; visible: false }
            PropertyChanges { target: idArduplaneSettings; visible: false }
            PropertyChanges { target: idArducopterSettings; visible: false }
        },
        State {
            name: 'loading'
            PropertyChanges { target: idAircraftConnectionText; visible: true }
            PropertyChanges { target: idAircraftConnectionText; text: qsTr('برای نمایش تنظیمات پارامتر ها را بارگیری کنید') }
            PropertyChanges { target: idSettingsCommands; visible: false }
            PropertyChanges { target: idAircraftSettings; visible: false }
            PropertyChanges { target: idArduplaneSettings; visible: false }
            PropertyChanges { target: idArducopterSettings; visible: false }
        },
        State {
            name: 'arduplane'
            PropertyChanges { target: idAircraftConnectionText; visible: false }
            PropertyChanges { target: idSettingsCommands; visible: true }
            PropertyChanges { target: idAircraftSettings; visible: true }
            PropertyChanges { target: idArduplaneSettings; visible: true }
            PropertyChanges { target: idArducopterSettings; visible: false }
        },
        State {
            name: 'arducopter'
            PropertyChanges { target: idAircraftConnectionText; visible: false }
            PropertyChanges { target: idSettingsCommands; visible: true }
            PropertyChanges { target: idAircraftSettings; visible: true }
            PropertyChanges { target: idArduplaneSettings; visible: false }
            PropertyChanges { target: idArducopterSettings; visible: true }
        }
    ]

    Text {
        id: idAircraftConnectionText
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_medium.name
        font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
        font.bold: true
    }

    Rectangle {
        id: idSettingsCommands
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
        height: idDownloadSettings.implicitHeight * 1.2
        color: parent.color

        readonly property real itemSpacing: idDisplay.getScaledWidth(0.01, 0.02)

        Text {
            id: idDownloadSettings
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: theme.text
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(1.75, 3.5)
            text: '\uf381'

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    ParamService.notifyDownload()
                }
            }
        }

        Text {
            id: idApplySettings
            anchors.left: idDownloadSettings.right
            anchors.leftMargin: parent.itemSpacing
            anchors.verticalCenter: parent.verticalCenter
            color: idDownloadSettings.color
            font: idDownloadSettings.font
            text: '\uf00c'

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (idPageSettings.paramsDownload) {
                        let aircraft_type = variable.getText('AIRCRAFT_TYPE')

                        if (aircraft_type === 'FIXEDWING') {
                            idArduplaneSettings.applyChanges()

                        } else if (aircraft_type === 'MULTIROTOR') {
                            idArducopterSettings.applyChanges()
                        }

                    } else {
                        toast.error(qsTr('پارامتر ها را بارگیری کنید'), 5000)
                    }
                }
            }
        }

        Text {
            id: idRebootAircraft
            anchors.left: idApplySettings.right
            anchors.leftMargin: parent.itemSpacing
            anchors.verticalCenter: parent.verticalCenter
            color: idApplySettings.color
            font: idDownloadSettings.font
            text: '\uf021'

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (parseInt(variable.getValue('ARM_STATUS'))) {
                        toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                    } else {
                        autopilot.reboot()
                    }
                }
            }
        }
    }

    Rectangle {
        id: idAircraftSettings
        anchors.top: idSettingsCommands.bottom
        anchors.bottom: parent.bottom
        anchors.left: idSettingsCommands.left
        anchors.right: idSettingsCommands.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        color: parent.color

        ObjectArduPlaneSettings {
            id: idArduplaneSettings
            anchors.fill: parent
        }

        ObjectArduCopterSettings {
            id: idArducopterSettings
            anchors.fill: parent
        }
    }

    Connections {
        target: ParamService

        onNotifyDownloadComplete: {
            idPageSettings.paramsDownload = true
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                idPageSettings.paramsDownload = false
            }
        }
    }

    Connections {
        target: scheduler

        onSchedule4Hz: {
            if (link.isConnected()) {
                if (!idPageSettings.paramsDownload) {
                    idPageSettings.state = 'loading'
                    return
                }

                let aircraft_type = variable.getText('AIRCRAFT_TYPE')

                if (aircraft_type === 'FIXEDWING') {
                    idPageSettings.state = 'arduplane'

                } else if (aircraft_type === 'MULTIROTOR') {
                    idPageSettings.state = 'arducopter'
                }

            } else {
                idPageSettings.state = 'disconnect'
            }
        }
    }
}
