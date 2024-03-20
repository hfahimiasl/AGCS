import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12


MapItemView {
    id: idRoot

    property bool textVisible: true

    delegate: MapCircle {
        center: centerCoordinate
        radius: centerCoordinate.distanceTo(QtPositioning.coordinate(model.points[1].latitude, model.points[1].longitude))
        opacity: 0.2
        color: model.color
        border.width: 1
        border.color: 'black'

        readonly property var centerCoordinate: QtPositioning.coordinate(model.points[0].latitude, model.points[0].longitude)

        Item {
            anchors.fill: parent

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(3, 6) // TODO
                color: theme.text
                text: model.group + ' ' + model.name
                visible: idRoot.textVisible
            }
        }
    }
}
