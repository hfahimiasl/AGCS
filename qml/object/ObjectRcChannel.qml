import QtQuick 2.12

import '../model'
import 'qrc:/js/Js.js' as Js


Item {
    id: idRoot

    property var title: ''
    property var progressBarTitle: ''
    property var min: 800
    property var max: 2200
    property var validMin: 1000
    property var validMax: 2000
    property var value: 0
    property var fontFamily: font_fa_medium.name
    property var pixelSize: idDisplay.getFontScale(1, 1)
    property var paramDownloaded: false

    Text {
        id: idServoOutputsRateText
        anchors.right: parent.right
        anchors.verticalCenter: idRoot.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: idRoot.fontFamily
        font.pixelSize: idRoot.pixelSize
        text: idRoot.title
    }

    ModelProgressBar {
        anchors.left: parent.left
        anchors.right: idRoot.title === '' ? parent.right : idServoOutputsRateText.left
        anchors.rightMargin: idRoot.title === '' ? undefined : idServoOutputsRateText.implicitHeight
        anchors.verticalCenter: idRoot.verticalCenter
        height: parent.height * 0.5
        pixelSize: idRoot.pixelSize
        title: idRoot.progressBarTitle
        value: Js.map(idRoot.value, idRoot.min, idRoot.max, 0.0, 1.0)
        contentItemColor: (idRoot.value < idRoot.validMin || idRoot.value > idRoot.validMax) ? (idRoot.paramDownloaded ? 'red' : theme.yellow) : theme.primary
    }

    Connections {
        target: ParamService

        onNotifyDownloadComplete: {
            idRoot.paramDownloaded = true
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            idRoot.paramDownloaded = false
        }
    }
}
