import QtQuick 2.12
import QtLocation 5.12

import '../items'


MapItemView {
    id: idRoot

    delegate: MapLocationItem {
        radius: idDisplay.getScaledWidth(0.012, 0.0325)
        coordinate: model.coordinate
        backgroundColor: theme.backgroundLight
        contentFont: fontAwesome.name
        contentColor: theme.text
        contentText: '\uf067'
        contentScale: 0.5
        editable: false

        onClicked: {
            idRoot.insert(model.sequence + 1, model.coordinate)
        }
    }

    function insert(index, coordinate) {
        PatternService.insertCorner(index, coordinate)
    }
}
