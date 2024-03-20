import QtQuick 2.12

import '../model'


ModelCart {
    id: idRoot
    visible: false

    property bool needApply: false

    Rectangle {
        id: idRectangle
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: idRoot.itemVerticalMargin
        anchors.horizontalCenter: parent.horizontalCenter
        width: idRoot.width - idRoot.itemHorizontalMargin - idRoot.leftPadding - idRoot.rightPadding
        color: theme.backgroundLight

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: parent.height * 0.075

            Item {
                width: idRectangle.width
                height: idStatusText.height * 1.75

                Text {
                    id: idStatusText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: qsTr('وضعیت')
                }

                ModelCombobox {
                    id: idStatusComboBox
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.65
                    height: parent.height
                    font: idRoot.font
                    editable: true

                    model: ListModel {
                        id: idStatusListModel
                    }

                    contentItem: Text {
                        id: idStatusComboBoxText
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
                        idStatusListModel.clear()

                        if (link.isConnected()) {
                            let safeties = autopilot.getAllBoardSafeties()

                            for (let i=0 ; i<safeties.length ; i++) {
                                idStatusListModel.append({ safety : safeties[i] })
                            }
                        }
                    }

                    onCurrentTextChanged: {
                        if (link.isConnected() &&
                                idStatusComboBox.currentText !== '' &&
                                idStatusComboBox.currentText.indexOf('N/A') === -1) {
                            idStatusComboBoxText.text = idStatusComboBox.currentText
                            idRoot.needApply = true
                        }
                    }
                }
            }
        }
    }

    function update() {
        if (ParamService.isExist('BRD_SAFETYENABLE')) {
            idStatusComboBoxText.text = autopilot.getBoardSafety()
            idRoot.visible = true

        } else {
            idRoot.visible = false
        }
    }

    function reset() {
        idStatusListModel.clear()
        idStatusComboBoxText.text = 'N/A'
        idRoot.visible = false
    }

    function applyChanges() {
        if (idRoot.needApply &&
                link.isConnected() &&
                idStatusComboBox.currentText !== '' &&
                idStatusComboBox.currentText.indexOf('N/A') === -1) {
            autopilot.setBoardSafety(idStatusComboBox.currentText)
            idRoot.needApply = false

            if (idRoot.visible) {
                toast.warn(qsTr('پس از اعمال تغییرات دستگاه را مجددا راه اندازی کنید'), 5000)
            }

            return true
        }

        return false
    }
}
