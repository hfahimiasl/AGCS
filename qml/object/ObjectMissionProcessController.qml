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
        text: '\uf4d7'
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
        text: qsTr('برای %1 ماموریت نوار زیر را تا انتها بکشید').arg(status)

        property string status: 'N/A'
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
            switch (idText.status) {
            case qsTr('شروع'):
                autopilot.mission('START')
                break

            case qsTr('توقف'):
                autopilot.mission('PAUSE')
                break

            case qsTr('از سرگیری'):
                autopilot.mission('RESUME')
                break
            }

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
        target: scheduler

        onSchedule4Hz: {
            if (link.isConnected()) {

                // TODO: Fix mission button bug (does not matter at the moment)

                if (autopilot.getFlightMode() === 'AUTO' && variable.getValue('SYSTEM_STATUS') === 4) {
                    idText.status = qsTr('توقف')

                } else {
                    if (variable.getValue('MISSION_ITEM_REACHED') !== 0 && variable.getValue('MISSION_CURRENT_ITEM') !== 1 && variable.getValue('MISSION_CURRENT_ITEM') !== variable.getValue('MISSION_ITEM_REACHED')) {
                        idText.status = qsTr('از سرگیری')

                    } else {
                        idText.status = qsTr('شروع')
                    }
                }
            }
        }
    }
}
