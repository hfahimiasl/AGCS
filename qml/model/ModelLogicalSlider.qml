import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle {
    id: idRoot
    radius: height * 0.5
    color: backgroundColor

    property real borderWidth: 2
    property color backgroundColor: theme.background
    property color indicatorColor: theme.primary

    readonly property real diameter: height - (borderWidth * 2)

    signal active

    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: idSlider.right
        anchors.rightMargin: -idRoot.borderWidth
        radius: height * 0.5
        color: idRoot.indicatorColor
    }

    Rectangle {
        id: idSlider
        x: idRoot.borderWidth
        y: idRoot.borderWidth
        width: idRoot.diameter
        height: idRoot.diameter
        radius: idRoot.diameter * 0.5
        color: idMouseArea.pressed ? '#f0f0f0' : '#f6f6f6'
    }

    MouseArea {
        id: idMouseArea
        anchors.fill: idSlider
        drag.target: idSlider
        drag.axis: Drag.XAxis
        drag.minimumX: borderWidth
        drag.maximumX: maxDrag
        preventStealing: true

        readonly property real maxDrag: idRoot.width - (idRoot.diameter + idRoot.borderWidth)
        readonly property bool dragActive: drag.active

        onDragActiveChanged: {
            if (!dragActive) {
                if (idSlider.x > maxDrag - idRoot.borderWidth) {
                    idRoot.active()
                }

                idSlider.x = idRoot.borderWidth
            }
        }
    }
}
