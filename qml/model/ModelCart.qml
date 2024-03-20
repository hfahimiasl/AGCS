import QtQuick 2.12
import QtQuick.Controls 2.12


Pane {
    id: idRoot
    font.bold: true
    font.family: font_fa_medium.name
    font.pixelSize: idDisplay.getFontScale(1, 1)

    property string tittle: ''                      //can be string or ""
    property var color: theme.backgroundLight      //can be palete
    property real radius: 5                      //can be palete
    property bool titleRightAlignment: true

    readonly property real topMarginGain: 0.025
    readonly property real itemVerticalMargin: idRoot.height * idRoot.topMarginGain * 3 + idText.height + idLine.height
    readonly property real itemHorizontalMargin: idRoot.width * 0.08

    background: Rectangle {
        id: idBackground
        anchors.fill: parent
        color: idRoot.color
        radius: idRoot.radius
        state: (tittle === '') ? 'NaN' : 'Title'

        Text {
            id: idText
            anchors.top: parent.top
            anchors.right: idRoot.titleRightAlignment ? parent.right : undefined
            anchors.left: idRoot.titleRightAlignment ? undefined : parent.left
            anchors.topMargin: parent.height * idRoot.topMarginGain
            anchors.rightMargin: parent.width * idRoot.topMarginGain
            anchors.leftMargin: anchors.rightMargin
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            fontSizeMode: Text.Fit
            font.family: idRoot.font.family
            font.pixelSize: idRoot.font.pixelSize
            color: theme.textDark
            text: tittle // TODO: change to title
        }

        Rectangle {
            id: idLine
            height: 1
            anchors.top: idText.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: parent.height * idRoot.topMarginGain
            anchors.leftMargin: idRoot.itemHorizontalMargin
            anchors.rightMargin: idRoot.itemHorizontalMargin
            color: theme.primaryDark
        }

        states: [
            State
            {
                name: 'NaN'
                PropertyChanges { target: idText; visible : false }
                PropertyChanges { target: idLine; visible : false }
            },
            State
            {
                name: 'Title'
                PropertyChanges { target: idText; visible : true }
                PropertyChanges { target: idLine; visible : true }
            }
        ]
    }
}
