import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    width: idDisplay.getScaledWidth(0.205, 0.45)
    height: idTitle.height + idDescription.height + idContainer.height + idButtons.height + idRoot.bottomPadding + (idRoot.topPadding * 4.0)

    property int batteryID: 1
    property bool upload: false

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    Text {
        id: idTitle
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        fontSizeMode: Text.Fit
        font.family: font_fa_black.name
        font.pixelSize: idRoot.fontPixelSize
        font.bold: true
        color: theme.text
        text: qsTr(('باتری #%1').arg(idRoot.batteryID))
    }

    Text {
        id: idDescription
        anchors.top: idTitle.bottom
        anchors.topMargin: idRoot.topPadding
        width: parent.width
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignJustify
        wrapMode: Text.WordWrap
        lineHeight: 1.25
        font.family: font_fa_medium.name
        font.pixelSize: idDisplay.getFontScale(1.05, 2.1)
        color: theme.text
        clip: true
        text: qsTr('برای محاسبه ضریب جریان ، ابتدا مقدار دقیق جریان را با استفاده از مولتی متر بدست آورده و در فیلد زیر وارد کنید. سپس روی دکمه محاسبه کلیک کنید.')
    }

    Item {
        id: idContainer
        anchors.top: idDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding
        height: idBatteryCurrentText.height * 1.75

        Text {
            id: idBatteryCurrentText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            fontSizeMode: Text.Fit
            font.family: font_fa_medium.name
            font.pixelSize: idDisplay.getFontScale(1, 2.25)
            color: theme.text
            text: qsTr('جریان باتری (A)')
        }

        ModelTextfield {
            id: idBatteryCurrentTextField
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.3
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            backgroundColor: theme.background
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            validator: RegExpValidator { regExp: /^\d{1,2}(\.\d{1,3})?$/ }
            onTextChanged: {
                if (idBatteryCurrentTextField.text === '') {
                    idBatteryCurrentTextField.borderColor = 'red'

                } else {
                    idBatteryCurrentTextField.resetBorderColor()
                }
            }
        }
    }

    Item {
        id: idButtons
        anchors.top: idContainer.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding
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
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('محاسبه')
            }

            onClicked: {
                if (!idBatteryCurrentTextField.acceptableInput) {
                    idBatteryCurrentTextField.borderColor = 'red'
                    return
                }

                const old_mult = ParamService.get(idRoot.rebuildParamID('BATT_AMP_PERVLT')).value

                if (old_mult === undefined || isNaN(old_mult)) {
                    toast.warn(qsTr('پارامتر ها را بارگیری کرده و مجددا تلاش کنید'), 5000)
                    idRoot.close()
                    return
                }

                if (old_mult === 0) {
                    toast.warn(qsTr('مقدار ضریب جریان را به 1 تغییر داده و دوباره امتحان کنید'), 5000)
                    idRoot.close()
                    return
                }

                const current = variable.getValue(idRoot.rebuildVariableID('BATTERY_CURRENT'))

                if (isNaN(current)) {
                    toast.warn(qsTr('دستگاه خود را مجددا راه اندازی کنید و از درستی جریان باتری مطمئن شوید'), 5000)
                    idRoot.close()
                    return
                }

                if (current === 0) {
                    toast.warn(qsTr('مقدار ضریب جریان را افزایش داده و دوباره امتحان کنید'), 5000)
                    idRoot.close()
                    return
                }

                const mult = (parseFloat(idBatteryCurrentTextField.text) * old_mult) / current
                ParamService.notifyUpload(idRoot.rebuildParamID('BATT_AMP_PERVLT'), mult)
                idRoot.upload = true
                idRoot.close()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idVerticalLine.left

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                idRoot.close()
            }
        }
    }

    function rebuildParamID(id) {
        return idRoot.batteryID === 1 ? id : (id.substring(0, 4) + String(idRoot.batteryID) + id.substring(4, id.length))
    }

    function rebuildVariableID(id) {
        return id.substring(0, 7) + String(idRoot.batteryID) + id.substring(7, id.length)
    }

    function openByID(id) {
        idBatteryCurrentTextField.resetBorderColor()
        const current = variable.getValue(idRoot.rebuildVariableID('BATTERY_CURRENT'))
        idBatteryCurrentTextField.text = isNaN(current) ? '0.000' : current.toFixed(3)
        idRoot.batteryID = id
        idRoot.open()
    }

    Connections {
        target: ParamService

        onNotifyChanges: {
            if (idRoot.upload && param.id === idRoot.rebuildParamID('BATT_AMP_PERVLT')) {
                idRoot.upload = false
                toast.info(qsTr('تغییرات اعمال شد'), 5000)
            }
        }
    }
}
