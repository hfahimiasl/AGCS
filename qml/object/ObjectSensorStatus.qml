import QtQuick 2.12

import '../model'
import 'qrc:/js/Js.js' as Js


Item {
    id: idRoot

    property var buttonMargin: undefined
    property var progressBarMargin: undefined

    property var fontFamily: font_fa_black.name
    property var pixelSize: idDisplay.getFontScale(1, 1)
    property var buttonName: 'N/A'

    property var min: 0
    property var max: 0
    property var axis: [undefined, undefined, undefined]

    readonly property var text: [
        idRoot.axis[0] === undefined ? 'N/A' : 'X  ' + idRoot.axis[0],
        idRoot.axis[1] === undefined ? 'N/A' : 'Y  ' + idRoot.axis[1],
        idRoot.axis[2] === undefined ? 'N/A' : 'Z  ' + idRoot.axis[2]
    ]

    signal clicked()

    ModelButton {
        id: idButton
        anchors.right: idRoot.right
        anchors.rightMargin: idRoot.buttonMargin
        anchors.verticalCenter: idRoot.verticalCenter
        width: idRoot.width * 0.35
        height: idRoot.height * 0.35
        backgroundColor: theme.backgroundLight
        font.family: idRoot.fontFamily
        font.pixelSize: idRoot.pixelSize
        text: idRoot.buttonName
        onClicked: idRoot.clicked()
    }

    Column {
        id: idColumn
        anchors.left: idRoot.left
        anchors.right: idButton.left
        anchors.verticalCenter: idRoot.verticalCenter
        height: idRoot.height

        Repeater {
            id: idRepeater
            model: 3

            delegate: Item {
                id: idItem
                anchors.left: idColumn.left
                anchors.right: idColumn.right
                height: idColumn.height / 3

                ModelProgressBar {
                    id: idProgressBar
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.5
                    height: parent.height * 0.5
                    value: Js.map(idRoot.axis[model.index], idRoot.min, idRoot.max, 0.0, 1.0)
                }

                Text {
                    id: idText
                    anchors.left: idProgressBar.right
                    anchors.leftMargin: implicitHeight
                    anchors.verticalCenter: idProgressBar.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font.family: font_fa_medium.name
                    font.pixelSize: idRoot.pixelSize
                    text: idRoot.text[model.index]
                }
            }
        }
    }

    function update(sensor_name) {
        idRoot.axis = [
                    parseInt(variable.getValue('RAW_IMU_X' + sensor_name)),
                    parseInt(variable.getValue('RAW_IMU_Y' + sensor_name)),
                    parseInt(variable.getValue('RAW_IMU_Z' + sensor_name))
                ]

        for (let i=0 ; i<3 ; i++) {
            if (idRoot.axis[i] === undefined) {
                continue
            }

            if (idRoot.axis[i] < idRoot.min) {
                idRoot.min = idRoot.axis[i]
            }

            if (idRoot.axis[i] > idRoot.max) {
                idRoot.max = idRoot.axis[i]
            }
        }
    }

    function reset() {
        idRoot.min = 0
        idRoot.max = 0
        idRoot.axis = [undefined, undefined, undefined]
    }
}
