import QtQuick 2.12
import QtQuick.Controls 2.12


Button {
    id: idRoot

    property var radius: 10

    property var contentItemColor: theme.primary
    property var backgroundColor: theme.background

    property var borderWidth: 3
    property var borderColor: idRoot.contentItemColor

    state: 'normal'
    highlighted: true
    font.family: font_fa_medium.name
    font.pixelSize: idDisplay.getFontScale(1, 1)

    background: Rectangle {
        anchors.fill: parent
        radius: idRoot.radius
        color: idRoot.backgroundColor
        border.width: idRoot.borderWidth
        border.color: idRoot.borderColor
    }

    contentItem: Text {
        id: idContentItem
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
        fontSizeMode: Text.Fit
        opacity: enabled ? 1.0 : 0.3
        color: idRoot.contentItemColor
        font: idRoot.font
        text: idRoot.text
    }

    ModelBusyIndicator {
        id: idBusyIndicator
        anchors.centerIn: parent
        width: parent.height * 0.5
        height: width
    }

    states: [
        State {
            name: 'normal'
            PropertyChanges { target: idRoot ; enabled: true }
            PropertyChanges { target: idContentItem ; visible: true }
            PropertyChanges { target: idBusyIndicator ; visible: false }
        },
        State {
            name: 'busy'
            PropertyChanges { target: idRoot ; enabled: false }
            PropertyChanges { target: idContentItem ; visible: false }
            PropertyChanges { target: idBusyIndicator ; visible: true }
        }
    ]
}

