import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'


ModelPagetype {
    id: idPageFrimware

    property var firmwareTypes: []

    ModelCart {
        id: idModelCart
        tittle: qsTr('بروزرسانی فریمور')
        anchors.fill: parent
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
        font.family: font_fa_medium.name
        font.pixelSize: idDisplay.getFontScale(1.25, 2.5)

        Text {
            id: idChooseFramwareLabelText
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: idModelCart.itemVerticalMargin
            anchors.rightMargin: parent.width * 0.04
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.text
            fontSizeMode: Text.Fit
            font.family: font_fa_medium.name
            font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
            text: qsTr('انتخاب فریمور')
        }

        ModelCombobox {
            id: idChooseFramwareCombo
            anchors.verticalCenter: idChooseFramwareLabelText.verticalCenter
            anchors.right: idChooseFramwareLabelText.left
            anchors.rightMargin: parent.width * 0.02
            width: idChooseFramwareLabelText.width * 1.5
            height: idChooseFramwareLabelText.height * 1.25
            model: ListModel { id: idFirmwareTypes }
        }

        ModelButton {
            id: idUploadFirmwareButton
            anchors.verticalCenter: idChooseFramwareCombo.verticalCenter
            anchors.right: idChooseFramwareCombo.left
            anchors.rightMargin: idChooseFramwareCombo.anchors.rightMargin
            width: idChooseFramwareCombo.width
            height: idChooseFramwareCombo.height
            font.pixelSize: idChooseFramwareLabelText.font.pixelSize
            backgroundColor: idModelCart.color
            text: qsTr('بارگذاری')

            onClicked: {
                if (idChooseFramwareCombo.currentText !== '') {
                    firmware.notifyUpload(idChooseFramwareCombo.currentText)
                }
            }
        }

        ModelProgressBar {
            id: idFramwareUploadProgress
            anchors.top: idUploadFirmwareButton.top
            anchors.bottom: idUploadFirmwareButton.bottom
            anchors.left: parent.left
            anchors.right: idUploadFirmwareButton.left
            anchors.leftMargin: parent.width * 0.04
            anchors.rightMargin: idUploadFirmwareButton.anchors.rightMargin

            Connections {
                target: firmware

                onNotifyProgress: {
                    idFramwareUploadProgress.value = progress / 100
                }
            }
        }

        Rectangle {
            id: idFrimwareLogRec
            anchors.top: idFramwareUploadProgress.bottom
            anchors.bottom: parent.bottom
            anchors.left: idFramwareUploadProgress.left
            anchors.right: idChooseFramwareLabelText.right
            anchors.topMargin: parent.height * 0.02
            anchors.bottomMargin:parent.height * 0.025
            border.color: theme.backgroundLight
            color: theme.background

            Flickable {
                id: idFrimwareLogTextAreaScroll
                anchors.top:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height
                width: parent.width
                contentWidth: idConsoleLog.width
                contentHeight: idConsoleLog.height
                interactive: true
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                ScrollBar.vertical: ScrollBar {
                    parent: idFrimwareLogTextAreaScroll.parent
                    anchors.top: idFrimwareLogTextAreaScroll.top
                    anchors.left: idFrimwareLogTextAreaScroll.left
                    anchors.bottom: idFrimwareLogTextAreaScroll.bottom
                    policy: ScrollBar.AlwaysOn
                }

                TextArea {
                    id: idConsoleLog
                    width: idFrimwareLogTextAreaScroll.width
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    font.family: font_fa_medium.name
                    font.pixelSize: idDisplay.getFontScale(1.05, 2.1)
                    readOnly: true
                    text: ''
                }
            }

            Connections {
                target: firmware

                onNotifyFirmwaresList: {
                    firmwareTypes = list
                    idFirmwareTypes.clear()

                    for (var i=0 ; i<firmwareTypes.length ; i++) {
                        idFirmwareTypes.append({ type: firmwareTypes[i] })
                    }

                    if (firmwareTypes.length > 0) {
                        idFrimwareLogRec.log(qsTr('لیست فریمور ها دریافت شد'))
                        idFrimwareLogRec.log(qsTr('فریمور مورد نظر خود را انتخاب کنید'))
                        idChooseFramwareCombo.currentIndex = 0
                    }
                }

                onNotifyInfo: {
                    idFrimwareLogRec.log(info)

                    if (info === qsTr('لغو بارگذاری')) {
                        idUploadFirmwareButton.state = 'normal'
                    }
                }

                onNotifyError: {
                    if (error.indexOf('Get Board Info: Sync: Send Command: Invalid sync responce:') !== -1) {
                        idUploadFirmwareButton.state = 'normal'
                        idFrimwareLogRec.log(error)
                    }
                }

                onNotifyStart: {
                    idFrimwareLogRec.resetLog()
                    idUploadFirmwareButton.state = 'busy'
                }

                onNotifyComplete: {
                    idUploadFirmwareButton.state = 'normal'
                    idMenuView.setVisible('Main')
                    idFrimwareLogRec.resetLog()
                }
            }

            Component.onCompleted: {
                idFrimwareLogRec.resetLog()
            }

            function resetLog() {
                idConsoleLog.text = ''
                idConsoleLog.text += qsTr('دستگاه خود را قطع و مجددا به سیستم متصل نمایید\r\n')
                idConsoleLog.text += qsTr('سپس فریمور مورد نظر خود را انتخاب و بر روی دکمه بارگذاری کلیک نمایید\r\n')
            }

            function log(_txt) {
                idConsoleLog.text += _txt
                idConsoleLog.text += '\r\n'
            }

            Connections {
                target: settings

                onNotifyChanges: {
                    if (key === SystemSettings.GUITheme) {
                        idFirmwareTypes.clear()

                        for (var i=0 ; i<firmwareTypes.length ; i++) {
                            idFirmwareTypes.append({ type: firmwareTypes[i] })
                        }
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        firmware.notifySetPermission(visible)

        if (!visible) {
            idFirmwareTypes.clear()
        }
    }
}
