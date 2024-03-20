import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Text {
        id: idImage
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.025
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.yellow
        fontSizeMode: Text.Fit
        font.family: fontAwesome.name
        font.pixelSize: idDisplay.getFontScale(5, 10)
        text: idVariableConnection.inAir ? '\uf063' : '\uf062'
    }

    Text {
        id: idText
        anchors.top: idImage.bottom
        anchors.topMargin: idImage.anchors.topMargin * 4
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_medium.name
        font.pixelSize: idDisplay.getFontScale(1.05, 2.1)
        text: qsTr('برای %1 نوار زیر را تا انتها بکشید').arg(idVariableConnection.inAir ? idVariableConnection.displayText : ('برخاستن'))
    }

    ModelLogicalSlider {
        id: idSlider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: idText.bottom
        anchors.leftMargin: parent.width * 0.1
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: idImage.anchors.topMargin * 4
        height: parent.height * 0.175

        onActive: {
            idVariableConnection.inAir ? autopilot.setFlightMode(idVariableConnection.targetFlightMode) : autopilot.takeoff()
            idRoot.close()
        }
    }

    Item {
        anchors.top: idSlider.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idImage.anchors.topMargin * 4

        Rectangle {
            id: idLine
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.background
        }

        Text {
            anchors.top: idLine.bottom
            anchors.topMargin: parent.height * 0.3
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font: idText.font
            text: qsTr('لغو')
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                idRoot.close()
            }
        }
    }

    Connections {
        id: idVariableConnection
        target: variable

        property bool inAir: false
        property string targetFlightMode: ''
        property string displayText: ''

        onNotifyChanges: {
            if (id === 'SYSTEM_STATUS') {
                let isGPSHealth = parseInt(variable.getValue('SYS_STATUS_SENSOR_GPS_HEALTH')) !== 0
                let isFixedwing = String(variable.getText('AIRCRAFT_TYPE')) === 'FIXEDWING'
                let aircraftDistance = parseInt(variable.getValue('AIRCRAFT_2D_DISTANCE'))

                idVariableConnection.inAir = parseInt(variable.getValue(id)) === 4
                idVariableConnection.targetFlightMode = isGPSHealth
                        ? (isFixedwing ? 'RTL' : (aircraftDistance > 2.5 ? 'RTL' : 'LAND'))
                        : (isFixedwing ? 'CIRCLE' : 'LAND')

                if (idVariableConnection.targetFlightMode === 'RTL') {
                    idVariableConnection.displayText = ('بازگشت به خانه')

                } else if (idVariableConnection.targetFlightMode === 'LAND') {
                    idVariableConnection.displayText = ('فرود')

                } else {
                    idVariableConnection.displayText = ('پرواز دایره ای')
                }
            }
        }
    }
}
