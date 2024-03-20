import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12


MapItemView {
    id: idRoot

    delegate: MapQuickItem {
        anchorPoint.x: width * 0.5
        anchorPoint.y: height * 0.5
        coordinate: model.coordinate

        sourceItem: Canvas {
            width: idDisplay.getScaledWidth(0.025, 0.04) // TODO
            height: width

            readonly property real arcRadius: Math.PI * 0.5

            onPaint: {
                let centreX = width * 0.5
                let centreY = height * 0.5

                let ctx = getContext('2d')
                ctx.reset()

                ctx.beginPath()
                ctx.fillStyle = theme.primary
                ctx.moveTo(centreX, centreY)
                ctx.arc(centreX, centreY, width * 0.5, (Math.PI * 1.5) - (arcRadius * 0.5), (Math.PI * 1.5) + (arcRadius * 0.5), false)
                ctx.lineTo(centreX, centreY)
                ctx.fill()
            }
        }
    }
}
