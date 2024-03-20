import QtQuick 2.12

import '../model'


ModelCart {
    id: idRoot
    titleRightAlignment: false

    Column {
        id: idColumn
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: idRoot.itemVerticalMargin
        anchors.horizontalCenter: parent.horizontalCenter
        width: idRoot.width - idRoot.itemHorizontalMargin - idRoot.leftPadding - idRoot.rightPadding

        Repeater {
            model: 5

            delegate: Item {
                id: idItem
                anchors.left: idColumn.left
                anchors.right: idColumn.right
                height: idColumn.height / 5

                property string currentText: ''

                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    elide: Text.ElideRight
                    fontSizeMode: Text.Fit
                    color: theme.text
                    font: idRoot.font
                    text: ('CH %1 Opt').arg(model.index + 7)
                }

                ModelCombobox {
                    id: idComboBox
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.6
                    height: parent.height * 0.85
                    font: idRoot.font
                    editable: true
                    rightAlignment: false

                    model: ListModel {
                        id: idListModel
                    }

                    contentItem: Text {
                        id: idComboBoxText
                        text: 'N/A'
                        color: theme.text
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideMiddle
                        anchors.verticalCenter: parent.verticalCenter
                        font: parent.font
                        fontSizeMode: Text.Fit
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        anchors.rightMargin: 25
                    }

                    onPressedChanged: {
                        idListModel.clear()

                        if (link.isConnected()) {
                            let options = autopilot.getAllRemoteControlOptions()

                            for (let i=0 ; i<options.length ; i++) {
                                idListModel.append({ option : options[i] })
                            }
                        }
                    }

                    onCurrentTextChanged: {
                        idItem.currentText = idComboBox.currentText
                    }
                }

                onCurrentTextChanged: {
                    if (link.isConnected() && idItem.currentText !== '' && idItem.currentText.indexOf('N/A') === -1) {
                        autopilot.setRemoteControlOption(model.index + 7, idItem.currentText)
                    }
                }

                Connections {
                    target: link

                    onConnectionChanged: {
                        if (!connected) {
                            idItem.currentText = ''
                            idComboBoxText.text = 'N/A'
                        }
                    }
                }

                Connections {
                    target: ParamService

                    onNotifyDownloadComplete: {
                        idComboBoxText.text = autopilot.getRemoteControlOption(model.index + 7)
                    }

                    onNotifyChanges: {
                        idComboBoxText.text = autopilot.getRemoteControlOption(model.index + 7)
                    }
                }
            }
        }
    }
}
