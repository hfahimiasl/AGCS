import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelPopup {
    id: idRoot
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    readonly property real originalHeight: idRoot.topPadding * 2
                                           + idWaypointText.implicitHeight
                                           + idFlickable.contentHeight
                                           + idButtons.height
                                           + idRoot.bottomPadding * 2

    property var waypointItem: undefined
    property int sequence: -1

    Text {
        id: idWaypointText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_black.name
        font.bold: true
        font.pixelSize: idRoot.fontPixelSize
        text: qsTr(('نقطه حرکت #%1').arg(idRoot.sequence))
    }

    Flickable {
        id: idFlickable
        anchors.top: idWaypointText.bottom
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding
        anchors.bottomMargin: idColumn.spacing * 0.5
        contentWidth: idColumn.width
        contentHeight: idColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            parent: idFlickable.parent
            anchors.top: idFlickable.top
            anchors.bottom: idFlickable.bottom
            anchors.left: idFlickable.right
            policy: idDisplay.isLargeDisplay ? ScrollBar.AsNeeded : ScrollBar.AlwaysOn
        }

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: idDisplay.getScaledHeight(0.014, 0.025)

            Item {
                id: idAltitudeItem
                width: idFlickable.width
                height: idDisplay.getScaledWidth(0.0125, 0.03)

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    text: ('%1 %2  %3').arg(idAltitudeSlider.value.toFixed(1)).arg('m').arg(qsTr('ارتفاع'))
                }

                ModelSlider {
                    id: idAltitudeSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.6
                    height: parent.height
                    from: 0.5
                    to: 200
                    stepSize: 0.1
                }
            }

            Item {
                width: idAltitudeItem.width
                height: idAltitudeItem.height

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    text: ('%1 %2  %3').arg(idSpeedSlider.value.toFixed(1)).arg('m/s').arg(qsTr('سرعت'))
                }

                ModelSlider {
                    id: idSpeedSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAltitudeSlider.width
                    height: idAltitudeSlider.height
                    from: 0.1
                    to: 20
                    stepSize: 0.1
                }
            }

            Item {
                width: idAltitudeItem.width
                height: idAltitudeItem.height

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    text: ('%1 %2  %3').arg(idHoverTimeSlider.value.toFixed(0)).arg('s').arg(qsTr('توقف'))
                }

                ModelSlider {
                    id: idHoverTimeSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAltitudeSlider.width
                    height: idAltitudeSlider.height
                    from: 0
                    to: 60
                    stepSize: 1
                }
            }

            ModelCart {
                id: idRelayModelCart
                tittle: qsTr('رله')
                width: idAltitudeItem.width
                height: idDisplay.getScaledHeight(0.1, 0.26)
                color: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize

                ModelSwitch {
                    id: idRelayActiveSwitch
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: idRelayModelCart.topPadding * -0.75
                    width: height * 1.75
                    height: parent.height * 0.25

                    onStateChanged: {
                        if (state === 'ON') {
                            idRelayRectangle.opacity = 1
                            idRelayIDSpinBox.editable = true
                            idRelayStatusSwitch.enabled = true

                        } else {
                            idRelayRectangle.opacity = 0.5
                            idRelayIDSpinBox.editable = false
                            idRelayStatusSwitch.enabled = false
                        }
                    }
                }

                Rectangle {
                    id: idRelayRectangle
                    anchors.fill: parent
                    anchors.topMargin: idRelayModelCart.itemVerticalMargin
                    color: 'transparent'

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idRelayRectangle.width
                            height: idRelayIDText.height * 1.5

                            Text {
                                id: idRelayIDText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idRelayModelCart.font
                                text: qsTr('خروجی')
                            }

                            ModelSpinBox {
                                id: idRelayIDSpinBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: idRelayIDText.implicitWidth * 1.5
                                height: idRelayIDText.implicitHeight * 1.4
                                font: idRelayIDText.font
                                realFrom: 1
                                realTo: 99
                                realValue: realFrom
                                realStepSize: 1
                                decimals: 0
                                backgroundColor: 'transparent'

                                onRealValueChanged: {
                                    if (!editable) {
                                        idRelayIDSpinBox.set(realFrom)
                                    }
                                }
                            }
                        }

                        Item {
                            width: idRelayRectangle.width
                            height: idRelayStatusText.height * 1.5

                            Text {
                                id: idRelayStatusText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idRelayModelCart.font
                                text: qsTr('وضعیت')
                            }

                            ModelSwitch {
                                id: idRelayStatusSwitch
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: idRelayActiveSwitch.width
                                height: idRelayActiveSwitch.height
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idServoModelCart
                tittle: qsTr('سروو')
                width: idAltitudeItem.width
                height: idDisplay.getScaledHeight(0.1, 0.26)
                color: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize

                ModelSwitch {
                    id: idServoActiveSwitch
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: idServoModelCart.topPadding * -0.75
                    width: height * 1.75
                    height: parent.height * 0.25

                    onStateChanged: {
                        if (state === 'ON') {
                            idServoRectangle.opacity = 1
                            idServoIDSpinBox.editable = true
                            idServoSlider.enabled = true

                        } else {
                            idServoRectangle.opacity = 0.5
                            idServoIDSpinBox.editable = false
                            idServoSlider.enabled = false
                        }
                    }
                }

                Rectangle {
                    id: idServoRectangle
                    anchors.fill: parent
                    anchors.topMargin: idServoModelCart.itemVerticalMargin
                    color: 'transparent'

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idServoRectangle.width
                            height: idServoIDText.height * 1.5

                            Text {
                                id: idServoIDText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idServoModelCart.font
                                text: qsTr('خروجی')
                            }

                            ModelSpinBox {
                                id: idServoIDSpinBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: idServoIDText.implicitWidth * 1.5
                                height: idServoIDText.implicitHeight * 1.4
                                font: idServoIDText.font
                                realFrom: 1
                                realTo: 99
                                realValue: realFrom
                                realStepSize: 1
                                decimals: 0
                                backgroundColor: 'transparent'

                                onRealValueChanged: {
                                    if (!editable) {
                                        idServoIDSpinBox.set(realFrom)
                                    }
                                }
                            }
                        }

                        Item {
                            width: idServoRectangle.width
                            height: idServoStatusText.height * 1.5

                            Text {
                                id: idServoStatusText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idServoModelCart.font
                                text: ('%2  %1').arg(idServoSlider.value.toFixed(0)).arg(qsTr('مقدار'))
                            }

                            ModelSlider {
                                id: idServoSlider
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: idAltitudeSlider.height
                                from: 800
                                to: 2200
                                stepSize: 1
                                value: 1500
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idGimbalModelCart
                tittle: qsTr('گیمبال')
                width: idAltitudeItem.width
                height: idDisplay.getScaledHeight(0.1, 0.26)
                color: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize

                ModelSwitch {
                    id: idGimbalActiveSwitch
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: idGimbalModelCart.topPadding * -0.75
                    width: height * 1.75
                    height: parent.height * 0.25

                    onStateChanged: {
                        if (state === 'ON') {
                            idGimbalRectangle.opacity = 1
                            idGimbalTiltSlider.enabled = true
                            idGimbalPanSlider.enabled = true

                        } else {
                            idGimbalRectangle.opacity = 0.5
                            idGimbalTiltSlider.enabled = false
                            idGimbalPanSlider.enabled = false
                        }
                    }
                }

                Rectangle {
                    id: idGimbalRectangle
                    anchors.fill: parent
                    anchors.topMargin: idGimbalModelCart.itemVerticalMargin
                    color: 'transparent'

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idGimbalRectangle.width
                            height: idGimbalTiltText.height * 1.5

                            Text {
                                id: idGimbalTiltText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idGimbalModelCart.font
                                text: ('%2  %1%3')
                                .arg(Math.abs(idGimbalTiltSlider.value).toFixed(1))
                                .arg(qsTr('تیلت'))
                                .arg(idGimbalTiltSlider.value > 0.01 ? '+' : (idGimbalTiltSlider.value < -0.01 ? '-' : ''))
                            }

                            ModelSlider {
                                id: idGimbalTiltSlider
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: idAltitudeSlider.height
                                from: -90
                                to: 90
                                stepSize: 0.1
                                value: 0
                            }
                        }

                        Item {
                            width: idGimbalRectangle.width
                            height: idGimbalPanText.height * 1.5

                            Text {
                                id: idGimbalPanText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idGimbalModelCart.font
                                text: ('%2  %1%3')
                                .arg(Math.abs(idGimbalPanSlider.value).toFixed(1))
                                .arg(qsTr('پن'))
                                .arg(idGimbalPanSlider.value > 0.01 ? '+' : (idGimbalPanSlider.value < -0.01 ? '-' : ''))
                            }

                            ModelSlider {
                                id: idGimbalPanSlider
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: idAltitudeSlider.height
                                from: -90
                                to: 90
                                stepSize: 0.1
                                value: 0
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idCameraTriggerModelCart
                tittle: qsTr('شاتر')
                width: idAltitudeItem.width
                height: idDisplay.getScaledHeight(0.13, 0.35)
                color: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize

                ModelSwitch {
                    id: idCameraTriggerActiveSwitch
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: idCameraTriggerModelCart.topPadding * -0.75
                    width: height * 1.75
                    height: idGimbalActiveSwitch.height
                }

                Item {
                    id: idCameraTriggerItem
                    anchors.fill: parent
                    anchors.topMargin: idCameraTriggerModelCart.itemVerticalMargin

                    Column {
                        anchors.centerIn: parent

                        Item {
                            id: idCameraTriggerStatusItem
                            width: idCameraTriggerItem.width
                            height: idCameraTriggerStatusText.height * 1.5
                            enabled: idCameraTriggerActiveSwitch.state === 'ON'
                            opacity: enabled ? 1 : 0.5

                            Text {
                                id: idCameraTriggerStatusText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idCameraTriggerModelCart.font
                                text: qsTr('وضعیت')
                            }

                            ModelSwitch {
                                id: idCameraTriggerStatusSwitch
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: idCameraTriggerActiveSwitch.width
                                height: idCameraTriggerActiveSwitch.height
                            }
                        }

                        Item {
                            id: idCameraTriggerOnceItem
                            width: idCameraTriggerItem.width
                            height: idCameraTriggerOnceText.height * 1.5
                            enabled: idCameraTriggerStatusItem.enabled && idCameraTriggerStatusSwitch.state === 'ON'
                            opacity: enabled ? 1 : 0.5

                            Text {
                                id: idCameraTriggerOnceText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idCameraTriggerModelCart.font
                                text: qsTr('یک بار')
                            }

                            ModelSwitch {
                                id: idCameraTriggerOnceSwitch
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: idCameraTriggerActiveSwitch.width
                                height: idCameraTriggerActiveSwitch.height
                            }
                        }

                        Item {
                            id: idCameraTriggerDistItem
                            width: idCameraTriggerItem.width
                            height: idCameraTriggerDistText.height * 1.5
                            enabled: idCameraTriggerOnceItem.enabled && idCameraTriggerOnceSwitch.state === 'OFF'
                            opacity: enabled ? 1 : 0.5

                            Text {
                                id: idCameraTriggerDistText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idServoModelCart.font
                                text: ('%1 %2  %3').arg(idCameraTriggerDistSlider.value.toFixed(1)).arg('m').arg(qsTr('فاصله'))
                            }

                            ModelSlider {
                                id: idCameraTriggerDistSlider
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.6
                                height: idAltitudeSlider.height
                                from: 0.5
                                to: 100
                                stepSize: 0.1
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: idButtons
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: idDisplay.getScaledHeight(0.0275, 0.07)

        Rectangle {
            id: idHorizontalLine
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.background
        }

        Rectangle {
            id: idLeftVerticalLine
            anchors.top: idHorizontalLine.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.leftMargin: idHorizontalLine.width / 3
            width: idHorizontalLine.height
            color: idHorizontalLine.color
        }

        Rectangle {
            id: idRightVerticalLine
            anchors.top: idHorizontalLine.top
            anchors.bottom: parent.bottom
            anchors.right: idHorizontalLine.right
            anchors.rightMargin: idHorizontalLine.width / 3
            width: idHorizontalLine.height
            color: idHorizontalLine.color
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idLeftVerticalLine.left

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                idRoot.close()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idLeftVerticalLine.right
            anchors.right: idRightVerticalLine.left

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: 'red'
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('حذف')
            }

            onClicked: {
                MissionService.removeWaypoint(idRoot.sequence)
                idRoot.close()
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idRightVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('ذخیره')
            }

            onClicked: {
                idRoot.waypointItem.coordinate.altitude = parseFloat(idAltitudeSlider.value.toFixed(1))
                idRoot.waypointItem.hoverTime = parseInt(idHoverTimeSlider.value.toFixed(0))
                idRoot.waypointItem.speed = parseFloat(idSpeedSlider.value.toFixed(1))
                idRoot.waypointItem.relayActive = idRelayActiveSwitch.checked
                idRoot.waypointItem.relayID = idRelayIDSpinBox.realValue
                idRoot.waypointItem.relayStatus = idRelayStatusSwitch.checked
                idRoot.waypointItem.servoActive = idServoActiveSwitch.checked
                idRoot.waypointItem.servoID = idServoIDSpinBox.realValue
                idRoot.waypointItem.servoPWM = idServoSlider.value
                idRoot.waypointItem.gimbalActive = idGimbalActiveSwitch.checked
                idRoot.waypointItem.gimbalTilt = idGimbalTiltSlider.value
                idRoot.waypointItem.gimbalPan = idGimbalPanSlider.value
                idRoot.waypointItem.cameraTriggerActive = idCameraTriggerActiveSwitch.checked
                idRoot.waypointItem.cameraTriggerStatus = idCameraTriggerStatusSwitch.checked
                idRoot.waypointItem.cameraTriggerOnce = idCameraTriggerOnceSwitch.checked
                idRoot.waypointItem.cameraTriggerDistance = idCameraTriggerDistSlider.value
                MissionService.updateWaypoint(idRoot.waypointItem, idRoot.sequence)
                idRoot.close()
            }
        }
    }

    onClosed: {
        idRoot.waypointItem = undefined
        idRoot.sequence = -1
    }

    function openBySequence(sequence) {
        idRoot.waypointItem = MissionService.getWaypoint(sequence)
        idAltitudeSlider.value = idRoot.waypointItem.coordinate.altitude
        idHoverTimeSlider.value = idRoot.waypointItem.hoverTime
        idSpeedSlider.value = idRoot.waypointItem.speed
        idRelayActiveSwitch.checked = idRoot.waypointItem.relayActive
        idRelayIDSpinBox.set(idRoot.waypointItem.relayID)
        idRelayStatusSwitch.checked = idRoot.waypointItem.relayStatus
        idServoActiveSwitch.checked = idRoot.waypointItem.servoActive
        idServoIDSpinBox.set(idRoot.waypointItem.servoID)
        idServoSlider.value = idRoot.waypointItem.servoPWM
        idGimbalActiveSwitch.checked = idRoot.waypointItem.gimbalActive
        idGimbalTiltSlider.value = idRoot.waypointItem.gimbalTilt
        idGimbalPanSlider.value = idRoot.waypointItem.gimbalPan
        idCameraTriggerActiveSwitch.checked = idRoot.waypointItem.cameraTriggerActive
        idCameraTriggerStatusSwitch.checked = idRoot.waypointItem.cameraTriggerStatus
        idCameraTriggerOnceSwitch.checked = idRoot.waypointItem.cameraTriggerOnce
        idCameraTriggerDistSlider.value = idRoot.waypointItem.cameraTriggerDistance
        idRoot.sequence = sequence
        idRoot.open()
    }
}
