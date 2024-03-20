import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    anchors.centerIn: parent
    width: idDisplay.isLargeDisplay ? idDisplay.minimumWidth * 0.75 : idDisplay.displayWidth * 0.6
    height: idDisplay.isLargeDisplay ? idDisplay.minimumHeight * 0.75 : idDisplay.displayHeight * 0.9
    visible: false
    modal: true
    closePolicy: Popup.NoAutoClose

    Text {
        id: idRootText
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: parent.height * 0.025
        anchors.rightMargin: parent.width * 0.025
        horizontalAlignment: Text.AlignRight
        color: theme.text
        font.family: font_fa_black.name
        font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
        text: qsTr('درخواست جدید')
    }

    Text {
        id: idRootSubjectText
        anchors.top: idRootText.bottom
        anchors.right: idRootText.right
        anchors.topMargin: parent.height * 0.05
        horizontalAlignment: idRootText.horizontalAlignment
        color: idRootText.color
        font.family: font_fa_medium.name
        font.pixelSize: idRootText.font.pixelSize
        text: qsTr('عنوان')
    }

    ModelTextfield {
        id: idRootSubjectTextField
        anchors.left: parent.left
        anchors.right: idRootSubjectText.left
        anchors.leftMargin: parent.width * 0.05
        anchors.rightMargin: parent.width * 0.05
        anchors.verticalCenter: idRootSubjectText.verticalCenter
        height: idRootSubjectText.height * 1.4
        font.family: font_fa_medium.name
        font.pixelSize: idRootSubjectText.font.pixelSize * 0.9
        validator: RegExpValidator { regExp: /\w+[\w ]{1,1024}/ }
    }

    Text {
        id: idRootTypeText
        anchors.top: idRootSubjectText.bottom
        anchors.right: idRootSubjectText.right
        anchors.topMargin: parent.height * 0.05
        horizontalAlignment: idRootSubjectText.horizontalAlignment
        color: idRootText.color
        font.family: idRootSubjectText.font.family
        font.pixelSize: idRootText.font.pixelSize
        text: qsTr('واحد')
    }

    ModelCombobox {
        id: idRootTypeComboBox
        anchors.left: idRootSubjectTextField.left
        anchors.right: idRootSubjectTextField.right
        anchors.verticalCenter: idRootTypeText.verticalCenter
        height: idRootSubjectTextField.height
        backgroundColorBox: theme.backgroundLight
        font.family: font_fa_medium.name
        font.pixelSize: idRootSubjectTextField.font.pixelSize
        model: [qsTr('فنی'), qsTr('مالی')]
        editable: true
    }

    Text {
        id: idRootTicketText
        anchors.top: idRootTypeText.bottom
        anchors.right: idRootTypeText.right
        anchors.topMargin: parent.height * 0.05
        horizontalAlignment: idRootTypeText.horizontalAlignment
        color: idRootText.color
        font.family: idRootSubjectText.font.family
        font.pixelSize: idRootText.font.pixelSize
        text: qsTr('متن تیکت')
    }

    Flickable {
        id: idRootFlickable
        anchors.top: idRootTicketText.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: idRootTicketText.left
        anchors.leftMargin: parent.width * 0.05
        anchors.rightMargin: parent.width * 0.05
        anchors.bottomMargin: parent.height * 0.15
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        TextArea.flickable: TextArea {
            id: idRootTicketTextArea
            color: idRootSubjectTextField.color
            font.family: idRootSubjectTextField.font.family
            font.pixelSize: idRootSubjectTextField.font.pixelSize
            wrapMode: TextArea.Wrap

            background: Rectangle {
                id: idRootTicketTextAreaBackground
                border.color: idRootTicketTextAreaBackground.color
                radius: 5
                color: theme.backgroundLight

                function resetBorderColor() {
                    idRootTicketTextAreaBackground.border.color = idRootTicketTextAreaBackground.color
                }
            }
        }

        ScrollBar.vertical: ScrollBar {
            parent: idRootFlickable.parent
            anchors.top: idRootFlickable.top
            anchors.bottom: idRootFlickable.bottom
            anchors.right: idRootFlickable.right
            policy: ScrollBar.AsNeeded
        }
    }

    onVisibleChanged: {
        idRootSubjectTextField.text = ''
        idRootTypeComboBox.currentIndex = -1
        idRootTicketTextArea.text = ''
        idRoot.reset()
    }

    ModelButton {
        id: idRootSaveButton
        anchors.top: idRootFlickable.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: parent.height * 0.05
        anchors.rightMargin: parent.width * 0.2
        width: parent.width * 0.15
        backgroundColor: idRoot.backgroundColor
        font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
        text: qsTr('ارسال')

        onClicked: {
            let i = 0
            let index = []

            for (i=0 ; i<idRootTicketTextArea.text.length ; i++) {
                if (idRootTicketTextArea.text[i] === ' ' || idRootTicketTextArea.text[i] === '\n') {
                    if (index.indexOf(i) < 0) index.push(i)

                } else {
                    break
                }
            }

            for (i=idRootTicketTextArea.text.length - 1 ; i>=0 ; i--) {
                if (idRootTicketTextArea.text[i] === ' ' || idRootTicketTextArea.text[i] === '\n') {
                    if (index.indexOf(i) < 0) index.push(i)

                } else {
                    break
                }
            }

            let filtered_message = ''

            for (i=0 ; i<idRootTicketTextArea.text.length ; i++) {
                if (index.indexOf(i) < 0) {
                    filtered_message += idRootTicketTextArea.text[i]
                }
            }

            if (idRootSubjectTextField.text === '' || idRootTypeComboBox.currentIndex === -1 || filtered_message === '') {
                toast.error(qsTr('تمامی فیلد ها را پر کنید'), 5000)

                if (idRootSubjectTextField.text === '') {
                    idRootSubjectTextField.borderColor = 'red'

                } else {
                    idRootSubjectTextField.resetBorderColor()
                }

                if (idRootTypeComboBox.currentIndex === -1) {
                    idRootTypeComboBox.borderColor = 'red'

                } else {
                    idRootTypeComboBox.resetBorderColor()
                }

                if (filtered_message === '') {
                    idRootTicketTextAreaBackground.border.color = 'red'

                } else {
                    idRootTicketTextAreaBackground.resetBorderColor()
                }

            } else {
                idRoot.reset()
                idRootSaveButton.state = 'busy'
                let type = idRootTypeComboBox.currentText === qsTr('فنی') ? 'Technical' : 'Financial'
                support.requestAddTicket(idRootSubjectTextField.text, type, filtered_message)
            }
        }
    }

    ModelButton {
        id: idRootCancelButton
        anchors.top: idRootSaveButton.top
        anchors.bottom: idRootSaveButton.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.2
        width: idRootSaveButton.width
        backgroundColor: idRoot.backgroundColor
        font.pixelSize: idRootSaveButton.font.pixelSize * 0.9
        text: qsTr('لغو')
        onClicked: idRoot.close()
    }

    Connections {
        target: support

        onNotifyAddTicket: {
            idRoot.close()
            toast.info(qsTr('تیکت ثبت شد'), 5000)
            support.requestTicketsList()
        }

        onErrorAddTicket: {
            idRootSaveButton.state = 'normal'
            toast.error(qsTr('خطا در ثبت تیکت'), 5000)
        }
    }

    function reset() {
        idRootSubjectTextField.resetBorderColor()
        idRootTypeComboBox.resetBorderColor()
        idRootTicketTextAreaBackground.resetBorderColor()
        idRootSaveButton.state = 'normal'
    }
}
