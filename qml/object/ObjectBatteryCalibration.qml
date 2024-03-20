import QtQuick 2.12

import '../model'


ModelCart {
    id: idRoot
    width: idDisplay.getScaledWidth(0.25, 0.575)
    height: idDisplay.getScaledHeight(0.285, 0.7)
    tittle: qsTr(('تنظیمات باتری %1').arg(idRoot.batteryID))

    property int batteryID: 1

    property bool enableMode: false
    property bool paramDownloaded: false
    property bool aircraftArmed: true
    property bool aircraftConnected: false

    readonly property real rightMargin: idMinArmingVoltageText.implicitWidth + idMinArmingVoltageSpinBox.anchors.rightMargin

    Item {
        id: idContentItem
        anchors.fill: parent
        anchors.topMargin: idRoot.itemVerticalMargin

        Column {
            anchors.centerIn: parent
            spacing: parent.height * 0.025

            Item {
                id: idBatteryMonitorItem
                width: idContentItem.width
                height: idBatteryMonitorText.height * 1.75
                enabled: idRoot.aircraftConnected && !idRoot.aircraftArmed && idRoot.paramDownloaded
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idBatteryMonitorText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('مانیتور باتری')
                }

                ModelCombobox {
                    id: idBatteryMonitorCombobox
                    anchors.right: parent.right
                    anchors.rightMargin: idRoot.rightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierSpinBox.width
                    height: parent.height
                    font: idRoot.font
                    editable: true

                    model: ListModel {
                        id: idBatteryMonitorListModel
                    }

                    contentItem: Text {
                        id: idBatteryMonitorComboBoxTxt
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
                        idBatteryMonitorListModel.clear()

                        if (link.isConnected()) {
                            let batt_options = autopilot.getBatteryMonitorOptions()

                            for (let i=0 ; i<batt_options.length ; ++i) {
                                idBatteryMonitorListModel.append({ batt_option: batt_options[i] })
                            }
                        }
                    }

                    onCurrentTextChanged: {
                        idRoot.setPrerequisites()
                        autopilot.setBatteryMonitorOption(idRoot.batteryID, currentText)
                    }
                }
            }

            Item {
                width: idBatteryMonitorItem.width
                height: idBatteryMonitorItem.height
                enabled: idBatteryMonitorItem.enabled && idRoot.enableMode
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idBatteryCapacityText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('ظرفیت باتری (mAh)')
                }

                ModelSpinBox {
                    id: idBatteryCapacitySpinBox
                    anchors.right: parent.right
                    anchors.rightMargin: idRoot.rightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierSpinBox.width
                    height: parent.height
                    font: idRoot.font
                    editable: true
                    realFrom: 0
                    realTo: 100000
                    realValue: realFrom
                    realStepSize: 50
                    decimals: 0

                    onRealValueChanged: {
                        if (link.isConnected()) {
                            idRoot.setPrerequisites()
                            ParamService.notifyUpload(idRoot.rebuildParamID('BATT_CAPACITY'), idBatteryCapacitySpinBox.realValue)

                        } else {
                            idBatteryCapacitySpinBox.reset()
                        }
                    }
                }
            }

            Item {
                width: idBatteryMonitorItem.width
                height: idBatteryMonitorItem.height
                enabled: idBatteryMonitorItem.enabled && idRoot.enableMode
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idMinArmingVoltageText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('حداقل ولتاژ فعال شدن (V)')
                }

                ModelSpinBox {
                    id: idMinArmingVoltageSpinBox
                    anchors.right: idMinArmingVoltageText.left
                    anchors.rightMargin: parent.width * 0.025
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierSpinBox.width
                    height: parent.height
                    font: idRoot.font
                    editable: true
                    realFrom: 0
                    realTo: 75
                    realValue: realFrom
                    realStepSize: 0.1
                    decimals: 1

                    onRealValueChanged: {
                        if (link.isConnected()) {
                            idRoot.setPrerequisites()
                            ParamService.notifyUpload(idRoot.rebuildParamID('BATT_ARM_VOLT'), idMinArmingVoltageSpinBox.realValue)

                        } else {
                            idMinArmingVoltageSpinBox.reset()
                        }
                    }
                }
            }

            Item {
                width: idBatteryMonitorItem.width
                height: idBatteryMonitorItem.height
                enabled: idBatteryMonitorItem.enabled && idRoot.enableMode
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idVoltageMultiplierText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('ضریب ولتاژ')
                }

                ModelSpinBox {
                    id: idVoltageMultiplierSpinBox
                    anchors.right: parent.right
                    anchors.rightMargin: idRoot.rightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.3
                    height: parent.height
                    font: idRoot.font
                    editable: true
                    realFrom: 0
                    realTo: 100 // TODO: set this value based standards
                    realValue: realFrom
                    realStepSize: 1
                    decimals: 3

                    onRealValueChanged: {
                        if (link.isConnected()) {
                            idRoot.setPrerequisites()
                            ParamService.notifyUpload(idRoot.rebuildParamID('BATT_VOLT_MULT'), idVoltageMultiplierSpinBox.realValue)

                        } else {
                            idVoltageMultiplierSpinBox.reset()
                        }
                    }
                }

                ModelButton2 {
                    id: idVoltageMultiplierButton
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.2
                    height: parent.height * 0.85
                    radius: 3
                    text: qsTr('محاسبه')
                    onClicked: idVoltageMultiplierCalculator.openByID(idRoot.batteryID)
                }
            }

            Item {
                width: idBatteryMonitorItem.width
                height: idBatteryMonitorItem.height
                enabled: idBatteryMonitorItem.enabled && idRoot.enableMode
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idCurrentPerVoltageText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('جریان بر ولتاژ (A/V)')
                }

                ModelSpinBox {
                    id: idCurrentPerVoltageSpinBox
                    anchors.right: parent.right
                    anchors.rightMargin: idRoot.rightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierSpinBox.width
                    height: parent.height
                    font: idRoot.font
                    editable: true
                    realFrom: 0
                    realTo: 100 // TODO: set this value based standards
                    realValue: realFrom
                    realStepSize: 1
                    decimals: 3

                    onRealValueChanged: {
                        if (link.isConnected()) {
                            idRoot.setPrerequisites()
                            ParamService.notifyUpload(idRoot.rebuildParamID('BATT_AMP_PERVLT'), idCurrentPerVoltageSpinBox.realValue)

                        } else {
                            idCurrentPerVoltageSpinBox.reset()
                        }
                    }
                }

                ModelButton2 {
                    id: idCurrentPerVoltageButton
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierButton.width
                    height: idVoltageMultiplierButton.height
                    radius: idVoltageMultiplierButton.radius
                    text: qsTr('محاسبه')
                    onClicked: idCurrentPerVoltageCalculator.openByID(idRoot.batteryID)
                }
            }

            Item {
                width: idBatteryMonitorItem.width
                height: idBatteryMonitorItem.height
                enabled: idBatteryMonitorItem.enabled && idRoot.enableMode
                opacity: enabled ? 1 : 0.5

                Text {
                    id: idCurrentOffsetText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: qsTr('آفست جریان (V)')
                }

                ModelSpinBox {
                    id: idCurrentOffsetSpinBox
                    anchors.right: parent.right
                    anchors.rightMargin: idRoot.rightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    width: idVoltageMultiplierSpinBox.width
                    height: parent.height
                    font: idRoot.font
                    editable: true
                    realFrom: 0
                    realTo: 50
                    realValue: realFrom
                    realStepSize: 1
                    decimals: 3

                    onRealValueChanged: {
                        if (link.isConnected()) {
                            idRoot.setPrerequisites()
                            ParamService.notifyUpload(idRoot.rebuildParamID('BATT_AMP_OFFSET'), idCurrentOffsetSpinBox.realValue)

                        } else {
                            idCurrentOffsetSpinBox.reset()
                        }
                    }
                }
            }
        }
    }

    function rebuildParamID(id) {
        return idRoot.batteryID === 1 ? id : (id.substring(0, 4) + String(idRoot.batteryID) + id.substring(4, id.length))
    }

    function setPrerequisites() {
        ParamService.notifyUpload(idRoot.rebuildParamID('BATT_VOLT_PIN'), 2)
        ParamService.notifyUpload(idRoot.rebuildParamID('BATT_CURR_PIN'), 3)
    }

    function update(force, id) {
        if (force || id === idRoot.rebuildParamID('BATT_MONITOR')) {
            idRoot.enableMode = autopilot.isBatteryMonitorEnabled(idRoot.batteryID)
            idBatteryMonitorComboBoxTxt.text = autopilot.getBatteryMonitorOption(idRoot.batteryID)

            if (id === idRoot.rebuildParamID('BATT_MONITOR')) {
                toast.warn(qsTr('برای اعمال تغییرات دستگاه را مجددا راه اندازی کنید'), 5000)
            }
        }

        if (force || id === idRoot.rebuildParamID('BATT_CAPACITY')) idBatteryCapacitySpinBox.set(ParamService.get(idRoot.rebuildParamID('BATT_CAPACITY')).value)
        if (force || id === idRoot.rebuildParamID('BATT_ARM_VOLT')) idMinArmingVoltageSpinBox.set(ParamService.get(idRoot.rebuildParamID('BATT_ARM_VOLT')).value)
        if (force || id === idRoot.rebuildParamID('BATT_VOLT_MULT')) idVoltageMultiplierSpinBox.set(ParamService.get(idRoot.rebuildParamID('BATT_VOLT_MULT')).value)
        if (force || id === idRoot.rebuildParamID('BATT_AMP_PERVLT')) idCurrentPerVoltageSpinBox.set(ParamService.get(idRoot.rebuildParamID('BATT_AMP_PERVLT')).value)
        if (force || id === idRoot.rebuildParamID('BATT_AMP_OFFSET')) idCurrentOffsetSpinBox.set(ParamService.get(idRoot.rebuildParamID('BATT_AMP_OFFSET')).value)
    }

    function reset() {
        idRoot.enableMode = false
        idRoot.paramDownloaded = false

        idBatteryMonitorComboBoxTxt.text = 'N/A'

        idBatteryCapacitySpinBox.reset()
        idMinArmingVoltageSpinBox.reset()
        idVoltageMultiplierSpinBox.reset()
        idCurrentPerVoltageSpinBox.reset()
        idCurrentOffsetSpinBox.reset()
    }

    Connections {
        target: ParamService

        onNotifyDownloadComplete: {
            idRoot.paramDownloaded = true
            idRoot.update(true)
        }

        onNotifyChanges: {
            if (idRoot.paramDownloaded) {
                idRoot.update(false, param.id)
            }
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            idRoot.aircraftConnected = connected

            if (!connected) {
                idRoot.reset()
            }
        }
    }

    Connections {
        target: variable

        onNotifyChanges: {
            if (id === 'ARM_STATUS') {
                idRoot.aircraftArmed = parseInt(variable.getValue(id)) > 0
            }
        }
    }
}
