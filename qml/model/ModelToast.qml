import QtQuick 2.12


Rectangle {
    id: idRoot
    width: parent.width * 0.8
    height: idMessage.height + margin
    opacity: 0
    radius: 3

    readonly property int defaultTime: 3000
    readonly property int fadeTime: 300
    readonly property int margin: 10
    property int time: defaultTime

    Text {
        id: idMessage
        wrapMode: Text.Wrap
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: margin / 2
        horizontalAlignment: Text.AlignHCenter
        font.family: font_fa_medium.name
        font.pixelSize: idDisplay.getFontScale(0.9, 2)
        color: theme.text
    }

    SequentialAnimation {
        id: idAnimation
        running: false

        NumberAnimation {
            property: 'opacity'
            target: idRoot
            to: 1
            duration: idRoot.fadeTime
        }

        PauseAnimation {
            duration: idRoot.time - (idRoot.fadeTime * 2)
        }

        NumberAnimation {
            property: 'x'
            target: idRoot
            to: -parent.width
            duration: idRoot.fadeTime
        }

        NumberAnimation {
            property: 'opacity'
            target: idRoot
            to: 0
            duration: 10
        }
    }

    function animate(text, duration) {
        if (typeof duration === 'undefined') {
            idRoot.time = idRoot.defaultTime

        } else {
            idRoot.time = Math.max(duration, idRoot.fadeTime * 2)
        }

        idMessage.text = description
        idAnimation.start()
    }

    function show(type, text, duration) {
        idMessage.color = '#ffffff'

        switch(type) {
        case 'INFO':
            idRoot.color = theme.primary
            animate(text, duration)
            break

        case 'WARN':
            idRoot.color = theme.yellow
            animate(text, duration)
            break

        case 'ERROR':
            idRoot.color = theme.orange
            animate(text, duration)
            break

        default:
            console.error('unknown type')
            break
        }
    }
}
