import QtQuick 2.12
import QtQuick.Controls 2.12

import '../object'
import '../model'


ModelPagetype {
    id: idPageInput

    Item {
        id: idPageInputItem
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
                    height: idDisplay.isLargeDisplay ? idPageInputItem.height : (idRemoteControlChannelsModelCart.height + idFlightModesModelCart.height + idRemoteControlCalibrationButton.height + idPageInputItem.anchors.topMargin * 2)

                    ModelCart {
                        id: idRemoteControlChannelsModelCart
                        anchors.top: parent.top
                        anchors.right: parent.right
                        width: parent.width
                        height: idDisplay.getScaledHeight(parent.height * 0.4 / idDisplay.displayHeight, 1)
                        font.family: font_fa_medium.name
                        font.pixelSize: idDisplay.getFontScale(1, 2.25)
                        tittle: qsTr('کانال ها')
                        clip: true

                        Row {
                            id: idRemoteControlChannelsRow
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: idRemoteControlChannelsModelCart.itemVerticalMargin

                            Repeater {
                                model: 16

                                delegate: Item {
                                    anchors.top: idRemoteControlChannelsRow.top
                                    anchors.bottom: idRemoteControlChannelsRow.bottom
                                    width: idRemoteControlChannelsRow.width / 16

                                    ObjectRcChannel {
                                        id: idRemoteControlChannel
                                        anchors.centerIn: parent
                                        anchors.verticalCenterOffset: (width - parent.height) * 0.5
                                        width: parent.height * 0.85
                                        height: parent.width
                                        rotation: -90
                                        pixelSize: idRemoteControlChannelsModelCart.font.pixelSize
                                    }

                                    ModelSwitch {
                                        id: idReverseSwitch
                                        anchors.bottom: parent.bottom
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: idRemoteControlChannel.height * (idDisplay.isLargeDisplay ? 0.35 : 0.7)
                                        height: width * 0.5

                                        onCheckedChanged: {
                                            if (link.isConnected()) {
                                                ParamService.notifyUpload('RC' + (model.index + 1) + '_REVERSED', checked)

                                            } else if (checked) {
                                                checked = false
                                                toast.error(qsTr('دستگاه متصل نیست'), 5000)
                                            }
                                        }
                                    }

                                    Connections {
                                        target: variable

                                        onNotifyChanges: {
                                            if (id === 'REMOTE_CONTROL') {
                                                idRemoteControlChannel.value = variable.getValue('REMOTE_CONTROL_CHAN' + (model.index + 1))
                                            }
                                        }
                                    }

                                    Connections {
                                        target: ParamService

                                        onNotifyDownloadComplete: {
                                            idRemoteControlChannel.validMin = ParamService.get('RC' + (model.index + 1) + '_MIN').value
                                            idRemoteControlChannel.validMax = ParamService.get('RC' + (model.index + 1) + '_MAX').value
                                            idReverseSwitch.checked = ParamService.get('RC' + (model.index + 1) + '_REVERSED').value === 1
                                        }

                                        onNotifyChanges: {
                                            idRemoteControlChannel.validMin = ParamService.get('RC' + (model.index + 1) + '_MIN').value
                                            idRemoteControlChannel.validMax = ParamService.get('RC' + (model.index + 1) + '_MAX').value
                                            idReverseSwitch.checked = ParamService.get('RC' + (model.index + 1) + '_REVERSED').value === 1
                                        }
                                    }

                                    Connections {
                                        target: link

                                        onConnectionChanged: {
                                            if (!connected) {
                                                idReverseSwitch.checked = false
                                                idRemoteControlChannel.value = 0
                                                idRemoteControlChannel.validMin = 1000
                                                idRemoteControlChannel.validMax = 2000
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    ModelCart {
                        id: idFlightModesModelCart
                        anchors.top: idRemoteControlChannelsModelCart.bottom
                        anchors.right: idRemoteControlChannelsModelCart.right
                        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
                        width: idRemoteControlChannelsModelCart.width * (idDisplay.isLargeDisplay ? 0.875 : 1) - idDisplay.getScaledWidth(0.005, 0)
                        height: idDisplay.getScaledHeight(0.085, 0.225)
                        font: idRemoteControlChannelsModelCart.font
                        tittle: qsTr('مد های پرواز')
                        clip: true

                        Item {
                            id: idFlightModesContainer
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: idFlightModesModelCart.itemVerticalMargin
                            width: parent.width * (idDisplay.isLargeDisplay ? 0.95 : 1)

                            readonly property real spacing: width * 0.05 / 7
                        }

                        Row {
                            id: idFlightModesRow
                            anchors.top: idFlightModesContainer.top
                            anchors.bottom: idFlightModesContainer.bottom
                            anchors.right: idFlightModesContainer.right
                            width: idFlightModesContainer.width * 6 / 7
                            layoutDirection: Qt.RightToLeft

                            Repeater {
                                model: 6

                                delegate: Item {
                                    anchors.top: idFlightModesRow.top
                                    anchors.bottom: idFlightModesRow.bottom
                                    width: idFlightModesRow.width / 6

                                    readonly property var currentIntex: model.index

                                    Text {
                                        id: idFlightModeText
                                        anchors.right: parent.right
                                        anchors.rightMargin: idFlightModesContainer.spacing
                                        anchors.verticalCenter: parent.verticalCenter
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignRight
                                        color: theme.text
                                        fontSizeMode: Text.Fit
                                        font: idFlightModesModelCart.font
                                        text: qsTr('مد ' + (model.index + 1))
                                    }

                                    ModelCombobox {
                                        id: idFlightModeComboBox
                                        anchors.left: parent.left
                                        anchors.right: idFlightModeText.left
                                        anchors.leftMargin: idFlightModeText.anchors.rightMargin
                                        anchors.rightMargin: anchors.leftMargin
                                        anchors.verticalCenter: parent.verticalCenter
                                        height: parent.height
                                        font: idFlightModesModelCart.font
                                        editable: true

                                        model: ListModel {
                                            id: idFlightModesListModel
                                        }

                                        contentItem: Text {
                                            id: idFlightModeComboBoxText
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
                                            idFlightModesListModel.clear()

                                            if (link.isConnected()) {
                                                let flight_modes = autopilot.getAllFlightModes()

                                                for (let i=0 ; i<flight_modes.length ; i++) {
                                                    idFlightModesListModel.append({ mode: flight_modes[i] })
                                                }
                                            }
                                        }

                                        onCurrentTextChanged: {
                                            if (link.isConnected() && currentText !== '' && currentText.indexOf('N/A') === -1) {
                                                autopilot.setFlightMode(parent.currentIntex + 1, currentText)
                                            }
                                        }
                                    }

                                    Connections {
                                        target: scheduler

                                        onSchedule4Hz: {
                                            if (link.isConnected()) {
                                                idFlightModeComboBoxText.text = autopilot.getFlightMode(model.index + 1)
                                                idFlightModeComboBox.backgroundColorBox = (idFlightModeComboBoxText.text === autopilot.getFlightMode() ? theme.primary : theme.background)

                                            } else {
                                                idFlightModesListModel.clear()
                                                idFlightModeComboBoxText.text = 'N/A'
                                                idFlightModeComboBox.backgroundColorBox = theme.background
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Item {
                            id: idFlightModeChannels
                            anchors.top: idFlightModesContainer.top
                            anchors.bottom: idFlightModesContainer.bottom
                            anchors.left: idFlightModesContainer.left
                            anchors.right: idFlightModesRow.left
                            anchors.leftMargin: idFlightModesContainer.spacing
                            anchors.rightMargin: anchors.leftMargin

                            Text {
                                id: idFlightModeChannelsText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idFlightModesModelCart.font
                                text: qsTr('کانال')
                            }

                            ModelCombobox {
                                id: idFlightModeChannelsComboBox
                                anchors.left: parent.left
                                anchors.right: idFlightModeChannelsText.left
                                anchors.rightMargin: idFlightModesContainer.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                height: parent.height
                                font: idFlightModesModelCart.font
                                editable: true

                                model: ListModel {
                                    id: idFlightModeChannelsListModel
                                }

                                contentItem: Text {
                                    id: idFlightModeChannelsComboBoxText
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
                                    idFlightModeChannelsListModel.clear()

                                    if (link.isConnected()) {
                                        let available_channels = autopilot.getAvailableFlightModeChannels()

                                        for (let i=0 ; i<available_channels.length ; i++) {
                                            idFlightModeChannelsListModel.append({ channel: available_channels[i] })
                                        }
                                    }
                                }

                                onCurrentTextChanged: {
                                    if (link.isConnected() && currentText !== '' && currentText.indexOf('N/A') === -1) {
                                        autopilot.setFlightModeChannel(parseInt(currentText))
                                    }
                                }
                            }

                            Connections {
                                target: scheduler

                                onSchedule4Hz: {
                                    let flight_modes_channel = autopilot.getFlightModeChannel()
                                    idFlightModeChannelsComboBoxText.text = (flight_modes_channel !== -1 ? flight_modes_channel : 'N/A')
                                }
                            }
                        }
                    }

                    ModelButton {
                        id: idRemoteControlCalibrationButton
                        anchors.top: idDisplay.isLargeDisplay ? undefined : idFlightModesModelCart.bottom
                        anchors.right: idDisplay.isLargeDisplay ? idFlightModesModelCart.left : undefined
                        anchors.topMargin: idDisplay.isLargeDisplay ? undefined : idFlightModesModelCart.anchors.topMargin
                        anchors.rightMargin: idDisplay.isLargeDisplay ? (parent.width - idFlightModesModelCart.width - width) * 0.5 : undefined
                        anchors.verticalCenter: idDisplay.isLargeDisplay ? idFlightModesModelCart.verticalCenter : undefined
                        anchors.horizontalCenter: idDisplay.isLargeDisplay ? undefined : idFlightModesModelCart.horizontalCenter
                        width: idDisplay.getScaledWidth((parent.width - idFlightModesModelCart.width - idFlightModesModelCart.anchors.rightMargin) * 0.6 / idDisplay.displayWidth, 0.225)
                        height: idFlightModesModelCart.height * 0.5
                        font.family: font_fa_black.name
                        font.pixelSize: idDisplay.getFontScale(1, 2.5)
                        text: qsTr('کالیبره رادیو کنترل')

                        property bool started: false

                        onClicked: {
                            if (link.isConnected()) {
                                if (parseInt(variable.getValue('ARM_STATUS'))) {
                                    toast.error(qsTr('دستگاه را غیرفعال کنید'), 5000)

                                } else {
                                    if (idRemoteControlCalibrationButton.started) {
                                        if (idRemoteControlCalibrationButton.text === qsTr('ادامه')) {
                                            idRemoteControlCalibrationButton.contentItemColor = theme.primary
                                            idRemoteControlCalibrationButton.text = qsTr('ذخیره')
                                            toast.info(qsTr('جوی استیک ها را در وسط قرار داده و سپس روی دکمه ذخیره کلیک کنید'), 10000)

                                        } else if (idRemoteControlCalibrationButton.text === qsTr('ذخیره')) {
                                            idRemoteControlCalibrationButton.state = 'busy'
                                            autopilot.writeRemoteControllerTrims()
                                        }

                                    } else {
                                        idRemoteControlCalibrationButton.started = true
                                        idRemoteControlCalibrationButton.contentItemColor = theme.primary
                                        idRemoteControlCalibrationButton.text = qsTr('ادامه')
                                        autopilot.requestRemoteControllerCalibration()
                                        toast.info(qsTr('جوی استیک ها و سوئیچ ها را در تمام جهت ها حرکت داده و سپس روی دکمه ادامه کلیک کنید'), 10000)
                                    }
                                }

                            } else {
                                toast.error(qsTr('دستگاه متصل نیست'), 5000)
                            }
                        }

                        Connections {
                            target: autopilot

                            onRemoteControllerCalibrationFailed: {
                                if (!idRemoteControlCalibrationButton.started) { return }
                                idRemoteControlCalibrationButton.state = 'normal'
                                idRemoteControlCalibrationButton.started = false
                                idRemoteControlCalibrationButton.contentItemColor = 'red'
                                idRemoteControlCalibrationButton.text = qsTr('خطا در کالیبره')
                                toast.error(qsTr('خطا در کالیبره رادیو کنترل'), 10000)
                            }

                            onRemoteControllerCalibrationAccepted:{
                                idRemoteControlCalibrationButton.state = 'normal'
                                idRemoteControlCalibrationButton.started = false
                                idRemoteControlCalibrationButton.contentItemColor = theme.primary
                                idRemoteControlCalibrationButton.text = qsTr('کالیبره رادیو کنترل')
                                toast.info(qsTr('کالیبره رادیو کنترل انجام شد'), 10000)
                            }
                        }

                        Connections {
                            target: link

                            onConnectionChanged: {
                                if (!connected) {
                                    if (idRemoteControlCalibrationButton.started) {
                                        idRemoteControlCalibrationButton.contentItemColor = 'red'
                                        idRemoteControlCalibrationButton.text = qsTr('خطا در کالیبره')
                                        toast.error(qsTr('خطا در کالیبره رادیو کنترل'), 10000)

                                    } else {
                                        idRemoteControlCalibrationButton.contentItemColor = theme.primary
                                        idRemoteControlCalibrationButton.text = qsTr('کالیبره رادیو کنترل')
                                    }

                                } else {
                                    idRemoteControlCalibrationButton.contentItemColor = theme.primary
                                    idRemoteControlCalibrationButton.text = qsTr('کالیبره رادیو کنترل')
                                }

                                idRemoteControlCalibrationButton.state = 'normal'
                                idRemoteControlCalibrationButton.started = false
                            }
                        }
                    }
                }
            }
        }
    }
}
