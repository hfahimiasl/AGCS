import QtQuick 2.12
import QtLocation 5.12

import '../model'
import '../object'
import '../map'


ModelPagetype {
    id: idRoot
    state: idRoot.normalState

    readonly property string normalState: 'NORMAL'
    readonly property string waypointState: 'WAYPOINT'
    readonly property string patternState: 'PATTERN'
    readonly property string downloadState: 'DOWNLOAD'
    readonly property string uploadState: 'UPLOAD'

    readonly property color orgBackgroundColor: theme.backgroundDark
    readonly property color orgContentColor: theme.text

    readonly property color selBackgroundColor: theme.primary
    readonly property color selContentColor: theme.backgroundDark

    readonly property bool editable: idRoot.visible && (idRoot.state === idRoot.normalState || idRoot.state === idRoot.waypointState)

    Item {
        id: idActionItem
        anchors.top: idDisplay.isLargeDisplay ? undefined : parent.top
        anchors.left: parent.left
        anchors.verticalCenter: idDisplay.isLargeDisplay ? parent.verticalCenter : undefined
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.0125)
        anchors.topMargin: idDisplay.isLargeDisplay ? undefined : anchors.leftMargin
        width: idGrid.implicitWidth
        height: idGrid.implicitHeight

        MouseArea {
            anchors.fill: parent
        }

        Grid {
            id: idGrid
            anchors.centerIn: parent
            columns: idDisplay.isLargeDisplay ? 1 : 5
            spacing: idDisplay.isLargeDisplay ? idDisplay.getScaledHeight(0.015, 0.015) : idActionItem.anchors.leftMargin

            ObjectCircleItem {
                id: idSelectWaypointType
                radius: idDisplay.getScaledWidth(0.025, 0.065)
                backgroundColor: idRoot.orgBackgroundColor
                contentFont: fontAwesome.name
                contentColor: idRoot.orgContentColor
                contentText: '\uf4d7'

                onClicked: {
                    if (idRoot.state === idRoot.normalState) {
                        idRoot.state = idRoot.waypointState

                    } else if (idRoot.state === idRoot.waypointState) {
                        idRoot.state = idRoot.normalState

                    } else if (idRoot.state === idRoot.patternState) {
                        toast.warn(qsTr('الگوی خود را محاسبه یا لغو کنید'), 5000)

                    } else if (idRoot.state === idRoot.downloadState) {
                        toast.warn(qsTr('در حال بارگیری ماموریت'), 5000)

                    } else if (idRoot.state === idRoot.uploadState) {
                        toast.warn(qsTr('در حال بارگذاری ماموریت'), 5000)
                    }
                }
            }

            ObjectCircleItem {
                id: idCreatePattern
                radius: idSelectWaypointType.radius
                backgroundColor: idRoot.orgBackgroundColor
                contentFont: idSelectWaypointType.contentFont
                contentColor: idRoot.orgContentColor
                contentText: '\uf5ee'
                focusState: !MissionService.landExist && !MissionService.rtlExist

                onClicked: {
                    if (idRoot.state === idRoot.downloadState) {
                        toast.warn(qsTr('در حال بارگیری ماموریت'), 5000)

                    } else if (idRoot.state === idRoot.uploadState) {
                        toast.warn(qsTr('در حال بارگذاری ماموریت'), 5000)

                    } else if (MissionService.landExist) {
                        toast.error(qsTr('امکان ایجاد الگو پس از نقطه فرود وجود ندارد'), 5000)

                    } else if (MissionService.rtlExist) {
                        toast.error(qsTr('امکان ایجاد الگو پس از نقطه بازگشت به خانه وجود ندارد'), 5000)

                    } else {
                        idRoot.state = idRoot.patternState
                    }
                }
            }

            ObjectCircleItem {
                id: idClear
                radius: idSelectWaypointType.radius
                backgroundColor: idRoot.orgBackgroundColor
                contentFont: idSelectWaypointType.contentFont
                contentColor: idRoot.orgContentColor
                contentText: '\uf1f8'

                onClicked: {
                    if (idRoot.state === idRoot.patternState) {
                        toast.warn(qsTr('الگوی خود را محاسبه یا لغو کنید'), 5000)

                    } else if (idRoot.state === idRoot.downloadState) {
                        toast.warn(qsTr('در حال بارگیری ماموریت'), 5000)

                    } else if (idRoot.state === idRoot.uploadState) {
                        toast.warn(qsTr('در حال بارگذاری ماموریت'), 5000)

                    } else {
                        idRoot.state = idRoot.normalState
                        MissionService.notifyClear()
                    }
                }
            }

            ObjectCircleItem {
                id: idDownload
                radius: idSelectWaypointType.radius
                backgroundColor: idRoot.orgBackgroundColor
                contentFont: idSelectWaypointType.contentFont
                contentColor: idRoot.orgContentColor
                contentText: '\uf381'
                focusState: false

                onClicked: {
                    if (link.isConnected()) {
                        if (idRoot.state === idRoot.uploadState) {
                            toast.warn(qsTr('در حال بارگذاری ماموریت'), 5000)

                        } else {
                            idRoot.state = idRoot.downloadState
                            MissionService.notifyDownload()
                        }

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }

            ObjectCircleItem {
                id: idUpload
                radius: idSelectWaypointType.radius
                backgroundColor: idRoot.orgBackgroundColor
                contentFont: idSelectWaypointType.contentFont
                contentColor: idRoot.orgContentColor
                contentText: '\uf382'
                focusState: false

                onClicked: {
                    if (link.isConnected()) {
                        if (idRoot.state === idRoot.downloadState) {
                            toast.warn(qsTr('در حال بارگیری ماموریت'), 5000)

                        } else {
                            idRoot.state = idRoot.uploadState
                            MissionService.notifyUpload()
                        }

                    } else {
                        toast.error(qsTr('دستگاه متصل نیست'), 5000)
                    }
                }
            }
        }
    }

    ObjectWaypointTypes {
        id: idWaypointTypes
        anchors.top: idDisplay.isLargeDisplay ? idActionItem.top : idActionItem.bottom
        anchors.left: idDisplay.isLargeDisplay ? idActionItem.right : idActionItem.left
        anchors.leftMargin: idDisplay.isLargeDisplay ? idActionItem.anchors.leftMargin : undefined
        anchors.topMargin: idDisplay.isLargeDisplay ? undefined : idActionItem.anchors.topMargin
        visible: false
    }

    ObjectTakeoffEditor {
        id: idTakeoffEditor
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.125, 0.325)
    }

    ObjectWaypointEditor {
        id: idWaypointEditor
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.isLargeDisplay
                ? (idWaypointEditor.originalHeight > app.height ? idDisplay.getScaledHeight(0.585, 0.585) : idWaypointEditor.originalHeight)
                : idDisplay.displayHeight * 0.875
    }

    ObjectLandEditor {
        id: idLandEditor
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.085, 0.225)
    }

    ObjectPatternEditor {
        id: idPatternEditor
        anchors.top: idDisplay.isLargeDisplay ? idActionItem.top : undefined
        anchors.left: idDisplay.isLargeDisplay ? idActionItem.right : undefined
        anchors.right: idDisplay.isLargeDisplay ? undefined : parent.right
        anchors.leftMargin: idDisplay.isLargeDisplay ? idActionItem.anchors.leftMargin : undefined
        anchors.rightMargin: idDisplay.isLargeDisplay ? undefined : idActionItem.anchors.leftMargin
        anchors.verticalCenter: idDisplay.isLargeDisplay ? undefined : parent.verticalCenter

        onActiveChanged: {
            if (!active) {
                idRoot.state = idRoot.normalState
            }
        }
    }

    ObjectPatternCornerEditor {
        id: idPatternCornerEditor
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.085, 0.225)
    }

    ObjectPatternRenderProgress {
        id: idPatternRenderProgress
        anchors.centerIn: parent
        width: idDisplay.getScaledWidth(0.175, 0.45)
        height: idDisplay.getScaledHeight(0.125, 0.325)
    }

    states: [
        State {
            name: idRoot.normalState
            PropertyChanges { target: idSelectWaypointType; focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idCreatePattern;                          enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idClear;              focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idDownload;                               enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idUpload;                                 enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypointTypes;      visible:    false }
        },
        State {
            name: idRoot.waypointState
            PropertyChanges { target: idSelectWaypointType; focusState: true;   enabled: true; backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idCreatePattern;                          enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idClear;              focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idDownload;                               enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idUpload;                                 enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypointTypes;      visible:    true }
        },
        State {
            name: idRoot.patternState
            PropertyChanges { target: idSelectWaypointType; focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idCreatePattern;                          enabled: true; backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idClear;              focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idDownload;                               enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idUpload;                                 enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypointTypes;      visible:    false }
            PropertyChanges { target: idPatternEditor;      active:     true }
        },
        State {
            name: idRoot.downloadState
            PropertyChanges { target: idSelectWaypointType; focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idCreatePattern;                          enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idClear;              focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idDownload;                               enabled: true; backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idUpload;                                 enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypointTypes;      visible:    false }
        },
        State {
            name: idRoot.uploadState
            PropertyChanges { target: idSelectWaypointType; focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idCreatePattern;                          enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idClear;              focusState: true;   enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idDownload;                               enabled: true; backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idUpload;                                 enabled: true; backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idWaypointTypes;      visible:    false }
        }
    ]

    Connections {
        target: link

        onConnectionChanged: {
            idDownload.focusState = connected
            idUpload.focusState = connected
        }
    }

    Connections {
        target: MissionService

        onNotifyDownloadSize: {
            if (!size) {
                idRoot.state = idRoot.normalState
            }
        }

        onNotifyDownloadFailed: {
            idRoot.state = idRoot.normalState
        }

        onNotifyDownloadComplete: {
            idRoot.state = idRoot.normalState
        }

        onNotifyUploadSize: {
            if (!size) {
                idRoot.state = idRoot.normalState
            }
        }

        onNotifyUploadFailed: {
            idRoot.state = idRoot.normalState
        }

        onNotifyUploadComplete: {
            idRoot.state = idRoot.normalState
        }

        onTakeoffSelected: {
            idTakeoffEditor.open()
        }

        onWaypointSelected: {
            idWaypointEditor.openBySequence(sequence)
        }

        onLandSelected: {
            idLandEditor.open()
        }
    }

    Connections {
        target: PatternService

        onCornerSelected: {
            if (PatternService.cornerSize() > 3) {
                idPatternCornerEditor.openBySequence(sequence)
            }
        }

        onRenderStarted: {
            idPatternRenderProgress.open()
        }

        onRenderCanceled: {
            idPatternRenderProgress.close()
            idPatternRenderProgress.value = 0
            toast.warn(qsTr('لغو فرآیند تولید ماموریت'), 5000)
        }

        onRenderProgress: {
            idPatternRenderProgress.value = progress
        }

        onRenderCompleted: {
            idPatternRenderProgress.value = 0
            idPatternRenderProgress.close()
            toast.info(qsTr('فرآیند تولید ماموریت کامل شد'), 5000)
        }
    }
}
