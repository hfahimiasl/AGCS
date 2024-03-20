import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    property real value: 0

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
        text: qsTr('در حال تولید ماموریت')
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
            width: parent.width * 0.15
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            text: parseInt(idRoot.value * 100) + ' %'
        }

        ModelProgressBar {
            id: idProgressBar
            anchors.left: parent.left
            anchors.right: idValue.left
            anchors.rightMargin: idRoot.leftPadding
            anchors.verticalCenter: parent.verticalCenter
            height: 5
            value: idRoot.value

            background: Rectangle {
                color: theme.backgroundDark
            }

            contentItem: Item {
                Rectangle {
                    width: idProgressBar.width * idProgressBar.visualPosition
                    height: parent.height
                    color: theme.primary
                }
            }
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

        MouseArea {
            anchors.top: idHorizontalLine.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Text {
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.3
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                PatternService.cancelRenderProcess()
            }
        }
    }
}
