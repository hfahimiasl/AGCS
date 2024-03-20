import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12


Item {
    id: idRoot
    property string backcolor: ""
    property string textcolor: ""
    property string textin: ""
    property real pixelSize: idDisplay.fontScale
    width: idRootTxt.width + 20
    height: idRootTxt.height + 5
    visible: false

    Rectangle {
        anchors.fill: parent
        color: backcolor
        opacity: 0.5
        radius: 2

        Text {
            id : idRootTxt
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: idRoot.pixelSize
            font.family: font_fa_black.name
            text: textin
            color: textcolor
        }
    }
}
