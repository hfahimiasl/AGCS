import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'
import '../object'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose
    backgroundColor: theme.backgroundDark

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

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

    Flickable {
        id: idFlickable
        anchors.top: idAGCS.bottom
        anchors.bottom: idMessageText.top
        anchors.left: parent.left
        anchors.right: parent.right
        contentWidth: idItemColumn.width
        contentHeight:idItemColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: idItemColumn
            anchors.centerIn: parent

            Item {
                id: idUserNameItem
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.05, 0.125)

                ModelTextfield {
                    id: idUserName
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - (idRoot.topPadding * 0.75)
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('نام')
                    validator: RegExpValidator { regExp: /\w+[\w ]{1,1024}/ }

                    onTextChanged: {
                        if (idUserName.text === '') {
                            idUserName.resetBorderColor()

                        } else {
                            idUserName.borderColor = idUserName.acceptableInput && idUserName.text.length >= 3 ? theme.primary : 'red'
                        }
                    }
                }
            }

            Item {
                id: idUserFamilyItem
                width: idUserNameItem.width
                height: idUserNameItem.height

                ModelTextfield {
                    id: idUserFamily
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idUserName.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('نام خانوادگی')
                    validator: RegExpValidator { regExp: /\w+[\w ]{1,1024}/ }

                    onTextChanged: {
                        if (idUserFamily.text === '') {
                            idUserFamily.resetBorderColor()

                        } else {
                            idUserFamily.borderColor = idUserFamily.acceptableInput && idUserFamily.text.length >= 3 ? theme.primary : 'red'
                        }
                    }
                }
            }

            Item {
                id: idEmailItem
                width: idUserNameItem.width
                height: idUserNameItem.height

                ModelTextfield {
                    id: idEmail
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idUserName.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('ایمیل')
                    validator: RegExpValidator { regExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }

                    onTextChanged: {
                        if (idEmail.text === '') {
                            idEmail.resetBorderColor()

                        } else {
                            idEmail.borderColor = idEmail.acceptableInput ? theme.primary : 'red'
                        }
                    }
                }
            }

            Item {
                id: idPhoneItem
                width: idUserNameItem.width
                height: idUserNameItem.height

                ModelTextfield {
                    id: idPhone
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idUserName.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('تلفن همراه')
                    validator: RegExpValidator { regExp: /09(0[1-5]|1[0-9]|2[0-9]|3[0-9]|9[0-9])-?[0-9]{3}-?[0-9]{4}/ }

                    onTextChanged: {
                        if (idPhone.text === '') {
                            idPhone.resetBorderColor()

                        } else {
                            idPhone.borderColor = idPhone.acceptableInput ? theme.primary : 'red'
                        }
                    }
                }
            }

            Item {
                id: idPasswordItem
                width: idUserNameItem.width
                height: idUserNameItem.height

                ModelTextfield {
                    id: idPassword
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idUserName.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    echoMode: TextInput.Password
                    passwordMaskDelay: 1000
                    placeholderText: qsTr('رمز عبور (حداقل 8 کاراکتر)')
                    validator: RegExpValidator { regExp: /(.*)/ }

                    onTextChanged: {
                        if (idPassword.text === '') {
                            idPassword.resetBorderColor()

                        } else {
                            idPassword.borderColor = idPassword.acceptableInput && idPassword.text.length >= 8 ? theme.primary : 'red'
                        }

                        if (idRepeatPassword.text === '') {
                            idRepeatPassword.resetBorderColor()

                        } else {
                            idRepeatPassword.borderColor = idRepeatPassword.acceptableInput && idRepeatPassword.text.length >= 8 && idRepeatPassword.text === idPassword.text ? theme.primary : 'red'
                        }
                    }
                }
            }

            Item {
                id: idRepeatPasswordItem
                width: idUserNameItem.width
                height: idUserNameItem.height

                ModelTextfield {
                    id: idRepeatPassword
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idUserName.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    backgroundColor: theme.background
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    echoMode: TextInput.Password
                    passwordMaskDelay: 1000
                    placeholderText: qsTr('تکرار رمز عبور')
                    validator: idPassword.validator

                    onTextChanged: {
                        if (idRepeatPassword.text === '') {
                            idRepeatPassword.resetBorderColor()

                        } else {
                            idRepeatPassword.borderColor = idRepeatPassword.acceptableInput && idRepeatPassword.text.length >= 8 && idRepeatPassword.text === idPassword.text ? theme.primary : 'red'
                        }
                    }
                }
            }
        }
    }

    Text {
        id: idMessageText
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: implicitHeight * 1.5
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
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
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

            onClicked: {
                idRoot.close()
                idLoginform.open()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idVerticalLine.left

            Text {
                id: idSignupButtonText
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

            ModelBusyIndicator {
                id: idBusyIndicator
                anchors.centerIn: idSignupButtonText
                width: height
                height: idSignupButtonText.implicitHeight

                onVisibleChanged: {
                    idSignupButtonText.visible = !visible
                }
            }

            onClicked: {
                idRoot.signup()
            }
        }
    }

    function toEnglishDigits(str) {
        let e = "۰".charCodeAt(0);
        str = str.replace(/[۰-۹]/g, function (t) {
            return t.charCodeAt(0) - e;
        });

        e = "٠".charCodeAt(0);
        str = str.replace(/[٠-٩]/g, function (t) {
            return t.charCodeAt(0) - e;
        });

        return str;
    }

    function signup() {
        let error = false

        if (!idUserName.acceptableInput || idUserName.text.length < 3) {
            idUserName.borderColor = 'red'
            error = true

        } else {
            idUserName.resetBorderColor()
        }

        if (!idUserFamily.acceptableInput || idUserFamily.text.length < 3) {
            idUserFamily.borderColor = 'red'
            error = true

        } else {
            idUserFamily.resetBorderColor()
        }

        if (!idEmail.acceptableInput) {
            idEmail.borderColor = 'red'
            error = true

        } else {
            idEmail.resetBorderColor()
        }

        if (!idPhone.acceptableInput) {
            idPhone.borderColor = 'red'
            error = true

        } else {
            idPhone.resetBorderColor()
        }

        if (!idPassword.acceptableInput || idPassword.text.length < 8) {
            idPassword.borderColor = 'red'
            error = true

        } else {
            idPassword.resetBorderColor()
        }

        if (!idRepeatPassword.acceptableInput || idRepeatPassword.text.length < 8 || idRepeatPassword.text !== idPassword.text) {
            idRepeatPassword.borderColor = 'red'
            error = true

        } else {
            idRepeatPassword.resetBorderColor()
        }

        if (error) {
            idMessageText.text = qsTr('اطلاعات را به درستی وارد کنید')
            return
        }

        idBusyIndicator.visible = true
        user_auth.signup(idUserName.text, idUserFamily.text, idEmail.text.toLowerCase(), idPassword.text, idRoot.toEnglishDigits(idPhone.text), '', '', '', '')
    }

    onVisibleChanged: {
        idUserName.text = ''
        idUserFamily.text = ''
        idEmail.text = ''
        idPhone.text = ''
        idPassword.text = ''
        idRepeatPassword.text = ''
        idMessageText.text = ''

        idUserName.resetBorderColor()
        idUserFamily.resetBorderColor()
        idEmail.resetBorderColor()
        idPhone.resetBorderColor()
        idPassword.resetBorderColor()
        idRepeatPassword.resetBorderColor()
    }

    Connections {
        target: user_auth

        onNotifyError: {
            idMessageText.text = error
            idBusyIndicator.visible = false
        }

        onNotifySignup: {
            idRoot.close()
            idMessageText.text = ''
            idBusyIndicator.visible = false
            idLoginform.open()
            toast.info(qsTr('ثبت نام انجام شد'), 20000)
            toast.info(qsTr('لینک فعال سازی اکانت کاربری برای شما ارسال شد'), 20000)
            toast.info(qsTr('لطفا ایمیل خود را بررسی کنید'), 20000)
        }
    }
}
