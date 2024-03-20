import QtQuick 2.12
import QtLocation 5.12

import '../items'


MapItemView {
    id: idRoot

    property bool drag: false

    delegate: MapLocationItem {
        radius: idDisplay.getScaledWidth(0.0182, 0.045)
        coordinate: model.coordinate
        backgroundColor: theme.backgroundLight
        contentFont: fontAwesome.name
        contentColor: '#00b176'
        contentText: ''
        opacity: idRoot.drag ? 0 : 1

        onPressAndHold: {
            idRoot.drag = true
        }

        onPositionChanged: {
            if (pressed) {
                idRoot.drag = true
                idRoot.updateCoordinate(model.sequence, idMapObject.toCoordinate(Qt.point(x + anchorPoint.x, y + anchorPoint.y)))
            }
        }

        onReleased: {
            idRoot.drag = false
        }

        onClicked: {
            idRoot.drag = false
            PatternService.selectCorner(model.sequence)
        }
    }

    function updateCoordinate(sequence, coordinate) {
        let item = PatternService.getCornerItem(sequence)

        if (coordinate.isValid) {
            item.coordinate.latitude = coordinate.latitude
            item.coordinate.longitude = coordinate.longitude
        }

        PatternService.updateCorner(sequence, item.coordinate)
    }
}
