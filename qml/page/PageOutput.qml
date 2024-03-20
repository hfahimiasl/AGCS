import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'
import '../object'
import 'qrc:/js/Js.js' as Js


ModelPagetype {
    id: idPageOutput

    property bool paramsDownloaded: false

    Item {
        id: idPageOutputItem
        anchors.fill: parent
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin

        ScrollView {
            anchors.fill: parent
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                anchors.fill: parent
                model: 1

                delegate: Item {
                    anchors.centerIn: parent
                    width: parent.width
                    height: idDisplay.isLargeDisplay ? idPageOutputItem.height : (idFrameModelCart.height + idCameraTriggerModelCart.height + idServoOutputsModelcart.height + idPageOutputItem.anchors.topMargin * 2)

                    ModelCart {
                        id: idFrameModelCart
                        tittle: qsTr('بدنه')
                        anchors.top: parent.top
                        anchors.right: parent.right
                        width: idDisplay.getScaledWidth(Js.map(idPageOutputItem.width, idDisplay.minimumWidth, idDisplay.displayWidth, 0.1958, 0.25), idPageOutputItem.width / idDisplay.displayWidth)
                        height: idDisplay.getScaledHeight(0.315, 0.85)
                        font.family: font_fa_medium.name
                        font.pixelSize: idDisplay.getFontScale(1, 2.25)
                        clip: true

                        Text {
                            id: idFrameLabelTxt
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: idFrameModelCart.itemVerticalMargin
                            anchors.rightMargin: parent.width * 0.05
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idFrameModelCart.font
                            text: 'N/A'
                        }

                        ModelCombobox {
                            id: idFrameClassComboBox
                            anchors.right: idFrameLabelTxt.left
                            anchors.rightMargin: parent.width * 0.05
                            anchors.verticalCenter: idFrameLabelTxt.verticalCenter
                            width: parent.width * 0.35
                            height: idFrameLabelTxt.height * 1.75
                            font: idFrameLabelTxt.font
                            editable: true
                            visible: false
                            model: idFrameClassList

                            ListModel {
                                id: idFrameClassList
                            }

                            contentItem: Text {
                                id: idFrameClassComboBoxText
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

                            Component.onCompleted: {
                                idFrameClassList.clear()
                                idFrameClassList.append({ class_list: 'QUAD' })
                                idFrameClassList.append({ class_list: 'Y6' })
                                idFrameClassList.append({ class_list: 'HEXA' })
                                idFrameClassList.append({ class_list: 'OCTO' })
                                idFrameClassList.append({ class_list: 'OCTOQUAD' })
                            }

                            onCurrentTextChanged: {
                                switch (idFrameClassComboBox.currentText) {
                                case 'QUAD':
                                    idFrameTypeList.clear()
                                    idFrameTypeList.append({ type_list: '+' })
                                    idFrameTypeList.append({ type_list: 'X' })
                                    idFrameTypeComboBox.visible = true
                                    break

                                case 'Y6':
                                    idFrameTypeList.clear()
                                    idFrameTypeList.append({ type_list: 'A' })
                                    idFrameTypeList.append({ type_list: 'B' })
                                    idFrameTypeList.append({ type_list: 'F' })
                                    idFrameTypeComboBox.visible = true
                                    break

                                case 'HEXA':
                                    idFrameTypeList.clear()
                                    idFrameTypeList.append({ type_list: '+' })
                                    idFrameTypeList.append({ type_list: 'X' })
                                    idFrameTypeComboBox.visible = true
                                    break

                                case 'OCTO':
                                    idFrameTypeList.clear()
                                    idFrameTypeList.append({ type_list: '+' })
                                    idFrameTypeList.append({ type_list: 'X' })
                                    idFrameTypeComboBox.visible = true
                                    break

                                case 'OCTOQUAD':
                                    idFrameTypeList.clear()
                                    idFrameTypeList.append({ type_list: 'X' })
                                    idFrameTypeComboBox.visible = true
                                    break
                                }

                                idFrameClassComboBoxText.text = idFrameClassComboBox.currentText
                                idFrameTypeComboBoxText.text = ''
                            }
                        }

                        ModelCombobox {
                            id: idFrameTypeComboBox
                            anchors.right: idFrameClassComboBox.left
                            anchors.rightMargin: idFrameClassComboBox.anchors.rightMargin
                            anchors.verticalCenter: idFrameClassComboBox.verticalCenter
                            width: idFrameClassComboBox.width * 0.5
                            height: idFrameClassComboBox.height
                            font: idFrameClassComboBox.font
                            editable: true
                            visible: false
                            model: idFrameTypeList

                            ListModel {
                                id: idFrameTypeList
                            }

                            contentItem: Text {
                                id: idFrameTypeComboBoxText
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

                            onCurrentTextChanged: {
                                idFrameTypeComboBoxText.text = idFrameTypeComboBox.currentText
                            }
                        }

                        Text {
                            id: idChooseFrameBtn
                            anchors.right: idFrameTypeComboBox.left
                            anchors.rightMargin: idFrameTypeComboBox.anchors.rightMargin
                            anchors.verticalCenter: idFrameLabelTxt.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font.family: fontAwesome.name
                            font.pixelSize: idFrameLabelTxt.font.pixelSize * 1.1
                            text: '\uf00c'
                            visible: false

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    if (link.isConnected() &&
                                            idFrameClassComboBox.currentText !== '' &&
                                            idFrameClassComboBox.currentText !== 'N/A' &&
                                            idFrameTypeComboBox.currentText !== '' &&
                                            idFrameTypeComboBox.currentText !== 'N/A') {
                                        autopilot.setFrame(idFrameClassComboBox.currentText, idFrameTypeComboBox.currentText)

                                    } else if (idFrameClassComboBox.currentText === '' || idFrameTypeComboBox.currentText === '') {
                                        toast.error(qsTr('بدنه خود را انتخاب کنید'), 5000)
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: idImageRectangle
                            anchors.top: idFrameClassComboBox.bottom
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: theme.backgroundLight
                        }

                        Image {
                            id: idFrameImage
                            anchors.centerIn: idImageRectangle
                            source: 'qrc:/images/aircraft/general.svg'
                            sourceSize: Qt.size(idImageRectangle.height * 1.25, idImageRectangle.height * 1.25)

                            readonly property var wing_image: {
                                'FIXEDWING': 'qrc:/images/aircraft/fixed wing.svg'
                            }

                            readonly property var multirotor_image: {
                                'QUAD': {
                                    '+': 'qrc:/images/aircraft/Quad+.svg',
                                    'X': 'qrc:/images/aircraft/QuadX.svg'
                                },

                                'Y6': {
                                    'V': 'qrc:/images/aircraft/Y6.svg',
                                    'Y6B': 'qrc:/images/aircraft/Y6.svg',
                                    'Y6F': 'qrc:/images/aircraft/Y6.svg'
                                },

                                'HEXA': {
                                    '+': 'qrc:/images/aircraft/Hexa+.svg',
                                    'X': 'qrc:/images/aircraft/HexaX.svg'
                                },

                                'OCTO': {
                                    '+': 'qrc:/images/aircraft/Octa+.svg',
                                    'X': 'qrc:/images/aircraft/OctaX.svg'
                                },

                                'OCTOQUAD': {
                                    'X': 'qrc:/images/aircraft/QuadX-coax.svg'
                                }
                            }


                            function updateWing() {
                                idFrameLabelTxt.text = qsTr('نوع بدنه')
                                idChooseFrameBtn.visible = false
                                idFrameClassComboBox.visible = false
                                idFrameTypeComboBox.visible = false

                                var image_source = idFrameImage.wing_image['FIXEDWING']

                                if (typeof image_source !== 'undefined') {
                                    idFrameImage.source = image_source

                                } else {
                                    idFrameImage.source = 'qrc:/images/aircraft/general.svg'
                                }
                            }

                            function updateMultiRotor() {
                                idFrameLabelTxt.text = qsTr('نوع بدنه')
                                idChooseFrameBtn.visible = true
                                idFrameClassComboBox.visible = true
                                idFrameTypeComboBox.visible = true

                                var image_source = 'undefined'

                                if (autopilot.getFrameClass() !== 'N/A') {
                                    image_source = idFrameImage.multirotor_image[autopilot.getFrameClass()][autopilot.getFrameType()]
                                }

                                if (typeof image_source !== 'undefined' && image_source !== 'undefined') {
                                    idFrameImage.source = image_source

                                } else {
                                    idFrameImage.source = 'qrc:/images/aircraft/general.svg'
                                }
                            }

                            function reset() {
                                idFrameLabelTxt.text = qsTr('N/A')
                                idChooseFrameBtn.visible = false
                                idFrameClassComboBox.visible = false
                                idFrameTypeComboBox.visible = false
                                idFrameImage.source = 'qrc:/images/aircraft/general.svg'
                                idFrameClassComboBoxText.text = qsTr('N/A')
                                idFrameTypeComboBoxText.text = qsTr('N/A')
                            }

                            function update() {
                                switch (variable.getText('AIRCRAFT_TYPE')) {
                                case 'FIXEDWING':
                                    idFrameImage.updateWing()
                                    break

                                case 'MULTIROTOR':
                                    idFrameImage.updateMultiRotor()
                                    break

                                default:
                                    idFrameImage.reset()
                                    break
                                }
                            }
                        }


                        Connections {
                            target: ParamService

                            onNotifyDownloadComplete: {
                                paramsDownloaded = true

                                idFrameImage.update()

                                var frame_class = autopilot.getFrameClass()
                                var frame_type = autopilot.getFrameType()

                                idFrameClassComboBoxText.text = frame_class

                                if (frame_class === 'Y6') {
                                    if (frame_type === 'V') {
                                        idFrameTypeComboBoxText.text = 'A'

                                    } else if (frame_type === 'Y6B') {
                                        idFrameTypeComboBoxText.text = 'B'

                                    } else if (frame_type === 'Y6F') {
                                        idFrameTypeComboBoxText.text = 'F'
                                    }

                                } else {
                                    idFrameTypeComboBoxText.text = frame_type
                                }
                            }

                            onNotifyChanges: {
                                if (paramsDownloaded && param.id === 'FRAME_TYPE') {
                                    toast.info(qsTr('بدنه دستگاه تغییر کرد'), 5000)
                                    autopilot.reboot()
                                }
                            }
                        }

                        Connections {
                            target: link

                            onConnectionChanged: {
                                if (!connected) {
                                    paramsDownloaded = false
                                    idFrameImage.reset()
                                }
                            }
                        }
                    }

                    ModelCart {
                        id: idCameraTriggerModelCart
                        tittle: qsTr('دوربین')
                        anchors.top: idFrameModelCart.bottom
                        anchors.left: idFrameModelCart.left
                        anchors.right: idFrameModelCart.right
                        anchors.topMargin: idPageOutputItem.anchors.topMargin
                        height: idDisplay.getScaledHeight(0.125, 0.325)
                        font: idFrameModelCart.font
                        clip: true

                        Rectangle {
                            id: ididCameraTriggerRectangle
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: idCameraTriggerModelCart.itemVerticalMargin
                            color: theme.backgroundLight

                            Column {
                                anchors.centerIn: parent
                                spacing: parent.height * 0.075

                                Item {
                                    width: ididCameraTriggerRectangle.width
                                    height: ididCameraTriggerTypeText.height * 1.75

                                    Text {
                                        id: ididCameraTriggerTypeText
                                        anchors.right: parent.right
                                        anchors.rightMargin: parent.width * 0.015
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idCameraTriggerModelCart.font
                                        text: qsTr('نوع')
                                    }

                                    ModelCombobox {
                                        id: idCameraTriggerTypeComboBox
                                        anchors.right: ididCameraTriggerTypeText.left
                                        anchors.rightMargin: parent.width * 0.025
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: idCameraTriggerPinComboBox.width * 0.9
                                        height: parent.height
                                        font: idCameraTriggerModelCart.font
                                        editable: true

                                        model: ListModel {
                                            id: idCameraTriggerTypeComboBoxListModel
                                        }

                                        contentItem: Text {
                                            id: idCameraTriggerTypeComboBoxText
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
                                            idCameraTriggerTypeComboBoxListModel.clear()

                                            if (link.isConnected()) {
                                                let types = autopilot.getAllCameraTriggerTypes()

                                                for (let i=0 ; i<types.length ; i++) {
                                                    idCameraTriggerTypeComboBoxListModel.append({ type: types[i] })
                                                }
                                            }
                                        }

                                        onCurrentTextChanged: {
                                            if (link.isConnected() && currentText !== '' && currentText.indexOf('N/A') === -1) {
                                                autopilot.setCameraTriggerType(currentText)
                                            }
                                        }
                                    }

                                    Text {
                                        id: ididCameraTriggerPinText
                                        anchors.right: idCameraTriggerTypeComboBox.left
                                        anchors.rightMargin: idCameraTriggerTypeComboBox.anchors.rightMargin * 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idCameraTriggerModelCart.font
                                        text: qsTr('خروجی')
                                    }

                                    ModelCombobox {
                                        id: idCameraTriggerPinComboBox
                                        anchors.right: ididCameraTriggerPinText.left
                                        anchors.rightMargin: idCameraTriggerTypeComboBox.anchors.rightMargin
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width * 0.2
                                        height: parent.height
                                        font: idCameraTriggerModelCart.font
                                        editable: true

                                        model: ListModel {
                                            id: idCameraTriggerPinComboBoxListModel
                                        }

                                        contentItem: Text {
                                            id: idCameraTriggerPinComboBoxText
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
                                            idCameraTriggerPinComboBoxListModel.clear()

                                            if (link.isConnected()) {
                                                let pins = autopilot.getAllCameraTriggerPins()

                                                for (let i=0 ; i<pins.length ; i++) {
                                                    idCameraTriggerPinComboBoxListModel.append({ pin: pins[i] })
                                                }
                                            }
                                        }

                                        onCurrentTextChanged: {
                                            if (link.isConnected() && currentText !== '' && currentText.indexOf('N/A') === -1) {
                                                autopilot.setCameraTriggerPin(currentText)
                                            }
                                        }
                                    }

                                    Text {
                                        id: idCameraTriggerTimeText
                                        anchors.right: idCameraTriggerPinComboBox.left
                                        anchors.rightMargin: idCameraTriggerPinComboBox.anchors.rightMargin * 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idCameraTriggerModelCart.font
                                        text: qsTr('زمان')
                                    }

                                    ModelSpinBox {
                                        id: idCameraTriggerTimeSpinBox
                                        anchors.right: idCameraTriggerTimeText.left
                                        anchors.rightMargin: idCameraTriggerPinComboBox.anchors.rightMargin
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width * 0.175
                                        height: parent.height
                                        font: idCameraTriggerModelCart.font
                                        editable: true
                                        realFrom: 0.0
                                        realTo: 5.0
                                        realValue: realFrom
                                        realStepSize: 0.1
                                        decimals: 1

                                        onRealValueChanged: {
                                            if (link.isConnected()) {
                                                ParamService.notifyUpload('CAM_DURATION', realValue * 10)

                                            } else {
                                                reset()
                                            }
                                        }
                                    }
                                }

                                Item {
                                    width: ididCameraTriggerRectangle.width
                                    height: idCameraTriggerPushedText.height * 1.75

                                    Text {
                                        id: idCameraTriggerPushedText
                                        anchors.right: parent.right
                                        anchors.rightMargin: parent.width * 0.015
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idCameraTriggerModelCart.font
                                        text: qsTr('فعال')
                                        visible: idCameraTriggerTypeComboBoxText.text === 'Servo'
                                    }

                                    ModelSpinBox {
                                        id: idCameraTriggerPushedSpinBox
                                        anchors.right: idCameraTriggerPushedText.left
                                        anchors.rightMargin: idCameraTriggerPushedText.anchors.rightMargin
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width * 0.275
                                        height: parent.height
                                        font: idCameraTriggerPushedText.font
                                        editable: true
                                        realFrom: 800
                                        realTo: 2200
                                        realValue: 1900
                                        realStepSize: 1
                                        decimals: 0
                                        visible: idCameraTriggerPushedText.visible

                                        onRealValueChanged: {
                                            if (link.isConnected()) {
                                                ParamService.notifyUpload('CAM_SERVO_ON', realValue)

                                            } else {
                                                set(1900)
                                            }
                                        }
                                    }

                                    Text {
                                        id: idCameraTriggerNotPushedText
                                        anchors.right: idCameraTriggerPushedSpinBox.left
                                        anchors.rightMargin: idCameraTriggerPushedSpinBox.anchors.rightMargin * 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idCameraTriggerModelCart.font
                                        text: qsTr('غیرفعال')
                                        visible: idCameraTriggerPushedText.visible
                                    }

                                    ModelSpinBox {
                                        id: idCameraTriggerNotPushedSpinBox
                                        anchors.right: idCameraTriggerNotPushedText.left
                                        anchors.rightMargin: idCameraTriggerPushedText.anchors.rightMargin
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: idCameraTriggerPushedSpinBox.width
                                        height: parent.height
                                        font: idCameraTriggerPushedText.font
                                        editable: true
                                        realFrom: 800
                                        realTo: 2200
                                        realValue: 1100
                                        realStepSize: 1
                                        decimals: 0
                                        visible: idCameraTriggerPushedText.visible

                                        onRealValueChanged: {
                                            if (link.isConnected()) {
                                                ParamService.notifyUpload('CAM_SERVO_OFF', realValue)

                                            } else {
                                                set(1100)
                                            }
                                        }
                                    }

                                    Text {
                                        id: idCameraTriggerTakePhotoText
                                        anchors.right: idCameraTriggerNotPushedSpinBox.left
                                        anchors.rightMargin: idCameraTriggerPinComboBox.anchors.rightMargin * 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font.family: fontAwesome.name
                                        font.pixelSize: idDisplay.getFontScale(1.75, 3.5)
                                        text: '\uf030'

                                        MouseArea {
                                            anchors.fill: parent

                                            onPressedChanged: {
                                                idCameraTriggerTakePhotoText.color = (pressed && link.isConnected()) ? theme.primary : theme.text
                                            }

                                            onClicked: {
                                                if (link.isConnected()) {
                                                    autopilot.triggerCamera()

                                                } else {
                                                    toast.error(qsTr('دستگاه متصل نیست'), 5000)
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Connections {
                                target: ParamService

                                onNotifyDownloadComplete: {
                                    idCameraTriggerTypeComboBoxText.text = autopilot.getCameraTriggerType()
                                    idCameraTriggerPinComboBoxText.text = autopilot.getCameraTriggerPin()
                                    idCameraTriggerTimeSpinBox.set(ParamService.get('CAM_DURATION').value * 0.1)
                                    idCameraTriggerPushedSpinBox.set(ParamService.get('CAM_SERVO_ON').value)
                                    idCameraTriggerNotPushedSpinBox.set(ParamService.get('CAM_SERVO_OFF').value)
                                }

                                onNotifyChanges: {
                                    let id = param.id

                                    if (id === 'CAM_TRIGG_TYPE') {
                                        idCameraTriggerTypeComboBoxText.text = autopilot.getCameraTriggerType()
                                        idCameraTriggerPinComboBoxText.text = autopilot.getCameraTriggerPin()

                                    } else if (id === 'RELAY_PIN' || (id.indexOf('SERVO') !== -1 && id.indexOf('FUNCTION') !== -1)) {
                                        idCameraTriggerPinComboBoxText.text = autopilot.getCameraTriggerPin()

                                    } else if (id === 'CAM_DURATION') {
                                        idCameraTriggerTimeSpinBox.set(param.value * 0.1)

                                    } else if (id === 'CAM_SERVO_ON') {
                                        idCameraTriggerPushedSpinBox.set(param.value)

                                    } else if (id === 'CAM_SERVO_OFF') {
                                        idCameraTriggerNotPushedSpinBox.set(param.value)
                                    }
                                }
                            }

                            Connections {
                                target: link

                                onConnectionChanged: {
                                    if (!connected) {
                                        idCameraTriggerTypeComboBoxText.text = 'N/A'
                                        idCameraTriggerPinComboBoxText.text = 'N/A'
                                        idCameraTriggerTimeSpinBox.reset()
                                        idCameraTriggerPushedSpinBox.set(1900)
                                        idCameraTriggerNotPushedSpinBox.set(1100)
                                    }
                                }
                            }
                        }
                    }

                    ModelCart {
                        id: idServoOutputsModelcart
                        tittle: qsTr('خروجی ها')
                        anchors.top: idDisplay.isLargeDisplay ? idFrameModelCart.top : idCameraTriggerModelCart.bottom
                        anchors.left: parent.left
                        anchors.right: idDisplay.isLargeDisplay ? idFrameModelCart.left : idFrameModelCart.right
                        anchors.topMargin: idDisplay.isLargeDisplay ? undefined : idCameraTriggerModelCart.anchors.topMargin
                        anchors.rightMargin: idDisplay.isLargeDisplay ? idPageOutputItem.anchors.rightMargin : undefined
                        height: idDisplay.getScaledHeight(parent.height / idDisplay.displayHeight, 2)
                        font.family: font_fa_medium.name
                        font.pixelSize: idDisplay.getFontScale(1, 2.25)

                        Item {
                            id: idServoOutputsTitles
                            anchors.top: parent.top
                            anchors.topMargin: idServoOutputsModelcart.itemVerticalMargin * 0.9
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: idServoOutputsModelcart.width * 0.9
                            height: idFrequencyText.height * 1.75

                            Item {
                                id: idFrequencyItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                width: parent.width * 0.35

                                Text {
                                    id: idFrequencyText
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    color: theme.text
                                    fontSizeMode: Text.Fit
                                    font: idServoOutputsModelcart.font
                                    text: qsTr('فرکانس')
                                }

                                ModelSpinBox {
                                    id: idFrequencySpinBox
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * 0.5
                                    height: parent.height
                                    font: idServoOutputsModelcart.font
                                    editable: true
                                    realFrom: 50
                                    realTo: 1000
                                    realValue: 400
                                    realStepSize: 1
                                    decimals: 0

                                    onRealValueChanged: {
                                        if (link.isConnected()) {
                                            if (variable.getValue('ARM_STATUS')) {
                                                idFrequencySpinBox.set(autopilot.getOutputRate())
                                                toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                autopilot.setOutputRate(realValue)
                                            }

                                        } else {
                                            idFrequencySpinBox.set(400)
                                        }
                                    }

                                    Connections {
                                        target: ParamService

                                        onNotifyDownloadComplete: {
                                            idFrequencySpinBox.set(autopilot.getOutputRate())
                                        }

                                        onNotifyChanges: {
                                            idFrequencySpinBox.set(autopilot.getOutputRate())
                                        }
                                    }

                                    Connections {
                                        target: link

                                        onConnectionChanged: {
                                            if (!connected) {
                                                idFrequencySpinBox.set(400)
                                            }
                                        }
                                    }
                                }
                            }

                            Item {
                                id: idFunctionItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: idFrequencyItem.left
                                anchors.rightMargin: parent.width * 0.013
                                width: parent.width * 0.15

                                Text {
                                    anchors.centerIn: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: theme.text
                                    fontSizeMode: Text.Fit
                                    font: idServoOutputsModelcart.font
                                    text: qsTr('عملکرد')
                                }
                            }

                            Item {
                                id: idMinimumItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: idFunctionItem.left
                                anchors.rightMargin: idFunctionItem.anchors.rightMargin
                                width: idFunctionItem.width

                                Text {
                                    anchors.centerIn: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: theme.text
                                    fontSizeMode: Text.Fit
                                    font: idServoOutputsModelcart.font
                                    text: qsTr('کمترین')
                                }
                            }

                            Item {
                                id: idTrimItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: idMinimumItem.left
                                anchors.rightMargin: idMinimumItem.anchors.rightMargin
                                width: idMinimumItem.width

                                Text {
                                    anchors.centerIn: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: theme.text
                                    fontSizeMode: Text.Fit
                                    font: idServoOutputsModelcart.font
                                    text: qsTr('آستانه')
                                }
                            }

                            Item {
                                id: idMaximumItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: idTrimItem.left
                                anchors.rightMargin: idTrimItem.anchors.rightMargin
                                width: idTrimItem.width

                                Text {
                                    anchors.centerIn: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    color: theme.text
                                    fontSizeMode: Text.Fit
                                    font: idServoOutputsModelcart.font
                                    text: qsTr('بیشترین')
                                }
                            }
                        }

                        ScrollView {
                            anchors.top: idServoOutputsTitles.bottom
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: parent.height * 0.015
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            ScrollBar.vertical.interactive: true
                            ScrollBar.horizontal.interactive: true

                            ListView {
                                id: idServoOutputsListView
                                anchors.fill: parent
                                spacing: 5
                                model: 16

                                delegate: ObjectAux {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: idServoOutputsTitles.width
                                    height: (idServoOutputsListView.height - (idServoOutputsListView.spacing * 15)) / 16
                                    pixelSize: idServoOutputsModelcart.font.pixelSize

                                    onMinChanged: {
                                        if (link.isConnected()) {
                                            if (variable.getValue('ARM_STATUS')) {
                                                setMin(autopilot.getOutputMin(model.index + 1))
                                                toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                autopilot.setOutputMin(model.index + 1, min)
                                            }

                                        } else {
                                            setMin(1000)
                                        }
                                    }

                                    onMaxChanged: {
                                        if (link.isConnected()) {
                                            if (variable.getValue('ARM_STATUS')) {
                                                setMax(autopilot.getOutputMax(model.index + 1))
                                                toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                autopilot.setOutputMax(model.index + 1, max)
                                            }

                                        } else {
                                            setMax(2000)
                                        }
                                    }

                                    onTrimChanged: {
                                        if (link.isConnected()) {
                                            if (variable.getValue('ARM_STATUS')) {
                                                setTrim(autopilot.getOutputTrim(model.index + 1))
                                                toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                autopilot.setOutputTrim(model.index + 1, trim)
                                            }

                                        } else {
                                            setTrim(1500)
                                        }
                                    }

                                    onComboCurrentTextChanged: {
                                        if (link.isConnected() && comboCurrentText !== '' && comboCurrentText !== 'N/A') {
                                            autopilot.setOutputFunction(model.index + 1, comboCurrentText)
                                        }
                                    }

                                    onReverseChanged: {
                                        if (link.isConnected()) {
                                            if (variable.getValue('ARM_STATUS')) {
                                                setReverse(autopilot.isOutputReversed(model.index + 1))

                                            } else {
                                                autopilot.setOutputReversed(model.index + 1, reverse)
                                            }

                                        } else {
                                            setReverse(false)
                                        }
                                    }

                                    Connections {
                                        target: variable

                                        onNotifyChanges: {
                                            if (id.indexOf('SERVO') !== -1) {
                                                progressValue = variable.getValue('SERVO' + (model.index + 1) + '_RAW')
                                            }
                                        }
                                    }

                                    Connections {
                                        target: ParamService

                                        onNotifyDownloadComplete: {
                                            setMin(autopilot.getOutputMin(model.index + 1))
                                            setMax(autopilot.getOutputMax(model.index + 1))
                                            setTrim(autopilot.getOutputTrim(model.index + 1))
                                            setFunc(autopilot.getOutputFunction(model.index + 1))
                                            setReverse(autopilot.isOutputReversed(model.index + 1))
                                        }

                                        onNotifyChanges: {
                                            setMin(autopilot.getOutputMin(model.index + 1))
                                            setMax(autopilot.getOutputMax(model.index + 1))
                                            setTrim(autopilot.getOutputTrim(model.index + 1))
                                            setFunc(autopilot.getOutputFunction(model.index + 1))
                                            setReverse(autopilot.isOutputReversed(model.index + 1))
                                        }
                                    }

                                    Connections {
                                        target: link

                                        onConnectionChanged: {
                                            if (!connected) {
                                                reset()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
