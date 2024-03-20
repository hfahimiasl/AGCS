import QtQuick 2.12
import QtLocation 5.12

import '../items'


MapLocationItem {
    id: idRoot
    radius: idDisplay.getScaledWidth(0.0182, 0.045)
    coordinate: PatternService.polygonCenter.coordinate
    backgroundColor: theme.backgroundLight
    contentFont: fontAwesome.name
    contentColor: theme.text
    contentText: '\uf065'
    contentScale: 0.75
    editable: true
    opacity: idRoot.drag ? 0 : 1

    property bool drag: false

    onPressAndHold: {
        idRoot.drag = true
    }

    onPositionChanged: {
        if (pressed) {
            idRoot.drag = true
            idRoot.moveTo(idMapObject.toCoordinate(Qt.point(x + anchorPoint.x, y + anchorPoint.y)))
        }
    }

    onReleased: {
        idRoot.drag = false
    }

    function moveTo(coordinate) {
        if (coordinate.isValid) {
            PatternService.moveTo(coordinate)
        }
    }
}
