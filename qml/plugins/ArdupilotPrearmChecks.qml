import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelCart {
    id: idRoot
    titleRightAlignment: false

    property real itemHeight: 0
    property int lastArmCheck: 0

    Flickable {
        id: idFlickable
        anchors.fill: parent
        anchors.topMargin: idRoot.itemVerticalMargin
        contentWidth: idColumn.width
        contentHeight: idColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            id: idScrollBar
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: idRoot.itemHeight * 0.05

            readonly property real margins: idScrollBar.width * 2

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idAllText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'All'
                }

                ModelSwitch {
                    id: idAllSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: height * 1.75
                    height: idAllText.implicitHeight

                    onCheckedChanged: {
                        if (checked) {
                            updateChecks(1, false)
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idBarometerText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Barometer'
                }

                ModelSwitch {
                    id: idBarometerSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idCompassText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Compass'
                }

                ModelSwitch {
                    id: idCompassSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idGPSLockText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'GPS lock'
                }

                ModelSwitch {
                    id: idGPSLockSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idINSText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'INS'
                }

                ModelSwitch {
                    id: idINSSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idParametersText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Parameters'
                }

                ModelSwitch {
                    id: idParametersSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idRCChannelsText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'RC Channels'
                }

                ModelSwitch {
                    id: idRCChannelsSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idBoardVoltageText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Board Voltage'
                }

                ModelSwitch {
                    id: idBoardVoltageSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idBatteryLevelText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Battery Level'
                }

                ModelSwitch {
                    id: idBatteryLevelSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idAirspeedText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Airspeed'
                }

                ModelSwitch {
                    id: idAirspeedSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idLoggingAvailableText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Logging Available'
                }

                ModelSwitch {
                    id: idLoggingAvailableSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idHardwareSafetySwitchText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Hardware Safety Switch'
                }

                ModelSwitch {
                    id: idHardwareSafetySwitchSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idGPSConfigurationText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'GPS Configuration'
                }

                ModelSwitch {
                    id: idGPSConfigurationSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idSystemText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'System'
                }

                ModelSwitch {
                    id: idSystemSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idMissionText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Mission'
                }

                ModelSwitch {
                    id: idMissionSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idRangefinderText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Rangefinder'
                }

                ModelSwitch {
                    id: idRangefinderSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idCameraText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'Camera'
                }

                ModelSwitch {
                    id: idCameraSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idAuxAuthText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'AuxAuth'
                }

                ModelSwitch {
                    id: idAuxAuthSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }

            Item {
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idFFTText
                    anchors.left: parent.left
                    anchors.leftMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: 'FFT'
                }

                ModelSwitch {
                    id: idFFTSwitch
                    anchors.right: parent.right
                    anchors.rightMargin: idColumn.margins
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAllSwitch.width
                    height: idAllSwitch.height

                    onCheckedChanged: {
                        if (checked) {
                            idAllSwitch.checked = false
                        }
                    }
                }
            }
        }
    }

    function calculateArmingChecks() {
        let value = 0

        value += idAllSwitch.checked ? 1 : 0
        value += idBarometerSwitch.checked ? 2 : 0
        value += idCompassSwitch.checked ? 4 : 0
        value += idGPSLockSwitch.checked ? 8 : 0
        value += idINSSwitch.checked ? 16 : 0
        value += idParametersSwitch.checked ? 32 : 0
        value += idRCChannelsSwitch.checked ? 64 : 0
        value += idBoardVoltageSwitch.checked ? 128 : 0
        value += idBatteryLevelSwitch.checked ? 256 : 0
        value += idAirspeedSwitch.checked ? 512 : 0
        value += idLoggingAvailableSwitch.checked ? 1024 : 0
        value += idHardwareSafetySwitchSwitch.checked ? 2048 : 0
        value += idGPSConfigurationSwitch.checked ? 4096 : 0
        value += idSystemSwitch.checked ? 8192 : 0
        value += idMissionSwitch.checked ? 16384 : 0
        value += idRangefinderSwitch.checked ? 32768 : 0
        value += idCameraSwitch.checked ? 65536 : 0
        value += idAuxAuthSwitch.checked ? 131072 : 0
        value += idFFTSwitch.checked ? 524288 : 0

        return value
    }

    function updateChecks(value, updateLast) {
        idAllSwitch.checked = value & 1
        idBarometerSwitch.checked = value & 2
        idCompassSwitch.checked = value & 4
        idGPSLockSwitch.checked = value & 8
        idINSSwitch.checked = value & 16
        idParametersSwitch.checked = value & 32
        idRCChannelsSwitch.checked = value & 64
        idBoardVoltageSwitch.checked = value & 128
        idBatteryLevelSwitch.checked = value & 256
        idAirspeedSwitch.checked = value & 512
        idLoggingAvailableSwitch.checked = value & 1024
        idHardwareSafetySwitchSwitch.checked = value & 2048
        idGPSConfigurationSwitch.checked = value & 4096
        idSystemSwitch.checked = value & 8192
        idMissionSwitch.checked = value & 16384
        idRangefinderSwitch.checked = value & 32768
        idCameraSwitch.checked = value & 65536
        idAuxAuthSwitch.checked = value & 131072
        idFFTSwitch.checked = value & 524288

        if (updateLast) {
            lastArmCheck = value
        }
    }

    function reset() {
        updateChecks(0)
    }

    function applyChanges() {
        var arm_check = calculateArmingChecks()

        if (arm_check !== lastArmCheck) {
            ParamService.notifyUpload('ARMING_CHECK', arm_check)

            if (idRoot.visible) {
                toast.warn(qsTr('پس از اعمال تغییرات دستگاه را مجددا راه اندازی کنید'), 5000)
            }

            return true
        }

        return false
    }
}
