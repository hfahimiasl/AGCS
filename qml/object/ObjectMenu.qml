import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


Item {
    id: idRoot

    readonly property string docsAddress: 'https://docs.agcs.adlanpaya.ir/'

    ListModel {
        id: idListModel

        ListElement {
            item: 'main'
            icon: '\uf015'
        }

        ListElement {
            item: 'mission'
            icon: '\uf5a0'
        }

        ListElement {
            item: 'analyze'
            icon: '\uf201'
        }

        ListElement {
            item: 'output'
            icon: '\uf2f5'
        }

        ListElement {
            item: 'input'
            icon: '\uf2f6'
        }

        ListElement {
            item: 'calibration'
            icon: '\uf57e'
        }

        ListElement {
            item: 'safety'
            icon: '\uf023'
        }

        ListElement {
            item: 'settings'
            icon: '\uf0ad'
        }

        ListElement {
            item: 'options'
            icon: '\uf109'
        }

        ListElement {
            item: 'params'
            icon: '\uf1de'
        }

        ListElement {
            item: 'firmware'
            icon: '\uf382'
        }

        ListElement {
            item: 'support'
            icon: '\uf590'
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: width * 0.25
        opacity: 0.875
        color: theme.backgroundDark

        MouseArea {
            anchors.fill: parent
        }
    }

    Item {
        id: idLogoItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: width

        Image {
            anchors.fill: parent
            anchors.margins: parent.width * 0.15
            source: 'qrc:/images/logo-48.png'

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Qt.openUrlExternally(idRoot.docsAddress)
                }
            }
        }
    }

    ScrollView {
        anchors.top: idLogoItem.bottom
        anchors.bottom: idProfileItem.top
        anchors.left: parent.left
        anchors.right: parent.right
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        ListView {
            id: idListView
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            model: idListModel
            clip: true

            delegate: Item {
                id: idWrapperItem
                width: parent.width
                height: visible ? (width * (idDisplay.isLargeDisplay ? 1 : 0.75)) : 0
                visible: model.item === 'firmware' ? Qt.platform.os === 'windows' : true

                Text {
                    id: idImgItem
                    anchors.fill: parent
                    anchors.centerIn: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    opacity: idWrapperItem.ListView.isCurrentItem ? 1 : 0.5
                    color: idWrapperItem.ListView.isCurrentItem ? theme.text : theme.textDark
                    font.family: fontAwesome.name
                    font.pixelSize: idDisplay.getFontScale(1.25, 3.25)
                    antialiasing: true
                    smooth: true
                    text: icon
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        idRoot.setVisible(item)
                    }
                }
            }
        }
    }

    Item {
        id: idProfileItem
        anchors.bottom: idLinkItem.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: idLinkItem.height

        Text {
            anchors.centerIn: parent
            width: idLinkText.width
            height: idLinkText.height
            verticalAlignment: idLinkText.verticalAlignment
            horizontalAlignment: idLinkText.horizontalAlignment
            fontSizeMode: idLinkText.fontSizeMode
            font: idLinkText.font
            color: idLinkText.color
            text: '\uf406'
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (user_auth.isSignin()) {
                    idUserProfile.open()
                }
            }
        }
    }

    Item {
        id: idLinkItem
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: width * (idDisplay.isLargeDisplay ? 1 : 0.85)

        Text {
            id: idLinkText
            anchors.centerIn: parent
            width: parent.width * 0.35
            height: width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            font.family: fontAwesome.name
            font.pixelSize: 1000
            color: theme.primary
            text: '\uf0c1'
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                idLinkConnection.open()
            }
        }
    }

    function unvisibleAll() {
        idMainPage.visible = false
        idMissionPage.visible = false
        idAnalyzePage.visible = false
        idCalibrationPage.visible = false
        idInputPage.visible = false
        idOutputPage.visible = false
        idSafetyPage.visible = false
        idSettingsPage.visible = false
        idOptionsPage.visible = false
        idParameterPage.visible = false
        idFrimwarePage.visible = false
        idSupportPage.visible = false
    }

    function setVisible(page) {
        idRoot.unvisibleAll()

        switch (page) {
        case 'main':
            idListView.currentIndex = 0
            idMainPage.visible = true
            break

        case 'mission':
            idListView.currentIndex = 1
            idMissionPage.visible = true
            break

        case 'analyze':
            idListView.currentIndex = 2
            idAnalyzePage.visible = true
            break

        case 'output':
            idListView.currentIndex = 3
            idOutputPage.visible = true
            break

        case 'input':
            idListView.currentIndex = 4
            idInputPage.visible = true
            break

        case 'calibration':
            idListView.currentIndex = 5
            idCalibrationPage.visible = true
            break

        case 'safety':
            idListView.currentIndex = 6
            idSafetyPage.visible = true
            break

        case 'settings':
            idListView.currentIndex = 7
            idSettingsPage.visible = true
            break

        case 'options':
            idListView.currentIndex = 8
            idOptionsPage.visible = true
            break

        case 'params':
            idListView.currentIndex = 9
            idParameterPage.visible = true
            break

        case 'firmware':
            idListView.currentIndex = 10
            idFrimwarePage.visible = true
            break

        case 'support':
            idListView.currentIndex = 11
            idSupportPage.visible = true
            break

        default:
            break
        }
    }
}
