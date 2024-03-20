import QtQuick 2.12


Item {
    id: idRoot
    width: idRoot.radius
    height: idRoot.radius

    property real   radius
    property real   backgroundOpacity: 0.875
    property color  backgroundColor

    property real   contentScale: 0.5 // must be in [0, 1]
    property string contentFont
    property color  contentColor
    property string contentText

    property bool focusState: true

    signal clicked()

    Rectangle {
        id: idBackground
        anchors.fill: parent
        radius: width * 0.5
        opacity: idRoot.backgroundOpacity
        color: idRoot.backgroundColor
    }

    Text {
        id: idContent
        anchors.centerIn: parent
        width: parent.width * idRoot.contentScale
        height: parent.height * idRoot.contentScale
        opacity: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        font.family: idRoot.contentFont
        font.pixelSize: 1000
        color: idRoot.contentColor
        text: idRoot.contentText
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            if (idRoot.enabled) {
                idRoot.clicked()
            }
        }
    }

    onFocusStateChanged: {
        if (idRoot.focusState) {
            idBackground.opacity = idRoot.backgroundOpacity
            idContent.opacity = 1

        } else {
            idBackground.opacity = 0.25
            idContent.opacity = 0.75
        }
    }
}
