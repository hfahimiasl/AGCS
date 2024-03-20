import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Universal 2.12

import "../model"

Rectangle {
    id: idRoot
    anchors.top: parent.top
//    anchors.left: parent.left
//    anchors.right: idMenuView.left
    height:45*appSetting.heightMarging_scale
    color: theme.background
    ModelButton{
        id: idUserAccountBtn
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: idRoot.height
        height: idRoot.height
        font.pointSize : parseInt(15*appSetting.fontScale)
        text: qsTr("\uf406")
        backgroundColor: "transparent"
        font.family: fontAwesome.name
        onClicked: {
            idUserProfile.open()
        }
    }
    ModelButton{
        id: idConnectBtn
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: idUserAccountBtn.right
        anchors.leftMargin: 0
        width: idRoot.height
        height: idRoot.height
        font.pointSize: parseInt(15*appSetting.fontScale)
        text: qsTr("\uf0c1")
        backgroundColor: "transparent"
        font.family: fontAwesome.name
        onClicked: {
            idLinkConnection.open()
        }
    }
    ModelButton{
        id: idHelpBtn
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: idConnectBtn.right
        anchors.leftMargin: 0
        width: idRoot.height
        height: idRoot.height
        font.pointSize: parseInt(15*appSetting.fontScale)
        text: qsTr("\uf128")
        backgroundColor: "transparent"
        font.family: fontAwesome.name
        onClicked: {
            Qt.openUrlExternally(idMenuView.docsAddress);
        }
    }
// hold this for some testing
//    ModelButton{
//        id: idStartMission
//        anchors.verticalCenter: parent.verticalCenter
//        anchors.right: parent.right
//        anchors.leftMargin: 0
//        width: 180
//        height: idRoot.height
//        font.pointSize: parseInt(15*appSetting.fontScale)
//        text: "شروع ماموریت"
//        backcolor: "transparent"
//        onClicked: {

//        }
//    }
}
