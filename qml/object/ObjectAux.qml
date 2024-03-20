import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


Item {
    id: idRoot

    property int min: 1000
    property int max: 2000
    property int trim: 1500
    property bool reverse: false
    property bool comboEditable: true
    property var comboCurrentText: ''
    property var comboModel: ListModel {}
    property var pixelSize: idDisplay.getFontScale(1, 1)

    property double progressValue: 0

    Row {
        id: idRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: parent.width * 0.013

        ModelSpinBox {
            id: idMaxSpin
            width: idRoot.width * 0.15
            height: idRoot.height
            editable: true
            realFrom: 1700
            realTo: 2200
            realValue: 2000
            realStepSize: 1
            decimals: 0
            font.family: font_fa_medium.name
            font.pixelSize: idRoot.pixelSize

            onRealValueChanged: {
                idRoot.max = realValue
            }
        }

        ModelSpinBox {
            id: idTrimSpin
            width: idRoot.width * 0.15
            height: idRoot.height
            realFrom: 1301
            realTo: 1699
            realValue: 1500
            realStepSize: 1
            decimals: 0
            editable: true
            font.family: font_fa_medium.name
            font.pixelSize: idRoot.pixelSize

            onRealValueChanged: {
                idRoot.trim = realValue
            }
        }

        ModelSpinBox {
            id: idMinSpin
            width: idRoot.width * 0.15
            height: idRoot.height
            realFrom: 800
            realTo: 1300
            realValue: 1000
            realStepSize: 1
            decimals: 0
            editable: true
            font.family: font_fa_medium.name
            font.pixelSize: idRoot.pixelSize

            onRealValueChanged: {
                idRoot.min = realValue
            }
        }

        ModelCombobox {
            id: idFunctionCombo
            width: idRoot.width * 0.15
            height: idRoot.height
            font.family: font_fa_medium.name
            font.pixelSize: idRoot.pixelSize
            editable: idRoot.comboEditable
            model: ListModel { id: idFunctionsListModel }

            contentItem: Text {
                id: idFunctionComboText
                text: 'N/A'
                color: theme.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideMiddle
                anchors.verticalCenter: parent.verticalCenter
                font: parent.font
                fontSizeMode: Text.Fit
                anchors.rightMargin: 10
                anchors.right: parent.right
                anchors.leftMargin: 25
                anchors.left: parent.left
            }

            onPressedChanged: {
                idFunctionsListModel.clear()

                if (link.isConnected() && parseInt(variable.getValue('ARM_STATUS')) === 0) {
                    let output_functions = autopilot.getAllOutputFunctions()

                    for (let i=0 ; i<output_functions.length ; i++) {
                        idFunctionsListModel.append({ output_function: output_functions[i] })
                    }
                }
            }

            onCurrentTextChanged: {
                idRoot.comboCurrentText = currentText
            }
        }

        Item {
            width: idRoot.width * 0.35
            height: idRoot.height

            ModelSwitch {
                id: idSwitch
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: height * 2
                height: parent.height * 0.5

                onCheckedChanged: {
                    idRoot.reverse = checked
                }
            }

            ObjectRcChannel {
                id: idRCChannelItem
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: idSwitch.left
                anchors.rightMargin: idRow.spacing
                pixelSize: idRoot.pixelSize
                value: idRoot.progressValue
            }
        }
    }

    function setMin(_min) {
        idMinSpin.set(_min)
    }

    function setMax(_max) {
        idMaxSpin.set(_max)
    }

    function setTrim(_trim) {
        idTrimSpin.set(_trim)
    }

    function setFunc(_func) {
        idFunctionComboText.text = _func
    }

    function setReverse(_reverse) {
        idSwitch.checked = _reverse
    }

    function reset() {
        setMin(1000)
        setMax(2000)
        setTrim(1500)
        setReverse(false)
        idRoot.progressValue = 0
        idFunctionComboText.text = 'N/A'
    }
}
