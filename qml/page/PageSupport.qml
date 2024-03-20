import QtQuick 2.12
import QtQuick.Controls 2.12

//TODO: add for next version
//import SystemSettings 2.6

import '../model'
import '../object'


ModelPagetype {
    id: idPageSupport

    //    TODO: add for next version
    //    ObjectPopupPlansType { id: idPopupPlansType }

    ObjectPopupAddTicket { id: idPopupAddTicket }

    ObjectPopupTicketMessage { id: idPopupTicketMessage }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
        color: parent.color

        readonly property real spacing: anchors.rightMargin * (idDisplay.isLargeDisplay ? 1 : 1.5)

        Rectangle {
            id: idPlanType
            anchors.top: parent.top
            anchors.right: parent.right
            width: (parent.width * 0.5) - (parent.spacing * 0.5)
            height: parent.height * 0.2
            color: theme.backgroundLight

            Image {
                id: idPlanTypeImage
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.15
                anchors.verticalCenter: parent.verticalCenter
                source: 'qrc:/images/support/plan/base.svg'
                sourceSize: Qt.size(parent.height * 0.85, parent.height * 0.85)
            }

            Text {
                id: idPlanTypeText
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.25
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: font_fa_black.name
                font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
                text: qsTr('پایه')
            }

            //            TODO: add for next version
            //            ModelButton {
            //                id: idPlanTypeButton
            //                anchors.left: parent.left
            //                anchors.leftMargin: parent.width * 0.142
            //                anchors.verticalCenter: parent.verticalCenter
            //                width: parent.width * 0.2
            //                height: parent.height * 0.33
            //                backgroundColor: theme.primary
            //                font.pixelSize: idDisplay.getFontScale(1, 1)
            //                text: qsTr('پلن ها')
            //                onClicked: idPopupPlansType.visible = true
            //                visible: true
            //            }
            //            Connections {
            //                target: user_auth
            //                onNotifyValidation: {
            //                    switch (settings.get(SystemSettings.UserAuthSupportPlan)) {
            //                    case 'base':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/base.svg'
            //                        idPlanTypeText.text = qsTr('پایه')
            //                        break
            //                    case 'bronze':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/bronze.svg'
            //                        idPlanTypeText.text = qsTr('برنزی')
            //                        break
            //                    case 'silver':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/silver.svg'
            //                        idPlanTypeText.text = qsTr('نقره ای')
            //                        break
            //                    case 'palladium':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/palladium.svg'
            //                        idPlanTypeText.text = qsTr('پالادیوم')
            //                        break
            //                    case 'gold':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/gold.svg'
            //                        idPlanTypeText.text = qsTr('طلایی')
            //                        break
            //                    case 'platinum':
            //                        idPlanTypeImage.source = 'qrc:/images/support/plan/platinum.svg'
            //                        idPlanTypeText.text = qsTr('پلاتینیوم')
            //                        break
            //                    }
            //                    idPlanTypeImage.visible = true
            //                }
            //                onNotifyError: {
            //                    idPlanTypeImage.visible = false
            //                    idPlanTypeText.text = 'N/A'
            //                }
            //            }
        }

        Rectangle {
            id: idSoftwareGuide
            anchors.top: idPlanType.top
            anchors.left: parent.left
            width: idPlanType.width
            height: idPlanType.height
            color: theme.backgroundLight

            Text {
                anchors.right: parent.right
                anchors.rightMargin: parent.width * 0.125
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                wrapMode: Text.WordWrap
                fontSizeMode: idPlanTypeText.fontSizeMode
                font.family: idPlanTypeText.font.family
                font.pixelSize: idPlanTypeText.font.pixelSize
                text: qsTr('راهنمای نرم افزار')
            }

            ModelButton {
                id: idSoftwareGuideButton
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.142
                anchors.verticalCenter: parent.verticalCenter
                width: implicitWidth * 1.25
                height: implicitHeight * 1.1
                backgroundColor: parent.color
                font.family: idPlanTypeText.font.family
                font.pixelSize: idPlanTypeText.font.pixelSize * 0.75
                text: qsTr('راهنما')
                onClicked: Qt.openUrlExternally(idMenuView.docsAddress)
            }
        }

        Rectangle {
            id: idTicketsRectangle
            anchors.top: idPlanType.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: parent.spacing
            color: theme.backgroundLight

            ListModel { id: idTicketsListModel }

            readonly property real textTypeRightMargin: idTicketsRectangle.width * (idDisplay.isLargeDisplay ? 0.3 : 0.2)
            readonly property real textTimeRightMargin: idTicketsRectangle.width * (idDisplay.isLargeDisplay ? 0.05 : 0.025)
            readonly property real textStatusRightMargin: idTicketsRectangle.width * (idDisplay.isLargeDisplay ? 0.11 : 0.125)

            Text {
                id: idTicketsRectangleText
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.topMargin: parent.height * 0.04
                anchors.rightMargin: parent.width * 0.02
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idPlanTypeText.font.family
                font.pixelSize: idPlanTypeText.font.pixelSize
                text: qsTr('لیست تیکت ها')
            }

            ModelButton {
                id: idAddTicketsButton
                anchors.top: idTicketsRectangleText.top
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.02
                width: implicitWidth * 1.25
                height: implicitHeight * 1.1
                backgroundColor: parent.color
                font.family: idSoftwareGuideButton.font.family
                font.pixelSize: idSoftwareGuideButton.font.pixelSize
                text: qsTr('+ درخواست جدید')
                onClicked: user_auth.isSignin() ? idPopupAddTicket.visible = true : toast.error(qsTr('ابتدا وارد شوید'), 5000)
            }

            Text {
                id: idTicketsSubjectText
                anchors.top: idAddTicketsButton.bottom
                anchors.right: idTicketsLine.right
                anchors.topMargin: parent.height * 0.04
                fontSizeMode: Text.Fit
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
                color: theme.text
                text: qsTr('عنوان')
            }

            Text {
                id: idTicketsTextType
                anchors.top: idTicketsSubjectText.top
                anchors.right: idTicketsSubjectText.left
                anchors.rightMargin: idTicketsRectangle.textTypeRightMargin
                fontSizeMode: idTicketsSubjectText.fontSizeMode
                font.family: idTicketsSubjectText.font.family
                font.pixelSize: idTicketsSubjectText.font.pixelSize
                color: idTicketsSubjectText.color
                text: qsTr('واحد')
            }

            Text {
                id: idTicketsTimeText
                anchors.top: idTicketsSubjectText.top
                anchors.right: idTicketsTextType.left
                anchors.rightMargin: idTicketsRectangle.textTimeRightMargin
                fontSizeMode: idTicketsSubjectText.fontSizeMode
                font.family: idTicketsSubjectText.font.family
                font.pixelSize: idTicketsSubjectText.font.pixelSize
                color: idTicketsSubjectText.color
                text: qsTr('تاریخ')
            }

            Text {
                id: idTicketsStatusText
                anchors.top: idTicketsSubjectText.top
                anchors.right: idTicketsTimeText.left
                anchors.rightMargin: idTicketsRectangle.textStatusRightMargin
                fontSizeMode: idTicketsSubjectText.fontSizeMode
                font.family: idTicketsSubjectText.font.family
                font.pixelSize: idTicketsSubjectText.font.pixelSize
                color: idTicketsSubjectText.color
                text: qsTr('وضعیت')
            }

            Rectangle {
                id: idTicketsLine
                anchors.top: idTicketsSubjectText.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: parent.height * 0.025
                anchors.leftMargin: parent.width * 0.05
                anchors.rightMargin: parent.width * 0.05
                color: theme.primaryDark
                height: 1
            }

            Image {
                id: idTicketsImage
                anchors.centerIn: parent
                visible: true
                opacity: 1
                source: 'qrc:/images/support/ticket.svg'
                sourceSize: Qt.size(parent.height * 0.4, parent.height * 0.4)
            }

            ModelBusyIndicator {
                id: idTicketsBusyIndicator
                anchors.centerIn: parent
            }

            Text {
                id: idTicketsMessage
                anchors.top: idTicketsImage.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: idTicketsSubjectText.color
                fontSizeMode: idTicketsSubjectText.fontSizeMode
                font.family: idTicketsSubjectText.font.family
                font.pixelSize: idTicketsSubjectText.font.pixelSize
                visible: false
                text: ''
            }

            Text {
                id: idTicketsMessageAuthUser
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: idTicketsMessage.bottom
                color: theme.orange
                fontSizeMode: idTicketsSubjectText.fontSizeMode
                font.family: idTicketsSubjectText.font.family
                font.pixelSize: idTicketsSubjectText.font.pixelSize * 2
                visible: false
                text: qsTr('ابتدا وارد شوید')
            }

            ScrollView {
                anchors.top: idTicketsLine.bottom
                anchors.bottom: parent.bottom
                anchors.left: idTicketsLine.left
                anchors.right: idTicketsLine.right
                anchors.topMargin: idTicketsLine.anchors.topMargin
                anchors.bottomMargin: parent.height * 0.025
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    id: idTicketsListVeiw
                    anchors.fill: parent
                    clip: true
                    spacing: 2
                    boundsBehavior: Flickable.StopAtBounds
                    model: idTicketsListModel

                    delegate: Rectangle {
                        id: idTicketsDelegate
                        width: parent.width
                        height: idDisplay.getScaledHeight(0.05, 0.15)
                        border.color: theme.backgroundLight
                        color: theme.background

                        Text {
                            id: idTicketsDelegateSubjectText
                            anchors.right: parent.right
                            anchors.rightMargin: parent.width * (idDisplay.isLargeDisplay ? 0.02 : 0.025)
                            anchors.verticalCenter: parent.verticalCenter
                            width: (idTicketsSubjectText.width + idTicketsRectangle.textTypeRightMargin) * 0.9
                            clip: true
                            horizontalAlignment: Text.AlignRight
                            font.family: font_fa_medium.name
                            font.pixelSize: idDisplay.getFontScale(1.15, 2.3)
                            color: theme.text
                            text: SUBJECT
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: idTicketsSubjectText.width + idTicketsRectangle.textTypeRightMargin
                            anchors.verticalCenter: parent.verticalCenter
                            width: (idTicketsTextType.width + idTicketsRectangle.textTimeRightMargin) * 0.9
                            clip: true
                            horizontalAlignment: idTicketsDelegateSubjectText.horizontalAlignment
                            font.family: idTicketsDelegateSubjectText.font.family
                            font.pixelSize: idTicketsDelegateSubjectText.font.pixelSize
                            color: idTicketsDelegateSubjectText.color
                            text: TYPE === 'Technical' ? qsTr('فنی') : qsTr('مالی')
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: idTicketsSubjectText.width +
                                                 idTicketsRectangle.textTypeRightMargin +
                                                 idTicketsTextType.width +
                                                 idTicketsRectangle.textTimeRightMargin
                            width: (idTicketsTimeText.width + idTicketsRectangle.textStatusRightMargin) * 0.9
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: idTicketsDelegateSubjectText.horizontalAlignment
                            font.family: idTicketsDelegateSubjectText.font.family
                            font.pixelSize: idTicketsDelegateSubjectText.font.pixelSize
                            color: idTicketsDelegateSubjectText.color
                            text: UPDATEDAT
                        }

                        Rectangle {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: idTicketsSubjectText.width +
                                                 idTicketsRectangle.textTypeRightMargin +
                                                 idTicketsTextType.width +
                                                 idTicketsRectangle.textTimeRightMargin +
                                                 idTicketsTimeText.width +
                                                 idTicketsRectangle.textStatusRightMargin
                            width: idTicketsDelegateStatusText.implicitWidth + 40
                            height: idTicketsDelegateStatusText.implicitHeight + 10
                            radius: 20
                            clip: true
                            color: theme.backgroundDark

                            Text {
                                id: idTicketsDelegateStatusText
                                anchors.centerIn: parent
                                font.family: idTicketsDelegateSubjectText.font.family
                                font.pixelSize: idTicketsDelegateSubjectText.font.pixelSize
                                color: idTicketsDelegateSubjectText.color
                                clip: true
                                text: STATUS
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                idPopupTicketMessage.ticketID = idTicketsListModel.get(model.index).ID
                                idPopupTicketMessage.open()
                            }
                        }
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if (!visible) { return }
        idTicketsImage.opacity = 0.25
        idTicketsBusyIndicator.visible = true
        idTicketsMessage.visible = false
        idTicketsListModel.clear()
        support.requestTicketsList()
        idTicketsMessageAuthUser.visible = !user_auth.isSignin()
    }

    Connections {
        target: support

        onNotifyTicketsList: {
            idTicketsBusyIndicator.visible = false
            idTicketsMessage.visible = false
            idTicketsListModel.clear()

            if (id.length === 0) {
                idTicketsMessage.text = qsTr('موردی جهت نمایش وجود ندارد')
                idTicketsMessage.visible = true
                idTicketsImage.opacity = 1
                return
            }

            idTicketsImage.opacity = 0

            for (let i=0 ; i<id.length ; i++) {
                idTicketsListModel.append({
                                              'ID': id[i],
                                              'SUBJECT': support.getTicketInfo(id[i], 'subject'),
                                              'TYPE': support.getTicketInfo(id[i], 'type'),
                                              'UPDATEDAT': support.getTicketInfo(id[i], 'updatedAt'),
                                              'STATUS': support.getTicketInfo(id[i], 'state')
                                          })
            }
        }

        onErrorTicketsList: {
            idTicketsListModel.clear()
            idTicketsBusyIndicator.visible = false
            idTicketsMessage.text = qsTr('خطا در دریافت اطلاعات')
            idTicketsMessage.visible = true
            idTicketsImage.opacity = 1
        }
    }
}
