import QtQuick 2.12
import QtQuick.Controls 2.12

import '../model'


ModelCart {
    id: root
    height: root.custom_height
    visible: false

    readonly property var selectedWaypoint: MissionService.selected
    readonly property real item_height: idDisplay.getScaledHeight(0.03, 0.09)
    property var horizontal_alignment: Text.AlignRight
    readonly property string font_family: font_fa_medium.name
    readonly property real font_pixel_size: idDisplay.getFontScale(1, 2.25)
    readonly property int item_spacing: idDisplay.getScaledHeight(0.0075, 0.0225)

    readonly property real custom_height: idAltitudeTextField.height
                                          + idWaypointTypeComboBox.height
                                          + idWaypointListView.height
                                          + idWaypointListViewScrollBar.height
                                          + idCommandButtons.height
                                          + root.item_spacing * (idDisplay.isLargeDisplay ? 5.5 : 6.5)

    function reset() {
        MissionService.deselect()
        idAltitude.visible = true
        idWaypointType.visible = true
        idWaypointTypeComboBox.visible = true
        idWaypointTypeText.text = qsTr('نوع')
        idAltitudeTextField.text = ''
        idWaypointTypeComboBox.currentIndex = -1
    }

    function updateSelectedWaypoint(seq) {
        if (seq === 0) {
            idAltitude.visible = true
            idWaypointType.visible = true
            idWaypointTypeComboBox.visible = false
            idWaypointTypeText.text = qsTr('نوع    برخاستن')
            idAltitudeTextField.text = MissionService.get(1).alt

        } else if (seq === 1) {
            idAltitude.visible = false
            idWaypointType.visible = false
            MissionService.deselect()

        } else if (seq !== -1) {
            let cmd = MissionService.get(seq).cmd
            idAltitude.visible = cmd === 16 ? true : false
            idWaypointType.visible = true
            idWaypointTypeComboBox.visible = true
            idWaypointTypeText.text = qsTr('نوع')
            idAltitudeTextField.text = MissionService.get(seq).alt
            idWaypointTypeComboBox.currentIndex = cmd === 16 ? 0 : (cmd === 20 ? 1 : -1)
        }
    }

    onSelectedWaypointChanged: root.updateSelectedWaypoint(root.selectedWaypoint)

    onVisibleChanged: {
        if (!visible) {
            MissionService.deselect()
            root.reset()
        }
    }

    Item {
        id: idAltitude
        width: parent.width
        height: root.item_height
        anchors.top: parent.top

        Text {
            id: idAltitudeText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: root.horizontal_alignment
            font.family: root.font_family
            font.pixelSize: root.font_pixel_size
            color: theme.text
            text: qsTr('ارتفاع')
        }

        ModelTextfield {
            id: idAltitudeTextField
            height: parent.height
            anchors.left: parent.left
            anchors.right: idAltitudeText.left
            anchors.rightMargin: parent.width * 0.05
            font.pixelSize: root.font_pixel_size
            placeholderText: qsTr('متر')
            validator: RegExpValidator { regExp: /^(?!(0))\d{1,5}(\.\d{1})?$/ }
        }
    }

    Item {
        id: idWaypointType
        width: parent.width
        height: root.item_height
        anchors.top: idAltitude.bottom
        anchors.topMargin: root.item_spacing

        Text {
            id: idWaypointTypeText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: root.horizontal_alignment
            font.family: root.font_family
            font.pixelSize: root.font_pixel_size
            color: theme.text
            text: qsTr('نوع')
        }

        ModelCombobox {
            id: idWaypointTypeComboBox
            height: parent.height
            anchors.left: parent.left
            anchors.right: idWaypointTypeText.left
            anchors.rightMargin: parent.width * 0.05
            font.pixelSize: root.font_pixel_size
            model: [qsTr('حرکت'), qsTr('بازگشت به خانه')]
            currentIndex: -1
        }
    }

    ListView {
        id: idWaypointListView
        height: root.item_height * 0.75
        anchors.top: idWaypointType.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: root.item_spacing
        boundsBehavior: Flickable.StopAtBounds
        orientation: ListView.Horizontal
        // model: mission_model
        spacing: 1
        clip: true

        ScrollBar.horizontal: ScrollBar {
            id: idWaypointListViewScrollBar
            parent: idWaypointListView.parent
            anchors.top: idWaypointListView.bottom
            anchors.left: idWaypointListView.left
            anchors.right: idWaypointListView.right
            anchors.topMargin: root.item_spacing * 0.5
            policy: ScrollBar.AlwaysOn
        }

        delegate: Rectangle {
            id: idWplistDelegate
            height: idWaypointListView.height
            radius: height
            color: selected ? theme.blue : theme.background
            border.width: 3
            border.color: theme.primary
            visible: command === 16 || command === 20 || command === 21 || command === 22
            width: visible ? height : 0
            Text {
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit
                font.family: (seq === 0 || seq === 1 || (command === 20 && frame === 0) || (command === 21) || (command === 22 && frame === 3)) ? fontAwesome.name : root.font_family
                font.bold: true
                color: theme.text
                text: {
                    if (seq === 0) {
                        '\uf5b0'

                    } else if (seq === 1) {
                        '\uf47e'

                    } else if (command === 16 && frame === 3) {
                        seq

                    } else if (command === 20 && frame === 0) {
                        '\uf0e2'

                    } else if (command === 21) {
                        '\uf5af'

                    } else if (command === 22 && frame === 3) {
                        '\uf5b0'

                    } else {
                        '\uf128'
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: MissionService.select(seq)
            }
        }
    }

    Rectangle {
        id: idCommandButtons
        height: root.item_height
        anchors.top: idWaypointListView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idWaypointListViewScrollBar.height + root.item_spacing
        color: theme.backgroundDark

        ModelButton {
            width: parent.width * 0.45
            height: parent.height
            anchors.left: parent.left
            font.family: root.font_family
            font.pixelSize: root.font_pixel_size
            backgroundColor: root.color
            text: qsTr('حذف')

            onClicked: {
                let seq = MissionService.getSelected()

                if (seq === -1) {
                    toast.warn(qsTr('نقطه مورد نظر را انتخاب کنید'), 5000)
                    return
                }

                if (seq === 0 || seq === 1) {
                    if (MissionService.count() > 2) {
                        toast.error(qsTr('امکان حذف این نقطه وجود ندارد'), 5000)

                    } else {
                        MissionService.remove(0, 2)
                        root.reset()
                    }

                } else {
                    if (MissionService.get(seq).visible) {
                        if (MissionService.isExist(seq + 1) && !MissionService.get(seq + 1).visible) {
                            MissionService.remove(seq, 2)

                        } else {
                            MissionService.remove(seq, 1)
                        }

                        root.reset()

                    } else {
                        if (MissionService.isExist(seq - 1) && MissionService.get(seq - 1).visible) {
                            MissionService.remove(seq - 1, 2)

                        } else {
                            MissionService.remove(seq, 1)
                        }

                        root.reset()
                    }
                }
            }
        }

        ModelButton {
            width: parent.width * 0.45
            height: parent.height
            anchors.right: parent.right
            font.family: root.font_family
            font.pixelSize: root.font_pixel_size
            backgroundColor: root.color
            text: qsTr('ذخیره')

            onClicked: {
                let seq = MissionService.getSelected()

                if (seq === -1) {
                    toast.warn(qsTr('نقطه مورد نظر را انتخاب کنید'), 5000)
                    return
                }

                let item = MissionService.get(seq === 0 ? 1 : seq)

                if (idWaypointTypeComboBox.currentText === qsTr('بازگشت به خانه')) {
                    if (seq === MissionService.count() - 1) {
                        item.lat = 0
                        item.lon = 0
                        item.alt = 0
                        item.cmd = 20
                        item.frame = 0
                        item.current = 0
                        item.auto = 1
                        item.type = 0
                        item.param1 = 0
                        item.param2 = 0
                        item.param3 = 0
                        item.param4 = 0
                        item.visible = false
                        item.selected = false

                    } else {
                        idWaypointTypeComboBox.currentIndex = 0
                        toast.warn(qsTr('نقطه بازگشت به خانه در انتهای مسیر قابل تعریف می باشد'), 5000)
                        return
                    }

                } else if (seq !== 0 && seq !== 1) {
                    if (item.cmd === 20 && item.frame === 0) {
                        item.lat = MissionService.get(seq - 1).lat + 0.00025
                        item.lon = MissionService.get(seq - 1).lon + 0.00025
                        item.alt = 30
                        item.cmd = 16
                        item.frame = 3
                        item.current = 0
                        item.auto = 1
                        item.type = 0
                        item.param1 = 0
                        item.param2 = 0
                        item.param3 = 0
                        item.param4 = 0
                        item.visible = true
                        item.selected = false

                    } else {
                        if (idAltitudeTextField.text === '') {
                            toast.warn(qsTr('ارتفاع را وارد کنید'), 5000)
                            return
                        }

                        item.alt = parseFloat(idAltitudeTextField.text)
                    }

                } else {
                    if (idAltitudeTextField.text === '') {
                        toast.warn(qsTr('ارتفاع را وارد کنید'), 5000)
                        return
                    }

                    item.alt = parseFloat(idAltitudeTextField.text)
                }

                MissionService.insert(item)

                root.reset()
            }
        }
    }
}
