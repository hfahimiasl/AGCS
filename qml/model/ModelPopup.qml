import QtQuick 2.12
import QtQuick.Controls 2.12


Popup {
    id: idRoot

    property real radius: 3
    property color backgroundColor: theme.backgroundDark

    property real borderWidth: 0
    property color borderColor: idRoot.backgroundColor

    anchors.centerIn: parent

    // TODO: enable below lines enables us to use animations for popups. use better way!
    // x: (parent.width - width) * 0.5
    // y: (parent.height - height) * 0.5

    visible: false
    modal: true
    clip: true

    background: Rectangle {
        id: idBackground
        anchors.fill: parent
        radius: idRoot.radius
        color: idRoot.backgroundColor
        border.width: idRoot.borderWidth
        border.color: idRoot.borderColor
        opacity: 0.875
    }
}
