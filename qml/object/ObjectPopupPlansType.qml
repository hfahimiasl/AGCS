import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import "../model"
import "../page"
import "../object"


ModelPopup {
    id: idRoot
    anchors.centerIn: parent
    width: parent.width * 0.9
    height: parent.height * 0.9
    visible: false
    modal: true

    Image {
        id: idRootPlansImage
        anchors.centerIn: parent
        source: 'qrc:/images/support/ticket.svg'
        visible: true
        opacity: 1
    }

    ModelBusyIndicator {
        id: idRootBusyIndicator
        anchors.centerIn: parent
        running: true
    }

    Text {
        id: idRootPlansText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: idRootPlansImage.bottom
        font.family: font_fa_medium.name
        font.pointSize: 12
        fontSizeMode: Text.Fit
        color: theme.text
        visible: false
        text: ''
    }

    Rectangle {
        id: idRootLabel
        width: parent.width * 0.3
        height: parent.height
        anchors.right: parent.right
        color: theme.background

        readonly property var top_margin: [
            idSupportPlanItemBase.option_1_margin * 0.975,
            idSupportPlanItemBase.options_spacing * 0.75    ]

        readonly property var options: [
            qsTr('دسترسی به پایگاه دانش'),
            qsTr('پاسخ‌گویی به تیکت'),
            qsTr('تماس تلفنی'),
            qsTr('پشتیبانی در پیام‌رسان '),
            qsTr('قرارداد سطح کیفیت'),
            qsTr('پشتیبانی اختصاصی'),
            qsTr('مشاوره در طراحی زیرساخت'),
            qsTr('برگزاری کارگاه آموزشی')]

        Text {
            id: idRootLabelTextOption1
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: idRootLabel.top_margin[0]
            horizontalAlignment: Text.AlignRight
            font.family: font_fa_medium.name
            font.pointSize: parseInt(parent.width * 0.035) <= 0 ? 1 : parseInt(parent.width * 0.035)
            minimumPointSize: parseInt(appSetting.fontScale * 0.5)
            color: theme.text
            text: '<ul><li>' + idRootLabel.options[0] + '</li>'
        }

        Text {
            id: idRootLabelTextOption2
            anchors.top: idRootLabelTextOption1.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[1] + '</li>'
        }

        Text {
            id: idRootLabelTextOption3
            anchors.top: idRootLabelTextOption2.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[2] + '</li>'
        }

        Text {
            id: idRootLabelTextOption4
            anchors.top: idRootLabelTextOption3.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[3] + '</li>'
        }

        Text {
            id: idRootLabelTextOption5
            anchors.top: idRootLabelTextOption4.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[4] + '</li>'
        }

        Text {
            id: idRootLabelTextOption6
            anchors.top: idRootLabelTextOption5.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[5] + '</li>'
        }

        Text {
            id: idRootLabelTextOption7
            anchors.top: idRootLabelTextOption6.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[6] + '</li>'
        }

        Text {
            id: idRootLabelTextOption8
            anchors.top: idRootLabelTextOption7.bottom
            anchors.right: idRootLabelTextOption1.right
            anchors.topMargin: idRootLabel.top_margin[1]
            horizontalAlignment: idRootLabelTextOption1.horizontalAlignment
            font.family: idRootLabelTextOption1.font.family
            font.pointSize: idRootLabelTextOption1.font.pointSize
            minimumPointSize: idRootLabelTextOption1.minimumPointSize
            color: idRootLabelTextOption1.color
            text: '<ul><li>' + idRootLabel.options[7] + '</li>'
        }
    }

    Flickable {
        id: idRootFlickable
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: idRootLabel.left
        anchors.left: parent.left
        clip: true
        contentWidth: idRootFlickableRow.width
        contentHeight: idRootFlickableRow.height
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.horizontal: ScrollBar {
            id: idRootFlickableScrollBar
            parent: idRootFlickable.parent
            anchors.top: idRootFlickable.bottom
            anchors.left: idRootFlickable.left
            anchors.right: idRootFlickable.right
            policy: ScrollBar.AlwaysOn
        }

        Row {
            id: idRootFlickableRow
            layoutDirection: Qt.RightToLeft

            ModelSupportPlan {
                id: idSupportPlanItemBase
                width: idRootFlickable.width * 0.2
                height: idRootFlickable.height
                image: 'qrc:/images/support/plan/base.svg'
                title: 'پایه'
                options: ['\uf00c', ('حداکثر تا 24 ساعت'), '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }

            ModelSupportPlan {
                id: idSupportPlanItemBronze
                width: idSupportPlanItemBase.width
                height: idSupportPlanItemBase.height
                image: 'qrc:/images/support/plan/bronze.svg'
                title: 'برنزی'
                options: ['\uf00c', ('حداکثر تا 12 ساعت'), '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }

            ModelSupportPlan {
                id: idSupportPlanItemSilver
                width: idSupportPlanItemBase.width
                height: idSupportPlanItemBase.height
                image: 'qrc:/images/support/plan/silver.svg'
                title: 'نقره ای'
                options: ['\uf00c', ('حداکثر تا 4 ساعت'), ('در ساعات اداری'), '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }

            ModelSupportPlan {
                id: idSupportPlanItemPalladium
                width: idSupportPlanItemBase.width
                height: idSupportPlanItemBase.height
                image: 'qrc:/images/support/plan/palladium.svg'
                title: 'پالادیوم'
                options: ['\uf00c', ('حداکثر تا 2 ساعت'), ('از ساعت 9 الی 23'), '\uf00d', '\uf00d', '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }

            ModelSupportPlan {
                id: idSupportPlanItemGold
                width: idSupportPlanItemBase.width
                height: idSupportPlanItemBase.height
                image: 'qrc:/images/support/plan/gold.svg'
                title: 'طلایی'
                options: ['\uf00c', ('حداکثر تا 30 دقیقه'), ('24 ساعته'), '\uf00c', ('99/9 %'), '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }

            ModelSupportPlan {
                id: idSupportPlanItemPlatinum
                width: idSupportPlanItemBase.width
                height: idSupportPlanItemBase.height
                image: 'qrc:/images/support/plan/gold.svg'
                title: 'پلانتیوم'
                options: ['\uf00c', ('حداکثر تا 30 دقیقه'), ('24 ساعته'), '\uf00c', ('99/9 %'), '\uf00d', '\uf00d', '\uf00d']
                price: 'N/A'
            }
        }
    }

    onVisibleChanged: {
        if (!visible) { return }
        idRootLabel.visible = false
        idRootFlickable.visible = false
        idRootBusyIndicator.visible = true
        idRootPlansText.visible = false
        idRootPlansImage.opacity =  0.25
        idRootFlickableScrollBar.visible = false
        support.requestPlans()
    }

//    TODO: add for new version
//    Connections {
//        target: support

//        onNotifyPlans: {
//            let plans = {
//                'base': idSupportPlanItemBase,
//                'bronze': idSupportPlanItemBronze,
//                'silver': idSupportPlanItemSilver,
//                'palladium': idSupportPlanItemPalladium,
//                'gold': idSupportPlanItemGold,
//                'platinum': idSupportPlanItemPlatinum
//            }

//            for (let i=0 ; i<id.length ; i++) {
//                for (let key in plans) {
//                    if (id[i] === key) {
//                        plans[key].select = key === settings.get(SystemSettings.UserAuthSupportPlan)
//                        plans[key].price = support.getPlanInfo(key)
//                    }
//                }
//            }

//            idRootPlansImage.opacity = 0
//            idRootPlansText.visible = false
//            idRootBusyIndicator.visible = false
//            idRootFlickable.visible = true
//            idRootLabel.visible = true
//            idRootFlickableScrollBar.visible = true
//        }

//        onErrorPlans: {
//            idRootLabel.visible = false
//            idRootFlickable.visible = false
//            idRootBusyIndicator.visible = false
//            idRootPlansText.text = qsTr('خطا در دریافت اطلاعات')
//            idRootPlansText.visible = true
//            idRootPlansImage.opacity = 1
//            idRootFlickableScrollBar.visible = false
//        }
//    }
}
