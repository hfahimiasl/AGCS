import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Universal 2.12


ComboBox {
    id: idRoot

    property color backgroundColorBox : theme.background
    property color borderColor: idRoot.backgroundColorBox
    property color colorBox : theme.text
    property color colorItem : theme.textDark
    property color backgroundColorPupup : theme.backgroundDark

    property bool rightAlignment: true

    background: Rectangle {
        id: idComboBoxRectangle
        color: idRoot.backgroundColorBox
        border.color: idRoot.borderColor
        radius: 5
    }

    indicator: Text {
        id: idIndicator
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: idRoot.rightAlignment ? parent.left : undefined
        anchors.right: idRoot.rightAlignment ? undefined : parent.right
        anchors.topMargin: parent.height * 0.5
        anchors.bottomMargin: anchors.topMargin
        anchors.leftMargin: anchors.topMargin * 0.75
        anchors.rightMargin: anchors.leftMargin
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: idRoot.colorBox
        font.family: fontAwesome.name
        font.pixelSize: idRoot.font.pixelSize
        text: '\uf0d7'
    }

    contentItem: Text {
        anchors.left: idRoot.rightAlignment ? idIndicator.right : parent.left
        anchors.right: idRoot.rightAlignment ? parent.right : idIndicator.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: parent.width * 0.1
        anchors.rightMargin: anchors.leftMargin
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: idRoot.rightAlignment ? Text.AlignRight : Text.AlignLeft
        color: idRoot.colorBox
        font.family: idRoot.font.family
        font.pixelSize: idRoot.font.pixelSize
        text: idRoot.displayText
    }

    delegate: ItemDelegate {
        width: idRoot.width

        contentItem: Rectangle {
            anchors.fill: parent
            color: idRoot.backgroundColorBox

            Text {
                width: parent.width * 0.95
                height: parent.height
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                fontSizeMode: Text.Fit
                color: idRoot.colorBox
                font.bold: modelData === idRoot.displayText
                font.family: idRoot.font.family
                font.pixelSize: idRoot.font.pixelSize
                text: modelData
            }
        }
    }

    popup: Popup {
        y: idRoot.height - 1
        width: idRoot.width
        height:contentItem.implicitHeigh
        padding: 1

        contentItem: ListView {
            id:listView
            clip: true
            boundsBehavior : Flickable.StopAtBounds
            implicitHeight: contentHeight
            model: idRoot.popup.visible ? idRoot.delegateModel : null
            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            border.color: idRoot.backgroundColorPupup
        }
    }

    function resetBorderColor() {
        idRoot.borderColor = idRoot.backgroundColorBox
    }

    onBackgroundColorBoxChanged: {
        idRoot.resetBorderColor()
    }
}
