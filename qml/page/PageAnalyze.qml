import QtQuick 2.12
import QtQuick.Controls 2.12
import LogAckCode 1.0

import '../model'
import '../object'


ModelPagetype {
    id: idRoot

    property bool linkConnected: false

//    Rectangle {
//        id: idMenuRectangle
//        width: idLogServiceMenuItem.width * 2
//        height: idLogServiceMenuItem.height
//        anchors.top: parent.top
//        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
//        anchors.horizontalCenter: parent.horizontalCenter
//        radius: 10
//        color: theme.backgroundLight

//        readonly property double maxItemWidth: Math.max(idLogServiceMenuText.implicitWidth, idGeoTagMenuText.implicitWidth)
//        readonly property double maxItemHeight: Math.max(idLogServiceMenuText.implicitHeight, idGeoTagMenuText.implicitHeight)
//        readonly property double animationDuration: 200

//        Rectangle {
//            id: idIndicatorRectangle
//            width: idLogServiceMenuItem.width * 0.925
//            height: idLogServiceMenuItem.height * 0.75
//            radius: parent.radius * 0.75
//            anchors.verticalCenter: parent.verticalCenter
//            color: theme.primary
//        }

//        Item {
//            id: idLogServiceMenuItem
//            width: idMenuRectangle.maxItemWidth * 1.5
//            height: idMenuRectangle.maxItemHeight * 1.5
//            anchors.right: parent.right
//            anchors.verticalCenter: parent.verticalCenter

//            Text {
//                id: idLogServiceMenuText
//                anchors.centerIn: parent
//                verticalAlignment: Text.AlignVCenter
//                horizontalAlignment: Text.AlignHCenter
//                color: theme.text
//                fontSizeMode: Text.Fit
//                font.family: font_fa_black.name
//                font.pixelSize: idDisplay.getFontScale(1, 2.25)
//                text: qsTr('لاگ پرواز')
//            }

//            NumberAnimation {
//                id: idLogServiceAnimation
//                target: idIndicatorRectangle
//                property: 'x'
//                to: idGeoTagMenuItem.width + (idLogServiceMenuItem.width - idIndicatorRectangle.width) * 0.5
//                duration: idMenuRectangle.animationDuration
//                onFinished: {
//                    idGeoTagContainerItem.visible = false
//                    idLogServiceContainerItem.visible = true
//                }
//            }

//            MouseArea {
//                anchors.fill: parent
//                onClicked: idLogServiceAnimation.start()
//            }
//        }

//        Item {
//            id: idGeoTagMenuItem
//            width: idLogServiceMenuItem.width
//            height: idLogServiceMenuItem.height
//            anchors.left: parent.left
//            anchors.verticalCenter: parent.verticalCenter

//            Text {
//                id: idGeoTagMenuText
//                anchors.centerIn: parent
//                verticalAlignment: Text.AlignVCenter
//                horizontalAlignment: Text.AlignHCenter
//                color: theme.text
//                fontSizeMode: Text.Fit
//                font: idLogServiceMenuText.font
//                text: qsTr('Geo Tag')
//            }

//            NumberAnimation {
//                id: idGeoTagAnimation
//                target: idIndicatorRectangle
//                property: 'x'
//                to: (idGeoTagMenuItem.width - idIndicatorRectangle.width) * 0.5
//                duration: idMenuRectangle.animationDuration
//                onFinished: {
//                    idLogServiceContainerItem.visible = false
//                    idGeoTagContainerItem.visible = true
//                }
//            }

//            MouseArea {
//                anchors.fill: parent
//                onClicked: idGeoTagAnimation.start()
//            }
//        }
//    }

    Item {
        id: idContainer
        anchors.top: parent.top//idMenuRectangle.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)//idMenuRectangle.anchors.topMargin
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin
    }

    Item {
        id: idLogServiceContainerItem
        anchors.fill: idContainer

        property bool selectItem: false

        readonly property int modelSize: LogService.model.size

        Flickable {
            id: idLogServiceFlickable
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: idDisplay.getScaledWidth(0.05, 0.12)
            contentWidth: idLogServiceColumn.width
            contentHeight: idLogServiceColumn.height
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Column {
                id: idLogServiceColumn
                anchors.centerIn: parent
                spacing: 10

                ModelButton2 {
                    id: idRefreshButton
                    width: idLogServiceFlickable.width
                    height: idDisplay.getScaledHeight(0.0275, 0.075)
                    enabled: idRoot.linkConnected && !LogService.logEntryInProgress && !LogService.logDataInProgress
                    color: theme.backgroundDark
                    opacity: enabled ? 1 : 0.5
                    textMarginsScale: idDisplay.isLargeDisplay ? 0.15 : 0.215
                    text: qsTr('بروزرسانی')
                    onClicked: LogService.refresh()
                }

                ModelButton2 {
                    id: idDownloadButton
                    width: idRefreshButton.width
                    height: idRefreshButton.height
                    enabled: idRoot.linkConnected && !LogService.logEntryInProgress && !LogService.logDataInProgress && idLogServiceContainerItem.selectItem
                    color: theme.backgroundDark
                    opacity: enabled ? 1 : 0.5
                    textMarginsScale: idRefreshButton.textMarginsScale
                    text: qsTr('بارگیری')
                    onClicked: LogService.download()
                }

                ModelButton2 {
                    width: idRefreshButton.width
                    height: idRefreshButton.height
                    enabled: idRoot.linkConnected && !LogService.logEntryInProgress && !LogService.logDataInProgress && LogService.model.size
                    color: theme.backgroundDark
                    opacity: enabled ? 1 : 0.5
                    textMarginsScale: idRefreshButton.textMarginsScale
                    text: qsTr('حذف همه')
                    onClicked: idEraseLogPopup.open()
                }

                ModelButton2 {
                    width: idRefreshButton.width
                    height: idRefreshButton.height
                    enabled: idRoot.linkConnected && (LogService.logEntryInProgress || LogService.logDataInProgress)
                    color: theme.backgroundDark
                    opacity: enabled ? 1 : 0.5
                    textMarginsScale: idRefreshButton.textMarginsScale
                    text: qsTr('لغو')
                    onClicked: LogService.cancel()
                }
            }
        }

        Item {
            id: idLogEntryContainerItem
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idLogServiceFlickable.right
            anchors.right: parent.right
            anchors.leftMargin: idContainer.anchors.leftMargin

            readonly property real dateItemRightMargin: width * 0.1
            readonly property real sizeItemRightMargin: width * (idDisplay.isLargeDisplay ? 0.5 : 0.55)
            readonly property real statusItemRightMargin: width * (idDisplay.isLargeDisplay ? 0.6 : 0.7)

            Item {
                id: idLogEntryTitleItem
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: idDisplay.getScaledHeight(0.0425, 0.1)

                Item {
                    id: idLogEntryTitleContainerItem
                    anchors.fill: parent
                    anchors.topMargin: parent.height * 0.25
                    anchors.bottomMargin: anchors.topMargin

                    Text {
                        id: idLogEntryIDTitle
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        font.family: font_fa_black.name
                        font.pixelSize: parent.height
                        fontSizeMode: Text.Fit
                        color: theme.text
                        text: qsTr('ردیف')
                    }

                    Text {
                        anchors.fill: parent
                        anchors.rightMargin: idLogEntryContainerItem.dateItemRightMargin
                        verticalAlignment: idLogEntryIDTitle.verticalAlignment
                        horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                        font: idLogEntryIDTitle.font
                        fontSizeMode: idLogEntryIDTitle.fontSizeMode
                        color: idLogEntryIDTitle.color
                        text: qsTr('تاریخ')
                    }

                    Text {
                        anchors.fill: parent
                        anchors.rightMargin: idLogEntryContainerItem.sizeItemRightMargin
                        verticalAlignment: idLogEntryIDTitle.verticalAlignment
                        horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                        font: idLogEntryIDTitle.font
                        fontSizeMode: idLogEntryIDTitle.fontSizeMode
                        color: idLogEntryIDTitle.color
                        text: qsTr('اندازه')
                    }

                    Text {
                        anchors.fill: parent
                        anchors.rightMargin: idLogEntryContainerItem.statusItemRightMargin
                        verticalAlignment: idLogEntryIDTitle.verticalAlignment
                        horizontalAlignment: idLogEntryIDTitle.horizontalAlignment
                        font: idLogEntryIDTitle.font
                        fontSizeMode: idLogEntryIDTitle.fontSizeMode
                        color: idLogEntryIDTitle.color
                        text: qsTr('وضعیت')
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
                anchors.top: idLogEntryTitleItem.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idLogEntryTitleContainerItem.anchors.topMargin
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ListView {
                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    model: LogService.model
                    spacing: 5
                    clip: true

                    delegate: Rectangle {
                        id: idLogEntryRectangle
                        width: parent.width
                        height: idDisplay.getScaledHeight(0.035, 0.08)
                        color: theme.backgroundDark

                        readonly property var ackCode: {
                            const log = LogService.model.get(model.index)
                            return log ? log.ack : LogAckCode.Waiting
                        }

                        Item {
                            anchors.fill: parent
                            anchors.topMargin: parent.height * 0.2
                            anchors.bottomMargin: anchors.topMargin

                            Text {
                                id: idLogEntryID
                                anchors.fill: parent
                                anchors.rightMargin: parent.height * 0.5
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                font.family: font_fa_medium.name
                                font.pixelSize: parent.height
                                fontSizeMode: Text.Fit
                                color: {
                                    switch (idLogEntryRectangle.ackCode) {
                                    case LogAckCode.Available:
                                    case LogAckCode.Waiting:
                                    case LogAckCode.InProgress:
                                    default:
                                        return theme.text

                                    case LogAckCode.Download:
                                        return theme.primary

                                    case LogAckCode.Cancel:
                                        return '#a3a310'

                                    case LogAckCode.Error:
                                        return 'red'
                                    }
                                }
                                text: {
                                    const log = LogService.model.get(model.index)
                                    return log ? log.id + 1 : 'N/A'
                                }
                            }

                            Text {
                                anchors.fill: parent
                                anchors.leftMargin: parent.width - idLogEntryContainerItem.sizeItemRightMargin + (parent.height * 0.5)
                                anchors.rightMargin: idLogEntryContainerItem.dateItemRightMargin
                                verticalAlignment: idLogEntryID.verticalAlignment
                                horizontalAlignment: idLogEntryID.horizontalAlignment
                                font: idLogEntryID.font
                                fontSizeMode: idLogEntryID.fontSizeMode
                                color: idLogEntryID.color
                                clip: true
                                text: {
                                    const log = LogService.model.get(model.index)
                                    return log && log.received ? log.time.toLocaleString() : 'N/A'
                                }
                            }

                            Text {
                                anchors.fill: parent
                                anchors.rightMargin: idLogEntryContainerItem.sizeItemRightMargin
                                verticalAlignment: idLogEntryID.verticalAlignment
                                horizontalAlignment: idLogEntryID.horizontalAlignment
                                font: idLogEntryID.font
                                fontSizeMode: idLogEntryID.fontSizeMode
                                color: idLogEntryID.color
                                text: {
                                    const log = LogService.model.get(model.index)
                                    return log ? log.sizeString : 'N/A'
                                }
                            }

                            Item {
                                id: idAckIndicatorItem
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                anchors.topMargin: parent.height * 0.1
                                anchors.bottomMargin: anchors.topMargin
                                anchors.rightMargin: idLogEntryContainerItem.statusItemRightMargin + anchors.topMargin
                                width: height

                                readonly property bool inProgress: idLogEntryRectangle.ackCode === LogAckCode.InProgress

                                Text {
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                    font.family: fontAwesome.name
                                    font.pixelSize: parent.height
                                    fontSizeMode: Text.Fit
                                    visible: !idAckIndicatorItem.inProgress
                                    color: idLogEntryRectangle.ackCode === LogAckCode.InProgress ? theme.primary : idLogEntryID.color
                                    text: {
                                        switch (idLogEntryRectangle.ackCode) {
                                        case LogAckCode.Available:
                                            return '\uf381'

                                        case LogAckCode.Waiting:
                                            return '\uf251'

                                        case LogAckCode.Download:
                                            return '\uf00c'

                                        case LogAckCode.Cancel:
                                            return '\uf06a'

                                        case LogAckCode.Error:
                                            return '\uf071'

                                        default:
                                            return ''
                                        }
                                    }
                                }

                                Canvas {
                                    id: idLogEntryCanvas
                                    anchors.fill: parent
                                    antialiasing: true
                                    visible: idAckIndicatorItem.inProgress

                                    readonly property real centerWidth: idLogEntryCanvas.width * 0.5
                                    readonly property real centerHeight: idLogEntryCanvas.height * 0.5
                                    readonly property real radius: Math.min(idLogEntryCanvas.width, idLogEntryCanvas.height) * 0.5
                                    readonly property real offset: Math.PI * -0.5
                                    readonly property real angle: (idLogEntryCanvas.value - idLogEntryCanvas.minimumValue) / (idLogEntryCanvas.maximumValue - idLogEntryCanvas.minimumValue) * 2 * Math.PI
                                    readonly property real minimumValue: 0.0
                                    readonly property real maximumValue: 1.0
                                    readonly property real value: {
                                        const log = LogService.model.get(model.index)
                                        return log && !Number.isNaN(log.progress) ? log.progress : 0.0
                                    }

                                    onValueChanged: idLogEntryCanvas.requestPaint()

                                    onPaint: {
                                        const ctx = getContext('2d')
                                        ctx.save()
                                        ctx.clearRect(0, 0, idLogEntryCanvas.width, idLogEntryCanvas.height)
                                        ctx.beginPath()
                                        ctx.lineWidth = 2
                                        ctx.strokeStyle = theme.primary
                                        ctx.arc(idLogEntryCanvas.centerWidth, idLogEntryCanvas.centerHeight, idLogEntryCanvas.radius - ctx.lineWidth, idLogEntryCanvas.offset, idLogEntryCanvas.offset + idLogEntryCanvas.angle)
                                        ctx.stroke()
                                    }
                                }
                            }

                            Text {
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: idAckIndicatorItem.left
                                anchors.rightMargin: parent.anchors.topMargin + idAckIndicatorItem.anchors.topMargin
                                verticalAlignment: idLogEntryID.verticalAlignment
                                horizontalAlignment: idLogEntryID.horizontalAlignment
                                font: idLogEntryID.font
                                fontSizeMode: idLogEntryID.fontSizeMode
                                color: idLogEntryID.color
                                text: {
                                    switch (idLogEntryRectangle.ackCode) {
                                    case LogAckCode.Available:
                                        return qsTr('در دسترس')

                                    case LogAckCode.Cancel:
                                        return qsTr('لغو شده')

                                    case LogAckCode.Download:
                                        return qsTr('بارگیری شده')

                                    case LogAckCode.Error:
                                        return qsTr('خطا')

                                    case LogAckCode.InProgress:
                                        const log = LogService.model.get(model.index)
                                        return log ? log.rate : 'N/A'

                                    case LogAckCode.Waiting:
                                        return qsTr('در انتظار')

                                    default:
                                        return 'N/A'
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.margins: parent.height * 0.35
                            width: height
                            radius: height * 0.5
                            color: theme.primary
                            visible: {
                                const log = LogService.model.get(model.index)
                                return log && log.selected ? true : false
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (idRefreshButton.enabled) {
                                    LogService.model.get(model.index).selected = !LogService.model.get(model.index).selected
                                    idLogServiceContainerItem.updateSelectedSize()
                                }
                            }
                        }
                    }
                }
            }
        }

        function updateSelectedSize() {
            for (let i=0 ; i<LogService.model.size ; ++i) {
                let log = LogService.model.get(i)

                if (log && log.selected) {
                    idLogServiceContainerItem.selectItem = true
                    return
                }
            }

            idLogServiceContainerItem.selectItem = false
        }

        onModelSizeChanged: idLogServiceContainerItem.updateSelectedSize()

        Connections {
            target: LogService
            onSelectedChanged: idLogServiceContainerItem.updateSelectedSize()
        }
    }

//    Item {
//        id: idGeoTagContainerItem
//        anchors.fill: idContainer

//        Rectangle {
//            anchors.fill: parent
//            color: 'yellow'
//        }
//    }

    ObjectEraseLog {
        id: idEraseLogPopup
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.085, 0.225)
    }

//    Component.onCompleted: idLogServiceAnimation.start()

    Connections {
        target: link

        onConnectionChanged: {
            idRoot.linkConnected = connected
        }
    }
}
