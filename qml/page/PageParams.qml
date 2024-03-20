import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'
import '../object'


ModelPagetype {
    id: idRoot

    property bool warningVisible: false
    property bool downloadComplete: false

    ListModel {
        id: idSearchList
    }

    ModelPopup {
        id: idWarningPopup
        width: idDisplay.getScaledWidth(0.275, 0.375)
        height: idChangeParametersWarningIcon.contentHeight + idChangeParametersWarningText.contentHeight + idWarningPopup.itemSpacing * 4
        modal: true
        clip: true
        visible: false

        readonly property real itemSpacing: idDisplay.getScaledHeight(0.015, 0.03)

        Text {
            id: idChangeParametersWarningIcon
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: idWarningPopup.itemSpacing
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(3, 6)
            color: theme.yellow
            text: '\uf12a'
        }

        Text {
            id: idChangeParametersWarningText
            anchors.top: idChangeParametersWarningIcon.bottom
            anchors.topMargin: idWarningPopup.itemSpacing
            width: parent.width
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.AlignJustify
            font.family: font_fa_medium.name
            font.pixelSize: idDisplay.getFontScale(1.05, 2.1)
            color: theme.text
            clip: true
            text: qsTr('در صورتی که از تنظیم پارامتر ها اطلاع کافی ندارید این تنظیمات را تغییر ندهید. لازم به ذکر است عواقب هر گونه تغییر بر عهده کاربر می باشد.')
        }
    }

    Rectangle {
        id: idButtonsRectangle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
        height: idSearchTextfield.implicitHeight * 1.2
        color: parent.color

        readonly property real itemSpacing: idDisplay.getScaledWidth(0.01, 0.02)

        Item {
            id: idDownloadButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: idDownloadText.implicitWidth
            height: idDownloadText.implicitHeight

            Text {
                id: idDownloadText
                anchors.centerIn: parent
                color: theme.text
                font.family: fontAwesome.name
                fontSizeMode: Text.Fit
                font.pixelSize: idDisplay.getFontScale(1.65, 3.3)
                text: '\uf381'
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (link.isConnected()) {
                        ParamService.notifyDownload()
                        idRoot.reset()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        Item {
            id: idSaveToFileButton
            anchors.left: idDownloadButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: idButtonsRectangle.itemSpacing
            width: idSaveToFileText.implicitWidth
            height: idSaveToFileText.implicitHeight

            Text {
                id: idSaveToFileText
                anchors.centerIn: parent
                color: idDownloadText.color
                font: idDownloadText.font
                fontSizeMode: idDownloadText.fontSizeMode
                text: '\uf56d'
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (link.isConnected()) {
                        ParamService.notifySaveToFile()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        Item {
            id: idLoadFromFileButton
            anchors.left: idSaveToFileButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: idButtonsRectangle.itemSpacing
            width: idLoadFromFileText.implicitWidth
            height: idLoadFromFileText.implicitHeight

            Text {
                id: idLoadFromFileText
                anchors.centerIn: parent
                color: idDownloadText.color
                font: idDownloadText.font
                fontSizeMode: idDownloadText.fontSizeMode
                text: '\uf574'
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (link.isConnected()) {
                        ParamService.notifyLoadFromFile()

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        Item {
            id: idRestoreButton
            anchors.left: idLoadFromFileButton.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: idButtonsRectangle.itemSpacing
            width: idRestoreText.implicitWidth
            height: idRestoreText.implicitHeight

            Text {
                id: idRestoreText
                anchors.centerIn: parent
                color: idDownloadText.color
                font: idDownloadText.font
                fontSizeMode: idDownloadText.fontSizeMode
                text: '\uf021'
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (link.isConnected()) {
                        questions.clear()
                        questions.add(qsTr('از بازنشانی پارامتر ها اطمینان دارید؟'), 'restore_params')

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }

        ModelTextfield {
            id: idSearchTextfield
            anchors.left: idRestoreButton.right
            anchors.right: parent.right
            anchors.leftMargin: idButtonsRectangle.itemSpacing
            anchors.verticalCenter: parent.verticalCenter
            height: idDownloadButton.height * 1.5
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            backgroundColor: theme.backgroundDark
            font.family: font_fa_medium.name
            font.pixelSize: idDownloadText.font.pixelSize * 0.75
            placeholderText: qsTr('جستجو')
            validator: RegExpValidator { regExp: /\w+/ } // TODO: words + spaces + numbers
            onTextChanged: idRoot.search(text)
            enabled: false
        }
    }

    Item {
        id: idParamsContainerItem
        anchors.top: idButtonsRectangle.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin

        readonly property real idItemLeftMargin: width * (idDisplay.isLargeDisplay ? 0.085 : 0.2)
        readonly property real descriptionItemLeftMargin: width * (idDisplay.isLargeDisplay ? 0.275 : 0)
        readonly property real typeItemLeftMargin: width * (idDisplay.isLargeDisplay ? 0.8 : 0.55)
        readonly property real valueItemLeftMargin: width * (idDisplay.isLargeDisplay ? 0.875 : 0.775)

        Item {
            id: idParamsTitleItem
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: idDisplay.getScaledHeight(0.0425, 0.1)

            Item {
                id: idParamsTitleContainerItem
                anchors.fill: parent
                anchors.topMargin: parent.height * 0.25
                anchors.bottomMargin: anchors.topMargin

                Text {
                    id: idLogEntryIDTitle
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.family: font_fa_black.name
                    font.pixelSize: parent.height
                    fontSizeMode: Text.Fit
                    color: theme.text
                    text: qsTr('ردیف')
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: idParamsContainerItem.idItemLeftMargin
                    verticalAlignment: idLogEntryIDTitle.verticalAlignment
                    horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                    font: idLogEntryIDTitle.font
                    fontSizeMode: idLogEntryIDTitle.fontSizeMode
                    color: idLogEntryIDTitle.color
                    text: qsTr('شناسه')
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: idParamsContainerItem.descriptionItemLeftMargin
                    verticalAlignment: idLogEntryIDTitle.verticalAlignment
                    horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                    font: idLogEntryIDTitle.font
                    fontSizeMode: idLogEntryIDTitle.fontSizeMode
                    color: idLogEntryIDTitle.color
                    text: qsTr('توضیح')
                    visible: idDisplay.isLargeDisplay
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: idParamsContainerItem.typeItemLeftMargin
                    verticalAlignment: idLogEntryIDTitle.verticalAlignment
                    horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                    font: idLogEntryIDTitle.font
                    fontSizeMode: idLogEntryIDTitle.fontSizeMode
                    color: idLogEntryIDTitle.color
                    text: qsTr('نوع')
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: idParamsContainerItem.valueItemLeftMargin
                    verticalAlignment: idLogEntryIDTitle.verticalAlignment
                    horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                    font: idLogEntryIDTitle.font
                    fontSizeMode: idLogEntryIDTitle.fontSizeMode
                    color: idLogEntryIDTitle.color
                    text: qsTr('مقدار')
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: theme.primaryDark
            }
        }

        ScrollView {
            anchors.top: idParamsTitleItem.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: idParamsTitleContainerItem.anchors.topMargin
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: idParamsListVeiw
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                model: idSearchList
                spacing: 5
                clip: true

                delegate: Rectangle {
                    width: parent.width
                    height: idDisplay.getScaledHeight(0.035, 0.08)
                    color: theme.backgroundDark

                    Item {
                        anchors.fill: parent
                        anchors.topMargin: parent.height * 0.2
                        anchors.bottomMargin: anchors.topMargin

                        Text {
                            id: idTextIndex
                            anchors.fill: parent
                            anchors.leftMargin: parent.height * 0.5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.Alignleft
                            font.family: font_fa_medium.name
                            font.pixelSize: parent.height
                            fontSizeMode: Text.Fit
                            color: theme.text
                            text: index + 1
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: idParamsContainerItem.idItemLeftMargin
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.Alignleft
                            fontSizeMode: Text.Fit
                            font: idTextIndex.font
                            color: idTextIndex.color
                            text: id
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: idParamsContainerItem.descriptionItemLeftMargin
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.Alignleft
                            fontSizeMode: Text.Fit
                            font: idTextIndex.font
                            color: idTextIndex.color
                            text: short_description === "" ? "N/A" : short_description
                            visible: idDisplay.isLargeDisplay
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: idParamsContainerItem.typeItemLeftMargin
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.Alignleft
                            fontSizeMode: Text.Fit
                            font: idTextIndex.font
                            color: idTextIndex.color
                            text: type_text
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: idParamsContainerItem.valueItemLeftMargin
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.Alignleft
                            fontSizeMode: Text.Fit
                            font: idTextIndex.font
                            color: idTextIndex.color
                            text: decimal ? value.toFixed(6) : value
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            idSearchTextfield.enabled = false
                            idParamsListVeiw.interactive = false
                            idParamFact.open(ParamService.get(id))
                        }
                    }
                }
            }
        }
    }

    ObjectParamFact {
        id: idParamFact

        onClosed: {
            idParamsListVeiw.interactive = true

            if (idRoot.downloadComplete) {
                idSearchTextfield.enabled = true
            }
        }
    }

    onVisibleChanged: {
        idRoot.showWarning()
    }

    Connections {
        target: questions

        onEvent: {
            if(id === 'restore_params' && accept) {
                ParamService.notifyRestoreDefault()
            }
        }
    }

    Connections {
        target: ParamService

        onNotifyDownloadComplete: {
            idRoot.search('')
            idRoot.downloadComplete = true
            idSearchTextfield.enabled = true
            idRoot.showWarning()
        }

        onNotifyChanges: {
            if (idRoot.downloadComplete) {
                for (let i=0 ; i<idSearchList.count ; i++) {
                    if (idSearchList.get(i).id === param.id) {
                        idSearchList.remove(i)
                        idSearchList.insert(i, param)
                        break
                    }
                }
            }
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                idRoot.reset()
                idWarningPopup.close()
            }
        }
    }

    function showWarning() {
        if (idRoot.visible && !idRoot.warningVisible && idRoot.downloadComplete) {
            idRoot.warningVisible = true
            idWarningPopup.open()
        }
    }

    function search(text) {
        idSearchList.clear()

        text = text.toUpperCase()

        for (let i=0 ; i<ParamService.count() ; i++) {
            let param = ParamService.get(i)

            if (text === ''
                    || param.id.toUpperCase().indexOf(text) !== -1
                    || param.short_description.toUpperCase().indexOf(text) !== -1
                    || param.long_description.toUpperCase().indexOf(text) !== -1) {
                idSearchList.append(param)
            }
        }
    }

    function reset() {
        idSearchList.clear()
        idSearchTextfield.text = ''
        idSearchTextfield.enabled = false
        idRoot.downloadComplete = false
    }
}
