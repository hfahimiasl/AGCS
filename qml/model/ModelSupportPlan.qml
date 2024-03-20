import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle {
    id: idRoot
    width: parent.width
    height: parent.height
    radius: 5

    property var title: 'نوع پلن'
    property var image: 'qrc:/images/support/plan/base.svg'
    property var options: ['\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d']
    property var price: 'N/A'
    property var select: false

    readonly property int image_top_margin: idRoot.height * 0.05
    readonly property int title_top_margin: idRoot.height * 0.05

    readonly property int options_spacing: (idRoot.height - (idRoot.image_top_margin +
                                                             idRootImage.height +
                                                             idRoot.title_top_margin +
                                                             idRootTextPlan.height + (idRootTextOption1.height * 10))) / 10

    readonly property int option_1_margin: idRoot.image_top_margin +
                                           idRootImage.height +
                                           idRoot.title_top_margin +
                                           idRootTextPlan.height +
                                           idRoot.options_spacing

    color: theme.backgroundLight
    border.color: idRoot.select ? theme.primary : theme.background
    border.width: 5

    Image {
        id: idRootImage
        anchors.top: parent.top
        anchors.topMargin: idRoot.image_top_margin
        anchors.horizontalCenter: parent.horizontalCenter
        width: idRoot.width * 0.65
        height: this.width
        source: idRoot.image
    }

    Text {
        id: idRootTextPlan
        anchors.top: idRootImage.bottom
        anchors.topMargin: idRoot.title_top_margin
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        color: theme.text
        text: qsTr(idRoot.title)
    }

    Text {
        id: idRootTextOption1
        anchors.top: idRootTextPlan.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[0]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption2
        anchors.top: idRootTextOption1.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[1]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption3
        anchors.top: idRootTextOption2.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[2]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption4
        anchors.top: idRootTextOption3.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[3]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption5
        anchors.top: idRootTextOption4.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[4]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption6
        anchors.top: idRootTextOption5.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[5]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption7
        anchors.top: idRootTextOption6.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[6]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption8
        anchors.top: idRootTextOption7.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.options[7]
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    Text {
        id: idRootTextOption9
        anchors.top: idRootTextOption8.bottom
        anchors.topMargin: idRoot.options_spacing
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: font_fa_medium.name
        font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
        minimumPointSize: parseInt(appSetting.fontScale * 0.5)
        fontSizeMode: Text.Fit
        text: idRoot.price
        color: {
            if (this.text === '\uf00c') {'#45D266'}
            else if (this.text === '\uf00d') {'#C82A2A'}
            else {theme.text}
        }
    }

    // TODO: fix me
//    Rectangle {
//        anchors.top: idRootTextOption9.bottom
//        anchors.topMargin: idRoot.options_spacing
//        anchors.horizontalCenter: parent.horizontalCenter
//        width: idRootTextSelect.implicitWidth + 30
//        height: idRootTextSelect.implicitHeight + 10
//        radius: 20
//        clip: true
//        color: theme.primary

//        Text {
//            id: idRootTextSelect
//            anchors.centerIn: parent
//            font.family: font_fa_medium.name
//            font.pointSize: parseInt(parent.width * 0.06) <= 0 ? 1 : parseInt(parent.width * 0.06)
//            minimumPointSize: parseInt(appSetting.fontScale * 0.5)
//            fontSizeMode: Text.Fit
//            clip: true
//            color: theme.text
//            text: qsTr('انتخاب')

//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    console.log('by plan')
//                }
//            }
//        }
//    }
}
