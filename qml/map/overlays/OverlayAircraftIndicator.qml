import QtQuick 2.12
import QtLocation 5.12


MapQuickItem {
    anchorPoint.x: width * 0.5
    anchorPoint.y: height * 0.5

    sourceItem: Image {
        width: idDisplay.getScaledWidth(0.07, 0.15)
        height: width
        source: 'qrc:/images/aircraft/general.svg'
    }
}
