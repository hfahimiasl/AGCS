import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    property string userName: ''
    property bool badgeCheck: true
    property string userEmail: ''

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
        anchors.top: idAGCS.bottom
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: idRoot.bottomPadding

        Item {
            id: idUserNameItem
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: idUserName.implicitWidth + idBadgeCheck.implicitWidth * 1.5
            height: parent.height * 0.5

            Text {
                id: idUserName
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: idRoot.userName
            }

            Text {
                id: idBadgeCheck
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                color: '#00c3ff'
                fontSizeMode: Text.Fit
                font.family: fontAwesome.name
                font.pixelSize: idRoot.fontPixelSize * 1.25
                text: idRoot.badgeCheck ? 'badge-check' : ''
            }
        }

        Item {
            anchors.top: idUserNameItem.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: idUserEmail.implicitWidth
            height: idUserNameItem.height

            Text {
                id: idUserEmail
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: idRoot.userEmail
            }
        }
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
                color: 'red'
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('خروج از حساب')
            }

            onClicked: {
                user_auth.logout()
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

    function update() {
        idRoot.userName = settings.get(SystemSettings.UserAuthFirstName) + ' ' + settings.get(SystemSettings.UserAuthLastName)
        idRoot.badgeCheck = String(settings.get(SystemSettings.UserAuthIsAdmin)) === 'true' || String(settings.get(SystemSettings.UserAuthRoles)) === 'SuperAdmin'
        idRoot.userEmail = settings.get(SystemSettings.UserAuthEmail)
    }

    Component.onCompleted: {
        idRoot.update()
    }

    Connections {
        target: user_auth

        onNotifyLogout: {
            idRoot.close()
        }

        onNotifyValidation: {
            idRoot.update()
        }
    }
}
