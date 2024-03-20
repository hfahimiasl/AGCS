import QtQuick 2.12
import QtLocation 5.12

import '../items'


MapItemView {
    id: idRoot

    delegate: MapLocationItem {
        radius: idDisplay.getScaledWidth(0.0182, 0.045)
        coordinate: model.coordinate
        visible: model.visible
        backgroundColor: theme.backgroundLight
        contentFont: model.unicodeLabel ? fontAwesome.name : font_fa_medium.name
        contentColor: '#00b176'
        contentText: model.label
        contentScale: 0.7
        editable: idMissionPage.editable

        onPositionChanged: {
            if (pressed) {
                idRoot.updateCoordinate(model.sequence, idMapObject.toCoordinate(Qt.point(x + anchorPoint.x, y + anchorPoint.y)))
            }
        }

        onClicked: {
            if (editable) {
                MissionService.select(model.sequence)
            }

            if (idMainPage.visible)  {
                questions.clear()
                questions.add(('از حرکت به نقطه ') + model.sequence + (' مطمئن هستید؟'), 'change_current_wp_' + model.sequence)
            }
        }
    }

    function updateCoordinate(sequence, coordinate) {
        let item = MissionService.get(sequence)

        if (coordinate.isValid) {
            item.coordinate.latitude = coordinate.latitude
            item.coordinate.longitude = coordinate.longitude
        }

        MissionService.insert(item)
    }
}
