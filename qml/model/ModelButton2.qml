import QtQuick 2.12


Rectangle {
    id: idRoot
    radius: 3
    color: theme.background

    property string fontFamily: font_fa_medium.name
    property var fontPixelSize: undefined
    property color textColor: theme.text
    property string text: 'button'
    property double textMarginsScale: 0.15

    signal clicked()

    Item {
        anchors.fill: parent
        anchors.margins: Math.min(parent.width, parent.height) * idRoot.textMarginsScale

        Text {
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: idRoot.fontFamily ? idRoot.fontFamily : font.family
            font.pixelSize: idRoot.fontPixelSize === undefined ? parent.height : idRoot.fontPixelSize
            fontSizeMode: Text.Fit
            color: idRoot.textColor
            text: idRoot.text
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: idRoot.clicked()
    }
}
