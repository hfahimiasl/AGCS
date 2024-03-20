import QtQuick 2.12
import QtQuick.Controls 2.12


SpinBox {
    id: idRoot

    property color colorText: theme.text
    property color colorButton: theme.textDark
    property color backgroundColor: theme.backgroundLight
    property color backgroundColorButton: theme.backgroundDark

    font.family: font_fa_medium.name
    font.pixelSize: idDisplay.getFontScale(1, 1)

    up.indicator: Rectangle {
        id: idUp
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: parent.width * 0.25
        color: idRoot.up.pressed ? idRoot.backgroundColor : idRoot.backgroundColorButton

        Text {
            text: '\uf105'
            font.pixelSize: idRoot.font.pixelSize
            color: idRoot.colorButton
            anchors.fill: parent
            font.family: fontAwesome.name
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        id: idDown
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: parent.width * 0.25
        color: idRoot.down.pressed ? idRoot.backgroundColor : idRoot.backgroundColorButton

        Text {
            text: '\uf104'
            font.pixelSize: idRoot.font.pixelSize
            color: idRoot.colorButton
            anchors.fill: parent
            font.family: fontAwesome.name
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    background: Rectangle {
        color: idRoot.backgroundColor
    }

    contentItem: ModelTextfield {
        anchors.left: idDown.right
        anchors.right: idUp.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        font.pixelSize: idRoot.font.pixelSize
        font.family: idRoot.font.family
        text: textFromValue(idRoot.value, idRoot.locale)
        validator: DoubleValidator {}
        backgroundColor: idRoot.backgroundColor
        readOnly: !idRoot.editable
//        signalCount: 2
    }

    property bool init: false
    property bool lock: false

    property real realFrom: -1.0
    property real realTo: 1.0
    property real realStepSize: 0.1
    property real realValue: 0
    property int decimals: 1

    readonly property int factor: Math.pow(10, Math.max(idRoot.decimals, 0))

    property bool realValueChanged: false

    from: idRoot.realFrom * idRoot.factor
    to: idRoot.realTo * idRoot.factor
    stepSize: idRoot.realStepSize * idRoot.factor
    value: idRoot.realValue * idRoot.factor
    editable: true

    validator: DoubleValidator {
        bottom: Math.min(idRoot.from, idRoot.to)
        top: Math.max(idRoot.from, idRoot.to)
    }

    textFromValue: function(_value, _locale) {
        return Number(_value / idRoot.factor).toLocaleString(_locale, 'f', idRoot.decimals)
    }

    valueFromText: function(_text, _locale) {
        idRoot.lock = true
        idRoot.value = 0
        idRoot.lock = false
        return Number.fromLocaleString(_locale, _text) * idRoot.factor
    }

    onValueChanged: {
        if (!idRoot.lock && idRoot.init) {
            idRoot.realValue = idRoot.value / idRoot.factor
        }
    }

    function set(_value) {
        idRoot.lock = true
        idRoot.value = _value * idRoot.factor
        idRoot.lock = false
    }

    function reset() {
        idRoot.set(idRoot.realFrom)
        realValueChanged = false
    }

    Component.onCompleted: {
        idRoot.init = true
    }

    onRealValueChanged: {
        realValueChanged = idRoot.init && true
    }
}
