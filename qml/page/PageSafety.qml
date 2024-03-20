import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import '../model'
import '../object'


ModelPagetype {
    id: idRoot

    property bool paramDownloaded: false

    Flickable {
        id: idFlickable
        anchors.fill: parent
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
        contentWidth: idFlickable.width
        contentHeight: idGrid.implicitHeight
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        clip: true

        readonly property real columns: idDisplay.isLargeDisplay ? 2 : 1
        readonly property real rowSpacing: idDisplay.getScaledHeight(0.01, 0.015)
        readonly property real columnSpacing: idDisplay.getScaledWidth(0.005, 0.01)

        ScrollBar.vertical: ScrollBar {
            id: idScrollBar
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
        }

        Grid {
            id: idGrid
            anchors.fill: parent
            columns: idFlickable.columns
            columnSpacing: idFlickable.columnSpacing
            rowSpacing: idFlickable.rowSpacing
            layoutDirection: Qt.RightToLeft

            ModelCart {
                id: idBatteryModelCart
                tittle: qsTr('باتری')
                width: idDisplay.getScaledWidth(0.25, 0.575)
                height: idDisplay.getScaledHeight(0.125, 0.325)
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1, 2.25)

                Rectangle {
                    id: idBatteryRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idBatteryModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        anchors.centerIn: parent
                        spacing: parent.height * 0.075

                        Item {
                            width: idBatteryRectangle.width
                            height: idBatteryWarningVoltageText.height * 1.75

                            Text {
                                id: idBatteryWarningVoltageText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idBatteryModelCart.font
                                text: qsTr('ولتاژ اخطار')
                            }

                            ModelSpinBox {
                                id: idBatteryWarningVoltageSpinBox
                                anchors.right: parent.right
                                anchors.rightMargin: idBatteryCriticalVoltageText.implicitWidth + idBatteryCriticalVoltageSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: idBatteryCriticalVoltageSpinBox.width
                                height: parent.height
                                font: idBatteryModelCart.font
                                editable: true
                                realFrom: 0
                                realTo: 100 // TODO: set this value based standards
                                realValue: realFrom
                                realStepSize: 0.1
                                decimals: 1

                                onRealValueChanged: {
                                    if (link.isConnected()) {
                                        if (realValue >= autopilot.getCriticalVoltageThreshold() + 1) {
                                            autopilot.setLowVoltageThreshold(realValue)

                                        } else {
                                            autopilot.setLowVoltageThreshold(autopilot.getCriticalVoltageThreshold() + 1)
                                        }

                                    } else {
                                        idBatteryWarningVoltageSpinBox.reset()
                                    }
                                }
                            }

                            Text {
                                id: idBatteryWarningActionText
                                anchors.right: idBatteryWarningVoltageSpinBox.left
                                anchors.rightMargin: idBatteryCriticalActionText.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idBatteryModelCart.font
                                text: qsTr('عملیات')
                            }

                            ModelCombobox {
                                id: idBatteryWarningActionComboBox
                                anchors.right: idBatteryWarningActionText.left
                                anchors.rightMargin: idBatteryCriticalVoltageSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: idBatteryCriticalActionComboBox.width
                                height: parent.height
                                font: idBatteryModelCart.font
                                editable: true

                                model: ListModel {
                                    id: idBatteryWarningListModel
                                }

                                contentItem: Text {
                                    id: idBatteryWarningActionComboBoxTxt
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
                                    idBatteryWarningListModel.clear()

                                    if (link.isConnected()) {
                                        var low_voltage_actions = autopilot.getAllLowVoltageActions()

                                        for (var i=0 ; i<low_voltage_actions.length ; i++) {
                                            idBatteryWarningListModel.append({ low_voltage: low_voltage_actions[i] })
                                        }
                                    }
                                }

                                onCurrentTextChanged: {
                                    autopilot.setLowVoltageAction(currentText)
                                }
                            }
                        }

                        Item {
                            width: idBatteryRectangle.width
                            height: idBatteryCriticalVoltageText.height * 1.75

                            Text {
                                id: idBatteryCriticalVoltageText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idBatteryModelCart.font
                                text: qsTr('ولتاژ تخلیه')
                            }

                            ModelSpinBox {
                                id: idBatteryCriticalVoltageSpinBox
                                anchors.right: idBatteryCriticalVoltageText.left
                                anchors.rightMargin: parent.width * 0.025
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.2
                                height: parent.height
                                font: idBatteryModelCart.font
                                editable: true
                                realFrom: 0
                                realTo: 100 // TODO: set this value based standards
                                realValue: realFrom
                                realStepSize: 0.1
                                decimals: 1

                                onRealValueChanged: {
                                    if (link.isConnected()) {
                                        if (realValue >= autopilot.getCriticalVoltageThreshold() + 1) {
                                            autopilot.setLowVoltageThreshold(realValue)

                                        } else {
                                            autopilot.setLowVoltageThreshold(autopilot.getCriticalVoltageThreshold() + 1)
                                        }

                                    } else {
                                        idBatteryCriticalVoltageSpinBox.reset()
                                    }
                                }
                            }

                            Text {
                                id: idBatteryCriticalActionText
                                anchors.right: idBatteryCriticalVoltageSpinBox.left
                                anchors.rightMargin: idBatteryCriticalVoltageSpinBox.anchors.rightMargin * 2
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idBatteryModelCart.font
                                text: qsTr('عملیات')
                            }

                            ModelCombobox {
                                id: idBatteryCriticalActionComboBox
                                anchors.right: idBatteryCriticalActionText.left
                                anchors.rightMargin: idBatteryCriticalVoltageSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.45
                                height: parent.height
                                font: idBatteryModelCart.font
                                editable: true

                                model: ListModel {
                                    id: idBatteryCriticalListModel
                                }

                                contentItem: Text {
                                    id: idBatteryCriticalActionComboBoxTxt
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
                                    idBatteryCriticalListModel.clear()

                                    if (link.isConnected()) {
                                        var critical_voltage_actions = autopilot.getAllCriticalVoltageActions()

                                        for (var i=0 ; i<critical_voltage_actions.length ; i++) {
                                            idBatteryCriticalListModel.append({ critical_voltage: critical_voltage_actions[i] })
                                        }
                                    }
                                }

                                onCurrentTextChanged: {
                                    autopilot.setCriticalVoltageAction(currentText)
                                }
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idFenceModelCart
                tittle: qsTr('محدوده پرواز')
                width: idDisplay.getScaledWidth(0.27, 0.625)
                height: idDisplay.getScaledHeight(0.125, 0.325)
                font: idBatteryModelCart.font

                ModelSwitch {
                    id: idEnableFenceSwitch
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: idFenceModelCart.topPadding * -0.5
                    width: height * 1.75
                    height: parent.height * 0.15
                    visible: idRoot.paramDownloaded

                    onCheckedChanged: {
                        if (link.isConnected()) {
                            idFenceMaxRadiusFlightSpinBox.enabled = checked
                            idFenceMaxRadiusActionComboBox.enabled = checked
                            idFenceMaxAltActionComboBox.enabled = checked
                            idFenceMaxAltSpinBox.enabled = checked

                            autopilot.enableFence(checked)

                        } else {
                            checked = false
                        }
                    }
                }

                Rectangle {
                    id: idFenceRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idFenceModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idFenceColumn
                        anchors.centerIn: parent
                        spacing: parent.height * 0.075

                        Item {
                            width: idFenceRectangle.width
                            height: idFenceMaxAltText.height * 1.75

                            Text {
                                id: idFenceMaxAltText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idFenceModelCart.font
                                text: qsTr('حداکثر ارتفاع')
                            }

                            ModelSpinBox {
                                id: idFenceMaxAltSpinBox
                                anchors.right: parent.right
                                anchors.rightMargin: idFenceMaxAltText.implicitWidth + idFenceMaxRadiusFlightSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: idFenceMaxRadiusFlightSpinBox.width
                                height: parent.height
                                font: idFenceModelCart.font
                                editable: true
                                realFrom: 10
                                realTo: 1000
                                realValue: realFrom
                                realStepSize: 1
                                decimals: 0

                                onRealValueChanged: {
                                    if (link.isConnected()) {
                                        autopilot.setFenceAltitudeMax(realValue)

                                    } else {
                                        idFenceMaxAltSpinBox.reset()
                                    }
                                }
                            }

                            Text {
                                id: idFenceMaxAltActionText
                                anchors.right: idFenceMaxAltSpinBox.left
                                anchors.rightMargin: idFenceMaxRadiusActionText.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idFenceModelCart.font
                                text: qsTr('نوع')
                            }

                            ModelCombobox {
                                id: idFenceMaxAltActionComboBox
                                anchors.right: idFenceMaxAltActionText.right
                                anchors.rightMargin: idFenceMaxRadiusActionText.implicitWidth + idFenceMaxRadiusFlightSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: idFenceMaxRadiusActionComboBox.width
                                height: parent.height
                                font: idFenceModelCart.font
                                editable: true

                                model: ListModel {
                                    id: idFenceMaxAltActionListModel
                                }

                                contentItem: Text {
                                    id: idFenceMaxAltActionComboBoxText
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
                                    idFenceMaxAltActionListModel.clear()

                                    if (link.isConnected()) {
                                        var fence_types = autopilot.getAllFenceTypes()

                                        for (var i=0 ; i<fence_types.length ; i++) {
                                            idFenceMaxAltActionListModel.append({ fence_type: fence_types[i] })
                                        }
                                    }
                                }

                                onCurrentTextChanged: {
                                    if (currentText !== '') {
                                        autopilot.setFenceType(currentText)
                                    }
                                }
                            }
                        }

                        Item {
                            width: idFenceRectangle.width
                            height: idFenceMaxRadiusText.height * 1.75

                            Text {
                                id: idFenceMaxRadiusText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idFenceModelCart.font
                                text: qsTr('حداکثر فاصله')
                            }

                            ModelSpinBox {
                                id: idFenceMaxRadiusFlightSpinBox
                                anchors.right: idFenceMaxRadiusText.left
                                anchors.rightMargin: parent.width * 0.02
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.225
                                height: parent.height
                                font: idFenceModelCart.font
                                editable: true
                                realFrom: 30
                                realTo: 10000
                                realValue: realFrom
                                realStepSize: 1
                                decimals: 0

                                onRealValueChanged: {
                                    if (link.isConnected()) {
                                        autopilot.setFenceRadiusMax(realValue)

                                    } else {
                                        idFenceMaxRadiusFlightSpinBox.reset()
                                    }
                                }
                            }

                            Text {
                                id: idFenceMaxRadiusActionText
                                anchors.right: idFenceMaxRadiusFlightSpinBox.left
                                anchors.rightMargin: idFenceMaxRadiusFlightSpinBox.anchors.rightMargin * 2
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idFenceModelCart.font
                                text: qsTr('عملیات')
                            }

                            ModelCombobox {
                                id: idFenceMaxRadiusActionComboBox
                                anchors.right: idFenceMaxRadiusActionText.left
                                anchors.rightMargin: idFenceMaxRadiusFlightSpinBox.anchors.rightMargin
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.435
                                height: parent.height
                                font: idFenceModelCart.font
                                editable: true

                                model: ListModel {
                                    id: idFenceMaxRadiusActionListModel
                                }

                                contentItem: Text {
                                    id: idFenceMaxRadiusActionComboBoxText
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
                                    idFenceMaxRadiusActionListModel.clear()

                                    if (link.isConnected()) {
                                        var fence_actions = autopilot.getAllFenceActions()

                                        for (var i=0 ; i<fence_actions.length ; i++) {
                                            idFenceMaxRadiusActionListModel.append({ fence_action: fence_actions[i]})
                                        }
                                    }
                                }

                                onCurrentTextChanged: {
                                    if (currentText !== '') {
                                        autopilot.setFenceAction(currentText)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ObjectBatteryCalibration {
                id: idBatteryCalibration1
                font: idBatteryModelCart.font
                batteryID: 1
            }

            ObjectBatteryCalibration {
                id: idBatteryCalibration2
                font: idBatteryCalibration1.font
                batteryID: 2
            }
        }
    }

    ObjectVoltageMultiplierCalculator {
        id: idVoltageMultiplierCalculator
    }

    ObjectCurrentPerVoltageCalculator {
        id: idCurrentPerVoltageCalculator
    }

    function update(force, id) {
        idBatteryWarningActionComboBoxTxt.text = autopilot.getLowVoltageAction()
        idBatteryWarningVoltageSpinBox.set(autopilot.getLowVoltageThreshold())

        idBatteryCriticalActionComboBoxTxt.text = autopilot.getCriticalVoltageAction()
        idBatteryCriticalVoltageSpinBox.set(autopilot.getCriticalVoltageThreshold())

        idFenceMaxAltActionComboBoxText.text = autopilot.getFenceType()
        idFenceMaxRadiusActionComboBoxText.text = autopilot.getFenceAction()

        idFenceMaxAltSpinBox.set(autopilot.getFenceAltitudeMax())
        idFenceMaxRadiusFlightSpinBox.set(autopilot.getFenceRadiusMax())

        if (force || id === 'FENCE_ENABLE') {
            idEnableFenceSwitch.checked = autopilot.isFenceEnabled()
        }
    }

    function reset() {
        idBatteryWarningActionComboBoxTxt.text = 'N/A'
        idBatteryWarningVoltageSpinBox.reset()

        idBatteryCriticalActionComboBoxTxt.text = 'N/A'
        idBatteryCriticalVoltageSpinBox.reset()

        idFenceMaxAltActionComboBoxText.text = 'N/A'
        idFenceMaxRadiusActionComboBoxText.text = 'N/A'

        idFenceMaxAltSpinBox.reset()
        idFenceMaxRadiusFlightSpinBox.reset()

        idBatteryWarningListModel.clear()
        idBatteryCriticalListModel.clear()
        idFenceMaxRadiusActionListModel.clear()
        idFenceMaxAltActionListModel.clear()

        idEnableFenceSwitch.checked = false

        idRoot.paramDownloaded = false

        idVoltageMultiplierCalculator.close()
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
            if (!connected) {
                idRoot.reset()
            }
        }
    }
}
