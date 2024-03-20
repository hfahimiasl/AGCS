import QtQuick 2.12


Item {
    id: idRoot

    property var pixelSize: idDisplay.getFontScale(1, 1)

    property var presentOffset: undefined
    property var enabledOffset: undefined
    property var healthOffset: undefined
    property var nameMargin: undefined

    property var present: 'N/A'
    property var enable: 'N/A'
    property var health: 'N/A'
    property var name: 'N/A'

    Text {
        anchors.right: idRoot.right
        anchors.rightMargin: idRoot.nameMargin
        anchors.verticalCenter: idRoot.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: theme.text
        fontSizeMode: Text.Fit
        font.family: font_fa_medium.name
        font.pixelSize: idRoot.pixelSize
        text: idRoot.name
    }

//    Text {
//        anchors.centerIn: idRoot
//        anchors.horizontalCenterOffset: idRoot.presentOffset
//        verticalAlignment: Text.AlignVCenter
//        horizontalAlignment: Text.AlignRight
//        color: text === 'N/A' ? theme.text : (text === '\uf00c' ? theme.primary : 'red')
//        fontSizeMode: Text.Fit
//        font.family: fontAwesome.name
//        font.pixelSize: idRoot.pixelSize
//        text: idRoot.present
//    }

    Text {
        anchors.centerIn: idRoot
        anchors.horizontalCenterOffset: idRoot.enabledOffset
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: text === 'N/A' ? theme.text : (text === '\uf00c' ? theme.primary : 'red')
        fontSizeMode: Text.Fit
        font.family: fontAwesome.name
        font.pixelSize: idRoot.pixelSize
        text: idRoot.enable
    }

    Text {
        anchors.centerIn: idRoot
        anchors.horizontalCenterOffset: idRoot.healthOffset
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: text === 'N/A' ? theme.text : (text === '\uf00c' ? theme.primary : 'red')
        fontSizeMode: Text.Fit
        font.family: fontAwesome.name
        font.pixelSize: idRoot.pixelSize
        text: idRoot.health
    }

    function update(base_name) {
        let present = (variable.getValue(base_name + '_PRESENT') !== 0)

        idRoot.visible = present
        idRoot.present = present ? '\uf00c' : '\uf00d'
        idRoot.enable = (variable.getValue(base_name + '_ENABLED') !== 0) ? '\uf00c' : '\uf00d'
        idRoot.health = (variable.getValue(base_name + '_HEALTH') !== 0) ? '\uf00c' : '\uf00d'
    }

    function reset() {
        idRoot.visible = true
        idRoot.present = 'N/A'
        idRoot.enable = 'N/A'
        idRoot.health = 'N/A'
    }
}
