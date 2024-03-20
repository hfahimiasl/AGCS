import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'
import '../plugins'


Flickable {
    id: idRoot
    contentWidth: width
    contentHeight: idGrid.implicitHeight
    boundsBehavior: Flickable.StopAtBounds
    interactive: true
    visible: false
    clip: true

    property bool needApply: false

    readonly property real columns: idDisplay.isLargeDisplay ? 4 : 2
    readonly property real rowSpacing: idDisplay.getScaledHeight(0.01, 0.015)
    readonly property real columnSpacing: idDisplay.getScaledWidth(0.005, 0.01)
    readonly property real itemWidth: (idRoot.width - idScrollBar.implicitWidth - (idRoot.columnSpacing * (idRoot.columns - 1))) / idRoot.columns

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1, 2.25)

    readonly property real cartModel1ContentHeight: idDisplay.getScaledHeight(0.085, 0.225)
    readonly property real cartModel2ContentHeight: idDisplay.getScaledHeight(0.125, 0.325)
    readonly property real cartModel3ContentHeight: idDisplay.getScaledHeight(0.175, 0.475)
    readonly property real cartModel4ContentHeight: idDisplay.getScaledHeight(0.21, 0.55)
    readonly property real cartModel5ContentHeight: idDisplay.getScaledHeight(0.25, 0.65)

    readonly property real cartModel2SpacingGain: 0.075
    readonly property real cartModel3SpacingGain: 0.05
    readonly property real cartModel4SpacingGain: 0.0375
    readonly property real cartModel5SpacingGain: 0.03

    ScrollBar.vertical: ScrollBar {
        id: idScrollBar
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        policy: ScrollBar.AsNeeded
    }

    Grid {
        id: idGrid
        anchors.fill: parent
        columns: idRoot.columns
        columnSpacing: idRoot.columnSpacing
        rowSpacing: idRoot.rowSpacing

        ModelCart {
            id: idServoRollModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Servo Roll')
            titleRightAlignment: false

            Rectangle {
                id: idServoRollRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idServoRollModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idServoRollRectangle.width - idServoRollModelCart.itemHorizontalMargin
                        height: idServoRollPText.height * 1.75

                        Text {
                            id: idServoRollPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoRollModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idServoRollPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoRollModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 4
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idServoRollRectangle.width - idServoRollModelCart.itemHorizontalMargin
                        height: idServoRollIText.height * 1.75

                        Text {
                            id: idServoRollIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoRollModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idServoRollISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoRollModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.05
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoRollRectangle.width - idServoRollModelCart.itemHorizontalMargin
                        height: idServoRollDText.height * 1.75

                        Text {
                            id: idServoRollDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoRollModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idServoRollDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoRollModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.2
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoRollRectangle.width - idServoRollModelCart.itemHorizontalMargin
                        height: idServoRollIMAXText.height * 1.75

                        Text {
                            id: idServoRollIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoRollModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idServoRollIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoRollModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 4500
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idServoRollRectangle.width - idServoRollModelCart.itemHorizontalMargin
                        height: idServoRollFFText.height * 1.75

                        Text {
                            id: idServoRollFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoRollModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idServoRollFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoRollModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 4
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idServoPitchModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Servo Pitch')
            titleRightAlignment: false

            Rectangle {
                id: idServoPitchRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idServoPitchModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idServoPitchRectangle.width - idServoPitchModelCart.itemHorizontalMargin
                        height: idServoPitchPText.height * 1.75

                        Text {
                            id: idServoPitchPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoPitchModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idServoPitchPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoPitchModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 3
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idServoPitchRectangle.width - idServoPitchModelCart.itemHorizontalMargin
                        height: idServoPitchIText.height * 1.75

                        Text {
                            id: idServoPitchIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoPitchModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idServoPitchISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoPitchModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.05
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoPitchRectangle.width - idServoPitchModelCart.itemHorizontalMargin
                        height: idServoPitchDText.height * 1.75

                        Text {
                            id: idServoPitchDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoPitchModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idServoPitchDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoPitchModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.2
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoPitchRectangle.width - idServoPitchModelCart.itemHorizontalMargin
                        height: idServoPitchIMAXText.height * 1.75

                        Text {
                            id: idServoPitchIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoPitchModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idServoPitchIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoPitchModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 4500
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idServoPitchRectangle.width - idServoPitchModelCart.itemHorizontalMargin
                        height: idServoPitchFFText.height * 1.75

                        Text {
                            id: idServoPitchFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoPitchModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idServoPitchFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoPitchModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 4
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idServoYawModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Servo Yaw')
            titleRightAlignment: false

            Rectangle {
                id: idServoYawRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idServoYawModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idServoYawRectangle.width - idServoYawModelCart.itemHorizontalMargin
                        height: idServoYawRLLText.height * 1.75

                        Text {
                            id: idServoYawRLLText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoYawModelCart.font
                            text: 'RLL'
                        }

                        ModelSpinBox {
                            id: idServoYawRLLSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoYawModelCart.font
                            editable: true
                            realFrom: 0.8
                            realTo: 1.2
                            realValue: realFrom
                            realStepSize: 0.05
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoYawRectangle.width - idServoYawModelCart.itemHorizontalMargin
                        height: idServoYawINTText.height * 1.75

                        Text {
                            id: idServoYawINTText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoYawModelCart.font
                            text: 'INT'
                        }

                        ModelSpinBox {
                            id: idServoYawINTSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 2
                            realValue: realFrom
                            realStepSize: 0.25
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoYawRectangle.width - idServoYawModelCart.itemHorizontalMargin
                        height: idServoYawDAMPText.height * 1.75

                        Text {
                            id: idServoYawDAMPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoYawModelCart.font
                            text: 'DAMP'
                        }

                        ModelSpinBox {
                            id: idServoYawDAMPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 2
                            realValue: realFrom
                            realStepSize: 0.25
                            decimals: 2
                        }
                    }

                    Item {
                        width: idServoYawRectangle.width - idServoYawModelCart.itemHorizontalMargin
                        height: idServoYawIMAXText.height * 1.75

                        Text {
                            id: idServoYawIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoYawModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idServoYawIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 4500
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idServoYawRectangle.width - idServoYawModelCart.itemHorizontalMargin
                        height: idServoYawSLIPText.height * 1.75

                        Text {
                            id: idServoYawSLIPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idServoYawModelCart.font
                            text: 'SLIP'
                        }

                        ModelSpinBox {
                            id: idServoYawSLIPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idServoYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 4
                            realValue: realFrom
                            realStepSize: 0.25
                            decimals: 2
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idTECSModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('TECS')
            titleRightAlignment: false

            Rectangle {
                id: idTECSRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idTECSModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idTECSRectangle.width - idTECSModelCart.itemHorizontalMargin
                        height: idTECSClimbMaxText.height * 1.75

                        Text {
                            id: idTECSClimbMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idTECSModelCart.font
                            text: 'Climb Max (m/s)'
                        }

                        ModelSpinBox {
                            id: idTECSClimbMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idTECSModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 20
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idTECSRectangle.width - idTECSModelCart.itemHorizontalMargin
                        height: idTECSSinkMinText.height * 1.75

                        Text {
                            id: idTECSSinkMinText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idTECSModelCart.font
                            text: 'Sink Min (m/s)'
                        }

                        ModelSpinBox {
                            id: idTECSSinkMinSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idTECSModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 10
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idTECSRectangle.width - idTECSModelCart.itemHorizontalMargin
                        height: idTECSSinkMaxText.height * 1.75

                        Text {
                            id: idTECSSinkMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idTECSModelCart.font
                            text: 'Sink Max (m/s)'
                        }

                        ModelSpinBox {
                            id: idTECSSinkMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idTECSModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 20
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idTECSRectangle.width - idTECSModelCart.itemHorizontalMargin
                        height: idTECSPitchDampText.height * 1.75

                        Text {
                            id: idTECSPitchDampText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idTECSModelCart.font
                            text: 'Pitch Dampening'
                        }

                        ModelSpinBox {
                            id: idTECSPitchDampSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idTECSModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idTECSRectangle.width - idTECSModelCart.itemHorizontalMargin
                        height: idTECSTimeConstText.height * 1.75

                        Text {
                            id: idTECSTimeConstText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idTECSModelCart.font
                            text: 'Time Const (s)'
                        }

                        ModelSpinBox {
                            id: idTECSTimeConstSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idTECSModelCart.font
                            editable: true
                            realFrom: 3
                            realTo: 10
                            realValue: realFrom
                            realStepSize: 0.2
                            decimals: 1
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idThrottleModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel4ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Throttle')
            titleRightAlignment: false

            Rectangle {
                id: idThrottleRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idThrottleModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel4SpacingGain

                    Item {
                        width: idThrottleRectangle.width - idThrottleModelCart.itemHorizontalMargin
                        height: idThrottleCruisePercentageText.height * 1.75

                        Text {
                            id: idThrottleCruisePercentageText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleModelCart.font
                            text: 'Cruise Percentage'
                        }

                        ModelSpinBox {
                            id: idThrottleCruisePercentageSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idThrottleRectangle.width - idThrottleModelCart.itemHorizontalMargin
                        height: idThrottleMinText.height * 1.75

                        Text {
                            id: idThrottleMinText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleModelCart.font
                            text: 'Min'
                        }

                        ModelSpinBox {
                            id: idThrottleMinSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleModelCart.font
                            editable: true
                            realFrom: -100
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idThrottleRectangle.width - idThrottleModelCart.itemHorizontalMargin
                        height: idThrottleMaxText.height * 1.75

                        Text {
                            id: idThrottleMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleModelCart.font
                            text: 'Max'
                        }

                        ModelSpinBox {
                            id: idThrottleMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idThrottleRectangle.width - idThrottleModelCart.itemHorizontalMargin
                        height: idThrottleSlewRateText.height * 1.75

                        Text {
                            id: idThrottleSlewRateText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleModelCart.font
                            text: 'Slew Rate'
                        }

                        ModelSpinBox {
                            id: idThrottleSlewRateSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 127
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idAirspeedModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel4ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Airspeed')
            titleRightAlignment: false

            Rectangle {
                id: idAirspeedRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idAirspeedModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel4SpacingGain

                    Item {
                        width: idAirspeedRectangle.width - idAirspeedModelCart.itemHorizontalMargin
                        height: idAirspeedTargetText.height * 1.75

                        Text {
                            id: idAirspeedTargetText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idAirspeedModelCart.font
                            text: 'Target'
                        }

                        ModelSpinBox {
                            id: idAirspeedTargetSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idAirspeedModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 65535 // TODO: TRIM_ARSPD_CM has not range in document. Temporarily set to UINT16MAX
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idAirspeedRectangle.width - idAirspeedModelCart.itemHorizontalMargin
                        height: idAirspeedMinText.height * 1.75

                        Text {
                            id: idAirspeedMinText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idAirspeedModelCart.font
                            text: 'Min'
                        }

                        ModelSpinBox {
                            id: idAirspeedMinSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idAirspeedModelCart.font
                            editable: true
                            realFrom: 5
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idAirspeedRectangle.width - idAirspeedModelCart.itemHorizontalMargin
                        height: idAirspeedMaxText.height * 1.75

                        Text {
                            id: idAirspeedMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idAirspeedModelCart.font
                            text: 'Max'
                        }

                        ModelSpinBox {
                            id: idAirspeedMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idAirspeedModelCart.font
                            editable: true
                            realFrom: 5
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idAirspeedRectangle.width - idAirspeedModelCart.itemHorizontalMargin
                        height: idAirspeedRatioText.height * 1.75

                        Text {
                            id: idAirspeedRatioText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idAirspeedModelCart.font
                            text: 'Ratio'
                        }

                        ModelSpinBox {
                            id: idAirspeedRatioSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idAirspeedModelCart.font
                            editable: true
                            realFrom: -32768 // TODO: ARSPD_RATIO has not range in document. Temporarily set to INT16MIN
                            realTo: 32767 // TODO: ARSPD_RATIO has not range in document. Temporarily set to INT16MAX
                            realValue: 0
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idNavigationAnglesModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel4ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Navigation Angles')
            titleRightAlignment: false

            Rectangle {
                id: idNavigationAnglesRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idNavigationAnglesModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel2SpacingGain

                    Item {
                        width: idNavigationAnglesRectangle.width - idNavigationAnglesModelCart.itemHorizontalMargin
                        height: idNavigationAnglesBankMaxText.height * 1.75

                        Text {
                            id: idNavigationAnglesBankMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idNavigationAnglesModelCart.font
                            text: 'Bank Max (deg)'
                        }

                        ModelSpinBox {
                            id: idNavigationAnglesBankMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idNavigationAnglesModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 90
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idNavigationAnglesRectangle.width - idNavigationAnglesModelCart.itemHorizontalMargin
                        height: idNavigationAnglesPitchMinText.height * 1.75

                        Text {
                            id: idNavigationAnglesPitchMinText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idNavigationAnglesModelCart.font
                            text: 'Pitch Min (deg)'
                        }

                        ModelSpinBox {
                            id: idNavigationAnglesPitchMinSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idNavigationAnglesModelCart.font
                            editable: true
                            realFrom: -90
                            realTo: 0
                            realValue: realTo
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idNavigationAnglesRectangle.width - idNavigationAnglesModelCart.itemHorizontalMargin
                        height: idNavigationAnglesPitchMaxText.height * 1.75

                        Text {
                            id: idNavigationAnglesPitchMaxText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idNavigationAnglesModelCart.font
                            text: 'Pitch Max (deg)'
                        }

                        ModelSpinBox {
                            id: idNavigationAnglesPitchMaxSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idNavigationAnglesModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 90
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }
                }
            }
        }

        Item {
            width: idRoot.itemWidth
            height: idRoot.cartModel4ContentHeight

            ModelCart {
                id: idL1ControlModelCart
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: idRoot.cartModel2ContentHeight - (idRoot.rowSpacing * 0.5)
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('L1 Control')
                titleRightAlignment: false

                Rectangle {
                    id: idL1ControlRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idL1ControlModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        anchors.centerIn: parent
                        spacing: parent.height * idRoot.cartModel2SpacingGain

                        Item {
                            width: idL1ControlRectangle.width - idL1ControlModelCart.itemHorizontalMargin
                            height: idL1ControlPeriodText.height * 1.75

                            Text {
                                id: idL1ControlPeriodText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idL1ControlModelCart.font
                                text: 'Period (s)'
                            }

                            ModelSpinBox {
                                id: idL1ControlPeriodSpin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.35
                                height: parent.height
                                font: idL1ControlModelCart.font
                                editable: true
                                realFrom: 1
                                realTo: 60
                                realValue: realFrom
                                realStepSize: 1
                                decimals: 0
                            }
                        }

                        Item {
                            width: idL1ControlRectangle.width - idL1ControlModelCart.itemHorizontalMargin
                            height: idL1ControlDampingText.height * 1.75

                            Text {
                                id: idL1ControlDampingText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idL1ControlModelCart.font
                                text: 'Damping'
                            }

                            ModelSpinBox {
                                id: idL1ControlDampingSpin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.35
                                height: parent.height
                                font: idL1ControlModelCart.font
                                editable: true
                                realFrom: 0.6
                                realTo: 1
                                realValue: realFrom
                                realStepSize: 0.05
                                decimals: 2
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idRudderModelCart
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: idRoot.cartModel1ContentHeight - (idRoot.rowSpacing * 0.5)
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('Rudder')
                titleRightAlignment: false

                Rectangle {
                    id: idRudderRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idRudderModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idRudderRectangle.width - idRudderModelCart.itemHorizontalMargin
                            height: idRudderMixText.height * 1.75

                            Text {
                                id: idRudderMixText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idRudderModelCart.font
                                text: 'Mix'
                            }

                            ModelSpinBox {
                                id: idRudderMixSpin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.35
                                height: parent.height
                                font: idRudderModelCart.font
                                editable: true
                                realFrom: 0
                                realTo: 1
                                realValue: realFrom
                                realStepSize: 0.01
                                decimals: 2
                            }
                        }
                    }
                }
            }
        }

        ObjectRemoteControlOption {
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Remote Control Options')
        }

        ArdupilotPrearmChecks {
            id: idArmingChecks
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            itemHeight: idServoRollPText.height * 1.75
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Arming Checks')
        }

        Item {
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight

            ArdupilotTelemetryConfig {
                id: idTelemetryConfig
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: idRoot.cartModel2ContentHeight
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('تلمتری 1')
                portNumber: 1
            }

            ArdupilotSafetySwitch {
                id: idSafetySwitch
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: idRoot.cartModel1ContentHeight
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('کلید ایمنی')
            }
        }
    }

    function updateSpinBoxes(id, force) {
        if (force || id === 'RLL2SRV_P') idServoRollPSpin.set(ParamService.get('RLL2SRV_P').value)
        if (force || id === 'RLL2SRV_I') idServoRollISpin.set(ParamService.get('RLL2SRV_I').value)
        if (force || id === 'RLL2SRV_D') idServoRollDSpin.set(ParamService.get('RLL2SRV_D').value)
        if (force || id === 'RLL2SRV_IMAX') idServoRollIMAXSpin.set(ParamService.get('RLL2SRV_IMAX').value)
        if (force || id === 'RLL2SRV_FF') idServoRollFFSpin.set(ParamService.get('RLL2SRV_FF').value)

        if (force || id === 'PTCH2SRV_P') idServoPitchPSpin.set(ParamService.get('PTCH2SRV_P').value)
        if (force || id === 'PTCH2SRV_I') idServoPitchISpin.set(ParamService.get('PTCH2SRV_I').value)
        if (force || id === 'PTCH2SRV_D') idServoPitchDSpin.set(ParamService.get('PTCH2SRV_D').value)
        if (force || id === 'PTCH2SRV_IMAX') idServoPitchIMAXSpin.set(ParamService.get('PTCH2SRV_IMAX').value)
        if (force || id === 'PTCH2SRV_FF') idServoPitchFFSpin.set(ParamService.get('PTCH2SRV_FF').value)

        if (force || id === 'YAW2SRV_RLL') idServoYawRLLSpin.set(ParamService.get('YAW2SRV_RLL').value)
        if (force || id === 'YAW2SRV_INT') idServoYawINTSpin.set(ParamService.get('YAW2SRV_INT').value)
        if (force || id === 'YAW2SRV_DAMP') idServoYawDAMPSpin.set(ParamService.get('YAW2SRV_DAMP').value)
        if (force || id === 'YAW2SRV_IMAX') idServoYawIMAXSpin.set(ParamService.get('YAW2SRV_IMAX').value)
        if (force || id === 'YAW2SRV_SLIP') idServoYawSLIPSpin.set(ParamService.get('YAW2SRV_SLIP').value)

        if (force || id === 'TECS_CLMB_MAX') idTECSClimbMaxSpin.set(ParamService.get('TECS_CLMB_MAX').value)
        if (force || id === 'TECS_SINK_MIN') idTECSSinkMinSpin.set(ParamService.get('TECS_SINK_MIN').value)
        if (force || id === 'TECS_SINK_MAX') idTECSSinkMaxSpin.set(ParamService.get('TECS_SINK_MAX').value)
        if (force || id === 'TECS_PTCH_DAMP') idTECSPitchDampSpin.set(ParamService.get('TECS_PTCH_DAMP').value)
        if (force || id === 'TECS_TIME_CONST') idTECSTimeConstSpin.set(ParamService.get('TECS_TIME_CONST').value)

        if (force || id === 'TRIM_THROTTLE') idThrottleCruisePercentageSpin.set(ParamService.get('TRIM_THROTTLE').value)
        if (force || id === 'THR_MIN') idThrottleMinSpin.set(ParamService.get('THR_MIN').value)
        if (force || id === 'THR_MAX') idThrottleMaxSpin.set(ParamService.get('THR_MAX').value)
        if (force || id === 'THR_SLEWRATE') idThrottleSlewRateSpin.set(ParamService.get('THR_SLEWRATE').value)

        if (force || id === 'TRIM_ARSPD_CM') idAirspeedTargetSpin.set(ParamService.get('TRIM_ARSPD_CM').value)
        if (force || id === 'ARSPD_FBW_MIN') idAirspeedMinSpin.set(ParamService.get('ARSPD_FBW_MIN').value)
        if (force || id === 'ARSPD_FBW_MAX') idAirspeedMaxSpin.set(ParamService.get('ARSPD_FBW_MAX').value)
        if (force || id === 'ARSPD_RATIO') idAirspeedRatioSpin.set(ParamService.get('ARSPD_RATIO').value)

        if (force || id === 'LIM_ROLL_CD') idNavigationAnglesBankMaxSpin.set(ParamService.get('LIM_ROLL_CD').value * 0.01)
        if (force || id === 'LIM_PITCH_MIN') idNavigationAnglesPitchMinSpin.set(ParamService.get('LIM_PITCH_MIN').value * 0.01)
        if (force || id === 'LIM_PITCH_MAX') idNavigationAnglesPitchMaxSpin.set(ParamService.get('LIM_PITCH_MAX').value * 0.01)

        if (force || id === 'NAVL1_PERIOD') idL1ControlPeriodSpin.set(ParamService.get('NAVL1_PERIOD').value)
        if (force || id === 'NAVL1_DAMPING') idL1ControlDampingSpin.set(ParamService.get('NAVL1_DAMPING').value)

        if (force || id === 'KFF_RDDRMIX') idRudderMixSpin.set(ParamService.get('KFF_RDDRMIX').value)
    }

    function applyChanges() {
        if (idServoRollPSpin.realValueChanged) {
            idRoot.needApply = true
            idServoRollPSpin.realValueChanged = false
            ParamService.notifyUpload('RLL2SRV_P', idServoRollPSpin.realValue)
        }

        if (idServoRollISpin.realValueChanged) {
            idRoot.needApply = true
            idServoRollISpin.realValueChanged = false
            ParamService.notifyUpload('RLL2SRV_I', idServoRollISpin.realValue)
        }

        if (idServoRollDSpin.realValueChanged) {
            idRoot.needApply = true
            idServoRollDSpin.realValueChanged = false
            ParamService.notifyUpload('RLL2SRV_D', idServoRollDSpin.realValue)
        }

        if (idServoRollIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idServoRollIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('RLL2SRV_IMAX', idServoRollIMAXSpin.realValue)
        }

        if (idServoRollFFSpin.realValueChanged) {
            idRoot.needApply = true
            idServoRollFFSpin.realValueChanged = false
            ParamService.notifyUpload('RLL2SRV_FF', idServoRollFFSpin.realValue)
        }

        if (idServoPitchPSpin.realValueChanged) {
            idRoot.needApply = true
            idServoPitchPSpin.realValueChanged = false
            ParamService.notifyUpload('PTCH2SRV_P', idServoPitchPSpin.realValue)
        }

        if (idServoPitchISpin.realValueChanged) {
            idRoot.needApply = true
            idServoPitchISpin.realValueChanged = false
            ParamService.notifyUpload('PTCH2SRV_I', idServoPitchISpin.realValue)
        }

        if (idServoPitchDSpin.realValueChanged) {
            idRoot.needApply = true
            idServoPitchDSpin.realValueChanged = false
            ParamService.notifyUpload('PTCH2SRV_D', idServoPitchDSpin.realValue)
        }

        if (idServoPitchIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idServoPitchIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('PTCH2SRV_IMAX', idServoPitchIMAXSpin.realValue)
        }

        if (idServoPitchFFSpin.realValueChanged) {
            idRoot.needApply = true
            idServoPitchFFSpin.realValueChanged = false
            ParamService.notifyUpload('PTCH2SRV_FF', idServoPitchFFSpin.realValue)
        }

        if (idServoYawRLLSpin.realValueChanged) {
            idRoot.needApply = true
            idServoYawRLLSpin.realValueChanged = false
            ParamService.notifyUpload('YAW2SRV_RLL', idServoYawRLLSpin.realValue)
        }

        if (idServoYawINTSpin.realValueChanged) {
            idRoot.needApply = true
            idServoYawINTSpin.realValueChanged = false
            ParamService.notifyUpload('YAW2SRV_INT', idServoYawINTSpin.realValue)
        }

        if (idServoYawDAMPSpin.realValueChanged) {
            idRoot.needApply = true
            idServoYawDAMPSpin.realValueChanged = false
            ParamService.notifyUpload('YAW2SRV_DAMP', idServoYawDAMPSpin.realValue)
        }

        if (idServoYawIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idServoYawIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('YAW2SRV_IMAX', idServoYawIMAXSpin.realValue)
        }

        if (idServoYawSLIPSpin.realValueChanged) {
            idRoot.needApply = true
            idServoYawSLIPSpin.realValueChanged = false
            ParamService.notifyUpload('YAW2SRV_SLIP', idServoYawSLIPSpin.realValue)
        }

        if (idTECSClimbMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idTECSClimbMaxSpin.realValueChanged = false
            ParamService.notifyUpload('TECS_CLMB_MAX', idTECSClimbMaxSpin.realValue)
        }

        if (idTECSSinkMinSpin.realValueChanged) {
            idRoot.needApply = true
            idTECSSinkMinSpin.realValueChanged = false
            ParamService.notifyUpload('TECS_SINK_MIN', idTECSSinkMinSpin.realValue)
        }

        if (idTECSSinkMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idTECSSinkMaxSpin.realValueChanged = false
            ParamService.notifyUpload('TECS_SINK_MAX', idTECSSinkMaxSpin.realValue)
        }

        if (idTECSPitchDampSpin.realValueChanged) {
            idRoot.needApply = true
            idTECSPitchDampSpin.realValueChanged = false
            ParamService.notifyUpload('TECS_PTCH_DAMP', idTECSPitchDampSpin.realValue)
        }

        if (idTECSTimeConstSpin.realValueChanged) {
            idRoot.needApply = true
            idTECSTimeConstSpin.realValueChanged = false
            ParamService.notifyUpload('TECS_TIME_CONST', idTECSTimeConstSpin.realValue)
        }

        if (idThrottleCruisePercentageSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleCruisePercentageSpin.realValueChanged = false
            ParamService.notifyUpload('TRIM_THROTTLE', idThrottleCruisePercentageSpin.realValue)
        }

        if (idThrottleMinSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleMinSpin.realValueChanged = false
            ParamService.notifyUpload('THR_MIN', idThrottleMinSpin.realValue)
        }

        if (idThrottleMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleMaxSpin.realValueChanged = false
            ParamService.notifyUpload('THR_MAX', idThrottleMaxSpin.realValue)
        }

        if (idThrottleSlewRateSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleSlewRateSpin.realValueChanged = false
            ParamService.notifyUpload('THR_SLEWRATE', idThrottleSlewRateSpin.realValue)
        }

        if (idAirspeedTargetSpin.realValueChanged) {
            idRoot.needApply = true
            idAirspeedTargetSpin.realValueChanged = false
            ParamService.notifyUpload('TRIM_ARSPD_CM', idAirspeedTargetSpin.realValue)
        }

        if (idAirspeedMinSpin.realValueChanged) {
            idRoot.needApply = true
            idAirspeedMinSpin.realValueChanged = false
            ParamService.notifyUpload('ARSPD_FBW_MIN', idAirspeedMinSpin.realValue)
        }

        if (idAirspeedMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idAirspeedMaxSpin.realValueChanged = false
            ParamService.notifyUpload('ARSPD_FBW_MAX', idAirspeedMaxSpin.realValue)
        }

        if (idAirspeedRatioSpin.realValueChanged) {
            idRoot.needApply = true
            idAirspeedRatioSpin.realValueChanged = false
            ParamService.notifyUpload('ARSPD_RATIO', idAirspeedRatioSpin.realValue)
        }

        if (idNavigationAnglesBankMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idNavigationAnglesBankMaxSpin.realValueChanged = false
            ParamService.notifyUpload('LIM_ROLL_CD', idNavigationAnglesBankMaxSpin.realValue * 100)
        }

        if (idNavigationAnglesPitchMinSpin.realValueChanged) {
            idRoot.needApply = true
            idNavigationAnglesPitchMinSpin.realValueChanged = false
            ParamService.notifyUpload('LIM_PITCH_MIN', idNavigationAnglesPitchMinSpin.realValue * 100)
        }

        if (idNavigationAnglesPitchMaxSpin.realValueChanged) {
            idRoot.needApply = true
            idNavigationAnglesPitchMaxSpin.realValueChanged = false
            ParamService.notifyUpload('LIM_PITCH_MAX', idNavigationAnglesPitchMaxSpin.realValue * 100)
        }

        if (idL1ControlPeriodSpin.realValueChanged) {
            idRoot.needApply = true
            idL1ControlPeriodSpin.realValueChanged = false
            ParamService.notifyUpload('NAVL1_PERIOD', idL1ControlPeriodSpin.realValue)
        }

        if (idL1ControlDampingSpin.realValueChanged) {
            idRoot.needApply = true
            idL1ControlDampingSpin.realValueChanged = false
            ParamService.notifyUpload('NAVL1_DAMPING', idL1ControlDampingSpin.realValue)
        }

        if (idRudderMixSpin.realValueChanged) {
            idRoot.needApply = true
            idRudderMixSpin.realValueChanged = false
            ParamService.notifyUpload('KFF_RDDRMIX', idRudderMixSpin.realValue)
        }

        if (idArmingChecks.applyChanges()) {
            idRoot.needApply = true
        }

        if (idSafetySwitch.applyChanges()) {
            idRoot.needApply = true
        }
    }

    Connections {
        target: ParamService

        onNotifyDownloadComplete: {
            if (variable.getText('AIRCRAFT_TYPE') !== 'FIXEDWING') {
                return
            }

            idRoot.updateSpinBoxes('N/A', true)
            idArmingChecks.updateChecks(ParamService.get('ARMING_CHECK').value, true)
            idTelemetryConfig.update()
            idSafetySwitch.update()
        }

        onNotifyChanges: {
            if (variable.getText('AIRCRAFT_TYPE') !== 'FIXEDWING') {
                return
            }

            let id = param.id

            idRoot.updateSpinBoxes(id, false)

            if (id.indexOf('RC') !== -1 && id.indexOf('_OPTION') !== -1) {
                idRoot.needApply = true
            }

            if (id === 'ARMING_CHECK') {
                idArmingChecks.updateChecks(param.value, true)
            }

            if (id.indexOf('SERIAL') !== -1 && (id.indexOf('_PROTOCOL') !== -1 || id.indexOf('_BAUD') !== -1)) {
                idTelemetryConfig.update()
                idRoot.needApply = true
            }

            if (id === 'BRD_SAFETYENABLE') {
                idSafetySwitch.update()
            }

            if (idRoot.needApply) {
                idRoot.needApply = false

                if (idRoot.visible) {
                    toast.info(qsTr('تغییرات اعمال شد'), 5000)
                }
            }
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                idRoot.needApply = false

                idServoRollPSpin.reset()
                idServoRollISpin.reset()
                idServoRollDSpin.reset()
                idServoRollIMAXSpin.reset()
                idServoRollFFSpin.reset()

                idServoPitchPSpin.reset()
                idServoPitchISpin.reset()
                idServoPitchDSpin.reset()
                idServoPitchIMAXSpin.reset()
                idServoPitchFFSpin.reset()

                idServoYawRLLSpin.reset()
                idServoYawINTSpin.reset()
                idServoYawDAMPSpin.reset()
                idServoYawIMAXSpin.reset()
                idServoYawSLIPSpin.reset()

                idTECSClimbMaxSpin.reset()
                idTECSSinkMinSpin.reset()
                idTECSSinkMaxSpin.reset()
                idTECSPitchDampSpin.reset()
                idTECSTimeConstSpin.reset()

                idThrottleCruisePercentageSpin.reset()
                idThrottleMinSpin.reset()
                idThrottleMaxSpin.reset()
                idThrottleSlewRateSpin.reset()

                idAirspeedTargetSpin.reset()
                idAirspeedMinSpin.reset()
                idAirspeedMaxSpin.reset()
                idAirspeedRatioSpin.reset()

                idNavigationAnglesBankMaxSpin.reset()
                idNavigationAnglesPitchMinSpin.reset()
                idNavigationAnglesPitchMaxSpin.reset()

                idL1ControlPeriodSpin.reset()
                idL1ControlDampingSpin.reset()

                idRudderMixSpin.reset()

                idArmingChecks.reset()

                idTelemetryConfig.reset()

                idSafetySwitch.reset()
            }
        }
    }
}
