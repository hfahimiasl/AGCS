import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'
import '../object'
import 'qrc:/js/Js.js' as Js


ModelPagetype {
    id: idPageCalibration

    Item {
        id: idPageCalibrationItem
        anchors.fill: parent
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: idDisplay.getScaledWidth(0.005, 0.01)
        anchors.rightMargin: anchors.leftMargin

        ScrollView {
            anchors.fill: parent
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                anchors.fill: parent
                model: 1

                delegate: Item {
                    anchors.centerIn: parent
                    width: parent.width
                    height: idDisplay.isLargeDisplay ? idPageCalibrationItem.height : (idSystemStatusModelCart.height + idSensorModelCart.height + idPageCalibrationItem.anchors.topMargin)

                    ModelCart {
                        id: idSystemStatusModelCart
                        anchors.top: parent.top
                        anchors.right: parent.right
                        // map(x, y, z, 0.1958, 0.25) if idSystemStatusPresentText was visible
                        width: idDisplay.getScaledWidth(Js.map(idPageCalibrationItem.width, idDisplay.minimumWidth, idDisplay.displayWidth, 0.15, 0.2), idPageCalibrationItem.width / idDisplay.displayWidth)
                        height: idDisplay.getScaledHeight(0.45, idSystemStatusColumn.implicitHeight * 1.25 / idDisplay.displayHeight)
                        font.family: font_fa_medium.name
                        font.pixelSize: idDisplay.getFontScale(1, 2.25)
                        tittle: qsTr('وضعیت دستگاه')
                        clip: true

                        Item {
                            id: idSystemStatusItem
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: idSystemStatusModelCart.itemVerticalMargin * 0.85
                            anchors.leftMargin: idSystemStatusModelCart.itemHorizontalMargin * 0.65
                            height: idSystemStatusHealthText.implicitHeight * 1.25

                            Text {
                                id: idSystemStatusHealthText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idSystemStatusModelCart.font
                                text: qsTr('سلامت')
                            }

                            Text {
                                id: idSystemStatusEnabledText
                                anchors.left: idSystemStatusHealthText.right
                                anchors.leftMargin: parent.width * 0.075
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idSystemStatusModelCart.font
                                text: qsTr('فعال')
                            }

                            Text {
                                id: idSystemStatusPresentText
                                anchors.left: idSystemStatusEnabledText.right
                                anchors.leftMargin: idSystemStatusEnabledText.anchors.leftMargin
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idSystemStatusModelCart.font
                                text: qsTr('اتصال')
                                visible: false
                            }
                        }

                        Flickable {
                            id: idSystemStatusFlickable
                            anchors.top: idSystemStatusItem.bottom
                            anchors.bottom: parent.bottom
                            anchors.left: idSystemStatusItem.left
                            anchors.right: idSystemStatusItem.right
                            anchors.topMargin: parent.height * 0.025
                            contentWidth: idSystemStatusColumn.width
                            contentHeight: idSystemStatusColumn.height
                            boundsBehavior: Flickable.StopAtBounds
                            clip: true

                            ScrollBar.vertical: ScrollBar {
                                id: idSystemStatusScrollBar
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                policy: ScrollBar.AsNeeded
                            }

                            Column {
                                id: idSystemStatusColumn
                                anchors.centerIn: parent
                                spacing: 10

                                ObjectSystemStatus {
                                    id: idGyro1Status
                                    width: idSystemStatusFlickable.width
                                    height: idSystemStatusItem.height * 0.75
                                    presentOffset: (idSystemStatusHealthText.implicitWidth + idSystemStatusEnabledText.anchors.leftMargin + idSystemStatusEnabledText.implicitWidth + idSystemStatusPresentText.anchors.leftMargin + (idSystemStatusPresentText.implicitWidth * 0.5)) - (idSystemStatusItem.width * 0.5)
                                    enabledOffset: (idSystemStatusHealthText.implicitWidth + idSystemStatusEnabledText.anchors.leftMargin + (idSystemStatusEnabledText.implicitWidth * 0.5)) - (idSystemStatusItem.width * 0.5)
                                    healthOffset: (idSystemStatusHealthText.implicitWidth * 0.5) - (idSystemStatusItem.width * 0.5)
                                    nameMargin: idSystemStatusScrollBar.width * 2
                                    pixelSize: idSystemStatusHealthText.font.pixelSize
                                    name: qsTr('جایروسکوپ 1')
                                }

                                ObjectSystemStatus {
                                    id: idGyro2Status
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('جایروسکوپ 2')
                                }

                                ObjectSystemStatus {
                                    id: idAccel1Status
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('شتاب سنج 1')
                                }

                                ObjectSystemStatus {
                                    id: idAccel2Status
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('شتاب سنج 2')
                                }

                                ObjectSystemStatus {
                                    id: idCompass1Status
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('قطب نما 1')
                                }

                                ObjectSystemStatus {
                                    id: idCompass2Status
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('قطب نما 2')
                                }

                                ObjectSystemStatus {
                                    id: idAHRSStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('AHRS')
                                }

                                ObjectSystemStatus {
                                    id: idPressureStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('فشار سنج')
                                }

                                ObjectSystemStatus {
                                    id: idDiffPressureStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('سرعت سنج هوایی') // TODO: check real name
                                }

                                ObjectSystemStatus {
                                    id: idLaserPositionStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('لیزر')
                                }

                                ObjectSystemStatus {
                                    id: idGPSStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('جی پی اس')
                                }

                                ObjectSystemStatus {
                                    id: idOpticalFlowStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('شار نوری')
                                }

                                ObjectSystemStatus {
                                    id: idVisionPositionStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('موقعیت دیداری')
                                }

                                ObjectSystemStatus {
                                    id: idObstacleAvoidanceStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('ممانعت از برخورد')
                                }

                                ObjectSystemStatus {
                                    id: idBatteryStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('باتری')
                                }

                                ObjectSystemStatus {
                                    id: idRemoteControlStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('گیرنده رادیو کنترل')
                                }

                                ObjectSystemStatus {
                                    id: idMotorOutputsStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('خروجی موتور')
                                }

                                ObjectSystemStatus {
                                    id: idPrearmCheckStatus
                                    width: idGyro1Status.width
                                    height: idGyro1Status.height
                                    presentOffset: idGyro1Status.presentOffset
                                    enabledOffset: idGyro1Status.enabledOffset
                                    healthOffset: idGyro1Status.healthOffset
                                    nameMargin: idGyro1Status.nameMargin
                                    pixelSize: idGyro1Status.pixelSize
                                    name: qsTr('امکان فعال شدن')
                                }
                            }
                        }

                        Connections {
                            target: variable

                            onNotifyChanges: {
                                if (id === 'SYS_STATUS') {
                                    idGyro1Status.update('SYS_STATUS_SENSOR_3D_GYRO1')
                                    idGyro2Status.update('SYS_STATUS_SENSOR_3D_GYRO2')
                                    idAccel1Status.update('SYS_STATUS_SENSOR_3D_ACCEL1')
                                    idAccel2Status.update('SYS_STATUS_SENSOR_3D_ACCEL2')
                                    idCompass1Status.update('SYS_STATUS_SENSOR_3D_MAG1')
                                    idCompass2Status.update('SYS_STATUS_SENSOR_3D_MAG2')
                                    idAHRSStatus.update('SYS_STATUS_AHRS')
                                    idPressureStatus.update('SYS_STATUS_SENSOR_ABSOLUTE_PRESSURE')
                                    idDiffPressureStatus.update('SYS_STATUS_SENSOR_DIFFERENTIAL_PRESSURE')
                                    idLaserPositionStatus.update('SYS_STATUS_SENSOR_LASER_POSITION')
                                    idGPSStatus.update('SYS_STATUS_SENSOR_GPS')
                                    idOpticalFlowStatus.update('SYS_STATUS_SENSOR_OPTICAL_FLOW')
                                    idVisionPositionStatus.update('SYS_STATUS_SENSOR_VISION_POSITION')
                                    idObstacleAvoidanceStatus.update('SYS_STATUS_OBSTACLE_AVOIDANCE')
                                    idBatteryStatus.update('SYS_STATUS_SENSOR_BATTERY')
                                    idRemoteControlStatus.update('SYS_STATUS_SENSOR_RC_RECEIVER')
                                    idMotorOutputsStatus.update('SYS_STATUS_SENSOR_MOTOR_OUTPUTS')
                                    idPrearmCheckStatus.update('SYS_STATUS_PREARM_CHECK')
                                }
                            }
                        }

                        Connections {
                            target: link

                            onConnectionChanged: {
                                if (!connected) {
                                    idGyro1Status.reset()
                                    idGyro2Status.reset()
                                    idAccel1Status.reset()
                                    idAccel2Status.reset()
                                    idCompass1Status.reset()
                                    idCompass2Status.reset()
                                    idAHRSStatus.reset()
                                    idPressureStatus.reset()
                                    idDiffPressureStatus.reset()
                                    idLaserPositionStatus.reset()
                                    idGPSStatus.reset()
                                    idOpticalFlowStatus.reset()
                                    idVisionPositionStatus.reset()
                                    idObstacleAvoidanceStatus.reset()
                                    idBatteryStatus.reset()
                                    idRemoteControlStatus.reset()
                                    idMotorOutputsStatus.reset()
                                    idPrearmCheckStatus.reset()
                                }
                            }
                        }
                    }

                    ModelCart {
                        id: idSensorModelCart
                        anchors.top: idDisplay.isLargeDisplay ? idSystemStatusModelCart.top : idSystemStatusModelCart.bottom
                        anchors.bottom: idDisplay.isLargeDisplay ? idSystemStatusModelCart.bottom : undefined
                        anchors.right: idDisplay.isLargeDisplay ? idSystemStatusModelCart.left : idSystemStatusModelCart.right
                        anchors.topMargin: idDisplay.isLargeDisplay ? undefined : idPageCalibrationItem.anchors.topMargin
                        anchors.rightMargin: idDisplay.isLargeDisplay ? idPageCalibrationItem.anchors.rightMargin : undefined
                        width: idDisplay.getScaledWidth(0.2, idPageCalibrationItem.width / idDisplay.displayWidth)
                        height: idDisplay.getScaledHeight(undefined, 1.25)
                        font: idSystemStatusModelCart.font
                        tittle: qsTr('سنسور ها')
                        clip: true

                        Item {
                            id: idSensorStatusItem
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.topMargin: idSensorModelCart.itemVerticalMargin
                            clip: true

                            readonly property real itemHeightGain: 0.85

                            Item {
                                id: idSensorAccelItem
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: parent.height / 3

                                ObjectSensorStatus {
                                    id: idSensorAccelStatus
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height * idSensorStatusItem.itemHeightGain
                                    pixelSize: idDisplay.getFontScale(1, 2.5)
                                    buttonName: qsTr('کالیبره شتاب سنج')

                                    onClicked: {
                                        if (link.isConnected()) {
                                            if (parseInt(variable.getValue('ARM_STATUS'))) {
                                                toast.error(qsTr('برای کالیبره شتاب سنج دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                idAccelCalibrationPopup.open()
                                            }

                                        } else {
                                            toast.error(qsTr('دستگاه متصل نیست'), 5000)
                                        }
                                    }
                                }
                            }

                            Item {
                                id: idSensorGyroItem
                                anchors.top: idSensorAccelItem.bottom
                                anchors.left: idSensorAccelItem.left
                                anchors.right: idSensorAccelItem.right
                                height: idSensorAccelItem.height

                                ObjectSensorStatus {
                                    id: idSensorGyroStatus
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height * idSensorStatusItem.itemHeightGain
                                    pixelSize: idSensorAccelStatus.pixelSize
                                    buttonName: qsTr('کالیبره جایروسکوپ')

                                    onClicked: {
                                        if (link.isConnected()) {
                                            if (parseInt(variable.getValue('ARM_STATUS'))) {
                                                toast.error(qsTr('برای کالیبره جایروسکوپ دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                idGyroCalibrationPopup.open()
                                            }

                                        } else {
                                            toast.error(qsTr('دستگاه متصل نیست'), 5000)
                                        }
                                    }
                                }
                            }

                            Item {
                                id: idSensorCompassItem
                                anchors.top: idSensorGyroItem.bottom
                                anchors.left: idSensorGyroItem.left
                                anchors.right: idSensorGyroItem.right
                                height: idSensorGyroItem.height

                                ObjectSensorStatus {
                                    id: idSensorCompassStatus
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height * idSensorStatusItem.itemHeightGain
                                    pixelSize: idSensorAccelStatus.pixelSize
                                    buttonName: qsTr('کالیبره قطب نما')

                                    onClicked: {
                                        if (link.isConnected()) {
                                            if (parseInt(variable.getValue('ARM_STATUS'))) {
                                                toast.error(qsTr('برای کالیبره قطب نما دستگاه را غیرفعال کنید'), 5000)

                                            } else {
                                                idCompassCalibrationPopup.open()
                                            }

                                        } else {
                                            toast.error(qsTr('دستگاه متصل نیست'), 5000)
                                        }
                                    }
                                }
                            }

                            Connections {
                                target: variable

                                onNotifyChanges: {
                                    if (id === 'RAW_IMU') {
                                        idSensorAccelStatus.update('ACC')
                                        idSensorGyroStatus.update('GYRO')
                                        idSensorCompassStatus.update('MAG')
                                    }
                                }
                            }

                            Connections {
                                target: link

                                onConnectionChanged: {
                                    if (!connected) {
                                        idSensorAccelStatus.reset()
                                        idSensorGyroStatus.reset()
                                        idSensorCompassStatus.reset()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ModelPopup {
        id: idAccelCalibrationPopup
        anchors.centerIn: parent
        width: idDisplay.isLargeDisplay ? idDisplay.minimumWidth * 0.8 : idDisplay.displayWidth * 0.9
        height: idDisplay.isLargeDisplay ? idDisplay.minimumHeight * 0.55 : idDisplay.displayHeight * 0.9
        closePolicy: Popup.NoAutoClose

        property var started: false

        onVisibleChanged: {
            idAccelCalibrationText.reset()
        }

        Image {
            id: idAccelCalibrationImage
            anchors.left: parent.left
            anchors.leftMargin: width * 0.25
            anchors.verticalCenter: parent.verticalCenter
            source: String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'
            sourceSize: Qt.size(parent.height * 0.75, parent.height * 0.75)
            visible: !idAccelCalibrationResultText.visible

            Connections {
                target: settings

                onNotifyChanges: {
                    if (key === SystemSettings.GUITheme) {
                        let address = idAccelCalibrationImage.source.toString()
                        let dark = String(settings.get(key)) === 'DARK'
                        idAccelCalibrationImage.source = address.replace(dark ? "gray" : "green", dark ? "green" : "gray")
                    }
                }
            }
        }

        Text {
            id: idAccelCalibrationResultText
            anchors.centerIn: idAccelCalibrationImage
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(8, 16)
            visible: false

            states: [
                State {
                    name: 'accepted'
                    PropertyChanges { target: idAccelCalibrationResultText ; text: '\uf058' }
                    PropertyChanges { target: idAccelCalibrationResultText ; color: theme.primary }
                },
                State {
                    name: 'failed'
                    PropertyChanges { target: idAccelCalibrationResultText ; text: '\uf071' }
                    PropertyChanges { target: idAccelCalibrationResultText ; color: 'red' }
                }
            ]
        }

        Item {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idAccelCalibrationImage.right
            anchors.right: parent.right
            anchors.leftMargin: idAccelCalibrationImage.anchors.leftMargin
            anchors.rightMargin: anchors.leftMargin * 0.5
            anchors.topMargin: parent.height * 0.125
            anchors.bottomMargin: anchors.topMargin * 0.5

            Text {
                id: idAccelCalibrationText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignJustify
                color: theme.text
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1, 2.25)
                clip: true

                function clear() {
                    idAccelCalibrationText.text = ''
                }

                function add(text) {
                    idAccelCalibrationText.text += '<ul><li>' + text + '</li></ul></br>'
                }

                function reset() {
                    idAccelCalibrationText.clear()
                    // TODO: add details
                    idAccelCalibrationText.add(qsTr('برای شروع کالیبره شتاب سنج روی دکمه شروع کلیک کنید'))
                }
            }

            ModelButton {
                id: idAccelCalibrationCancelButton
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
                width: parent.width * 0.4
                height: parent.height * 0.125
                backgroundColor: 'transparent'
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1.15, 2.3)
                text: qsTr('لغو')

                onClicked: {
                    idAccelCalibrationPopup.terminate()
                }
            }

            ModelButton {
                id: idAccelCalibrationCommanderButton
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: idAccelCalibrationCancelButton.width
                height: idAccelCalibrationCancelButton.height
                backgroundColor: 'transparent'
                font: idAccelCalibrationCancelButton.font
                text: qsTr('شروع')

                onClicked: {
                    if (parseInt(variable.getValue('ARM_STATUS'))) {
                        idAccelCalibrationPopup.started = false
                        idAccelCalibrationResultText.state = 'failed'
                        idAccelCalibrationResultText.visible = true
                        idAccelCalibrationText.clear()
                        idAccelCalibrationText.add(qsTr('خطا در کالیبره'))
                        idAccelCalibrationText.add(qsTr('برای کالیبره شتاب سنج دستگاه را غیرفعال کنید'))
                        idAccelCalibrationText.add(qsTr('سپس روی دکمه تلاش مجدد کلیک کنید'))
                        idAccelCalibrationCommanderButton.state = 'normal'
                        idAccelCalibrationCommanderButton.text = qsTr('تلاش مجدد')

                    } else {
                        if (idAccelCalibrationCommanderButton.text === qsTr('راه اندازی مجدد')) {
                            idAccelCalibrationPopup.terminate()
                            autopilot.reboot()
                            return
                        }

                        idAccelCalibrationCommanderButton.state = 'busy'

                        if (idAccelCalibrationPopup.started) {
                            autopilot.requestNextAccelCalibrationSide()

                        } else {
                            idAccelCalibrationPopup.started = true
                            idAccelCalibrationResultText.visible = false
                            idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'

                            if (idAccelCalibrationCommanderButton.text === qsTr('تلاش مجدد')) {
                                idAccelCalibrationText.clear()
                                idAccelCalibrationText.add(qsTr('در حال شروع مجدد کالیبره'))
                            }

                            autopilot.requestAccelCalibration()
                        }
                    }
                }
            }
        }

        function terminate() {
            idAccelCalibrationPopup.close()
            idAccelCalibrationPopup.started = false
            idAccelCalibrationResultText.visible = false
            idAccelCalibrationCommanderButton.state = 'normal'
            idAccelCalibrationCommanderButton.text = qsTr('شروع')
            idAccelCalibrationText.reset()
            idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'
            autopilot.resetCalibrationProgress()
        }

        Connections {
            target: autopilot

            onAccelCalibrationPosLevel: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را به صورت افقی روی سطحی صاف قرار داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationPosLeft: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEFT.svg' : 'qrc:/images/calibration/gray/ACC-LEFT.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را ۹۰ درجه به سمت چپ دوران داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationPosRight: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-RIGHT.svg' : 'qrc:/images/calibration/gray/ACC-RIGHT.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را ۹۰ درجه به سمت راست دوران داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationPosNoseDown: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-NOSEDOWN.svg' : 'qrc:/images/calibration/gray/ACC-NOSEDOWN.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را ۹۰ درجه به سمت جلو دوران داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationPosNoseUp: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-NOSEUP.svg' : 'qrc:/images/calibration/gray/ACC-NOSEUP.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را ۹۰ درجه به سمت عقب دوران داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationPosBack: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-BACK.svg' : 'qrc:/images/calibration/gray/ACC-BACK.svg'
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('دستگاه را به پشت قرار داده و روی دکمه بعدی کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('بعدی')
            }

            onAccelCalibrationAccepted: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationPopup.started = false
                idAccelCalibrationResultText.state = 'accepted'
                idAccelCalibrationResultText.visible = true
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('برای کامل شدن فرآیند کالیبره دستگاه را مجددا راه اندازی کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('راه اندازی مجدد')
            }

            onAccelCalibrationFailed: {
                if (!idAccelCalibrationPopup.started) {
                    return
                }

                idAccelCalibrationPopup.started = false
                idAccelCalibrationResultText.state = 'failed'
                idAccelCalibrationResultText.visible = true
                idAccelCalibrationText.clear()
                idAccelCalibrationText.add(qsTr('خطا در کالیبره'))
                idAccelCalibrationText.add(qsTr('برای انجام مجدد کالیبره روی دکمه تلاش مجدد کلیک کنید'))
                idAccelCalibrationCommanderButton.state = 'normal'
                idAccelCalibrationCommanderButton.text = qsTr('تلاش مجدد')
            }
        }

        Connections {
            target: link

            onConnectionChanged: {
                if (!connected) {
                    if (idAccelCalibrationPopup.started) {
                        toast.error(qsTr('خطا در کالیبره شتاب سنج'), 5000)
                    }

                    idAccelCalibrationPopup.terminate()
                }
            }
        }
    }

    ModelPopup {
        id: idGyroCalibrationPopup
        anchors.centerIn: parent
        width: idDisplay.isLargeDisplay ? idDisplay.minimumWidth * 0.8 : idDisplay.displayWidth * 0.9
        height: idDisplay.isLargeDisplay ? idDisplay.minimumHeight * 0.55 : idDisplay.displayHeight * 0.9
        closePolicy: Popup.NoAutoClose

        property var started: false

        onVisibleChanged: {
            idGyroCalibrationText.reset()
        }

        Image {
            id: idGyroCalibrationImage
            anchors.left: parent.left
            anchors.leftMargin: width * 0.25
            anchors.verticalCenter: parent.verticalCenter
            source: String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'
            sourceSize: Qt.size(parent.height * 0.75, parent.height * 0.75)
            visible: !idGyroCalibrationResultText.visible

            Connections {
                target: settings

                onNotifyChanges: {
                    if (key === SystemSettings.GUITheme) {
                        let address = idGyroCalibrationImage.source.toString()
                        let dark = String(settings.get(key)) === 'DARK'
                        idGyroCalibrationImage.source = address.replace(dark ? "gray" : "green", dark ? "green" : "gray")
                    }
                }
            }
        }

        Text {
            id: idGyroCalibrationResultText
            anchors.centerIn: idGyroCalibrationImage
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(8, 16)
            visible: false

            states: [
                State {
                    name: 'accepted'
                    PropertyChanges { target: idGyroCalibrationResultText ; text: '\uf058' }
                    PropertyChanges { target: idGyroCalibrationResultText ; color: theme.primary }
                },
                State {
                    name: 'failed'
                    PropertyChanges { target: idGyroCalibrationResultText ; text: '\uf071' }
                    PropertyChanges { target: idGyroCalibrationResultText ; color: 'red' }
                }
            ]
        }

        Item {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idGyroCalibrationImage.right
            anchors.right: parent.right
            anchors.leftMargin: idGyroCalibrationImage.anchors.leftMargin
            anchors.rightMargin: anchors.leftMargin * 0.5
            anchors.topMargin: parent.height * 0.125
            anchors.bottomMargin: anchors.topMargin * 0.5

            Text {
                id: idGyroCalibrationText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignJustify
                color: theme.text
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1, 2.25)
                clip: true

                function clear() {
                    idGyroCalibrationText.text = ''
                }

                function add(text) {
                    idGyroCalibrationText.text += '<ul><li>' + text + '</li></ul></br>'
                }

                function reset() {
                    idGyroCalibrationText.clear()
                    // TODO: add details
                    idGyroCalibrationText.add(qsTr('برای شروع کالیبره جایروسکوپ روی دکمه شروع کلیک کنید'))
                }
            }

            ModelButton {
                id: idGyroCalibrationCancelButton
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
                width: parent.width * 0.4
                height: parent.height * 0.125
                backgroundColor: 'transparent'
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1.15, 2.3)
                text: qsTr('لغو')

                onClicked: {
                    idGyroCalibrationPopup.terminate()
                }
            }

            ModelButton {
                id: idGyroCalibrationCommanderButton
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: idGyroCalibrationCancelButton.width
                height: idGyroCalibrationCancelButton.height
                backgroundColor: 'transparent'
                font: idGyroCalibrationCancelButton.font
                text: qsTr('شروع')

                onClicked: {
                    if (parseInt(variable.getValue('ARM_STATUS'))) {
                        idGyroCalibrationPopup.started = false
                        idGyroCalibrationResultText.state = 'failed'
                        idGyroCalibrationResultText.visible = true
                        idGyroCalibrationText.clear()
                        idGyroCalibrationText.add(qsTr('خطا در کالیبره'))
                        idGyroCalibrationText.add(qsTr('برای کالیبره جایروسکوپ دستگاه را غیرفعال کنید'))
                        idGyroCalibrationText.add(qsTr('سپس روی دکمه تلاش مجدد کلیک کنید'))
                        idGyroCalibrationCommanderButton.state = 'normal'
                        idGyroCalibrationCommanderButton.text = qsTr('تلاش مجدد')

                    } else {
                        if (idGyroCalibrationCommanderButton.text === qsTr('راه اندازی مجدد')) {
                            idGyroCalibrationPopup.terminate()
                            autopilot.reboot()
                            return
                        }

                        idGyroCalibrationCommanderButton.state = 'busy'

                        if (!idGyroCalibrationPopup.started) {
                            idGyroCalibrationPopup.started = true
                            idGyroCalibrationResultText.visible = false
                            idGyroCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'

                            if (idGyroCalibrationCommanderButton.text === qsTr('تلاش مجدد')) {
                                idGyroCalibrationText.clear()
                                idGyroCalibrationText.add(qsTr('در حال شروع مجدد کالیبره'))
                            }

                            autopilot.requestLevelCalibration()
                        }
                    }
                }
            }
        }

        function terminate() {
            idGyroCalibrationPopup.close()
            idGyroCalibrationPopup.started = false
            idGyroCalibrationResultText.visible = false
            idGyroCalibrationCommanderButton.state = 'normal'
            idGyroCalibrationCommanderButton.text = qsTr('شروع')
            idGyroCalibrationText.reset()
            idGyroCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/ACC-LEVEL.svg' : 'qrc:/images/calibration/gray/ACC-LEVEL.svg'
            autopilot.resetCalibrationProgress()
        }

        Connections {
            target: autopilot

            onLevelCalibrationAccepted: {
                if (!idGyroCalibrationPopup.started) {
                    return
                }

                idGyroCalibrationPopup.started = false
                idGyroCalibrationResultText.state = 'accepted'
                idGyroCalibrationResultText.visible = true
                idGyroCalibrationText.clear()
                idGyroCalibrationText.add(qsTr('برای کامل شدن فرآیند کالیبره دستگاه را مجددا راه اندازی کنید'))
                idGyroCalibrationCommanderButton.state = 'normal'
                idGyroCalibrationCommanderButton.text = qsTr('راه اندازی مجدد')
            }

            onLevelCalibrationFailed: {
                if (!idGyroCalibrationPopup.started) {
                    return
                }

                idGyroCalibrationPopup.started = false
                idGyroCalibrationResultText.state = 'failed'
                idGyroCalibrationResultText.visible = true
                idGyroCalibrationText.clear()
                idGyroCalibrationText.add(qsTr('خطا در کالیبره'))
                idGyroCalibrationText.add(qsTr('برای انجام مجدد کالیبره روی دکمه تلاش مجدد کلیک کنید'))
                idGyroCalibrationCommanderButton.state = 'normal'
                idGyroCalibrationCommanderButton.text = qsTr('تلاش مجدد')
            }
        }

        Connections {
            target: link

            onConnectionChanged: {
                if (!connected) {
                    if (idGyroCalibrationPopup.started) {
                        toast.error(qsTr('خطا در کالیبره جایروسکوپ'), 5000)
                    }

                    idGyroCalibrationPopup.terminate()
                }
            }
        }
    }

    ModelPopup {
        id: idCompassCalibrationPopup
        anchors.centerIn: parent
        width: idDisplay.isLargeDisplay ? idDisplay.minimumWidth * 0.8 : idDisplay.displayWidth * 0.9
        height: idDisplay.isLargeDisplay ? idDisplay.minimumHeight * 0.55 : idDisplay.displayHeight * 0.9
        closePolicy: Popup.NoAutoClose

        property var started: false

        onVisibleChanged: {
            idCompassCalibrationText.reset()
            idCompassCalibrationProgressBar.value = 0
            idCompassCalibrationProgressBar.visible = false
        }

        Image {
            id: idCompassCalibrationImage
            anchors.left: parent.left
            anchors.leftMargin: width * 0.25
            anchors.verticalCenter: parent.verticalCenter
            source: String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/COMPASS.svg' : 'qrc:/images/calibration/gray/COMPASS.svg'
            sourceSize: Qt.size(parent.height * 0.75, parent.height * 0.75)
            visible: !idCompassCalibrationResultText.visible

            Connections {
                target: settings

                onNotifyChanges: {
                    if (key === SystemSettings.GUITheme) {
                        let address = idCompassCalibrationImage.source.toString()
                        let dark = String(settings.get(key)) === 'DARK'
                        idCompassCalibrationImage.source = address.replace(dark ? "gray" : "green", dark ? "green" : "gray")
                    }
                }
            }
        }

        Text {
            id: idCompassCalibrationResultText
            anchors.centerIn: idCompassCalibrationImage
            font.family: fontAwesome.name
            font.pixelSize: idDisplay.getFontScale(8, 16)
            visible: false

            states: [
                State {
                    name: 'accepted'
                    PropertyChanges { target: idCompassCalibrationResultText ; text: '\uf058' }
                    PropertyChanges { target: idCompassCalibrationResultText ; color: theme.primary }
                },
                State {
                    name: 'failed'
                    PropertyChanges { target: idCompassCalibrationResultText ; text: '\uf071' }
                    PropertyChanges { target: idCompassCalibrationResultText ; color: 'red' }
                }
            ]
        }

        Item {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idCompassCalibrationImage.right
            anchors.right: parent.right
            anchors.leftMargin: idCompassCalibrationImage.anchors.leftMargin
            anchors.rightMargin: anchors.leftMargin * 0.5
            anchors.topMargin: parent.height * 0.125
            anchors.bottomMargin: anchors.topMargin * 0.5

            Text {
                id: idCompassCalibrationText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignJustify
                color: theme.text
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1, 2.25)
                clip: true

                function clear() {
                    idCompassCalibrationText.text = ''
                }

                function add(text) {
                    idCompassCalibrationText.text += '<ul><li>' + text + '</li></ul></br>'
                }

                function reset() {
                    idCompassCalibrationText.clear()
                    // TODO: add details
                    idCompassCalibrationText.add(qsTr('برای شروع کالیبره قطب نما روی دکمه شروع کلیک کنید'))
                }
            }

            Item {
                anchors.top: idCompassCalibrationText.bottom
                anchors.bottom: idCompassCalibrationCommanderButton.top
                anchors.left: idCompassCalibrationCancelButton.left
                anchors.right: idCompassCalibrationCommanderButton.right

                ModelProgressBar {
                    id: idCompassCalibrationProgressBar
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: idCompassCalibrationCommanderButton.height * 0.5

                    Connections {
                        target: variable

                        onNotifyChanges: {
                            if (id === 'COMPASS_CAL_PROG') {
                                if (idCompassCalibrationPopup.started) {
                                    idCompassCalibrationProgressBar.value = variable.getValue(id) / 100.0

                                } else {
                                    idCompassCalibrationProgressBar.value = 0
                                }
                            }
                        }
                    }
                }
            }

            ModelButton {
                id: idCompassCalibrationCancelButton
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: parent.width * 0.05
                width: parent.width * 0.4
                height: parent.height * 0.125
                backgroundColor: 'transparent'
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1.15, 2.3)
                text: qsTr('لغو')

                onClicked: {
                    if (idCompassCalibrationPopup.started) {
                        autopilot.requestCancelCompassCalibration()
                    }

                    idCompassCalibrationPopup.terminate()
                }
            }

            ModelButton {
                id: idCompassCalibrationCommanderButton
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: idCompassCalibrationCancelButton.width
                height: idCompassCalibrationCancelButton.height
                backgroundColor: 'transparent'
                font: idCompassCalibrationCancelButton.font
                text: qsTr('شروع')

                onClicked: {
                    if (parseInt(variable.getValue('ARM_STATUS'))) {
                        idCompassCalibrationPopup.started = false
                        idCompassCalibrationResultText.state = 'failed'
                        idCompassCalibrationResultText.visible = true
                        idCompassCalibrationText.clear()
                        idCompassCalibrationText.add(qsTr('خطا در کالیبره'))
                        idCompassCalibrationText.add(qsTr('برای کالیبره قطب نما دستگاه را غیرفعال کنید'))
                        idCompassCalibrationText.add(qsTr('سپس روی دکمه تلاش مجدد کلیک کنید'))
                        idCompassCalibrationCommanderButton.state = 'normal'
                        idCompassCalibrationCommanderButton.text = qsTr('تلاش مجدد')

                    } else {
                        if (idCompassCalibrationCommanderButton.text === qsTr('راه اندازی مجدد')) {
                            idCompassCalibrationPopup.terminate()
                            autopilot.reboot()
                            return
                        }

                        idCompassCalibrationCommanderButton.state = 'busy'

                        if (!idCompassCalibrationPopup.started) {
                            idCompassCalibrationPopup.started = true
                            idCompassCalibrationResultText.visible = false
                            idCompassCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/COMPASS.svg' : 'qrc:/images/calibration/gray/COMPASS.svg'

                            if (idCompassCalibrationCommanderButton.text === qsTr('تلاش مجدد')) {
                                idCompassCalibrationText.clear()
                                idCompassCalibrationText.add(qsTr('در حال شروع مجدد کالیبره'))
                            }

                            autopilot.requestCompassCalibration()
                        }
                    }
                }
            }
        }

        function terminate() {
            idCompassCalibrationPopup.close()
            idCompassCalibrationPopup.started = false
            idCompassCalibrationResultText.visible = false
            idCompassCalibrationProgressBar.value = 0
            idCompassCalibrationProgressBar.visible = false
            idCompassCalibrationCommanderButton.state = 'normal'
            idCompassCalibrationCommanderButton.text = qsTr('شروع')
            idCompassCalibrationText.reset()
            idCompassCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/COMPASS.svg' : 'qrc:/images/calibration/gray/COMPASS.svg'
            autopilot.resetCalibrationProgress()
        }

        Connections {
            target: autopilot

            onCompassCalibrationStarted: {
                if (!idCompassCalibrationPopup.started) {
                    return
                }

                idCompassCalibrationImage.source = String(settings.get(SystemSettings.GUITheme)) === 'DARK' ? 'qrc:/images/calibration/green/COMPASS.svg' : 'qrc:/images/calibration/gray/COMPASS.svg'
                idCompassCalibrationText.clear()
                idCompassCalibrationText.add(qsTr('دستگاه را در تمامی محور ها تا پر شدن کامل نوار زیر دوران دهید'))
                idCompassCalibrationProgressBar.value = 0
                idCompassCalibrationProgressBar.visible = true
                idCompassCalibrationCommanderButton.state = 'busy'
            }

            onCompassCalibrationAccepted: {
                if (!idCompassCalibrationPopup.started) {
                    return
                }

                idCompassCalibrationPopup.started = false
                idCompassCalibrationResultText.state = 'accepted'
                idCompassCalibrationResultText.visible = true
                idCompassCalibrationText.clear()
                idCompassCalibrationText.add(qsTr('برای کامل شدن فرآیند کالیبره دستگاه را مجددا راه اندازی کنید'))
                idCompassCalibrationCommanderButton.state = 'normal'
                idCompassCalibrationCommanderButton.text = qsTr('راه اندازی مجدد')
            }

            onCompassCalibrationFailed: {
                if (!idCompassCalibrationPopup.started) {
                    return
                }

                idCompassCalibrationPopup.started = false
                idCompassCalibrationResultText.state = 'failed'
                idCompassCalibrationResultText.visible = true
                idCompassCalibrationText.clear()
                idCompassCalibrationText.add(qsTr('خطا در کالیبره'))
                idCompassCalibrationText.add(qsTr('برای انجام مجدد کالیبره روی دکمه تلاش مجدد کلیک کنید'))
                idCompassCalibrationProgressBar.value = 0
                idCompassCalibrationProgressBar.visible = false
                idCompassCalibrationCommanderButton.state = 'normal'
                idCompassCalibrationCommanderButton.text = qsTr('تلاش مجدد')
            }
        }

        Connections {
            target: link

            onConnectionChanged: {
                if (!connected) {
                    if (idCompassCalibrationPopup.started) {
                        toast.error(qsTr('خطا در کالیبره قطب نما'), 5000)
                    }

                    idCompassCalibrationPopup.terminate()
                }
            }
        }
    }
}
