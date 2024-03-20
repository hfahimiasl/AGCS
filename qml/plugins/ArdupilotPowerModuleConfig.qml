import QtQuick 2.12
import QtQuick.Controls 2.12

import "../model"
import "../page"
import "../object"
import "../plugins"

ModelCart {
    id : root

    tittle: qsTr("کالیبره باتری")
    height: parent.height * 0.65
    width: parent.width * 0.3
    property var childwidth : root.width * 0.65
    property var childheight: root.height * 0.06

    Column {
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.05
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 25
        spacing: parent.height * 0.04

        Item {
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                text: qsTr("نمایشگر باتری")
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            ModelCombobox {
                id: idBatteryMonitorCombo
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                editable: true

                model: ["Disable", "Enable"]/*ListModel {
                    id: idBatteryMonitorListModel
                }*/

                contentItem: Text {
                    id: idBatteryMonitorComboTxt
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.leftMargin: 25
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "N/A"
                    color: theme.text
                    elide: Text.ElideMiddle
                    minimumPointSize: parseInt(appSetting.fontScale * 2)
                    fontSizeMode: Text.Fit
                    font: font_fa_medium.name
                }
                onCurrentTextChanged: {
                    batteryMonitorItemsEnable()
                }
            }
        }

        Item {
            id: idBatteryCapacityItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("ظرفیت باتری")
            }

            ModelTextfield {
                id: idBatteryCapacityTextField
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                placeholderText: qsTr("MAh")
                validator: DoubleValidator {}
                backgroundColor: theme.background
            }
        }

        Item {
            id: idMinimumArmVoltageItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("حداقل ولتاژ ARM")
            }

            ModelTextfield {
                id: idMinimumArmVoltageTextField
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                placeholderText: qsTr("V")
                validator: DoubleValidator{}
                backgroundColor: theme.background
            }
        }

        Item {
            id: idPowerSensorItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("سنسور پاور")
            }

            ModelCombobox {
                id: idPowerSensorCombo
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                anchors.left: parent.left
                editable: true

                model: ["Disable", "Enable"]/*ListModel {
                    id: idPowerSensorListModel
                }*/

                contentItem: Text {
                    id: idPowerSensorComboTxt
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.leftMargin: 25
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: font_fa_medium.name
                    text: "N/A"
                    color: theme.text
                    elide: Text.ElideMiddle
                    minimumPointSize: parseInt(appSetting.fontScale * 2)
                    fontSizeMode: Text.Fit
                }
                onCurrentTextChanged: {
                    powerSensorItemsEnable()
                }
            }
        }

        Item {
            id: idCurrentPinItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("پین فعلی")
            }

            ModelCombobox {
                id: idCurrentPinCombo
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                editable: true

                model: ListModel {
                    id: idCurrentPinListModel
                }

                contentItem: Text {
                    id: idCurrentPinComboTxt
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.leftMargin: 25
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: font_fa_medium.name
                    text: "N/A"
                    color: theme.text
                    elide: Text.ElideMiddle
                    minimumPointSize: parseInt(appSetting.fontScale * 2)
                    fontSizeMode: Text.Fit
                }
            }
        }

        Item {
            id: idVoltagePinItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("ولتاژ پین")
            }

            ModelCombobox {
                id: idVoltagePinCombo
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                editable: true

                model: ListModel {
                    id: idVoltagePinListModel
                }

                contentItem: Text {
                    id: idVoltagepinComboTxt
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.leftMargin: 25
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font: font_fa_medium.name
                    text: "N/A"
                    color: theme.text
                    elide: Text.ElideMiddle
                    minimumPointSize: parseInt(appSetting.fontScale * 2)
                    fontSizeMode: Text.Fit
                }
            }
        }

        Item {
            id: idVoltageMultiplierItem
            anchors.right: parent.right
            width: root.childwidth * 1.35
            height: root.childheight

            Label {
                id: idVoltageMultiplierLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.25
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Voltage muliplier")
            }

            ModelTextfield {
                id: idVoltageMultiplierCombo
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: idVoltageMultiplierLabel.left
                anchors.left: idVoltageMultiplierCalculateBtn.right
                anchors.rightMargin: parent.width * 0.05
                anchors.leftMargin: parent.width * 0.05
                height: parent.height
                validator: DoubleValidator{}
                backgroundColor: theme.background
            }

            ModelButton {
                id: idVoltageMultiplierCalculateBtn
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.2
                height: parent.height
                font.pointSize: parseInt(appSetting.fontScale * 10)
                text: qsTr("محسابه")
                backgroundColor: theme.purple
                visible: true
                onClicked: {
                    idVoltageMultiplierCalculatePopup.open()
                }
            }
        }

        Item {
            id: idAmpsPerVoltItem
            anchors.right: parent.right
            width: root.childwidth * 1.35
            height: root.childheight

            Label {
                id: idAmpsPerVoltLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.25
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Amps per Voltage")
            }

            ModelTextfield {
                id: idAmpsPerVoltCombo
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: idAmpsPerVoltLabel.left
                anchors.left: idAmpsPerVoltCalculateBtn.right
                anchors.rightMargin: parent.width * 0.05
                anchors.leftMargin: parent.width * 0.05
                height: parent.height
                placeholderText: qsTr("A/V")
                validator: DoubleValidator{}
                backgroundColor: theme.background
            }

            ModelButton {
                id: idAmpsPerVoltCalculateBtn
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.2
                height: parent.height
                font.pointSize: parseInt(appSetting.fontScale * 10)
                text: qsTr("محسابه")
                backgroundColor: theme.purple
                visible: true
                onClicked: {
                    idAmpsPerVoltCalculatePopup.open()
                }
            }
        }

        Item {
            id: idAmpsOffsetItem
            anchors.right: parent.right
            width: root.childwidth
            height: root.childheight

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Amps offset")
            }

            ModelTextfield {
                id: idAmpsOffsetTextField
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                placeholderText: qsTr("V")
                validator: DoubleValidator {}
                backgroundColor: theme.background
            }
        }
    }

    ModelPopup {
        id: idVoltageMultiplierCalculatePopup
        parent: parent
        modal: true
        visible: false
        width: parent.width * 0.9
        height: parent.height * 0.5
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            id: idInfoVoltageMultiplierCalculateLabel
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.15
            font.family: font_fa_medium.name
            font.pointSize: parseInt(appSetting.fontScale * 9)
            minimumPointSize: parseInt(appSetting.fontScale * 2)
            fontSizeMode: Text.Fit
            color: theme.text
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: qsTr("با استفاده از یک ولت متر مقدار ولتاژ باتری را اندازه بگیرید و در باکس پایین وارد کنید.سپس بر روی دکمه محسابه و اعمال کلیک کنید تا مقدار محاسبه شده برای شما اعمال شود.")
        }

        Item {
            id: idMeasureBatteryVoltageItem
            anchors.top: idInfoVoltageMultiplierCalculateLabel.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("ولتاژ اندازه گیری شده")
            }

            ModelTextfield {
                id: idMeasureBatteryVoltageTextField
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                placeholderText: qsTr("V")
                validator: DoubleValidator {}
                backgroundColor: theme.backgroundLight
            }
        }

        Item {
            id: idVehicleCalculatedVoltageItem
            anchors.top: idMeasureBatteryVoltageItem.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("ولتاژ دستگاه :")
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("0.0")
            }
        }

        Item {
            id: idMultiplierCalculatedVoltageItem
            anchors.top: idVehicleCalculatedVoltageItem.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("ولتاژ ضرب شده :")
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("0.0")
            }
        }

        ModelButton {
            id: idVoltageMultiplierCalculateAndsetBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: idMultiplierCalculatedVoltageItem.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.bottom: parent.Bottom
            width: parent.width * 0.5
            font.pointSize: parseInt(appSetting.fontScale * 8)
            text: qsTr("محاسبه و اعمال")
            backgroundColor: theme.purple
            visible: true
            onClicked: {
            }
        }
    }

    ModelPopup {
        id: idAmpsPerVoltCalculatePopup
        parent: parent
        modal: true
        visible: false
        width: parent.width * 0.9
        height: parent.height * 0.5
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            id:idInfoAmpsPerVoltCalculateLabel
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.15
            font.family: font_fa_medium.name
            font.pointSize: parseInt(appSetting.fontScale * 9)
            minimumPointSize: parseInt(appSetting.fontScale * 2)
            fontSizeMode: Text.Fit
            color: theme.text
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            text: qsTr("با استفاده از یک آمپر سنج مقدار جریان باتری را اندازه بگیرید و در باکس پایین وارد کنید.سپس بر روی دکمه محسابه و اعمال کلیک کنید تا مقدار محاسبه شده برای شما اعمال شود.")
        }

        Item {
            id: idMeasureBatteryCurrentItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: idInfoAmpsPerVoltCalculateLabel.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("جریان اندازه گیری شده")
            }

            ModelTextfield {
                id: idMeasureBatteryCurrentTextField
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                height: parent.height
                placeholderText: qsTr("MAh")
                validator: DoubleValidator {}
                backgroundColor: theme.backgroundLight
            }
        }

        Item {
            id: idVehicleCalculatedCurrentItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: idMeasureBatteryCurrentItem.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("جریان دستگاه :")
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("0.0")
            }
        }

        Item {
            id: idAmpsPerVoltCalculatedItem
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: idVehicleCalculatedCurrentItem.bottom
            anchors.topMargin: parent.height * 0.05
            width: parent.width * 0.9
            height: parent.height * 0.15

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("آمپر ثانیه در ولت :")
            }

            Label {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                width: parent.width * 0.35
                height: parent.height
                font.family: font_fa_medium.name
                font.pointSize: parseInt(appSetting.fontScale * 9)
                minimumPointSize: parseInt(appSetting.fontScale * 2)
                fontSizeMode: Text.Fit
                color: theme.text
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("0.0")
            }
        }

        ModelButton {
            id: idAmpsPerVoltCalculateAndsetBtn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: idAmpsPerVoltCalculatedItem.bottom
            anchors.topMargin: parent.height * 0.05
            anchors.bottom: parent.Bottom
            width: parent.width * 0.5
            font.pointSize: parseInt(appSetting.fontScale * 8)
            text: qsTr("محاسبه و اعمال")
            backgroundColor: theme.purple
            visible: true
            onClicked: {
            }
        }
    }

    function batteryMonitorItemsEnable(){

        if(idBatteryMonitorCombo.currentText === "Disable"){

            idPowerSensorItem.enabled       = false
            idMinimumArmVoltageItem.enabled = false
            idBatteryCapacityItem.enabled   = false
            idCurrentPinItem.enabled        = false
            idVoltagePinItem.enabled        = false
            idVoltageMultiplierItem.enabled = false
            idAmpsPerVoltItem.enabled       = false
            idAmpsOffsetItem.enabled        = false


        } else {

            idPowerSensorItem.enabled       = true
            idMinimumArmVoltageItem.enabled = true
            idBatteryCapacityItem.enabled   = true

        }
    }

    function powerSensorItemsEnable(){

        if(idPowerSensorCombo.currentText === "Disable"){

            idCurrentPinItem.enabled        = false
            idVoltagePinItem.enabled        = false
            idVoltageMultiplierItem.enabled = false
            idAmpsPerVoltItem.enabled       = false
            idAmpsOffsetItem.enabled        = false

        }else {

            idCurrentPinItem.enabled        = true
            idVoltagePinItem.enabled        = true
            idVoltageMultiplierItem.enabled = true
            idAmpsPerVoltItem.enabled       = true
            idAmpsOffsetItem.enabled        = true

        }
    }
}
