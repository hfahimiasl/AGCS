import QtQuick 2.12
import QtQuick.Controls 2.12


Slider {
    id: idRoot
    snapMode: Slider.SnapOnRelease
    from: 0
    to: 1
    stepSize: 0.1
    value: idRoot.from

    property real backgroundHeightScale: 0.2

    background: Rectangle {
        x: idRoot.leftPadding
        y: idRoot.topPadding + (idRoot.availableHeight * 0.5) - (height * 0.5)
        width: idRoot.availableWidth
        height: idRoot.height * idRoot.backgroundHeightScale
        color: '#9b9b9b'

        Rectangle {
            width: idRoot.visualPosition * parent.width
            height: parent.height
            color: '#1fa3f6'
        }
    }

    handle: Rectangle {
        x: idRoot.leftPadding + idRoot.visualPosition * (idRoot.availableWidth - width)
        y: idRoot.topPadding + (idRoot.availableHeight * 0.5) - (height * 0.5)
        width: height
        height: idRoot.height
        radius: height * 0.5
        border.width: 0
        color: idRoot.pressed ? '#f0f0f0' : '#ffffff'
    }
}
