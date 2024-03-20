import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    Text {
        id: idTakeoffText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_black.name
        font.bold: true
        font.pixelSize: idRoot.fontPixelSize
        text: qsTr('ارتفاع برخاست')
    }

    Item {
        anchors.top: idTakeoffText.bottom
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            id: idValue
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.2
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            text: idSlider.value.toFixed(1) + ' m'
        }

        ModelSlider {
            id: idSlider
            anchors.left: parent.left
            anchors.right: idValue.left
            anchors.rightMargin: idRoot.leftPadding
            anchors.verticalCenter: parent.verticalCenter
            height: idDisplay.getScaledWidth(0.0125, 0.03)
            from: 0.5
            to: 200
            stepSize: 0.1
        }
    }

    Item {
        id: idButtons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: idDisplay.getScaledHeight(0.0275, 0.07)

        Rectangle {
            id: idHorizontalLine
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.background
        }

        Rectangle {
            id: idVerticalLine
            anchors.top: idHorizontalLine.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: idHorizontalLine.horizontalCenter
            width: idHorizontalLine.height
            color: idHorizontalLine.color
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('ذخیره')
            }

            onClicked: {
                let takeoff_item = MissionService.getTakeoff()
                takeoff_item.coordinate.altitude = parseFloat(idSlider.value.toFixed(1))
                MissionService.updateTakeoff(takeoff_item)
                idRoot.close()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idVerticalLine.left

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                idRoot.close()
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            idSlider.value = MissionService.getTakeoff().coordinate.altitude
        }
    }
}
