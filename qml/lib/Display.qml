import QtQuick 2.12
import QtQuick.Window 2.12


QtObject {
    readonly property int displayWidth: Screen.width
    readonly property int displayHeight: Screen.height
    readonly property real minimumWidth: displayWidth * 0.5625
    readonly property real minimumHeight: displayHeight * 0.6019
    readonly property real displayDPI: Screen.pixelDensity / 0.0393700787401575
    readonly property real displaySize: Math.sqrt((displayWidth * displayWidth) + (displayHeight * displayHeight)) / displayDPI
    readonly property real displayOffset: 10
    readonly property bool isLargeDisplay: displaySize > displayOffset
    readonly property real fontScale: displaySize * 0.5 / 72 * displayDPI

    function getScaledWidth(desktop, mobile) {
        return Screen.width * (isLargeDisplay ? desktop : mobile)
    }

    function getScaledHeight(desktop, mobile) {
        return Screen.height * (isLargeDisplay ? desktop : mobile)
    }

    function getFontScale(desktop, mobile) {
        return fontScale * (isLargeDisplay ? desktop : mobile)
    }
}
