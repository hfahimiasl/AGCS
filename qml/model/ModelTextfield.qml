import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12


TextField {
    id: idRoot

    property color backgroundColor: theme.backgroundLight
//    property var lastDisplayText: 0
//    property int counter: 0
//    property bool lock: false
//    property int signalCount: 1 // This value explains how many signals are emitted when the value changes

    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    font.family: font_fa_medium.name
    font.pixelSize: idDisplay.getFontScale(1, 1)

    //TODO : find wat to set font.size dynamicly with textfiled size. pn: set font.size to idRoot.height*X does not work
    color: theme.text
    placeholderText: ''
    validator: IntValidator {}
    selectByMouse: true
    selectionColor: theme.primary

    property color borderColor: idRoot.backgroundColor

    background: Rectangle {
        id: textFieldBackground
        color: idRoot.backgroundColor
        border.color: idRoot.borderColor
        anchors.fill: parent
        radius: 5
    }

    function resetBorderColor() {
        idRoot.borderColor = idRoot.backgroundColor
    }

    onBackgroundColorChanged: {
        idRoot.resetBorderColor()
    }

//    onDisplayTextChanged: {
//        if (idRoot.lastDisplayText !== idRoot.displayText && idRoot.counter === idRoot.signalCount) {
//            idRoot.lastDisplayText = idRoot.displayText
//            idRoot.lock = true
//            textFieldBackground.color = theme.primary
//        }

//        if (!idRoot.lock) {
//            idRoot.counter++
//        }
//    }

//    onEditingFinished: {
//        idRoot.lock = false
//        idRoot.counter = 0
//        textFieldBackground.color = idRoot.backgroundColor
//    }

//    onBackgroundColorChanged: {
//        textFieldBackground.color = idRoot.backgroundColor
//    }

//    Connections {
//        target: link
//        onConnectionChanged: {
//            if (!connected) {
//                idRoot.lock = false
//                idRoot.counter = 0
//                textFieldBackground.color = idRoot.backgroundColor
//            }
//        }
//    }

//    Component.onCompleted: {
//        idRoot.lastDisplayText = idRoot.displayText
//    }
}
