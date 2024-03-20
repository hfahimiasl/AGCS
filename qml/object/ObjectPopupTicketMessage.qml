import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'


ModelPopup {
    id: idRoot
    anchors.centerIn: parent
    width: idDisplay.isLargeDisplay ? parent.width * 0.65 : idDisplay.displayWidth * 0.75
    height: idDisplay.isLargeDisplay ? parent.height * 0.75 : idDisplay.displayHeight * 0.9
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    ListModel { id: idRootListModel }

    property var ticketID: 0

    Image {
        id: idRootExitImage
        anchors.top: parent.top
        anchors.left: parent.left
        source: 'qrc:/images/other/exit.png'
        sourceSize: Qt.size(parent.height * 0.075, parent.height * 0.075)

        MouseArea {
            anchors.fill: parent
            onClicked: idRoot.close()
        }
    }

    Image {
        id: idRootMessageImage
        anchors.centerIn: parent
        source: 'qrc:/images/support/ticket.svg'
        sourceSize: Qt.size(parent.height * 0.4, parent.height * 0.4)
        visible: true
        opacity: 1
    }

    ModelBusyIndicator {
        id: idRootBusyIndicator
        anchors.centerIn: parent
        z: 10
    }

    Text {
        id: idTicketsMessage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: idRootMessageImage.bottom
        font.family: font_fa_medium.name
        font.pointSize: 12
        fontSizeMode: Text.Fit
        color: theme.text
        visible: false
        text: ''
    }

    ScrollView {
        anchors.top: idRootExitImage.bottom
        anchors.bottom: idRootSendImage.visible ? idRootFlickable.top : parent.bottom
        anchors.left: idRootFlickable.left
        anchors.right: idRootSendImage.right
        anchors.bottomMargin: parent.height * 0.025
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ListView {
            id: idRootListVeiw
            anchors.fill: parent
            clip: true
            spacing: 4
            boundsBehavior: Flickable.StopAtBounds
            model: idRootListModel

            delegate: Rectangle {
                id: idTicketsDelegate
                anchors.left: ISUSER ? undefined : parent.left
                anchors.right: ISUSER ? parent.right : undefined
                width: Math.max(idTicketsDelegateMessageText.width, idTicketsDelegateTimeText.width) + 20
                height: idTicketsDelegateMessageText.height + 35
                radius: 5
                color: ISUSER ? theme.backgroundLight : theme.primary

                TextArea {
                    id: idTicketsDelegateMessageText
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 5
                    clip: true
                    horizontalAlignment: TextArea.AlignRight
                    font.family: font_fa_medium.name
                    font.pixelSize: idDisplay.getFontScale(1.075, 2.5)
                    color: theme.text
                    wrapMode: TextArea.Wrap
                    text: MESSAGE
                    readOnly: true

                    Component.onCompleted: updateWidth()

                    Connections {
                        target: idRootListVeiw
                        onWidthChanged: idTicketsDelegateMessageText.updateWidth()
                    }

                    function updateWidth() {
                        idTicketsDelegateMessageText.width = idRootListVeiw.width * 0.75 - 20

                        if (idTicketsDelegateMessageText.width > idTicketsDelegateMessageText.implicitWidth) {
                            idTicketsDelegateMessageText.width = idTicketsDelegateMessageText.implicitWidth
                        }
                    }
                }

                Text {
                    id: idTicketsDelegateTimeText
                    anchors.bottom: parent.bottom
                    anchors.left: ISUSER ? parent.left : undefined
                    anchors.right: ISUSER ? undefined : parent.right
                    anchors.bottomMargin: 10
                    anchors.leftMargin: ISUSER ? 10 : undefined
                    anchors.rightMargin: ISUSER ? undefined : 10
                    font.family: font_fa_medium.name
                    font.pixelSize: idDisplay.getFontScale(1.05, 2.25)
                    color: theme.text
                    text: SENTAT
                }
            }

            ScrollBar.vertical: ScrollBar {
                id: idRootListVeiwScrollBar
                visible: false
                position: 0
            }
        }
    }

    Image {
        id: idRootSendImage
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: parent.height * 0.01
        anchors.rightMargin: parent.width * 0.01
        source: 'qrc:/images/support/Send-Message.png'
        sourceSize: Qt.size(40, 40)

        MouseArea {
            anchors.fill: parent
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

                if (filtered_message === '') {
                    idRootTicketTextAreaBackground.border.color = 'red'
                    toast.error(qsTr('متن تیکت را پر کنید'), 5000)

                } else {
                    idRootBusyIndicator.visible = true
                    idRootTicketTextAreaBackground.resetBorderColor()
                    support.requestAddMessage(idRoot.ticketID, filtered_message)
                }
            }
        }
    }

    Flickable {
        id: idRootFlickable
        anchors.bottom: idRootSendImage.bottom
        anchors.left: parent.left
        anchors.right: idRootSendImage.left
        anchors.leftMargin: parent.width * 0.005
        anchors.rightMargin: parent.width * 0.01
        height: idRootSendImage.height * (idDisplay.isLargeDisplay ? 4.5 : 2.75)
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        visible: idRootSendImage.visible

        TextArea.flickable: TextArea {
            id: idRootTicketTextArea
            color: theme.text
            font.family: font_fa_medium.name
            font.pixelSize: idDisplay.getFontScale(1.075, 2.5)
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
            visible: idRootFlickable.visible
        }
    }

    onVisibleChanged: {
        if (!visible) {
            support.requestTicketsList()
            return
        }

        idRootListModel.clear()
        idRootMessageImage.opacity = 0.25
        idRootBusyIndicator.visible = true
        idTicketsMessage.visible = false
        idRootSendImage.visible = false
        idRootTicketTextArea.text = ''
        idRootTicketTextAreaBackground.resetBorderColor()
        support.requestTicketMessages(ticketID)
    }

    Connections {
        target: support

        onNotifyTicketMessages: {
            idRootBusyIndicator.visible = false
            idTicketsMessage.visible = false
            idRootListModel.clear()

            if (id.length === 0) {
                idRootMessageImage.opacity = 1
                idTicketsMessage.text = qsTr('موردی جهت نمایش وجود ندارد')
                idTicketsMessage.visible = true
                idRootSendImage.visible = support.getTicketInfo(idRoot.ticketID, 'state') !== 'Close'
                return
            }

            idRootMessageImage.opacity = 0

            for (let i=0 ; i<id.length ; i++) {
                idRootListModel.append({
                                           "ID": id[i],
                                           "ISUSER": support.getMessageInfo(id[i], "user") === String(settings.get(SystemSettings.UserAuthID)),
                                           "MESSAGE": support.getMessageInfo(id[i], "message"),
                                           "SENTAT": support.getMessageInfo(id[i], "sentAt")
                                       })
            }

            idRootSendImage.visible = support.getTicketInfo(idRoot.ticketID, 'state') !== qsTr('بسته شده')

            idRootListVeiwScrollBar.position = 1
        }

        onErrorTicketMessages: {
            idRootBusyIndicator.visible = false
            idTicketsMessage.text = qsTr('خطا در دریافت اطلاعات')
            idTicketsMessage.visible = true
            idRootMessageImage.opacity = 1
        }

        onNotifyAddMessage: {
            idRootTicketTextArea.text = ''
            support.requestTicketMessages(idRoot.ticketID)
            toast.info(qsTr('پیام فرستاده شد'), 5000)
        }

        onErrorAddMessage: {
            idRootBusyIndicator.visible = false
            toast.error(qsTr('خطا در ارسال پیام'), 5000)
        }
    }
}
