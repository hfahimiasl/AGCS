import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


Rectangle {
    id: idRoot
    width: idInfoRow.implicitWidth * 1.2
    height: idInfoRow.implicitHeight * 1.3
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottomMargin: idDisplay.getScaledHeight(0.01, 0.01)
    color: theme.backgroundDark
    radius: 5
    z: parent.z + 10

    Row {
        id: idInfoRow
        anchors.centerIn: parent
        spacing: idDisplay.getScaledWidth(0.01, 0.0225)

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: idUavBatteryLevelIcone.implicitWidth + idUavBatteryLevelTxt.implicitWidth + parent.spacing * 0.25
            height: Math.max(idUavBatteryLevelIcone.implicitHeight, idUavBatteryLevelTxt.implicitWidth)

            Text {
                id: idUavBatteryLevelIcone
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: theme.text
                font.family: fontAwesome.name
                fontSizeMode: Text.Fit
                font.pixelSize: idDisplay.getFontScale(1.4, 2.75)
                text: {
                    if (level <= 0)
                        '\uf244' // fa-battery-empty

                    else if (level <= 1)
                        '\uf243' // fa-battery-quarter

                    else if (level <= 2)
                        '\uf242' // fa-battery-half

                    else if (level <= 3)
                        '\uf241' // fa-battery-three-quarters

                    else if (level <= 4)
                        '\uf240' // fa-battery-full

                    else
                        '\uf244' // fa-battery-empty
                }

                property int level: 0
            }

            Text {
                id: idUavBatteryLevelTxt
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: font_fa_medium.name
                font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
                text: 'N/A'
            }
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: idUavSatelliteIcone.implicitWidth + idUavSatelliteText.implicitWidth + parent.spacing * 0.25
            height: Math.max(idUavSatelliteIcone.implicitHeight, idUavSatelliteText.implicitWidth)

            Text {
                id: idUavSatelliteIcone
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: fontAwesome.name
                font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
                text: '\uf7bf'
            }

            Text {
                id: idUavSatelliteText
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: theme.text
                font.family: font_fa_medium.name
                fontSizeMode: Text.Fit
                font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
                text: 'N/A'
            }
        }

        Text {
            id: idCurrModeUavModesTxt
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: font_fa_medium.name
            font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
            text: 'N/A'

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                ListModel { id: idFlightModesList }

                onClicked: {
                    if (link.isConnected()) {
                        idModesPopup.open()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }

                onPressedChanged: {
                    idFlightModesList.clear()
                    var modes = autopilot.getAllFlightModes()

                    for (let i=0 ; i<modes.length ; i++) {
                        idFlightModesList.append({ flight_mode: modes[i] })
                    }
                }
            }
        }

        ModelPopup {
            id: idModesPopup
            modal: true
            visible: false
            width: idRoot.width
            implicitHeight: 150
            y: -(height + 2)
            x: 0

            Flickable {
                anchors.fill: parent
                contentWidth: width
                contentHeight: idFlow.implicitHeight
                clip: true

                Flow {
                    id: idFlow
                    width: parent.width
                    spacing: 5
                    clip: true

                    Repeater {
                        model: idFlightModesList
                        delegate: Rectangle {
                            id: delegate
                            width: idMessageText.contentWidth * 1.2
                            height: idMessageText.contentHeight * 1.4
                            border.color: theme.text
                            color: 'transparent'

                            Label {
                                id: idMessageText
                                anchors.centerIn: parent
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.Wrap
                                color: theme.textDark
                                font.pixelSize: idUavBatteryLevelIcone.font.pixelSize * 0.5
                                font.family: font_fa_medium.name
                                text: flight_mode
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: delegate.color = theme.text
                                onExited: delegate.color = 'transparent'
                                onClicked: idModesPopup.curritem(flight_mode)
                            }
                        }
                    }
                }
            }

            function curritem(index) {
                idModesPopup.close()
                autopilot.setFlightMode(index)
            }
        }

        Text {
            id: idUavARMStatus
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: fontAwesome.name
            font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
            text: '\uf057'

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (link.isConnected()) {
                        idArmDisarmController.open()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        Text {
            id: idTakeoffLanding
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: fontAwesome.name
            font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
            text: '\uf062'

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (link.isConnected()) {
                        idTakeoffLandingController.open()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        Text {
            id: idUavStartMissionStatus
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: fontAwesome.name
            font.pixelSize: idUavBatteryLevelIcone.font.pixelSize
            text: '\uf4d7'

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (link.isConnected()) {
                        idMissionProcessController.open()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }
    }

    Connections {
        target: variable

        onNotifyChanges: {
            if (id.indexOf('GPS_RAW') !== -1) {
                let satellites_visible = variable.getValue('GPS_RAW_SATELLITES_VISIBLE')
                idUavSatelliteText.text = satellites_visible === 255 ? 'N/A' : satellites_visible

            } else if (id.indexOf('SYS_STATUS') !== -1) {
                let batt = variable.getValue('SYS_STATUS_BATTERY_REMAINING')
                idUavBatteryLevelTxt.text = batt === -1 ? 'N/A' : batt
                idUavBatteryLevelIcone.level = (batt === -1 ? 0 : batt) / 25

            } else if (id === 'ARM_STATUS') {
                idUavARMStatus.text = link.isConnected() && variable.getValue(id) ? '\uf058' : '\uf057'

            } else if (id === 'SYSTEM_STATUS') {
                idTakeoffLanding.text = link.isConnected() && parseInt(variable.getValue(id)) === 4 ? '\uf063' : '\uf062'
            }

            idCurrModeUavModesTxt.text = autopilot.getFlightMode()
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                idArmDisarmController.close()
                idTakeoffLandingController.close()
                idMissionProcessController.close()
            }
        }
    }
}
