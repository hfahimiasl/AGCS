import QtQuick 2.12


Rectangle {
    id: idRoot
    radius: height * 0.5

    property bool checked: false
    property real borderWidth: 1

    readonly property real diameter: height - (borderWidth * 2)

    state: 'OFF'

    states: [
        State {
            name: 'ON'
            PropertyChanges { target: idRoot; color: theme.primary }
            PropertyChanges { target: idSlider; x: idRoot.width - (idSlider.width + idRoot.borderWidth) }
            PropertyChanges { target: idRoot; checked: true }
        },
        State {
            name: 'OFF'
            PropertyChanges { target: idRoot; color: theme.backgroundDark }
            PropertyChanges { target: idSlider; x: idRoot.borderWidth }
            PropertyChanges { target: idRoot; checked: false }
        }
    ]

    Rectangle {
        id: idSlider
        x: idRoot.borderWidth
        y: idRoot.borderWidth
        width: idRoot.diameter * (idMouseArea.pressed ? 1.25 : 1)
        height: idRoot.diameter
        radius: idRoot.diameter * 0.5
        color: idMouseArea.pressed ? '#f0f0f0' : '#f6f6f6'
    }

    MouseArea {
        id: idMouseArea
        anchors.fill: parent

        onClicked: {
            idRoot.checked = !idRoot.checked
        }
    }

    onCheckedChanged: {
        idRoot.state = idRoot.checked ? 'ON' : 'OFF'
    }
}
