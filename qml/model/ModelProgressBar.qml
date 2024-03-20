import QtQuick 2.12
import QtQuick.Controls 2.12


ProgressBar {
    id: idRoot

    property var title: ''
    property var pixelSize: idDisplay.getFontScale(1, 1)
    property var contentItemColor: theme.primary

    background: Rectangle {
        color: theme.backgroundDark
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4
        clip: true

        Rectangle {
            color: idRoot.contentItemColor
            width: idRoot.width * idRoot.visualPosition
            height: parent.height
        }

        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: font_fa_medium.name
            font.pixelSize: idRoot.pixelSize
            text: idRoot.title
        }
    }
}
