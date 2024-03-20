import QtQuick 2.12


Rectangle {
    id: idRoot
    width: parent.width
    height: idMessageItem.height + idButtons.height
    color: theme.backgroundDark
    x: parent.width - width * 1.025
    opacity: 1
    property bool selfDestroying: false
    readonly property real defaultTime: 3000
    property real time: defaultTime
    readonly property real fadeTime: 1000
    radius: 5

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1, 2.25)

    function show(text) {
        idMessage.text = text
    }

    Item {
        id: idMessageItem
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: idRoot.width * 0.95
        height: idMessage.height + (idMessage.height / idMessage.lineCount) * 0.5

        Text {
            id: idMessage
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: idMessageItem.left
            anchors.right: idMessageItem.right
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            wrapMode: Text.WordWrap
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            lineHeight: 1.25
        }
    }

    Item {
        id: idButtons
        anchors.top: idMessageItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: idDisplay.getScaledHeight(0.0275, 0.07)

        Rectangle {
            id: idHorizontalLine
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.background
        }

        Rectangle {
            id: idVerticalLine
            anchors.top: idHorizontalLine.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: idHorizontalLine.horizontalCenter
            width: idHorizontalLine.height
            color: idHorizontalLine.color
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
                id: idSigninButtonText
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('بله')
            }

            onClicked: {
                questions.event(id, true)
                idAnimation.start()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idVerticalLine.left

            Text {
                anchors.top: parent.top
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: 'red'
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('خیر')
            }

            onClicked: {
                questions.event(id, false)
                idAnimation.start()
            }
        }
    }

    SequentialAnimation {
        id: idAnimation
        running: false

        NumberAnimation {
            property: 'x'
            target: idRoot
            to: app.width
            duration: fadeTime
        }

        NumberAnimation {
            property: 'opacity'
            target: idRoot
            to: 0
            duration: 10
        }

        onFinished: {
            idQuestionListModel.remove(id)
        }
    }
}
