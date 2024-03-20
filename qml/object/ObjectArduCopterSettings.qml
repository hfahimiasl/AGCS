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
            id: idStabilizeRollModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel2ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Stabilize Roll (Error to Rate)')
            titleRightAlignment: false

            Rectangle {
                id: idStabilizeRollRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idStabilizeRollModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel2SpacingGain

                    Item {
                        width: idStabilizeRollRectangle.width - idStabilizeRollModelCart.itemHorizontalMargin
                        height: idStabilizeRollPText.height * 1.75

                        Text {
                            id: idStabilizeRollPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizeRollModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idStabilizeRollPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizeRollModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 12
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idStabilizeRollRectangle.width - idStabilizeRollModelCart.itemHorizontalMargin
                        height: idStabilizeRollACCELMAText.height * 1.75

                        Text {
                            id: idStabilizeRollACCELMAText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizeRollModelCart.font
                            text: 'ACCEL MA'
                        }

                        ModelSpinBox {
                            id: idStabilizeRollACCELMASpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizeRollModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 180000
                            realValue: realFrom
                            realStepSize: 1000
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idStabilizePitchModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel2ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Stabilize Pitch (Error to Rate)')
            titleRightAlignment: false

            Rectangle {
                id: idStabilizePitchRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idStabilizePitchModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel2SpacingGain

                    Item {
                        width: idStabilizePitchRectangle.width - idStabilizePitchModelCart.itemHorizontalMargin
                        height: idStabilizePitchPText.height * 1.75

                        Text {
                            id: idStabilizePitchPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizePitchModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idStabilizePitchPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizePitchModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 12
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idStabilizePitchRectangle.width - idStabilizePitchModelCart.itemHorizontalMargin
                        height: idStabilizePitchACCELMAText.height * 1.75

                        Text {
                            id: idStabilizePitchACCELMAText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizePitchModelCart.font
                            text: 'ACCEL MA'
                        }

                        ModelSpinBox {
                            id: idStabilizePitchACCELMASpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizePitchModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 180000
                            realValue: realFrom
                            realStepSize: 1000
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idStabilizeYawModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel2ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Stabilize Yaw (Error to Rate)')
            titleRightAlignment: false

            Rectangle {
                id: idStabilizeYawRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idStabilizeYawModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel2SpacingGain

                    Item {
                        width: idStabilizeYawRectangle.width - idStabilizeYawModelCart.itemHorizontalMargin
                        height: idStabilizeYawPText.height * 1.75

                        Text {
                            id: idStabilizeYawPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizeYawModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idStabilizeYawPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizeYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 6
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idStabilizeYawRectangle.width - idStabilizeYawModelCart.itemHorizontalMargin
                        height: idStabilizeYawACCELMAText.height * 1.75

                        Text {
                            id: idStabilizeYawACCELMAText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idStabilizeYawModelCart.font
                            text: 'ACCEL MA'
                        }

                        ModelSpinBox {
                            id: idStabilizeYawACCELMASpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idStabilizeYawModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 72000
                            realValue: realFrom
                            realStepSize: 1000
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idPositionXYModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel2ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Position XY (Dist to Speed)')
            titleRightAlignment: false

            Rectangle {
                id: idPositionXYRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idPositionXYModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel2SpacingGain

                    Item {
                        width: idPositionXYRectangle.width - idPositionXYModelCart.itemHorizontalMargin
                        height: idPositionXYPText.height * 1.75

                        Text {
                            id: idPositionXYPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPositionXYModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idPositionXYPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPositionXYModelCart.font
                            editable: true
                            realFrom: 0.5
                            realTo: 2
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idPositionXYRectangle.width - idPositionXYModelCart.itemHorizontalMargin
                        height: idPositionXYInputTCText.height * 1.75

                        Text {
                            id: idPositionXYInputTCText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPositionXYModelCart.font
                            text: 'INPUT TC'
                        }

                        ModelSpinBox {
                            id: idPositionXYInputTCSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPositionXYModelCart.font
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

        ModelCart {
            id: idRollRateModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Rate Roll')
            titleRightAlignment: false

            Rectangle {
                id: idRollRateRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idRollRateModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idRollRateRectangle.width - idRollRateModelCart.itemHorizontalMargin
                        height: idRollRatePText.height * 1.75

                        Text {
                            id: idRollRatePText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idRollRateModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idRollRatePSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idRollRateModelCart.font
                            editable: true
                            realFrom: 0.01
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.005
                            decimals: 3
                        }
                    }

                    Item {
                        width: idRollRateRectangle.width - idRollRateModelCart.itemHorizontalMargin
                        height: idRollRateIText.height * 1.75

                        Text {
                            id: idRollRateIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idRollRateModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idRollRateISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idRollRateModelCart.font
                            editable: true
                            realFrom: 0.01
                            realTo: 2
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idRollRateRectangle.width - idRollRateModelCart.itemHorizontalMargin
                        height: idRollRateDText.height * 1.75

                        Text {
                            id: idRollRateDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idRollRateModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idRollRateDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idRollRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.05
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }

                    Item {
                        width: idRollRateRectangle.width - idRollRateModelCart.itemHorizontalMargin
                        height: idRollRateIMAXText.height * 1.75

                        Text {
                            id: idRollRateIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idRollRateModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idRollRateIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idRollRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idRollRateRectangle.width - idRollRateModelCart.itemHorizontalMargin
                        height: idRollRateFFText.height * 1.75

                        Text {
                            id: idRollRateFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idRollRateModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idRollRateFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idRollRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idPitchRateModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Rate Pitch')
            titleRightAlignment: false

            Rectangle {
                id: idPitchRateRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idPitchRateModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idPitchRateRectangle.width - idPitchRateModelCart.itemHorizontalMargin
                        height: idPitchRatePText.height * 1.75

                        Text {
                            id: idPitchRatePText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPitchRateModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idPitchRatePSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPitchRateModelCart.font
                            editable: true
                            realFrom: 0.01
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.005
                            decimals: 3
                        }
                    }

                    Item {
                        width: idPitchRateRectangle.width - idPitchRateModelCart.itemHorizontalMargin
                        height: idPitchRateIText.height * 1.75

                        Text {
                            id: idPitchRateIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPitchRateModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idPitchRateISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPitchRateModelCart.font
                            editable: true
                            realFrom: 0.01
                            realTo: 2
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idPitchRateRectangle.width - idPitchRateModelCart.itemHorizontalMargin
                        height: idPitchRateDText.height * 1.75

                        Text {
                            id: idPitchRateDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPitchRateModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idPitchRateDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPitchRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.05
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }

                    Item {
                        width: idPitchRateRectangle.width - idPitchRateModelCart.itemHorizontalMargin
                        height: idPitchRateIMAXText.height * 1.75

                        Text {
                            id: idPitchRateIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPitchRateModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idPitchRateIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPitchRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idPitchRateRectangle.width - idPitchRateModelCart.itemHorizontalMargin
                        height: idPitchRateFFText.height * 1.75

                        Text {
                            id: idPitchRateFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idPitchRateModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idPitchRateFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idPitchRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idYawRateModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Rate Yaw')
            titleRightAlignment: false

            Rectangle {
                id: idYawRateRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idYawRateModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idYawRateRectangle.width - idYawRateModelCart.itemHorizontalMargin
                        height: idYawRatePText.height * 1.75

                        Text {
                            id: idYawRatePText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idYawRateModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idYawRatePSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idYawRateModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 2.5
                            realValue: realFrom
                            realStepSize: 0.005
                            decimals: 3
                        }
                    }

                    Item {
                        width: idYawRateRectangle.width - idYawRateModelCart.itemHorizontalMargin
                        height: idYawRateIText.height * 1.75

                        Text {
                            id: idYawRateIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idYawRateModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idYawRateISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idYawRateModelCart.font
                            editable: true
                            realFrom: 0.01
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idYawRateRectangle.width - idYawRateModelCart.itemHorizontalMargin
                        height: idYawRateDText.height * 1.75

                        Text {
                            id: idYawRateDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idYawRateModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idYawRateDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idYawRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.02
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }

                    Item {
                        width: idYawRateRectangle.width - idYawRateModelCart.itemHorizontalMargin
                        height: idYawRateIMAXText.height * 1.75

                        Text {
                            id: idYawRateIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idYawRateModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idYawRateIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idYawRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idYawRateRectangle.width - idYawRateModelCart.itemHorizontalMargin
                        height: idYawRateFFText.height * 1.75

                        Text {
                            id: idYawRateFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idYawRateModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idYawRateFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idYawRateModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idVelocityXYModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Velocity XY (Vel to Accel)')
            titleRightAlignment: false

            Rectangle {
                id: idVelocityXYRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idVelocityXYModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idVelocityXYRectangle.width - idVelocityXYModelCart.itemHorizontalMargin
                        height: idVelocityXYPText.height * 1.75

                        Text {
                            id: idVelocityXYPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idVelocityXYModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idVelocityXYPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idVelocityXYModelCart.font
                            editable: true
                            realFrom: 0.1
                            realTo: 6
                            realValue: realFrom
                            realStepSize: 0.1
                            decimals: 1
                        }
                    }

                    Item {
                        width: idVelocityXYRectangle.width - idVelocityXYModelCart.itemHorizontalMargin
                        height: idVelocityXYIText.height * 1.75

                        Text {
                            id: idVelocityXYIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idVelocityXYModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idVelocityXYISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idVelocityXYModelCart.font
                            editable: true
                            realFrom: 0.02
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idVelocityXYRectangle.width - idVelocityXYModelCart.itemHorizontalMargin
                        height: idVelocityXYDText.height * 1.75

                        Text {
                            id: idVelocityXYDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idVelocityXYModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idVelocityXYDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idVelocityXYModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
                        }
                    }

                    Item {
                        width: idVelocityXYRectangle.width - idVelocityXYModelCart.itemHorizontalMargin
                        height: idVelocityXYIMAXText.height * 1.75

                        Text {
                            id: idVelocityXYIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idVelocityXYModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idVelocityXYIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idVelocityXYModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 4500
                            realValue: realFrom
                            realStepSize: 10
                            decimals: 0
                        }
                    }

                    Item {
                        width: idVelocityXYRectangle.width - idVelocityXYModelCart.itemHorizontalMargin
                        height: idVelocityXYFILTText.height * 1.75

                        Text {
                            id: idVelocityXYFILTText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idVelocityXYModelCart.font
                            text: 'FILT'
                        }

                        ModelSpinBox {
                            id: idVelocityXYFILTSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idVelocityXYModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 100
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idWPNavModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('WPNav (cm\'s)')
            titleRightAlignment: false

            Rectangle {
                id: idWPNavRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idWPNavModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idWPNavRectangle.width - idWPNavModelCart.itemHorizontalMargin
                        height: idWPNavSpeedText.height * 1.75

                        Text {
                            id: idWPNavSpeedText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idWPNavModelCart.font
                            text: 'Speed'
                        }

                        ModelSpinBox {
                            id: idWPNavSpeedSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idWPNavModelCart.font
                            editable: true
                            realFrom: 20
                            realTo: 2000
                            realValue: realFrom
                            realStepSize: 50
                            decimals: 0
                        }
                    }

                    Item {
                        width: idWPNavRectangle.width - idWPNavModelCart.itemHorizontalMargin
                        height: idWPNavRadiusText.height * 1.75

                        Text {
                            id: idWPNavRadiusText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idWPNavModelCart.font
                            text: 'Radius'
                        }

                        ModelSpinBox {
                            id: idWPNavRadiusSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idWPNavModelCart.font
                            editable: true
                            realFrom: 5
                            realTo: 1000
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idWPNavRectangle.width - idWPNavModelCart.itemHorizontalMargin
                        height: idWPNavSpeedUpText.height * 1.75

                        Text {
                            id: idWPNavSpeedUpText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idWPNavModelCart.font
                            text: 'Speed Up'
                        }

                        ModelSpinBox {
                            id: idWPNavSpeedUpSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idWPNavModelCart.font
                            editable: true
                            realFrom: 10
                            realTo: 1000
                            realValue: realFrom
                            realStepSize: 50
                            decimals: 0
                        }
                    }

                    Item {
                        width: idWPNavRectangle.width - idWPNavModelCart.itemHorizontalMargin
                        height: idWPNavSpeedDownText.height * 1.75

                        Text {
                            id: idWPNavSpeedDownText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idWPNavModelCart.font
                            text: 'Speed Down'
                        }

                        ModelSpinBox {
                            id: idWPNavSpeedDownSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idWPNavModelCart.font
                            editable: true
                            realFrom: 10
                            realTo: 500
                            realValue: realFrom
                            realStepSize: 10
                            decimals: 0
                        }
                    }

                    Item {
                        width: idWPNavRectangle.width - idWPNavModelCart.itemHorizontalMargin
                        height: idWPNavLoiterSpeedText.height * 1.75

                        Text {
                            id: idWPNavLoiterSpeedText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idWPNavModelCart.font
                            text: 'Loiter Speed'
                        }

                        ModelSpinBox {
                            id: idWPNavLoiterSpeedSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idWPNavModelCart.font
                            editable: true
                            realFrom: 20
                            realTo: 2000
                            realValue: realFrom
                            realStepSize: 50
                            decimals: 0
                        }
                    }
                }
            }
        }

        ModelCart {
            id: idThrottleAccelModelCart
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            font.family: idRoot.fontFamily
            font.pixelSize: idRoot.fontPixelSize
            tittle: qsTr('Throttle Accel (Accel to Motor)')
            titleRightAlignment: false

            Rectangle {
                id: idThrottleAccelRectangle
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: idThrottleAccelModelCart.itemVerticalMargin
                color: theme.backgroundLight

                Column {
                    anchors.centerIn: parent
                    spacing: parent.height * idRoot.cartModel5SpacingGain

                    Item {
                        width: idThrottleAccelRectangle.width - idThrottleAccelModelCart.itemHorizontalMargin
                        height: idThrottleAccelPText.height * 1.75

                        Text {
                            id: idThrottleAccelPText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleAccelModelCart.font
                            text: 'P'
                        }

                        ModelSpinBox {
                            id: idThrottleAccelPSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleAccelModelCart.font
                            editable: true
                            realFrom: 0.5
                            realTo: 1.5
                            realValue: realFrom
                            realStepSize: 0.05
                            decimals: 2
                        }
                    }

                    Item {
                        width: idThrottleAccelRectangle.width - idThrottleAccelModelCart.itemHorizontalMargin
                        height: idThrottleAccelIText.height * 1.75

                        Text {
                            id: idThrottleAccelIText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleAccelModelCart.font
                            text: 'I'
                        }

                        ModelSpinBox {
                            id: idThrottleAccelISpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleAccelModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 3
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idThrottleAccelRectangle.width - idThrottleAccelModelCart.itemHorizontalMargin
                        height: idThrottleAccelDText.height * 1.75

                        Text {
                            id: idThrottleAccelDText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleAccelModelCart.font
                            text: 'D'
                        }

                        ModelSpinBox {
                            id: idThrottleAccelDSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleAccelModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.4
                            realValue: realFrom
                            realStepSize: 0.01
                            decimals: 2
                        }
                    }

                    Item {
                        width: idThrottleAccelRectangle.width - idThrottleAccelModelCart.itemHorizontalMargin
                        height: idThrottleAccelIMAXText.height * 1.75

                        Text {
                            id: idThrottleAccelIMAXText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleAccelModelCart.font
                            text: 'IMAX'
                        }

                        ModelSpinBox {
                            id: idThrottleAccelIMAXSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleAccelModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 1000
                            realValue: realFrom
                            realStepSize: 1
                            decimals: 0
                        }
                    }

                    Item {
                        width: idThrottleAccelRectangle.width - idThrottleAccelModelCart.itemHorizontalMargin
                        height: idThrottleAccelFFText.height * 1.75

                        Text {
                            id: idThrottleAccelFFText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            color: theme.text
                            fontSizeMode: Text.Fit
                            font: idThrottleAccelModelCart.font
                            text: 'FF'
                        }

                        ModelSpinBox {
                            id: idThrottleAccelFFSpin
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.35
                            height: parent.height
                            font: idThrottleAccelModelCart.font
                            editable: true
                            realFrom: 0
                            realTo: 0.5
                            realValue: realFrom
                            realStepSize: 0.001
                            decimals: 3
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

        Item {
            width: idRoot.itemWidth
            height: idThrottleAccelModelCart.height

            readonly property real itemHeight: (height * 0.5) - (idRoot.rowSpacing * 1.5)

            ModelCart {
                id: idAltitudeHoldModelCart
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.itemHeight
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('Altitude Hold (Alt to Climbrate)')
                titleRightAlignment: false

                Rectangle {
                    id: idAltitudeHoldRectangle
                    anchors.fill: parent
                    anchors.topMargin: idAltitudeHoldModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idAltitudeHoldRectangle.width - idAltitudeHoldModelCart.itemHorizontalMargin
                            height: idAltitudeHoldPText.height * 1.75

                            Text {
                                id: idAltitudeHoldPText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idAltitudeHoldModelCart.font
                                text: 'P'
                            }

                            ModelSpinBox {
                                id: idAltitudeHoldPSpin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.35
                                height: parent.height
                                font: idAltitudeHoldModelCart.font
                                editable: true
                                realFrom: 1
                                realTo: 3
                                realValue: realFrom
                                realStepSize: 0.01
                                decimals: 2
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idThrottleRateModelCart
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.itemHeight
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                tittle: qsTr('Throttle Rate (VSpd to Accel)')
                titleRightAlignment: false

                Rectangle {
                    id: idThrottleRateRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idThrottleRateModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        anchors.centerIn: parent

                        Item {
                            width: idThrottleRateRectangle.width - idThrottleRateModelCart.itemHorizontalMargin
                            height: idThrottleRatePText.height * 1.75

                            Text {
                                id: idThrottleRatePText
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idThrottleRateModelCart.font
                                text: 'P'
                            }

                            ModelSpinBox {
                                id: idThrottleRatePSpin
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.35
                                height: parent.height
                                font: idThrottleRateModelCart.font
                                editable: true
                                realFrom: 1
                                realTo: 8
                                realValue: realFrom
                                realStepSize: 0.01
                                decimals: 2
                            }
                        }
                    }
                }
            }
        }

        ArdupilotPrearmChecks {
            id: idArmingChecks
            width: idRoot.itemWidth
            height: idRoot.cartModel5ContentHeight
            itemHeight: idThrottleAccelFFText.height * 1.75
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
        if (force || id === 'ATC_ANG_RLL_P') idStabilizeRollPSpin.set(ParamService.get('ATC_ANG_RLL_P').value)
        if (force || id === 'ATC_ACCEL_R_MAX') idStabilizeRollACCELMASpin.set(ParamService.get('ATC_ACCEL_R_MAX').value)

        if (force || id === 'ATC_ANG_PIT_P') idStabilizePitchPSpin.set(ParamService.get('ATC_ANG_PIT_P').value)
        if (force || id === 'ATC_ACCEL_P_MAX') idStabilizePitchACCELMASpin.set(ParamService.get('ATC_ACCEL_P_MAX').value)

        if (force || id === 'ATC_ANG_YAW_P') idStabilizeYawPSpin.set(ParamService.get('ATC_ANG_YAW_P').value)
        if (force || id === 'ATC_ACCEL_Y_MAX') idStabilizeYawACCELMASpin.set(ParamService.get('ATC_ACCEL_Y_MAX').value)

        if (force || id === 'PSC_POSXY_P') idPositionXYPSpin.set(ParamService.get('PSC_POSXY_P').value)
        if (force || id === 'ATC_INPUT_TC') idPositionXYInputTCSpin.set(ParamService.get('ATC_INPUT_TC').value)

        if (force || id === 'ATC_RAT_RLL_P') idRollRatePSpin.set(ParamService.get('ATC_RAT_RLL_P').value)
        if (force || id === 'ATC_RAT_RLL_I') idRollRateISpin.set(ParamService.get('ATC_RAT_RLL_I').value)
        if (force || id === 'ATC_RAT_RLL_D') idRollRateDSpin.set(ParamService.get('ATC_RAT_RLL_D').value)
        if (force || id === 'ATC_RAT_RLL_IMAX') idRollRateIMAXSpin.set(ParamService.get('ATC_RAT_RLL_IMAX').value)
        if (force || id === 'ATC_RAT_RLL_FF') idRollRateFFSpin.set(ParamService.get('ATC_RAT_RLL_FF').value)

        if (force || id === 'ATC_RAT_PIT_P') idPitchRatePSpin.set(ParamService.get('ATC_RAT_PIT_P').value)
        if (force || id === 'ATC_RAT_PIT_I') idPitchRateISpin.set(ParamService.get('ATC_RAT_PIT_I').value)
        if (force || id === 'ATC_RAT_PIT_D') idPitchRateDSpin.set(ParamService.get('ATC_RAT_PIT_D').value)
        if (force || id === 'ATC_RAT_PIT_IMAX') idPitchRateIMAXSpin.set(ParamService.get('ATC_RAT_PIT_IMAX').value)
        if (force || id === 'ATC_RAT_PIT_FF') idPitchRateFFSpin.set(ParamService.get('ATC_RAT_PIT_FF').value)

        if (force || id === 'ATC_RAT_YAW_P') idYawRatePSpin.set(ParamService.get('ATC_RAT_YAW_P').value)
        if (force || id === 'ATC_RAT_YAW_I') idYawRateISpin.set(ParamService.get('ATC_RAT_YAW_I').value)
        if (force || id === 'ATC_RAT_YAW_D') idYawRateDSpin.set(ParamService.get('ATC_RAT_YAW_D').value)
        if (force || id === 'ATC_RAT_YAW_IMAX') idYawRateIMAXSpin.set(ParamService.get('ATC_RAT_YAW_IMAX').value)
        if (force || id === 'ATC_RAT_YAW_FF') idYawRateFFSpin.set(ParamService.get('ATC_RAT_YAW_FF').value)

        if (force || id === 'PSC_VELXY_P') idVelocityXYPSpin.set(ParamService.get('PSC_VELXY_P').value)
        if (force || id === 'PSC_VELXY_I') idVelocityXYISpin.set(ParamService.get('PSC_VELXY_I').value)
        if (force || id === 'PSC_VELXY_D') idVelocityXYDSpin.set(ParamService.get('PSC_VELXY_D').value)
        if (force || id === 'PSC_VELXY_IMAX') idVelocityXYIMAXSpin.set(ParamService.get('PSC_VELXY_IMAX').value)
        if (force || id === 'PSC_VELXY_FILT') idVelocityXYFILTSpin.set(ParamService.get('PSC_VELXY_FILT').value)

        if (force || id === 'WPNAV_SPEED') idWPNavSpeedSpin.set(ParamService.get('WPNAV_SPEED').value)
        if (force || id === 'WPNAV_RADIUS') idWPNavRadiusSpin.set(ParamService.get('WPNAV_RADIUS').value)
        if (force || id === 'WPNAV_SPEED_UP') idWPNavSpeedUpSpin.set(ParamService.get('WPNAV_SPEED_UP').value)
        if (force || id === 'WPNAV_SPEED_DN') idWPNavSpeedDownSpin.set(ParamService.get('WPNAV_SPEED_DN').value)
        if (force || id === 'LOIT_SPEED') idWPNavLoiterSpeedSpin.set(ParamService.get('LOIT_SPEED').value)

        if (force || id === 'PSC_ACCZ_P') idThrottleAccelPSpin.set(ParamService.get('PSC_ACCZ_P').value)
        if (force || id === 'PSC_ACCZ_I') idThrottleAccelISpin.set(ParamService.get('PSC_ACCZ_I').value)
        if (force || id === 'PSC_ACCZ_D') idThrottleAccelDSpin.set(ParamService.get('PSC_ACCZ_D').value)
        if (force || id === 'PSC_ACCZ_IMAX') idThrottleAccelIMAXSpin.set(ParamService.get('PSC_ACCZ_IMAX').value)
        if (force || id === 'PSC_ACCZ_FF') idThrottleAccelFFSpin.set(ParamService.get('PSC_ACCZ_FF').value)

        if (force || id === 'PSC_POSZ_P') idAltitudeHoldPSpin.set(ParamService.get('PSC_POSZ_P').value)

        if (force || id === 'PSC_VELZ_P') idThrottleRatePSpin.set(ParamService.get('PSC_VELZ_P').value)
    }

    function applyChanges() {
        if (idStabilizeRollPSpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizeRollPSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ANG_RLL_P', idStabilizeRollPSpin.realValue)
        }

        if (idStabilizeRollACCELMASpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizeRollACCELMASpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ACCEL_R_MAX', idStabilizeRollACCELMASpin.realValue)
        }

        if (idStabilizePitchPSpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizePitchPSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ANG_PIT_P', idStabilizePitchPSpin.realValue)
        }

        if (idStabilizePitchACCELMASpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizePitchACCELMASpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ACCEL_P_MAX', idStabilizePitchACCELMASpin.realValue)
        }

        if (idStabilizeYawPSpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizeYawPSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ANG_YAW_P', idStabilizeYawPSpin.realValue)
        }

        if (idStabilizeYawACCELMASpin.realValueChanged) {
            idRoot.needApply = true
            idStabilizeYawACCELMASpin.realValueChanged = false
            ParamService.notifyUpload('ATC_ACCEL_Y_MAX', idStabilizeYawACCELMASpin.realValue)
        }

        if (idPositionXYPSpin.realValueChanged) {
            idRoot.needApply = true
            idPositionXYPSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_POSXY_P', idPositionXYPSpin.realValue)
        }

        if (idPositionXYInputTCSpin.realValueChanged) {
            idRoot.needApply = true
            idPositionXYInputTCSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_INPUT_TC', idPositionXYInputTCSpin.realValue)
        }

        if (idRollRatePSpin.realValueChanged) {
            idRoot.needApply = true
            idRollRatePSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_RLL_P', idRollRatePSpin.realValue)
        }

        if (idRollRateISpin.realValueChanged) {
            idRoot.needApply = true
            idRollRateISpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_RLL_I', idRollRateISpin.realValue)
        }

        if (idRollRateDSpin.realValueChanged) {
            idRoot.needApply = true
            idRollRateDSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_RLL_D', idRollRateDSpin.realValue)
        }

        if (idRollRateIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idRollRateIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_RLL_IMAX', idRollRateIMAXSpin.realValue)
        }

        if (idRollRateFFSpin.realValueChanged) {
            idRoot.needApply = true
            idRollRateFFSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_RLL_FF', idRollRateFFSpin.realValue)
        }

        if (idPitchRatePSpin.realValueChanged) {
            idRoot.needApply = true
            idPitchRatePSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_PIT_P', idPitchRatePSpin.realValue)
        }

        if (idPitchRateISpin.realValueChanged) {
            idRoot.needApply = true
            idPitchRateISpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_PIT_I', idPitchRateISpin.realValue)
        }

        if (idPitchRateDSpin.realValueChanged) {
            idRoot.needApply = true
            idPitchRateDSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_PIT_D', idPitchRateDSpin.realValue)
        }

        if (idPitchRateIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idPitchRateIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_PIT_IMAX', idPitchRateIMAXSpin.realValue)
        }

        if (idPitchRateFFSpin.realValueChanged) {
            idRoot.needApply = true
            idPitchRateFFSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_PIT_FF', idPitchRateFFSpin.realValue)
        }

        if (idYawRatePSpin.realValueChanged) {
            idRoot.needApply = true
            idYawRatePSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_YAW_P', idYawRatePSpin.realValue)
        }

        if (idYawRateISpin.realValueChanged) {
            idRoot.needApply = true
            idYawRateISpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_YAW_I', idYawRateISpin.realValue)
        }

        if (idYawRateDSpin.realValueChanged) {
            idRoot.needApply = true
            idYawRateDSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_YAW_D', idYawRateDSpin.realValue)
        }

        if (idYawRateIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idYawRateIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_YAW_IMAX', idYawRateIMAXSpin.realValue)
        }

        if (idYawRateFFSpin.realValueChanged) {
            idRoot.needApply = true
            idYawRateFFSpin.realValueChanged = false
            ParamService.notifyUpload('ATC_RAT_YAW_FF', idYawRateFFSpin.realValue)
        }

        if (idVelocityXYPSpin.realValueChanged) {
            idRoot.needApply = true
            idVelocityXYPSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELXY_P', idVelocityXYPSpin.realValue)
        }

        if (idVelocityXYISpin.realValueChanged) {
            idRoot.needApply = true
            idVelocityXYISpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELXY_I', idVelocityXYISpin.realValue)
        }

        if (idVelocityXYDSpin.realValueChanged) {
            idRoot.needApply = true
            idVelocityXYDSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELXY_D', idVelocityXYDSpin.realValue)
        }

        if (idVelocityXYIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idVelocityXYIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELXY_IMAX', idVelocityXYIMAXSpin.realValue)
        }

        if (idVelocityXYFILTSpin.realValueChanged) {
            idRoot.needApply = true
            idVelocityXYFILTSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELXY_FILT', idVelocityXYFILTSpin.realValue)
        }

        if (idWPNavSpeedSpin.realValueChanged) {
            idRoot.needApply = true
            idWPNavSpeedSpin.realValueChanged = false
            ParamService.notifyUpload('WPNAV_SPEED', idWPNavSpeedSpin.realValue)
        }

        if (idWPNavRadiusSpin.realValueChanged) {
            idRoot.needApply = true
            idWPNavRadiusSpin.realValueChanged = false
            ParamService.notifyUpload('WPNAV_RADIUS', idWPNavRadiusSpin.realValue)
        }

        if (idWPNavSpeedUpSpin.realValueChanged) {
            idRoot.needApply = true
            idWPNavSpeedUpSpin.realValueChanged = false
            ParamService.notifyUpload('WPNAV_SPEED_UP', idWPNavSpeedUpSpin.realValue)
        }

        if (idWPNavSpeedDownSpin.realValueChanged) {
            idRoot.needApply = true
            idWPNavSpeedDownSpin.realValueChanged = false
            ParamService.notifyUpload('WPNAV_SPEED_DN', idWPNavSpeedDownSpin.realValue)
        }

        if (idWPNavLoiterSpeedSpin.realValueChanged) {
            idRoot.needApply = true
            idWPNavLoiterSpeedSpin.realValueChanged = false
            ParamService.notifyUpload('LOIT_SPEED', idWPNavLoiterSpeedSpin.realValue)
        }

        if (idThrottleAccelPSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleAccelPSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_ACCZ_P', idThrottleAccelPSpin.realValue)
        }

        if (idThrottleAccelISpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleAccelISpin.realValueChanged = false
            ParamService.notifyUpload('PSC_ACCZ_I', idThrottleAccelISpin.realValue)
        }

        if (idThrottleAccelDSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleAccelDSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_ACCZ_D', idThrottleAccelDSpin.realValue)
        }

        if (idThrottleAccelIMAXSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleAccelIMAXSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_ACCZ_IMAX', idThrottleAccelIMAXSpin.realValue)
        }

        if (idThrottleAccelFFSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleAccelFFSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_ACCZ_FF', idThrottleAccelFFSpin.realValue)
        }

        if (idAltitudeHoldPSpin.realValueChanged) {
            idRoot.needApply = true
            idAltitudeHoldPSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_POSZ_P', idAltitudeHoldPSpin.realValue)
        }

        if (idThrottleRatePSpin.realValueChanged) {
            idRoot.needApply = true
            idThrottleRatePSpin.realValueChanged = false
            ParamService.notifyUpload('PSC_VELZ_P', idThrottleRatePSpin.realValue)
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
            if (variable.getText('AIRCRAFT_TYPE') !== 'MULTIROTOR') {
                return
            }

            idRoot.updateSpinBoxes('N/A', true)
            idArmingChecks.updateChecks(ParamService.get('ARMING_CHECK').value, true)
            idTelemetryConfig.update()
            idSafetySwitch.update()
        }

        onNotifyChanges: {
            if (variable.getText('AIRCRAFT_TYPE') !== 'MULTIROTOR') {
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

                idStabilizeRollPSpin.reset()
                idStabilizeRollACCELMASpin.reset()

                idStabilizePitchPSpin.reset()
                idStabilizePitchACCELMASpin.reset()

                idStabilizeYawPSpin.reset()
                idStabilizeYawACCELMASpin.reset()

                idPositionXYPSpin.reset()
                idPositionXYInputTCSpin.reset()

                idRollRatePSpin.reset()
                idRollRateISpin.reset()
                idRollRateDSpin.reset()
                idRollRateIMAXSpin.reset()
                idRollRateFFSpin.reset()

                idPitchRatePSpin.reset()
                idPitchRateISpin.reset()
                idPitchRateDSpin.reset()
                idPitchRateIMAXSpin.reset()
                idPitchRateFFSpin.reset()

                idYawRatePSpin.reset()
                idYawRateISpin.reset()
                idYawRateDSpin.reset()
                idYawRateIMAXSpin.reset()
                idYawRateFFSpin.reset()

                idVelocityXYPSpin.reset()
                idVelocityXYISpin.reset()
                idVelocityXYDSpin.reset()
                idVelocityXYIMAXSpin.reset()
                idVelocityXYFILTSpin.reset()

                idWPNavSpeedSpin.reset()
                idWPNavRadiusSpin.reset()
                idWPNavSpeedUpSpin.reset()
                idWPNavSpeedDownSpin.reset()
                idWPNavLoiterSpeedSpin.reset()

                idThrottleAccelPSpin.reset()
                idThrottleAccelISpin.reset()
                idThrottleAccelDSpin.reset()
                idThrottleAccelIMAXSpin.reset()
                idThrottleAccelFFSpin.reset()

                idAltitudeHoldPSpin.reset()

                idThrottleRatePSpin.reset()

                idArmingChecks.reset()

                idTelemetryConfig.reset()

                idSafetySwitch.reset()
            }
        }
    }
}
