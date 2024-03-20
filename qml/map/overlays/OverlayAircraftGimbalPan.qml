import QtQuick 2.12
import QtLocation 5.12


MapQuickItem {
    anchorPoint.x: width * 0.5
    anchorPoint.y: height * 0.5

    sourceItem: Canvas {
        width: idDisplay.getScaledWidth(0.125, 0.2)
        height: width

        readonly property real arcRadius: Math.PI * 0.225

        onPaint: {
            let centreX = width * 0.5
            let centreY = height * 0.5

            let ctx = getContext('2d')
            ctx.reset()

            let gradient = ctx.createLinearGradient(centreX, centreY, centreX, y)
            gradient.addColorStop(0.25, theme.primary)
            gradient.addColorStop(1, 'transparent')

            ctx.beginPath()
            ctx.fillStyle = gradient
            ctx.moveTo(centreX, centreY)
            ctx.arc(centreX, centreY, width * 0.5, (Math.PI * 1.5) - (arcRadius * 0.5), (Math.PI * 1.5) + (arcRadius * 0.5), false)
            ctx.lineTo(centreX, centreY)
            ctx.fill()
        }
    }
}
