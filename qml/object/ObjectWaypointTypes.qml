import QtQuick 2.12
import QtPositioning 5.12


Item {
    id: idRoot
    width: idGrid.implicitWidth + idGrid.spacing
    height: idGrid.implicitHeight + idGrid.spacing
    state: idRoot.stateNormal

    readonly property string stateNormal: 'NORMAL'
    readonly property string stateTakeoff: 'TAKEOFF'
    readonly property string stateWaypoint: 'WAYPOINT'
    readonly property string stateLand: 'LAND'
    readonly property string stateRTL: 'RTL'

    readonly property color orgBackgroundColor: theme.backgroundDark
    readonly property color orgContentColor: theme.text

    readonly property color selBackgroundColor: theme.primary
    readonly property color selContentColor: theme.backgroundDark

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: idBackground
        anchors.fill: parent
        radius: idTakeoff.width * 0.5
        opacity: 0.25
        color: theme.backgroundLight
    }

    Grid {
        id: idGrid
        anchors.centerIn: parent
        columns: idDisplay.isLargeDisplay ? 1 : 4
        spacing: idDisplay.isLargeDisplay ? idDisplay.getScaledHeight(0.015, 0.015) : idDisplay.getScaledWidth(0.0125, 0.0125)

        ObjectCircleItem {
            id: idTakeoff
            radius: idDisplay.getScaledWidth(0.025, 0.06)
            backgroundColor: idRoot.orgBackgroundColor
            contentFont: fontAwesome.name
            contentColor: idRoot.orgContentColor
            contentText: '\uf062'
            focusState: enabled
            enabled: !MissionService.takeoffExist

            onClicked: {
                idRoot.state = idRoot.stateTakeoff
            }
        }

        ObjectCircleItem {
            id: idWaypoint
            radius: idTakeoff.radius
            backgroundColor: idRoot.orgBackgroundColor
            contentFont: idTakeoff.contentFont
            contentColor: idRoot.orgContentColor
            contentText: '\uf3c5'
            focusState: enabled
            enabled: MissionService.takeoffExist && !MissionService.landExist && !MissionService.rtlExist

            onClicked: {
                idRoot.state = idRoot.stateWaypoint
            }
        }

        ObjectCircleItem {
            id: idLand
            radius: idTakeoff.radius
            backgroundColor: idRoot.orgBackgroundColor
            contentFont: idTakeoff.contentFont
            contentColor: idRoot.orgContentColor
            contentText: '\uf063'
            focusState: enabled
            enabled: MissionService.takeoffExist && !MissionService.landExist && !MissionService.rtlExist

            onClicked: {
                idRoot.state = idRoot.stateLand
            }
        }

        ObjectCircleItem {
            id: idRTL
            radius: idTakeoff.radius
            backgroundColor: idRoot.orgBackgroundColor
            contentFont: idTakeoff.contentFont
            contentColor: idRoot.orgContentColor
            contentText: '\uf01e'
            focusState: enabled
            enabled: MissionService.takeoffExist && !MissionService.landExist

            onClicked: {
                if (MissionService.isRTLExist()) {
                    MissionService.removeRTL()
                    idRoot.state = idRoot.stateNormal

                } else {
                    MissionService.appendRTL()
                    idRoot.state = idRoot.stateRTL
                }
            }
        }
    }

    Connections {
        target: idMapObject

        onClicked: {
            if (!idRoot.visible) {
                return
            }

            if (idRoot.state === idRoot.stateTakeoff) {
                let takeoff_item = MissionService.getRawTakeoff()
                takeoff_item.coordinate = QtPositioning.coordinate(coordinate.latitude, coordinate.longitude, 30)
                MissionService.appendTakeoff(takeoff_item)
                idRoot.state = idRoot.stateWaypoint

            } else if (idRoot.state === idRoot.stateWaypoint) {
                let waypoint_item = MissionService.getRawWaypoint()
                waypoint_item.coordinate = QtPositioning.coordinate(coordinate.latitude, coordinate.longitude, 30)
                waypoint_item.hoverTime = 0
                waypoint_item.speed = 5
                waypoint_item.relayActive = false
                waypoint_item.relayStatus = false
                waypoint_item.servoActive = false
                waypoint_item.gimbalActive = false
                waypoint_item.cameraTriggerActive = false
                MissionService.appendWaypoint(waypoint_item)

            } else if (idRoot.state === idRoot.stateLand) {
                let land_item = MissionService.getRawLand()
                land_item.coordinate = QtPositioning.coordinate(coordinate.latitude, coordinate.longitude)
                MissionService.appendLand(land_item)
                idRoot.state = idRoot.stateNormal
            }
        }
    }

    states: [
        State {
            name: idRoot.stateNormal
            PropertyChanges { target: idTakeoff;    backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypoint;   backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idLand;       backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idRTL;        backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
        },
        State {
            name: idRoot.stateTakeoff
            PropertyChanges { target: idTakeoff;    backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idWaypoint;   backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idLand;       backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idRTL;        backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
        },
        State {
            name: idRoot.stateWaypoint
            PropertyChanges { target: idTakeoff;    backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypoint;   backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idLand;       backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idRTL;        backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
        },
        State {
            name: idRoot.stateLand
            PropertyChanges { target: idTakeoff;    backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypoint;   backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idLand;       backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
            PropertyChanges { target: idRTL;        backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
        },
        State {
            name: idRoot.stateRTL
            PropertyChanges { target: idTakeoff;    backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idWaypoint;   backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idLand;       backgroundColor: idRoot.orgBackgroundColor; contentColor: idRoot.orgContentColor }
            PropertyChanges { target: idRTL;        backgroundColor: idRoot.selBackgroundColor; contentColor: idRoot.selContentColor }
        }
    ]

    onVisibleChanged: {
        if (MissionService.isRTLExist()) {
            idRoot.state = idRoot.stateRTL

        } else {
            idRoot.state = idRoot.stateNormal
        }
    }
}
