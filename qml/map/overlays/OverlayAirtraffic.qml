import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12


MapItemView {
    id: idRoot

    delegate: MapQuickItem {
        width: 30
        height: width
        anchorPoint.x: width * 0.5
        anchorPoint.y: height * 0.5
        coordinate: QtPositioning.coordinate(model.latitude, model.longitude)
        rotation: model.heading - 90

        sourceItem: Item {
            anchors.fill: parent

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: fontAwesome.name
                font.pixelSize: idDisplay.getFontScale(2.5, 5)
                color: theme.yellow
                text: '\uf072'
            }
        }
    }
}

// blue '#03f9f9'
// green '#61f312'
