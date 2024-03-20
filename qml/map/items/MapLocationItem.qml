import QtQuick 2.12
import QtLocation 5.12


MapQuickItem {
    id: idRoot
    width: idRoot.radius
    height: idRoot.radius
    anchorPoint.x: width * 0.5
    anchorPoint.y: height * 0.5

    property real radius

    property color backgroundColor

    property string contentFont
    property color  contentColor
    property string contentText
    property real   contentScale: 0.975

    property bool editable: true

    readonly property bool pressed: idMouseArea.pressed

    signal pressAndHold()
    signal positionChanged()
    signal released()
    signal clicked()

    sourceItem: Rectangle {
        width: idRoot.radius
        height: idRoot.radius
        radius: idRoot.radius * 0.5
        color: idRoot.backgroundColor
        clip: true

        Text {
            anchors.centerIn: parent
            width: parent.width * idRoot.contentScale
            height: parent.height * idRoot.contentScale
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            font.family: idRoot.contentFont
            font.pixelSize: 1000
            color: idRoot.contentColor
            text: idRoot.contentText
        }

        MouseArea {
            id: idMouseArea
            anchors.fill: parent
            cursorShape: idRoot.editable ? (drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor) : undefined
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            drag.target: idRoot.editable ? idRoot : undefined
            drag.smoothed: false
            hoverEnabled: true

            onPressAndHold: {
                idRoot.pressAndHold()
            }

            onPositionChanged: {
                idRoot.positionChanged()
            }

            onReleased: {
                idRoot.released()
            }

            onClicked: {
                idRoot.clicked()
            }
        }
    }
}
