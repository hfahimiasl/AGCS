import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Universal 2.12
import SystemSettings 2.6


Canvas {
    id: idRoot

    property real cx: 0
    property real cy: 0

    scale: 0.5
    implicitWidth: appSetting.width_scale * 400
    implicitHeight: appSetting.height_scale * 400

    onPaint: {
        var context = getContext("2d")

        context.save()
        context.clearRect(0, 0, width, height)

        context.beginPath()
        context.fillStyle = "transparent"
        context.strokeStyle = theme.text
        context.fillRect(0, 0, width, height)
        context.fill()
        context.stroke()

        context.beginPath()
        context.fillStyle = "#white"
        context.strokeStyle = theme.text
        context.rect(10, 10, width - 20, height - 20)
        context.lineWidth = 10
        context.fill()
        context.stroke()

        context.beginPath()
        context.lineWidth = 5
        context.moveTo(60, cy - 30)
        context.strokeStyle = theme.text
        context.lineTo(340, cy - 30)
        context.stroke()

        context.beginPath()
        context.lineWidth = 5
        context.moveTo(60, cy + 30)
        context.strokeStyle = theme.text
        context.lineTo(340, cy + 30)
        context.stroke()

        context.beginPath()
        context.strokeStyle = theme.text
        context.arc(60, cy, 30, 0.5 * Math.PI, 1.5 * Math.PI, false)
        context.stroke()

        context.beginPath()
        context.strokeStyle = theme.text
        context.arc(340, cy, 30, 0.5 * Math.PI, 1.5 * Math.PI, true)
        context.stroke()

        var color = color = theme.primary

        if (cx > width/2+10 || cx < width/2-10 || cy > height/2+10 || cy < height/2-10) {
            color = theme.primaryDark
        }

        context.beginPath()
        context.fillStyle = color
        context.strokeStyle = color
        context.moveTo(cx, cy)
        context.arc(cx, cy, 20, 0, 2 * Math.PI, true)
        context.fill()
        context.stroke()

        context.restore()
    }

    onCxChanged: idRoot.requestPaint()
    onCyChanged: idRoot.requestPaint()

    Connections {
        target: settings
        onNotifyChanges: {
            if (key === SystemSettings.GUITheme) {
                idRoot.requestPaint()
            }
        }
    }
}
