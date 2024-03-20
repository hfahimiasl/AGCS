import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import SystemSettings 2.6

import "overlays"


Map {
    id: idRoot

    signal clicked(var coordinate)

    property bool drag: false

    property bool airspacePageMainEnabled: false
    property bool airspacePageMissionEnabled: false
    property bool airTrafficPageMainEnabled: false
    property bool airTrafficPageMissionEnabled: false

    readonly property real lineWidth: idDisplay.getFontScale(0.2, 0.45)

    readonly property var region: {
        idRoot.zoomLevel;
        idRoot.center;
        return QtPositioning.rectangle(idRoot.toCoordinate(Qt.point(0, 0)), idRoot.toCoordinate(Qt.point(idRoot.width, idRoot.height)))
    }

    readonly property bool airspaceVisible: {
        if (idMainPage.visible) {
            return idRoot.airspacePageMainEnabled

        } else if (idMissionPage.visible) {
            return idRoot.airspacePageMissionEnabled

        } else {
            return false
        }
    }

    readonly property bool airTrafficVisible: {
        if (idMainPage.visible) {
            return idRoot.airTrafficPageMainEnabled

        } else if (idMissionPage.visible) {
            return idRoot.airTrafficPageMissionEnabled

        } else {
            return false
        }
    }

    activeMapType: supportedMapTypes[parseInt(settings.get(SystemSettings.MapActiveType))]
    gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture | MapGestureArea.FlickGesture
    gesture.flickDeceleration: 3000
    gesture.preventStealing: true
    copyrightsVisible: true

    // https://bugreports.qt.io/browse/QTBUG-82185
    opacity: 0.99

    plugin: Plugin {
        name: "AdlanPaya"
    }

    Behavior on center {
        enabled: true

        CoordinateAnimation {
            duration: idRoot.drag ? 0 : 200
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked : {
            idRoot.clicked(idRoot.toCoordinate(Qt.point(mouse.x, mouse.y)))
        }
    }

    OverlayAirspaceCircleArea {
        model: circle_area_model
        visible: idRoot.airspaceVisible
        textVisible: idRoot.zoomLevel > 5
    }

    OverlayAirspacePolygonArea {
        model: polygon_area_model
        visible: idRoot.airspaceVisible
        textVisible: idRoot.zoomLevel > 5
    }

    OverlayAirspaceAirport {
        model: airport_model
        visible: idRoot.airspaceVisible

        onVisibleChanged: {
            if (visible) {
                airspace_service.request()
            }
        }
    }

    OverlayAirTraffic {
        model: air_traffic_model
        visible: idRoot.airTrafficVisible
    }

    OverlayMissionPath {
        line.width: idRoot.lineWidth
    }

    OverlayAircraftPath {
        id: idAircraftPath
        line.width: idRoot.lineWidth
    }

    OverlayTargetPath {
        id: idTargetPath
        line.width: idRoot.lineWidth
    }

    OverlayHomePoint {
        id: idHomePoint
    }

    // OverlayWaypointGimbalPan {
    //     model: TODO
    // }

    OverlayMissionItem {
        model: MissionItemModel
    }

    OverlayPatternPolygon {
        id: idPatternPolygon
        path: PatternService.polygonPath
        visible: idMissionPage.visible
    }

    OverlayPatternPolyline {
        path: PatternService.polylinePath
        visible: idPatternPolygon.visible
    }

    OverlayPatternNavPoint {
        contentText: '\uf1d8'
        coordinate: PatternService.startPoint.coordinate
        visible: idPatternPolygon.visible && PatternService.startPoint.visible
    }

    OverlayPatternNavPoint {
        contentText: '\uf11e'
        coordinate: PatternService.endPoint.coordinate
        visible: idPatternPolygon.visible && PatternService.endPoint.visible
    }

    OverlayPatternInsertPoint {
        model: PatternInsertPointModel
        visible: idPatternPolygon.visible && !idPatternCorner.drag && !idPatternCenter.drag
    }

    OverlayPatternCorner {
        id: idPatternCorner
        model: PatternCornerModel
        visible: idPatternPolygon.visible && !idPatternCenter.drag
    }

    OverlayPatternCenter {
        id: idPatternCenter
        visible: idPatternPolygon.visible && PatternService.polygonCenter.visible && !idPatternCorner.drag
    }

    OverlayHDOP {
        id: idHDOP
        center: idAircraftIndicator.coordinate
    }

    OverlayAircraftGimbalPan {
        id: idAircraftGimbalPan
        coordinate: idAircraftIndicator.coordinate
        visible: idAircraftIndicator.visible
    }

    OverlayAircraftIndicator {
        id: idAircraftIndicator
    }

    onAirspaceVisibleChanged: {
        if (!idRoot.airspaceVisible) {
            airspace_service.areaClear()
            airspace_service.airportClear()
        }
    }

    onAirTrafficVisibleChanged: {
        if (!idRoot.airTrafficVisible) {
            airspace_service.airTrafficClear()
        }
    }

    gesture.onPanStarted: {
        idRoot.drag = true
        idPatternCorner.drag = false
        idPatternCenter.drag = false
    }

    Component.onCompleted: {
        idRoot.zoomLevel = settings.get(SystemSettings.MapZoomLevel)
        idRoot.center = QtPositioning.coordinate(settings.get(SystemSettings.MapCenterLatitude), settings.get(SystemSettings.MapCenterLongitude))
    }

    Connections {
        target: scheduler

        onSchedule1Hz: {
            if (idRoot.visible && idRoot.width && idRoot.height) {
                settings.set(SystemSettings.MapZoomLevel, idRoot.zoomLevel)
                settings.set(SystemSettings.MapCenterLatitude, idRoot.center.latitude)
                settings.set(SystemSettings.MapCenterLongitude, idRoot.center.longitude)
            }
        }
    }

    Connections {
        target: variable

        onNotifyChanges: {
            if (id === "HOME_POS") {
                const home_coordinate = QtPositioning.coordinate(variable.getValue("HOME_POS_LAT"), variable.getValue("HOME_POS_LON"))

                if (home_coordinate.isValid) {
                    idHomePoint.coordinate = home_coordinate
                }

                idHomePoint.visible = home_coordinate.isValid
            }

            if (id === "GPS_RAW") {
                const aircraft = {}
                aircraft.coordinate = QtPositioning.coordinate(variable.getValue("GPS_RAW_LAT"), variable.getValue("GPS_RAW_LON"))
                aircraft.isValid = aircraft.coordinate.isValid && parseInt(aircraft.coordinate.latitude) !== 0 && parseInt(aircraft.coordinate.longitude) !== 0

                if (aircraft.isValid) {
                    idHDOP.center = aircraft.coordinate
                    idAircraftIndicator.coordinate = aircraft.coordinate
                    idAircraftPath.update(aircraft.coordinate)
                }

                idAircraftIndicator.visible = aircraft.isValid

                const hdop = {
                    radius: variable.getValue("GPS_RAW_EPH"),
                    isValid: !Number.isNaN(this.radius)
                }

                if (hdop.isValid) {
                    idHDOP.radius = hdop.radius
                }

                idHDOP.visible = aircraft.isValid && hdop.isValid

                const is_auto = autopilot.getFlightMode() === "AUTO"

                const target = {}
                target.coordinate = QtPositioning.coordinate(variable.getValue("POSITION_TARGET_LAT"), variable.getValue("POSITION_TARGET_LON"))
                target.isValid = target.coordinate.isValid && parseInt(target.coordinate.latitude) !== 0 && parseInt(target.coordinate.longitude) !== 0

                if (aircraft.isValid && target.isValid) {
                    idTargetPath.update(aircraft.coordinate, target.coordinate)
                }

                idTargetPath.visible = is_auto && aircraft.isValid && target.isValid

                if (!idRoot.drag && aircraft.isValid) {
                    idRoot.center = aircraft.coordinate
                }
            }

            if (id === "AIRCRAFT_HEADING" || id === "MOUNT_YAW") {
                idAircraftIndicator.rotation = variable.getValue("AIRCRAFT_HEADING")
                idAircraftGimbalPan.rotation = idAircraftIndicator.rotation + variable.getValue("MOUNT_YAW")
            }
        }
    }

    Connections {
        target: settings

        onNotifyChanges: {
            if (key === SystemSettings.MapActiveType) {
                idRoot.activeMapType = idRoot.supportedMapTypes[parseInt(settings.get(key))]
            }
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                idAircraftPath.reset()
                idTargetPath.visible = false
                idHomePoint.visible = false
                idHDOP.visible = false
                idAircraftIndicator.visible = false
            }
        }
    }
}
