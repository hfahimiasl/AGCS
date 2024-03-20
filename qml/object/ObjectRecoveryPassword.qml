import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)
    property string leftTime: ''

    Text {
        id: idAGCS
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_black.name
        font.bold: true
        font.pixelSize: idDisplay.getFontScale(2, 4)
        text: 'AGCS'
    }

    Text {
        id: idDescription
        anchors.top: idAGCS.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        lineHeight: 1.25
        wrapMode: Text.WordWrap
        font.family: idRoot.fontFamily
        font.pixelSize: idRoot.fontPixelSize
        text: qsTr('ایمیل حساب کاربری خود را وارد کرده و روی دکمه ارسال کلیک کنید تا لینک بازیابی رمز عبور به ایمیل شما ارسال شود')
    }

    Item {
        id: idUsernameItem
        anchors.top: idDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding
        height: idDisplay.getScaledHeight(0.05, 0.125)

        ModelTextfield {
            id: idUsername
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - (idRoot.topPadding * 0.75)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            backgroundColor: theme.background
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            placeholderText: qsTr('ایمیل')
            validator: RegExpValidator { regExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }

            onTextChanged: {
                if (idUsername.text === '') {
                    idUsername.resetBorderColor()

                } else {
                    idUsername.borderColor = idUsername.acceptableInput ? theme.primary : 'red'
                }
            }
        }
    }

    Text {
        id: idMessageText
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: idRoot.topPadding
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: 'red'
        fontSizeMode: Text.Fit
        font.family: idRoot.fontFamily
        font.pixelSize: idRoot.fontPixelSize
    }

    Item {
        id: idButtons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
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
            id: idSendMouseArea
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right
            state: 'ready'

            Text {
                id: idSendMouseAreaText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('ارسال')
            }

            ModelBusyIndicator {
                id: idBusyIndicator
                anchors.centerIn: idSendMouseAreaText
                width: height
                height: idSendMouseAreaText.implicitHeight
            }

            states: [
                State {
                    name: 'ready'
                    PropertyChanges { target: idUsername; enabled: true }
                    PropertyChanges { target: idSendMouseArea; enabled: true }
                    PropertyChanges { target: idBusyIndicator; visible: false }
                    PropertyChanges { target: idSendMouseAreaText; text: qsTr('ارسال') }
                },
                State {
                    name: 'request'
                    PropertyChanges { target: idUsername; enabled: false }
                    PropertyChanges { target: idSendMouseArea; enabled: false }
                    PropertyChanges { target: idBusyIndicator; visible: true }
                    PropertyChanges { target: idSendMouseAreaText; text: '' }
                },
                State {
                    name: 'timeout'
                    PropertyChanges { target: idUsername; enabled: false }
                    PropertyChanges { target: idSendMouseArea; enabled: false }
                    PropertyChanges { target: idBusyIndicator; visible: false }
                    PropertyChanges { target: idSendMouseAreaText; text: idRoot.leftTime }
                }
            ]

            onClicked: {
                idRoot.resetPassword()
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

    function resetPassword() {
        if (!idUsername.acceptableInput) {
            idUsername.borderColor = 'red'
            idMessageText.text = qsTr('اطلاعات را به درستی وارد کنید')
            return

        } else {
            idUsername.resetBorderColor()
        }

        idSendMouseArea.state = 'request'
        user_auth.resetPassword(idUsername.text.toLowerCase())
    }

    onVisibleChanged: {
        idUsername.text = ''
        idMessageText.text = ''
        idUsername.resetBorderColor()
        idLoginform.visible = !idRoot.visible
    }

    Connections {
        target: user_auth

        onNotifyError: {
            idSendMouseArea.state = 'ready'
            idMessageText.text = error
        }

        onNotifyResetPassword: {
            idSendMouseArea.state = 'timeout'
            idTimer.start()
            idRoot.close()
            toast.info(qsTr('لینک بازیابی رمز عبور برای شما ارسال شد لطفا ایمیل خود را بررسی کنید'), 15000)
        }
    }

    Timer {
        id: idTimer
        repeat: true
        interval: 1000
        property int counter: 120

        onTriggered: {
            let sec = idTimer.counter % 60
            let min = Math.floor(idTimer.counter / 60) % 60

            idRoot.leftTime = ('%1:%2').arg(min < 10 ? ('0' + min) : min).arg(sec < 10 ? ('0' + sec) : sec)
            idTimer.counter --

            if (idTimer.counter === 0) {
                idTimer.stop()
                idTimer.counter = 120
                idSendMouseArea.state = 'ready'
            }
        }
    }
}
