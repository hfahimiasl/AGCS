import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


Rectangle {
    id: idRoot
    anchors.fill: parent
    color: 'transparent'

    signal closed

    readonly property real verticalMargin: idDisplay.getScaledHeight(0.01, 0.015)
    readonly property real horizontalMargin: idDisplay.getScaledWidth(0.005, 0.01)
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)
    readonly property string fontFamily: font_fa_medium.name
    readonly property real fadeTime: 250

    property var param: ParamService.get('')

    Rectangle {
        id: idBackground
        anchors.fill: parent
        color: theme.backgroundLight
        opacity: 0.5
        visible: false

        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: idContent
        width: idDisplay.getScaledWidth(0.15, 0.35)
        height: parent.height
        x: -width
        color: theme.backgroundDark
        clip: true

        onXChanged: {
            if (idContent.x === -idContent.width) {
                idRoot.closed()
            }
        }

        Item {
            id: idTextfieldItem
            anchors.top: parent.top
            anchors.topMargin: idRoot.verticalMargin
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.85
            height: idDisplay.getScaledHeight(0.03, 0.09)

            ModelTextfield {
                id: idTextfield
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                placeholderText: qsTr('مقدار')
                validator: RegExpValidator {
                    regExp: idRoot.param === null ? /w+/ : (idRoot.param.decimal ? /^(0|(?!(0))[-+]?\d*)(\.\d{6})?$/ : /^(0|(?!(0))[-+]?\d*)$/)
                }

                onTextChanged: {
                    if (idTextfield.text !== '') {
                        idTextfield.resetBorderColor()
                    }
                }
            }
        }

        Item {
            id: idButtons
            anchors.top: idTextfieldItem.bottom
            anchors.topMargin: idRoot.verticalMargin
            anchors.left: parent.left
            anchors.right: parent.right
            height: idDisplay.getScaledHeight(0.0275, 0.07)

            Rectangle {
                id: idTopHorizontalLine
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: theme.background
            }

            Rectangle {
                id: idBottomHorizontalLine
                anchors.bottom: parent.bottom
                anchors.left: idTopHorizontalLine.left
                anchors.right: idTopHorizontalLine.right
                height: idTopHorizontalLine.height
                color: idTopHorizontalLine.color
            }

            Rectangle {
                id: idVerticalLine
                anchors.top: idTopHorizontalLine.top
                anchors.bottom: idBottomHorizontalLine.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: idTopHorizontalLine.height
                color: idTopHorizontalLine.color
            }

            MouseArea {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: idVerticalLine.right
                anchors.right: idTopHorizontalLine.right

                Text {
                    id: idSigninButtonText
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.primary
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    text: qsTr('ذخیره')
                }

                onClicked: {
                    if (idTextfield.text === '') {
                        idTextfield.borderColor = 'red'
                        return
                    }

                    let value = idRoot.param.decimal ? parseFloat(idTextfield.text) : parseInt(idTextfield.text)

                    if (value < idRoot.param.min) {
                        toast.error(qsTr('مقدار وارد شده کمتر از حد مجاز است'), 5000)
                        idTextfield.borderColor = 'red'
                        return
                    }

                    if (value > idRoot.param.max) {
                        toast.error(qsTr('مقدار وارد شده بیشتر از حد مجاز است'), 5000)
                        idTextfield.borderColor = 'red'
                        return
                    }

                    ParamService.notifyUpload(idRoot.param.id, value)
                    idRoot.close()
                }
            }

            MouseArea {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: idTopHorizontalLine.left
                anchors.right: idVerticalLine.left

                Text {
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
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

        Flickable {
            id: idFlickable
            anchors.top: idButtons.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: idRoot.verticalMargin * 3
            anchors.bottomMargin: idRoot.verticalMargin
            anchors.leftMargin: idRoot.horizontalMargin
            anchors.rightMargin: anchors.leftMargin
            contentWidth: idColumn.width
            contentHeight: idColumn.height
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            ScrollBar.vertical: ScrollBar {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: idColumn
                anchors.centerIn: parent
                spacing: 10

                Item {
                    id: idParamIDItem
                    width: idFlickable.width
                    height: idParamIDTitle.implicitHeight * 1.2
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.id !== undefined

                    Text {
                        id: idParamIDTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('شناسه')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamIDItem.isExist ? idRoot.param.id : 'N/A'
                    }
                }

                Item {
                    id: idParamIndexItem
                    width: idFlickable.width
                    height: idParamIndexTitle.implicitHeight * 1.2
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.index !== undefined

                    Text {
                        id: idParamIndexTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('شاخص')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamIndexItem.isExist ? idRoot.param.index : 'N/A'
                    }
                }

                Item {
                    id: idParamGroupItem
                    width: idFlickable.width
                    height: isExist ? idParamGroupTitle.implicitHeight * 1.2 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.group !== undefined && idRoot.param.group !== ''

                    Text {
                        id: idParamGroupTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('گروه')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamGroupItem.isExist ? idRoot.param.group : ''
                    }
                }

                Item {
                    id: idParamCategoryItem
                    width: idFlickable.width
                    height: isExist ? idParamCategoryTitle.implicitHeight * 1.2 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.category !== undefined && idRoot.param.category !== ''

                    Text {
                        id: idParamCategoryTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('دسته بندی')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamCategoryItem.isExist ? idRoot.param.category : ''
                    }
                }

                Item {
                    id: idParamShortDescriptionTitleItem
                    width: idFlickable.width
                    height: idParamShortDescriptionItem.isExist ? idParamShortDescriptionTitle.implicitHeight * 1.2 : 0
                    clip: true

                    Text {
                        id: idParamShortDescriptionTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('توضیح کوتاه')
                    }
                }

                Item {
                    id: idParamShortDescriptionItem
                    width: idFlickable.width
                    height: isExist ? idParamShortDescription.implicitHeight + idParamShortDescriptionTitleItem.height * 0.25 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.short_description !== undefined && idRoot.param.short_description !== ''

                    Text {
                        id: idParamShortDescription
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignJustify
                        color: theme.text
                        wrapMode: Text.Wrap
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamShortDescriptionItem.isExist ? idRoot.param.short_description : ''
                    }
                }

                Item {
                    id: idParamLongDescriptionTitleItem
                    width: idFlickable.width
                    height: idParamLongDescriptionItem.isExist ? idParamLongDescriptionTitle.implicitHeight * 1.2 : 0
                    clip: true

                    Text {
                        id: idParamLongDescriptionTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('توضیح کامل')
                    }
                }

                Item {
                    id: idParamLongDescriptionItem
                    width: idFlickable.width
                    height: isExist ? idParamLongDescription.implicitHeight + idParamLongDescriptionTitleItem.height * 0.25 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.long_description !== undefined && idRoot.param.long_description !== ''

                    Text {
                        id: idParamLongDescription
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignJustify
                        color: theme.text
                        wrapMode: Text.Wrap
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamLongDescriptionItem.isExist ? idRoot.param.long_description : ''
                    }
                }

                Item {
                    id: idParamUnitTextItem
                    width: idFlickable.width
                    height: isExist ? idParamUnitTextTitle.implicitHeight * 1.2 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.unit_text !== undefined && idRoot.param.unit_text !== ''

                    Text {
                        id: idParamUnitTextTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('واحد')
                    }

                    Text {
                        id: idParamUnitText
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamUnitTextItem.isExist ? idRoot.param.unit_text : ''
                    }
                }

                Item {
                    id: idParamTypeItem
                    width: idFlickable.width
                    height: isExist ? idParamTypeTitle.implicitHeight * 1.2 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.type_text !== undefined && idRoot.param.type_text !== ''

                    Text {
                        id: idParamTypeTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('نوع')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamTypeItem.isExist ? idRoot.param.type_text : ''
                    }
                }

                Item {
                    id: idParamMinItem
                    width: idFlickable.width
                    height: idParamMinTitle.implicitHeight * 1.2
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.min !== undefined

                    Text {
                        id: idParamMinTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('کمترین')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamMinItem.isExist ? (idRoot.param.decimal ? idRoot.param.min.toFixed(6) : idRoot.param.min) : 'N/A'
                    }
                }

                Item {
                    id: idParamMaxItem
                    width: idFlickable.width
                    height: idParamMaxTitle.implicitHeight * 1.2
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.max !== undefined

                    Text {
                        id: idParamMaxTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('بیشترین')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamMaxItem.isExist ? (idRoot.param.decimal ? idRoot.param.max.toFixed(6) : idRoot.param.max) : 'N/A'
                    }
                }

                Item {
                    id: idParamIncrementSizeItem
                    width: idFlickable.width
                    height: idParamIncrementSizeTitle.implicitHeight * 1.2
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.decimal !== undefined && idRoot.param.increment_size !== undefined

                    Text {
                        id: idParamIncrementSizeTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('اندازه تغییرات')
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        color: theme.text
                        fontSizeMode: Text.Fit
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: idParamIncrementSizeItem.isExist ? (idRoot.param.decimal ? idRoot.param.increment_size.toFixed(6) : idRoot.param.increment_size) : 'N/A'
                    }
                }

                Item {
                    id: idRebootRequiredItem
                    width: idFlickable.width
                    height: isExist ? idRebootRequiredTitle.implicitHeight * 1.2 : 0
                    clip: true

                    readonly property bool isExist: idRoot.param !== null && idRoot.param.reboot_required !== undefined && idRoot.param.reboot_required === true

                    Text {
                        id: idRebootRequiredTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        color: '#a3a310'
                        wrapMode: Text.Wrap
                        font.family: idRoot.fontFamily
                        font.pixelSize: idRoot.fontPixelSize
                        text: qsTr('بعد از ذخیره تغییرات دستگاه را مجددا راه اندازی کنید')
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: 'ESC'
        onActivated: idRoot.close()
    }

    SequentialAnimation {
        id: idOpenAnimation
        running: false

        NumberAnimation {
            property: 'x'
            target: idContent
            to: 0
            duration: idRoot.fadeTime
        }
    }

    SequentialAnimation {
        id: idCloseAnimation
        running: false

        NumberAnimation {
            id: idCloseNumberAnimation
            property: 'x'
            target: idContent
            to: -idContent.width
            duration: idRoot.fadeTime
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (connected) {
                idCloseNumberAnimation.duration = idRoot.fadeTime

            } else {
                idCloseNumberAnimation.duration = 0
                idRoot.close()
            }
        }
    }

    function open(param) {
        idRoot.param = param
        idTextfield.text = param.decimal ? param.value.toFixed(6) : param.value
        idBackground.visible = true

        if (idCloseAnimation.running) {
            idCloseAnimation.stop()
        }

        idOpenAnimation.start()
    }

    function close() {
        idBackground.visible = false

        if (idOpenAnimation.running) {
            idOpenAnimation.stop()
        }

        idCloseAnimation.start()
    }
}
