import QtQuick 2.12
import SystemSettings 2.6
import SystemUnits 1.0

import '../model'
import '../map'


ModelPagetype {
    id: idRoot

    Rectangle {
        id: idFlightInformationBox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.01)
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.005)
        width: idDisplay.getScaledWidth(0.1, 0.175)
        height: idFlightNavigationBox.height
        color: theme.backgroundDark
        radius: 5

        readonly property int decimals: 2

        Text {
            id: idTittles
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            fontSizeMode: Text.Fit
            color: theme.text
            font.bold: true
            font.family: font_fa_medium.name
            font.pixelSize: idDisplay.getFontScale(1.1, 2.2)
            text: qsTr('اطلاعات پرواز')
        }

        ListView {
            id: list
            width: parent.width
            anchors.top: idTittles.bottom
            anchors.bottom: parent.bottom
            anchors.topMargin: parent.height * 0.075
            clip: true

            model: ListModel {
                id: idFlightInformationList

                ListElement {
                    name: 'ارتفاع'
                    value: '0.00'
                    unit: 'm'
                }

                ListElement {
                    name: 'فاصله تا پهپاد'
                    value: '0.00'
                    unit: 'm'
                }

                ListElement {
                    name: 'سرعت عمودی'
                    value: '0.00'
                    unit: 'm/s'
                }

                ListElement {
                    name: 'سرعت افقی'
                    value: '0.00'
                    unit: 'm/s'
                }

                ListElement {
                    name: 'زمان پرواز'
                    value: '00:00:00'
                    unit: ''
                }

                ListElement {
                    name: 'ولتاژ باتری'
                    value: '0.00'
                    unit: 'V'
                }
            }

            delegate: Rectangle {
                width: parent.width
                height: idInformationName.implicitHeight * (idDisplay.isLargeDisplay ? 1.3 : 1.4)
                color: 'transparent'

                Text {
                    id: idInformationName
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font.family: font_fa_medium.name
                    font.pixelSize: idDisplay.getFontScale(1, 1.75)
                    text: name
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font.family: font_fa_medium.name
                    font.pixelSize: idInformationName.font.pixelSize
                    text: value + ' ' + unit
                }
            }
        }
    }

    Rectangle {
        id: idFlightNavigationBox
        anchors.top: idFlightInformationBox.top
        anchors.left: idFlightInformationBox.right
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.005)
        width: idDisplay.getScaledWidth(0.06, 0.11125)
        height: idDisplay.getScaledHeight(0.2125, 0.475)
        color: theme.backgroundDark
        radius: width / 2

        Rectangle {
            id: idAttitudeIndicator
            anchors.top: idFlightNavigationBox.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: (parent.width - width) / 2
            width: idFlightNavigationBox.width * 0.9
            height: width
            radius: width
            color: theme.blue

            Canvas {
                id: idAttitudeCanvas
                scale: idAttitudeIndicator.radius / 155
                anchors.centerIn: idAttitudeIndicator
                implicitWidth: 150
                implicitHeight: 150

                property double roll: 0
                property double pitch: 0
                property double pitchScale: 20

                function sign(x) {
                    return x > 0 ? 1 : -1
                }

                onPaint: {
                    let ctx = getContext('2d')
                    ctx.save()
                    ctx.clearRect(0, 0, width, height)
                    let ovlpitch = pitch //wrap360
                    let w2 = width / 2
                    let h2 = height / 2
                    let scpitch = ovlpitch

                    if (scpitch > 150) {
                        scpitch -= 180
                    }

                    if (scpitch < -150) {
                        scpitch += 180
                    }

                    let h = -scpitch / pitchScale * h2

                    ctx.translate(w2, h2)
                    ctx.rotate(roll * Math.PI / 180)
                    ctx.beginPath()
                    ctx.arc(0, 0, h2, 0, 2 * Math.PI)
                    ctx.closePath()
                    ctx.clip()

                    if (scpitch > pitchScale || scpitch < -pitchScale) {
                        ctx.beginPath()
                        ctx.arc(0, 0, h2, 0, 2 * Math.PI)
                        ctx.fillStyle = ovlpitch > pitchScale ? '#4F7DC2' : '#62982C'
                        ctx.fill()

                    } else {
                        let alpha = Math.asin(h / h2)
                        ctx.beginPath()
                        ctx.arc(0, 0, h2, -Math.PI + alpha, -alpha)
                        ctx.fillStyle = (ovlpitch > 150 || ovlpitch < -150) ? '#62982C' : '#4F7DC2'
                        ctx.fill()
                        ctx.beginPath()
                        ctx.arc(0, 0, h2, -alpha, -Math.PI + alpha)
                        ctx.fillStyle = (ovlpitch > 150 || ovlpitch < -150) ? '#4F7DC2' : '#62982C'
                        ctx.fill()
                        ctx.beginPath()
                        ctx.moveTo(-h2 * Math.cos(alpha), -h); ctx.lineTo(h2 * Math.cos(alpha), -h)
                        ctx.strokeStyle = 'white'
                        ctx.stroke()
                    }

                    ctx.beginPath()
                    ctx.lineWidth = 4

                    for (let i=180 ; i<=360 ; i+=15) {
                        if (i === 180 || i === 210|| i === 240 || i === 270 || i === 300 || i === 330 || i === 360) {
                            ctx.moveTo(Math.cos(i * Math.PI / 180) * width * 0.45 , Math.sin(i * Math.PI / 180) * height * 0.45)
                            ctx.lineTo(Math.cos(i * Math.PI / 180) * width, Math.sin(i * Math.PI / 180) * height)

                        } else if (i === 225 || i === 315) {
                            ctx.lineWidth = 1
                            ctx.moveTo(Math.cos(i * Math.PI / 180) * width * 0.45, Math.sin(i * Math.PI / 180) * height * 0.45)
                            ctx.lineTo(Math.cos(i * Math.PI / 180) * width, Math.sin(i * Math.PI / 180) * height)
                        }
                    }

                    ctx.moveTo(0 , height * -0.43);
                    ctx.lineTo(width * -0.04 , height * -0.48)
                    ctx.lineTo(width * 0.04 , height * -0.48)
                    ctx.stroke()
                    ctx.fillStyle = 'white'
                    ctx.fill()
                    ctx.closePath()
                    ctx.strokeStyle = 'white'
                    ctx.fillStyle = 'white'
                    ctx.beginPath()
                    ctx.arc(0, 0, h2 * 0.8, 0, Math.PI * 2)
                    ctx.closePath()
                    ctx.clip()
                    ctx.lineWidth = 2
                    drawPitchMarks(ctx, h2 / pitchScale, h2, ovlpitch)
                    ctx.restore()
                    ctx.translate(w2, h2)
                    ctx.beginPath()
                    ctx.moveTo(width * -0.36 , 0);
                    ctx.lineTo(width * -0.12 , 0)
                    ctx.moveTo(width * 0.36 , 0);
                    ctx.lineTo(width * 0.12 , 0)
                    ctx.moveTo(width * 0.12 + 2 , 0);
                    ctx.lineTo(width * 0.12 + 2 , height * 0.1)
                    ctx.moveTo(width * -0.12 - 2 , 0);
                    ctx.lineTo(width * -0.12 - 2 , height * 0.1)
                    ctx.moveTo(width * -0.03, height * -0.02);
                    ctx.lineTo(width * 0.025, height * -0.02)
                    ctx.lineTo(width * 0.025, height * 0.02)
                    ctx.lineTo(width * -0.03, height * 0.02)
                    ctx.lineWidth = 4
                    ctx.strokeStyle = 'yellow'
                    ctx.fillStyle = 'yellow'
                    ctx.fill()
                    ctx.stroke()
                    ctx.lineWidth = 2
                    ctx.moveTo(0 , height * -0.41);
                    ctx.lineTo(width * -0.04 , height * -0.36)
                    ctx.lineTo(width * 0.04 , height * -0.36)
                    ctx.lineTo(0, height * -0.41)
                    ctx.strokeStyle = 'yellow'
                    ctx.stroke()
                    ctx.resetTransform()
                    ctx.restore()
                }

                function drawPitchMarks(ctx, pxPerDegree, radius, ovlpitch) {
                    let dp = ovlpitch + pitchScale
                    let pmax = Math.ceil(dp / 2.5) * 2.5
                    let ymax = ovlpitch * pxPerDegree - pmax * pxPerDegree

                    for (let y = ymax, p = pmax ; y < radius ; y += 2.5 * pxPerDegree, p -= 2.5) {
                        if (p === 180 || p === 0 || p === -180) {
                            continue
                        }

                        ctx.beginPath()
                        ctx.moveTo(-10, y)
                        ctx.lineTo(10, y)
                        ctx.stroke()

                        let pp = p

                        if (pp > 180) {
                            pp -= 360
                        }

                        if (pp < -180) {
                            pp += 360
                        }

                        if (pp % 10 == 0) {
                            ctx.fillText(pp, 15, y)
                        }
                    }
                }

                onRollChanged: idAttitudeCanvas.requestPaint()
                onPitchChanged: idAttitudeCanvas.requestPaint()
            }
        }

        Rectangle {
            id: idHeadingIndicator
            anchors.bottom: idFlightNavigationBox.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: (parent.width - width) / 2
            width: idAttitudeIndicator.width
            height: idAttitudeIndicator.height
            radius: idAttitudeIndicator.radius
            color: theme.blue

            Canvas {
                id: idHeadingCanvas
                scale: idAttitudeCanvas.scale
                anchors.centerIn: idHeadingIndicator
                implicitWidth: 150
                implicitHeight: 150

                property double yaw: 0

                Image {
                    id: idHeadingImage
                    anchors.centerIn: parent
                    height: 90
                    width: 90
                }

                Text {
                    id: idNorthNavigationArrowLabel
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: parent.height * 0.04
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width / 15
                    height: width
                    color: theme.text
                    font.family: fontAwesome.name
                    font.pixelSize: idDisplay.getFontScale(1.5, 3)
                    text: '\uf0de'
                }

                Text {
                    id: idNorthText
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: parent.height * 0.1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width / 15
                    height: width
                    color: theme.text
                    font.family: font_fa_medium.name
                    font.pixelSize: idDisplay.getFontScale(1.25, 2.5)
                    text: 'N'
                    transform: Rotation {
                        origin.x: 5
                        origin.y: idHeadingCanvas.height / 2 - idHeadingCanvas.height * 0.1
                        angle: -idHeadingCanvas.yaw
                    }
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: parent.height * 0.1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: idNorthText.width
                    height: idNorthText.height
                    color: idNorthText.color
                    font.family: idNorthText.font.family
                    font.pixelSize: idNorthText.font.pixelSize
                    text: 'S'
                    transform: Rotation {
                        origin.x: 5
                        origin.y: -idHeadingCanvas.height / 2 + idHeadingCanvas.height * 0.18
                        angle: -idHeadingCanvas.yaw
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: parent.height * 0.1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: idNorthText.width
                    height: idNorthText.height
                    color: idNorthText.color
                    font.family: idNorthText.font.family
                    font.pixelSize: idNorthText.font.pixelSize
                    text: 'E'
                    transform: Rotation {
                        origin.x: -idHeadingCanvas.height / 2 + idHeadingCanvas.height * 0.1 + 10
                        origin.y: 5
                        angle: -idHeadingCanvas.yaw
                    }
                }

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: parent.height * 0.1
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    width: idNorthText.width
                    height: idNorthText.height
                    color: idNorthText.color
                    font.family: idNorthText.font.family
                    font.pixelSize: idNorthText.font.pixelSize
                    text: 'W'
                    transform: Rotation {
                        origin.x: idHeadingCanvas.height / 2 - idHeadingCanvas.height * 0.1
                        origin.y: 5
                        angle: -idHeadingCanvas.yaw
                    }
                }

                onPaint: {
                    let ctx = getContext('2d')
                    ctx.save()
                    ctx.clearRect(0, 0, width, height)
                    let ovlpitch = 0
                    let w2 = width / 2
                    let h2 = height / 2
                    let scpitch = ovlpitch

                    if (scpitch > 150) {
                        scpitch -= 180
                    }

                    if (scpitch < -150) {
                        scpitch += 180
                    }

                    ctx.translate(w2, h2)
                    ctx.rotate(-yaw * Math.PI / 180)
                    ctx.beginPath()
                    ctx.arc(0, 0, h2, 0, Math.PI * 2)
                    ctx.fillStyle = theme.backgroundDark
                    ctx.fill()
                    ctx.beginPath()
                    ctx.arc(0, 0, h2, 0, Math.PI * 2)
                    ctx.clip()

                    for(let i=0 ; i<=360 ; i+=15) {
                        ctx.moveTo(Math.cos(i * Math.PI / 180) * width * 0.45, Math.sin(i * Math.PI / 180) * height * 0.45)
                        ctx.lineTo(Math.cos(i * Math.PI / 180) * width, Math.sin(i * Math.PI / 180) * height)
                    }

                    ctx.moveTo(0, height * -0.42)
                    ctx.lineTo(0, -height)
                    ctx.moveTo(0, height * 0.42)
                    ctx.lineTo(0, height)
                    ctx.moveTo(width * 0.42 ,0)
                    ctx.lineTo(width, 0)
                    ctx.moveTo(width * -0.42 ,0)
                    ctx.lineTo(-width, 0)
                    ctx.strokeStyle = theme.text
                    ctx.stroke()
                    ctx.restore()
                }

                onYawChanged: idHeadingCanvas.requestPaint()
            }
        }
    }

    Connections {
        target: variable

        onNotifyChanges: {
            if (id.indexOf('ATTITUDE') !== -1) {
                idAttitudeCanvas.roll = variable.getValue('ATTITUDE_ROLL') * -57.2958
                idAttitudeCanvas.pitch = variable.getValue('ATTITUDE_PITCH') * 57.2958

            } else if (id === 'AIRCRAFT_HEADING') {
                idHeadingCanvas.yaw = variable.getValue(id)

            } else if (id.indexOf('GLOBAL_POSITION_INT') !== -1) {
                idFlightInformationList.set(0, { value : units.convert(SystemUnits.Distance, SystemUnits.MilliMeter, variable.getValue('GLOBAL_POSITION_INT_RELATIVE_ALT')).toFixed(idFlightInformationBox.decimals) })

            } else if (id === 'AIRCRAFT_3D_DISTANCE') {
                idFlightInformationList.set(1, { value : units.convert(SystemUnits.Distance, SystemUnits.Meter, variable.getValue(id)).toFixed(idFlightInformationBox.decimals) })

            } else if (id === 'AIRCRAFT_VERTICAL_SPEED') {
                idFlightInformationList.set(2, { value : units.convert(SystemUnits.Speed, SystemUnits.Mps, variable.getValue(id)).toFixed(idFlightInformationBox.decimals) })

            } else if (id === 'AIRCRAFT_HORIZONTAL_SPEED') {
                idFlightInformationList.set(3, { value : units.convert(SystemUnits.Speed, SystemUnits.Mps, variable.getValue(id)).toFixed(idFlightInformationBox.decimals) })

            } else if (id === 'FLIGHT_TIME') {
                idFlightInformationList.set(4, { value : variable.getText(id) })

            } else if (id.indexOf('BATTERY1_VOLTAGE') !== -1) {
                const voltage = variable.getValue(id)
                idFlightInformationList.set(5, { value : isNaN(voltage) ? "N/A" : units.convert(SystemUnits.Voltage, SystemUnits.Volt, voltage).toFixed(idFlightInformationBox.decimals) })
            }
        }
    }

    Connections {
        target: units

        onNotifyChanges: {
            switch (quantity) {
            case SystemUnits.Distance:
                idFlightInformationList.set(0, { unit: units.getSymbol(quantity) })
                idFlightInformationList.set(1, { unit: units.getSymbol(quantity) })
                break

            case SystemUnits.Speed:
                idFlightInformationList.set(2, { unit: units.getSymbol(quantity) })
                idFlightInformationList.set(3, { unit: units.getSymbol(quantity) })
                break

            case SystemUnits.Voltage:
                idFlightInformationList.set(5, { unit: units.getSymbol(quantity) })
                break
            }
        }
    }

    Connections {
        target: settings

        onNotifyChanges: {
            if (key === SystemSettings.GUITheme) {
                idHeadingImage.source = String(settings.get(key)) === 'DARK' ? 'qrc:/images/aircraft/general.svg' : 'qrc:/images/map/unknown_mark.svg'
                idHeadingCanvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
        idHeadingImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/aircraft/general.svg' : 'qrc:/images/map/unknown_mark.svg'
        idFlightInformationList.set(0, { unit: units.getSymbol(SystemUnits.Distance) })
        idFlightInformationList.set(1, { unit: units.getSymbol(SystemUnits.Distance) })
        idFlightInformationList.set(2, { unit: units.getSymbol(SystemUnits.Speed) })
        idFlightInformationList.set(3, { unit: units.getSymbol(SystemUnits.Speed) })
        idFlightInformationList.set(5, { unit: units.getSymbol(SystemUnits.Voltage) })
    }
}
