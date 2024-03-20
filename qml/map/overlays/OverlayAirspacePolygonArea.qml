import QtQuick 2.12
import QtQuick.Controls 2.12
import QtLocation 5.12


MapItemView {
    id: idRoot

    property bool textVisible: true

    delegate: MapPolygon {
        opacity: 0.2
        path: model.points
        color: model.color
        border.width: 1
        border.color: 'black'

        Item {
            anchors.fill: parent

            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(5, 10) // TODO
                font.bold: true
                color: theme.text
                text: model.group + ' ' + model.name
                visible: idRoot.textVisible
            }
        }
    }
}
