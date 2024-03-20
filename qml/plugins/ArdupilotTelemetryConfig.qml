import QtQuick 2.12

import '../model'


ModelCart {
    id: idRoot
    property int portNumber: 1

    Rectangle {
        id: idRectangle
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: idRoot.itemVerticalMargin
        anchors.horizontalCenter: parent.horizontalCenter
        width: idRoot.width - idRoot.itemHorizontalMargin - idRoot.leftPadding - idRoot.rightPadding
        color: theme.backgroundLight

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: parent.height * 0.075

            Item {
                width: idRectangle.width
                height: idProtocolText.height * 1.75

                Text {
                    id: idProtocolText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: qsTr('پروتکل')
                }

                ModelCombobox {
                    id: idProtocolComboBox
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.65
                    height: parent.height
                    font: idRoot.font
                    editable: true

                    model: ListModel {
                        id: idProtocolListModel
                    }

                    contentItem: Text {
                        id: idProtocolComboBoxText
                        text: 'N/A'
                        color: theme.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideMiddle
                        anchors.verticalCenter: parent.verticalCenter
                        font: parent.font
                        fontSizeMode: Text.Fit
                        anchors.rightMargin: 10
                        anchors.right: parent.right
                        anchors.leftMargin: 25
                        anchors.left: parent.left
                    }

                    onPressedChanged: {
                        idProtocolListModel.clear()

                        if (link.isConnected()) {
                            let protocols = autopilot.getAllTelemProtocols()

                            for (let i=0 ; i<protocols.length ; i++) {
                                idProtocolListModel.append({ protocol: protocols[i] })
                            }
                        }
                    }

                    onCurrentTextChanged: {
                        if (link.isConnected() && idProtocolComboBox.currentText !== '' && idProtocolComboBox.currentText.indexOf('N/A') === -1) {
                            autopilot.setTelemProtocol(idRoot.portNumber, idProtocolComboBox.currentText)
                        }
                    }
                }
            }

            Item {
                width: idRectangle.width
                height: idBaudRateText.height * 1.75

                Text {
                    id: idBaudRateText
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    color: theme.text
                    fontSizeMode: Text.Fit
                    font: idRoot.font
                    text: qsTr('سرعت')
                }

                ModelCombobox {
                    id: idBaudRateComboBox
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.65
                    height: parent.height
                    font: idRoot.font
                    editable: true

                    model: ListModel {
                        id: idBaudRateListModel
                    }

                    contentItem: Text {
                        id: idBaudRateComboBoxText
                        text: 'N/A'
                        color: theme.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideMiddle
                        anchors.verticalCenter: parent.verticalCenter
                        font: parent.font
                        fontSizeMode: Text.Fit
                        anchors.rightMargin: 10
                        anchors.right: parent.right
                        anchors.leftMargin: 25
                        anchors.left: parent.left
                    }

                    onPressedChanged: {
                        idBaudRateListModel.clear()

                        if (link.isConnected()) {
                            let baudrates = autopilot.getAllTelemBaudRates()

                            for (let i=0 ; i<baudrates.length ; i++) {
                                idBaudRateListModel.append({ baudrate: baudrates[i] })
                            }
                        }
                    }

                    onCurrentTextChanged: {
                        if (link.isConnected() && idBaudRateComboBox.currentText !== '' && idBaudRateComboBox.currentText.indexOf('N/A') === -1) {
                            autopilot.setTelemBaudRate(idRoot.portNumber, idBaudRateComboBox.currentText)
                        }
                    }
                }
            }
        }
    }

    function update() {
        idProtocolComboBoxText.text = autopilot.getTelemProtocol(idRoot.portNumber)
        idBaudRateComboBoxText.text = autopilot.getTelemBaudRate(idRoot.portNumber)
    }

    function reset() {
        idProtocolListModel.clear()
        idBaudRateListModel.clear()
        idProtocolComboBoxText.text = 'N/A'
        idBaudRateComboBoxText.text = 'N/A'
    }
}
