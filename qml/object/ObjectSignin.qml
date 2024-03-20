import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)
    property bool softLogout: false

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

    Item {
        id: idFieldsItem
        anchors.top: idAGCS.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: idUsernameItem.height * 2

        Item {
            id: idUsernameItem
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
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

        Item {
            id: idPasswordItem
            anchors.top: idUsernameItem.bottom
            anchors.left: idUsernameItem.left
            anchors.right: idUsernameItem.right
            height: idUsernameItem.height

            ModelTextfield {
                id: idPassword
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: idUsername.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                echoMode: TextInput.Password
                passwordMaskDelay: 1000
                placeholderText: qsTr('رمز عبور')
                validator: RegExpValidator { regExp: /(.*)/ }

                onTextChanged: {
                    if (idPassword.text === '') {
                        idPassword.resetBorderColor()

                    } else {
                        idPassword.borderColor = idPassword.acceptableInput && idPassword.text.length >= 8 ? theme.primary : 'red'
                    }
                }
            }
        }
    }

    Text {
        anchors.top: idFieldsItem.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding * 0.5
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: idRoot.fontFamily
        font.pixelSize: idRoot.fontPixelSize
        text: qsTr('بازیابی رمز عبور')

        MouseArea {
            anchors.centerIn: parent
            width: parent.implicitWidth
            height: parent.implicitHeight
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                idRoot.close()
                idRecoveryPassword.open()
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
        onLinkActivated: Qt.openUrlExternally(link)//'www.google.com')
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
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
                id: idSigninButtonText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('ورود')
            }

            ModelBusyIndicator {
                id: idBusyIndicator
                anchors.centerIn: idSigninButtonText
                width: height
                height: idSigninButtonText.implicitHeight

                onVisibleChanged: {
                    idSigninButtonText.visible = !visible
                }
            }

            onClicked: {
                idRoot.signin()
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
                text: qsTr('ثبت نام')
            }

            onClicked: {
                idRoot.close()
                idSignupform.open()
            }
        }
    }

    function signin() {
        let error = false

        if (!idUsername.acceptableInput) {
            idUsername.borderColor = 'red'
            error = true

        } else {
            idUsername.resetBorderColor()
        }

        if (!idPassword.acceptableInput || idPassword.text.length < 8) {
            idPassword.borderColor = 'red'
            error = true

        } else {
            idPassword.resetBorderColor()
        }

        if (error) {
            idMessageText.text = qsTr('اطلاعات را به درستی وارد کنید')
            return
        }

        idBusyIndicator.visible = true
        user_auth.signin(idUsername.text.toLowerCase(), idPassword.text)
    }

    onVisibleChanged: {
        idUsername.text = ''
        idPassword.text = ''
        idMessageText.text = ''

        idUsername.resetBorderColor()
        idPassword.resetBorderColor()
    }

    Component.onCompleted: {
        if (!user_auth.isSignin()) {
            idRoot.open()
        }
    }

    Connections {
        target: user_auth

        onNotifyError: {
            idMessageText.text = error
            idBusyIndicator.visible = false
        }

        onNotifySignin: {
            idRoot.close()
            idMessageText.text = ''
            idBusyIndicator.visible = false
            toast.info(qsTr('خوش آمدید'), 5000)
            idParameterPage.warningVisible = false
        }

        onNotifyLogout: {
            if (parseInt(variable.getValue('ARM_STATUS'))) {
                idRoot.softLogout = true
                toast.warn(qsTr('خروج از حساب کاربری بعد از غیر فعال شدن دستگاه انجام خواهد شد'), 5000)

            } else {
                idRoot.open()
                toast.info(qsTr('خروج از حساب کاربری انجام شد'), 5000)
            }
        }
    }

    Connections {
        target: scheduler

        onSchedule1Hz: {
            if (idRoot.softLogout && !parseInt(variable.getValue('ARM_STATUS')) && !user_auth.isSignin()) {
                idRoot.softLogout = false
                idRoot.open()
                toast.info(qsTr('خروج از حساب کاربری انجام شد'), 5000)
                link.disconnectAll()
            }
        }
    }
}
