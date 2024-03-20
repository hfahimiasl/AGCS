import QtQuick 2.12
import QtQuick.Controls 2.12
import QtPositioning 5.12

import '../model'
import 'qrc:/js/Js.js' as Js


Item {
    id: idRoot
    width: idDisplay.getScaledWidth(0.15, 0.35)
    height: idDisplay.isLargeDisplay ? idRoot.minimumHeight : parent.height * 0.75
    clip: true
    visible: idRoot.active

    property bool active: false

    readonly property real itemHeight: idDisplay.getScaledHeight(0.03, 0.09)
    readonly property real itemSpacing: idDisplay.getScaledHeight(0.0075, 0.0225)
    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1, 2.25)

    readonly property string agriculturePatternName: qsTr('کشاورزی')
    readonly property string photographyPatternName: qsTr('عکس برداری')
    readonly property bool isAgriculturePattern: idPatternTypeComboBox.currentText === idRoot.agriculturePatternName
    readonly property bool isPhotographyPattern: idPatternTypeComboBox.currentText === idRoot.photographyPatternName

    readonly property string photographyAutoCalc: qsTr('اطلاعات دوربین')
    readonly property string photographyManualCalc: qsTr('دستی')
    readonly property bool isphotographyAutoCalc: idPhotographyCalcTypeComboBox.currentText === idRoot.photographyAutoCalc
    readonly property bool isPhotographyManualCalc: idPhotographyCalcTypeComboBox.currentText === idRoot.photographyManualCalc

    readonly property real minimumHeight: idFlickable.anchors.topMargin
                                          + idFlickable.anchors.bottomMargin
                                          + idPatternTypeItem.height
                                          + idAltitudeItem.height
                                          + idSpeedItem.height
                                          + idAngleItem.height
                                          + idItem1.height
                                          + idItem2.height
                                          + idItem3.height
                                          + idItem4.height
                                          + idButtons.height
                                          + idRoot.itemSpacing * 7

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: idBackground
        anchors.fill: parent
        radius: 5
        opacity: 0.875
        color: theme.backgroundDark
    }

    ScrollView {
        id: idScrollView
        anchors.top: parent.top
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    }

    Flickable {
        id: idFlickable
        anchors.top: parent.top
        anchors.bottom: idButtons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        contentWidth: idColumn.width
        contentHeight: idColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            parent: idFlickable.parent
            anchors.top: idFlickable.top
            anchors.bottom: idFlickable.bottom
            anchors.left: idFlickable.right
            policy: idDisplay.isLargeDisplay
                    ? (idRoot.isAgriculturePattern
                       ? ScrollBar.AsNeeded
                       : idRoot.isPhotographyManualCalc
                         ? ScrollBar.AsNeeded
                         : ScrollBar.AlwaysOn)
                    : ScrollBar.AlwaysOn
        }

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: idRoot.itemSpacing

            Item {
                id: idPatternTypeItem
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idPatternTypeText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: qsTr('نوع')
                }

                ModelCombobox {
                    id: idPatternTypeComboBox
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: idPatternTypeText.left
                    anchors.rightMargin: parent.width * 0.05
                    font.pixelSize: idRoot.fontPixelSize
                    model: [idRoot.agriculturePatternName, idRoot.photographyPatternName]
                    editable: true

                    onCurrentTextChanged: {
                        idRoot.resetTextFieldsBorderColor()
                        idRoot.resetTextFieldsText()
                    }
                }
            }

            Item {
                id: idAltitudeItem
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%1 %2  %3').arg(idAltitudeSlider.value.toFixed(1)).arg('m').arg(qsTr('ارتفاع'))
                }

                ModelSlider {
                    id: idAltitudeSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.575
                    height: idDisplay.getScaledWidth(0.0125, 0.03)
                    from: 0.5
                    to: idRoot.isAgriculturePattern ? 20.0 : 200.0
                    stepSize: 0.1
                    value: 5

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idSpeedItem
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%1 %2  %3').arg(idSpeedSlider.value.toFixed(1)).arg('m/s').arg(qsTr('سرعت'))
                }

                ModelSlider {
                    id: idSpeedSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAltitudeSlider.width
                    height: idAltitudeSlider.height
                    from: 0.1
                    to: idRoot.isAgriculturePattern ? 10.0 : 20.0
                    stepSize: 0.1
                    value: 5

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idAngleItem
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%1 %2  %3').arg(idAngleSlider.value.toFixed(1)).arg('deg').arg(qsTr('زاویه'))
                }

                ModelSlider {
                    id: idAngleSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAltitudeSlider.width
                    height: idAltitudeSlider.height
                    from: 0
                    to: 359.9
                    stepSize: 0.1

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idItem1
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%1 %2  %3').arg(idBoomSlider.value.toFixed(1)).arg('m').arg(qsTr('طول بوم'))
                    visible: idRoot.isAgriculturePattern
                }

                ModelSlider {
                    id: idBoomSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idAltitudeSlider.width
                    height: idAltitudeSlider.height
                    from: 0.5
                    to: 10
                    stepSize: 0.1
                    value: 1
                    visible: idRoot.isAgriculturePattern

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }

                ModelCombobox {
                    id: idPhotographyCalcTypeComboBox
                    anchors.fill: parent
                    font.pixelSize: idRoot.fontPixelSize
                    model: [idRoot.photographyAutoCalc, idRoot.photographyManualCalc]
                    editable: true
                    visible: idRoot.isPhotographyPattern

                    onCurrentTextChanged: {
                        idItem2TextField.text = ''
                        idWidthSensorOrDistanceTextField.text = ''
                        idFocalLengthTextField.text = ''
                        idImageHeightTextField.text = ''
                        idImageWidthTextField.text = ''
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idItem2
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idItem2Text
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: idRoot.isAgriculturePattern ? qsTr('خروجی نازل') : (idRoot.isphotographyAutoCalc ? qsTr('طول سنسور') : qsTr('فاصله طولی'))
                }

                ModelTextfield {
                    id: idItem2TextField
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: idRoot.isAgriculturePattern ? idItem2Text.left : undefined
                    anchors.rightMargin: idRoot.isAgriculturePattern ? parent.width * 0.05 : undefined
                    width: idRoot.isPhotographyPattern ? idFocalLengthTextField.width : undefined
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: idRoot.isAgriculturePattern ? qsTr('شماره کانال') : (idRoot.isphotographyAutoCalc ? qsTr('میلی متر') : qsTr('متر'))
                    validator: RegExpValidator {
                        regExp: idRoot.isAgriculturePattern ? (/^(?!(0))\d{1,2}/) : (idRoot.isphotographyAutoCalc ? (/^(?!(0))\d{1,2}(\.\d{1})?$/) : (/^(?!(0))\d{1,3}(\.\d{1})?$/))
                    }
                    onTextChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idItem3
                width: idFlickable.width
                height: idRoot.itemHeight

                Text {
                    id: idItem3Text
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: idRoot.isAgriculturePattern ? ('%2  %1').arg(idMinOutputSlider.value.toFixed(0)).arg(qsTr('حداقل خروجی')) : (idRoot.isphotographyAutoCalc ? qsTr('عرض سنسور') : qsTr('فاصله عرضی'))
                }

                ModelSlider {
                    id: idMinOutputSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.5
                    height: idAltitudeSlider.height
                    from: 800
                    to: 2200
                    stepSize: 1
                    value: 1000
                    visible: idRoot.isAgriculturePattern

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }

                ModelTextfield {
                    id: idWidthSensorOrDistanceTextField
                    height: parent.height
                    anchors.left: parent.left
                    width: idFocalLengthTextField.width
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: idRoot.isphotographyAutoCalc ? qsTr('میلی متر') : qsTr('متر')
                    visible: idRoot.isPhotographyPattern
                    validator: RegExpValidator {
                        regExp: idRoot.isphotographyAutoCalc ? (/^(?!(0))\d{1,2}(\.\d{1})?$/) : (/^(?!(0))\d{1,3}(\.\d{1})?$/)
                    }
                    onTextChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idItem4
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isAgriculturePattern || (idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc)

                Text {
                    id: idItem4Text
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: idRoot.isAgriculturePattern ? ('%2  %1').arg(idMaxOutputSlider.value.toFixed(0)).arg(qsTr('حداکثر خروجی')) : qsTr('فاصله کانونی')
                }

                ModelSlider {
                    id: idMaxOutputSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.5
                    height: idAltitudeSlider.height
                    from: 800
                    to: 2200
                    stepSize: 1
                    value: 2000
                    visible: idRoot.isAgriculturePattern

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }

                ModelTextfield {
                    id: idFocalLengthTextField
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: idItem4Text.left
                    anchors.rightMargin: parent.width * 0.05
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('میلی متر')
                    visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc
                    validator: RegExpValidator {
                        regExp: /^(?!(0))\d{1,2}(\.\d{1})?$/
                    }

                    onTextChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idImageHeightItem
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: qsTr('طول عکس')
                }

                ModelTextfield {
                    id: idImageHeightTextField
                    height: parent.height
                    anchors.left: parent.left
                    width: idFocalLengthTextField.width
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('پیکسل')
                    validator: RegExpValidator {
                        regExp: /^(?!(0))\d{1,5}/
                    }

                    onTextChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idImageWidthItem
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: qsTr('عرض عکس')
                }

                ModelTextfield {
                    id: idImageWidthTextField
                    height: parent.height
                    anchors.left: parent.left
                    width: idFocalLengthTextField.width
                    font.pixelSize: idRoot.fontPixelSize
                    placeholderText: qsTr('پیکسل')
                    validator: RegExpValidator {
                        regExp: /^(?!(0))\d{1,5}/
                    }

                    onTextChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idHeightOverlapSliderItem
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%2  %%1').arg(idHeightOverlapSlider.value.toFixed(0)).arg(qsTr('همپوشانی طولی'))
                }

                ModelSlider {
                    id: idHeightOverlapSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.425
                    height: idAltitudeSlider.height
                    from: 50
                    to: 80
                    stepSize: 1

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idWidthOverlapSliderItem
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%2  %%1').arg(idWidthOverlapSlider.value.toFixed(0)).arg(qsTr('همپوشانی عرضی'))
                }

                ModelSlider {
                    id: idWidthOverlapSlider
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: idHeightOverlapSlider.width
                    height: idHeightOverlapSlider.height
                    from: 50
                    to: 80
                    stepSize: 1

                    onValueChanged: {
                        idRoot.updatePatternInfo()
                    }
                }
            }

            Item {
                id: idHeightGSD
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    id: idHeightGSDText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%2 %1').arg('GSD').arg(qsTr('طولی'))
                }

                Text {
                    height: idRoot.itemHeight
                    anchors.left: parent.left
                    width: idWidthGSDValue.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: {
                        if (idItem2TextField.text === '' || idFocalLengthTextField.text === '' || idImageHeightTextField.text === '') {
                            'N/A'

                        } else {
                            (idAltitudeSlider.value * 100.0 * parseFloat(idItem2TextField.text) / (parseFloat(idFocalLengthTextField.text) * parseFloat(idImageHeightTextField.text))).toFixed(5)
                        }
                    }
                }
            }

            Item {
                id: idWidthGSD
                width: idFlickable.width
                height: idRoot.itemHeight
                visible: idRoot.isPhotographyPattern && idRoot.isphotographyAutoCalc

                Text {
                    id: idWidthGSDText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    fontSizeMode: Text.Fit
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: ('%2 %1').arg('GSD').arg(qsTr('عرضی'))
                }

                Text {
                    id: idWidthGSDValue
                    height: idRoot.itemHeight
                    anchors.left: parent.left
                    anchors.right: idWidthGSDText.left
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: idRoot.fontFamily
                    font.pixelSize: idRoot.fontPixelSize
                    color: theme.text
                    text: {
                        if (idWidthSensorOrDistanceTextField.text === '' || idFocalLengthTextField.text === '' || idImageWidthTextField.text === '') {
                            'N/A'

                        } else {
                            (idAltitudeSlider.value * 100.0 * parseFloat(idWidthSensorOrDistanceTextField.text) / (parseFloat(idFocalLengthTextField.text) * parseFloat(idImageWidthTextField.text))).toFixed(5)
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
        height: idDisplay.getScaledHeight(0.03, 0.09)

        Rectangle {
            id: idHorizontalLine
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: theme.background
        }

        Rectangle {
            id: idVerticalLine
            anchors.top: idHorizontalLine.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: idHorizontalLine.horizontalCenter
            width: idHorizontalLine.height
            color: idHorizontalLine.color
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idVerticalLine.right
            anchors.right: idHorizontalLine.right

            Text {
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('تولید')
            }

            onClicked: {
                idRoot.resetTextFieldsBorderColor()

                if (idRoot.isAgriculturePattern) {
                    if (!idItem2TextField.text) {
                        idItem2TextField.borderColor = 'red'
                        toast.error(qsTr('شماره کانال را وارد کنید'), 5000)
                        return
                    }

                    PatternService.renderAgriculturePattern()
                    idRoot.exit()

                } else if (idRoot.isPhotographyPattern) {
                    let ok = true

                    if (!idItem2TextField.text) {
                        idItem2TextField.borderColor = 'red'
                        ok = false
                    }

                    if (!idWidthSensorOrDistanceTextField.text) {
                        idWidthSensorOrDistanceTextField.borderColor = 'red'
                        ok = false
                    }

                    if (idRoot.isphotographyAutoCalc) {
                        if (!idFocalLengthTextField.text) {
                            idFocalLengthTextField.borderColor = 'red'
                            ok = false
                        }

                        if (!idImageHeightTextField.text) {
                            idImageHeightTextField.borderColor = 'red'
                            ok = false
                        }

                        if (!idImageWidthTextField.text) {
                            idImageWidthTextField.borderColor = 'red'
                            ok = false
                        }
                    }

                    if (ok) {
                        PatternService.renderPhotographyPattern()
                        idRoot.exit()

                    } else {
                        toast.error(qsTr('اطلاعات را کامل کنید'), 5000)
                    }
                }
            }
        }

        MouseArea {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: idHorizontalLine.left
            anchors.right: idVerticalLine.left

            Text {
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                idRoot.exit()
            }
        }
    }

    onActiveChanged: {
        PatternService.clear()

        if (active) {
            let reversed_zoom = Js.map(idMapObject.zoomLevel, 15.0, 20.0, 85.0, 15.0)
            let latitude = idMapObject.center.latitude
            let longitude = idMapObject.center.longitude
            let latitude_gain = reversed_zoom * 0.000025
            let longitude_gain = reversed_zoom * 0.000065

            let corner = [
                    [latitude + latitude_gain, longitude - longitude_gain],
                    [latitude + latitude_gain, longitude + longitude_gain],
                    [latitude - latitude_gain, longitude + longitude_gain],
                    [latitude - latitude_gain, longitude - longitude_gain]
                ]

            for (let i=0 ; i<corner.length ; i++) {
                PatternService.appendCorner(QtPositioning.coordinate(corner[i][0], corner[i][1]))
            }
        }
    }

    onIsAgriculturePatternChanged: {
        if (idRoot.isAgriculturePattern) {
            idRoot.updateAgricultureInfo()
        }
    }

    onIsPhotographyPatternChanged: {
        if (idRoot.isPhotographyPattern) {
            idRoot.updatePhotographyInfo()
        }
    }

    function updateAgricultureInfo() {
        let info = PatternService.getAgricultureInfo()
        info.altitude = idAltitudeSlider.value
        info.speed = idSpeedSlider.value
        info.angle = idAngleSlider.value
        info.boomLength = idBoomSlider.value
        info.nozzleChannel = parseInt(idItem2TextField.text)
        info.nozzleMin = idMinOutputSlider.value
        info.nozzleMax = idMaxOutputSlider.value
        PatternService.updateAgricultureInfo()
    }

    function updatePhotographyInfo() {
        let info = PatternService.getPhotographyInfo()
        info.altitude = idAltitudeSlider.value
        info.speed = idSpeedSlider.value
        info.angle = idAngleSlider.value

        if (idRoot.isphotographyAutoCalc) {
            info.spacing = PatternService.photographyCalculation(info.altitude,
                                                                 parseFloat(idWidthSensorOrDistanceTextField.text),
                                                                 parseFloat(idFocalLengthTextField.text),
                                                                 idWidthOverlapSlider.value)

            info.cameraTriggerDistance = PatternService.photographyCalculation(info.altitude,
                                                                               parseFloat(idItem2TextField.text),
                                                                               parseFloat(idFocalLengthTextField.text),
                                                                               idHeightOverlapSlider.value)

        } else {
            info.spacing = parseFloat(idWidthSensorOrDistanceTextField.text)
            info.cameraTriggerDistance = parseFloat(idItem2TextField.text)
        }

        PatternService.updatePhotographyInfo()
    }

    function updatePatternInfo() {
        if (idRoot.isAgriculturePattern) {
            idRoot.updateAgricultureInfo()

        } else if (idRoot.isPhotographyPattern) {
            idRoot.updatePhotographyInfo()
        }
    }

    function resetTextFieldsBorderColor() {
        idItem2TextField.resetBorderColor()
        idWidthSensorOrDistanceTextField.resetBorderColor()
        idFocalLengthTextField.resetBorderColor()
        idImageHeightTextField.resetBorderColor()
        idImageWidthTextField.resetBorderColor()
    }

    function resetTextFieldsText() {
        idItem2TextField.text = ''
        idWidthSensorOrDistanceTextField.text = ''
        idFocalLengthTextField.text = ''
        idImageHeightTextField.text = ''
        idImageWidthTextField.text = ''
    }

    function exit() {
        idRoot.active = false
    }
}
