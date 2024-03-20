import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6
import SystemUnits 1.0

import '../model'


ModelPagetype {
    Flickable {
        id: idFlickable
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.topMargin: idDisplay.getScaledHeight(0.01, 0.015)
        anchors.bottomMargin: anchors.topMargin
        anchors.rightMargin: idDisplay.getScaledWidth(0.005, 0.01)
        width: idDisplay.getScaledWidth(0.135, 0.3)
        contentWidth: idColumn.width
        contentHeight: idColumn.height
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        ScrollBar.vertical: ScrollBar {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: idColumn
            anchors.centerIn: parent
            spacing: idFlickable.anchors.topMargin

            ModelCart {
                id: idMapSettingModelCart
                tittle: qsTr('تنظیمات نقشه')
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.125, 0.325)
                font.family: font_fa_medium.name
                font.pixelSize: idUnitsMeasurementModelCart.font.pixelSize

                property bool boot: false

                Rectangle {
                    id: idMapSettingRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idMapSettingModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idMapSettingColumn
                        anchors.centerIn: parent
                        spacing: parent.height * 0.1

                        Item {
                            width: idMapSettingRectangle.width
                            height: idMapProviderText.height * 1.75

                            Text {
                                id: idMapProviderText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idMapSettingModelCart.font
                                text: qsTr('سرویس')
                            }

                            ModelCombobox {
                                id: idMapProviderComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: parent.height
                                font: idMapSettingModelCart.font
                                model: MapEngine.mapProviderList

                                readonly property string provider: idMapProviderComboBox.textAt(idMapProviderComboBox.currentIndex)

                                onProviderChanged: {
                                    if (!idMapSettingModelCart.boot) {
                                        return
                                    }

                                    idMapSettingModelCart.updateActiveMapType(idMapProviderComboBox.provider, MapEngine.mapTypeList(idMapProviderComboBox.provider)[0])
                                }
                            }
                        }

                        Item {
                            width: idMapSettingRectangle.width
                            height: idMapTypeText.height * 1.75

                            Text {
                                id: idMapTypeText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idMapSettingModelCart.font
                                text: qsTr('نوع')
                            }

                            ModelCombobox {
                                id: idMapTypeComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: parent.height
                                font: idMapSettingModelCart.font
                                model: MapEngine.mapTypeList(idMapProviderComboBox.provider)

                                readonly property string type: idMapTypeComboBox.textAt(idMapTypeComboBox.currentIndex)

                                onTypeChanged: {
                                    if (!idMapSettingModelCart.boot) {
                                        return
                                    }

                                    idMapSettingModelCart.updateActiveMapType(idMapProviderComboBox.provider, idMapTypeComboBox.type)
                                }
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    const provider = String(settings.get(SystemSettings.MapProvider))
                    const type = String(settings.get(SystemSettings.MapType))

                    idMapSettingModelCart.updateActiveMapType(provider, type)

                    for (let i in idMapProviderComboBox.model) {
                        if (idMapProviderComboBox.model[i] === provider) {
                            idMapProviderComboBox.currentIndex = i
                            break
                        }
                    }

                    for (let j in MapEngine.mapTypeList(provider)) {
                        if (MapEngine.mapTypeList(provider)[j] === type) {
                            idMapTypeComboBox.currentIndex = j
                            break
                        }
                    }

                    idMapSettingModelCart.boot = true
                }

                function updateActiveMapType(provider, type) {
                    const name = provider + " " + type

                    for (let i in idMapObject.supportedMapTypes) {
                        if (idMapObject.supportedMapTypes[i].name === name) {
                            settings.set(SystemSettings.MapProvider, provider)
                            settings.set(SystemSettings.MapType, type)
                            idMapObject.activeMapType = idMapObject.supportedMapTypes[i]
                            return
                        }
                    }
                }
            }

            ModelCart {
                id: idAirspaceModelCart
                tittle: qsTr('حریم هوایی')
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.1, 0.26)
                font.family: font_fa_medium.name
                font.pixelSize: idMapSettingModelCart.font.pixelSize

                Rectangle {
                    id: idAirspaceRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idAirspaceModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idAirspaceColumn
                        anchors.centerIn: parent

                        Item {
                            width: idAirspaceRectangle.width
                            height: idAirspacePageMainText.height * 1.5

                            Text {
                                id: idAirspacePageMainText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idAirspaceModelCart.font
                                text: qsTr('آشیانه')
                            }

                            ModelSwitch {
                                id: idAirspacePageMainSwitch
                                anchors.left: parent.left
                                anchors.leftMargin: idColumn.margins
                                anchors.verticalCenter: parent.verticalCenter
                                width: height * 1.75
                                height: idAirspacePageMainText.implicitHeight

                                onCheckedChanged: {
                                    settings.set(SystemSettings.MapAirspacePageMainEnabled, idAirspacePageMainSwitch.checked)
                                    idMapObject.airspacePageMainEnabled = idAirspacePageMainSwitch.checked
                                }

                                Component.onCompleted: {
                                    idAirspacePageMainSwitch.checked = String(settings.get(SystemSettings.MapAirspacePageMainEnabled)) === 'true'
                                    idMapObject.airspacePageMainEnabled = idAirspacePageMainSwitch.checked
                                }
                            }
                        }

                        Item {
                            width: idAirspaceRectangle.width
                            height: idAirspacePageMissionText.height * 1.5

                            Text {
                                id: idAirspacePageMissionText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idAirspaceModelCart.font
                                text: qsTr('ماموریت')
                            }

                            ModelSwitch {
                                id: idAirspacePageMissionSwitch
                                anchors.left: parent.left
                                anchors.leftMargin: idColumn.margins
                                anchors.verticalCenter: parent.verticalCenter
                                width: height * 1.75
                                height: idAirspacePageMissionText.implicitHeight

                                onCheckedChanged: {
                                    settings.set(SystemSettings.MapAirspacePageMissionEnabled, idAirspacePageMissionSwitch.checked)
                                    idMapObject.airspacePageMissionEnabled = idAirspacePageMissionSwitch.checked
                                }

                                Component.onCompleted: {
                                    idAirspacePageMissionSwitch.checked = String(settings.get(SystemSettings.MapAirspacePageMissionEnabled)) === 'true'
                                    idMapObject.airspacePageMissionEnabled = idAirspacePageMissionSwitch.checked
                                }
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idAirTrafficModelCart
                tittle: qsTr('ترافیک هوایی')
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.1, 0.26)
                font.family: font_fa_medium.name
                font.pixelSize: idMapSettingModelCart.font.pixelSize

                Rectangle {
                    id: idAirTrafficRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idAirTrafficModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idAirTrafficColumn
                        anchors.centerIn: parent

                        Item {
                            width: idAirTrafficRectangle.width
                            height: idAirTrafficPageMainText.height * 1.5

                            Text {
                                id: idAirTrafficPageMainText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idAirTrafficModelCart.font
                                text: qsTr('آشیانه')
                            }

                            ModelSwitch {
                                id: idAirTrafficPageMainSwitch
                                anchors.left: parent.left
                                anchors.leftMargin: idColumn.margins
                                anchors.verticalCenter: parent.verticalCenter
                                width: height * 1.75
                                height: idAirTrafficPageMainText.implicitHeight

                                onCheckedChanged: {
                                    settings.set(SystemSettings.MapAirTrafficPageMainEnabled, idAirTrafficPageMainSwitch.checked)
                                    idMapObject.airTrafficPageMainEnabled = idAirTrafficPageMainSwitch.checked
                                }

                                Component.onCompleted: {
                                    idAirTrafficPageMainSwitch.checked = String(settings.get(SystemSettings.MapAirTrafficPageMainEnabled)) === 'true'
                                    idMapObject.airTrafficPageMainEnabled = idAirTrafficPageMainSwitch.checked
                                }
                            }
                        }

                        Item {
                            width: idAirTrafficRectangle.width
                            height: idAirTrafficPageMissionText.height * 1.5

                            Text {
                                id: idAirTrafficPageMissionText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idAirTrafficModelCart.font
                                text: qsTr('ماموریت')
                            }

                            ModelSwitch {
                                id: idAirTrafficPageMissionSwitch
                                anchors.left: parent.left
                                anchors.leftMargin: idColumn.margins
                                anchors.verticalCenter: parent.verticalCenter
                                width: height * 1.75
                                height: idAirTrafficPageMissionText.implicitHeight

                                onCheckedChanged: {
                                    settings.set(SystemSettings.MapAirTrafficPageMissionEnabled, idAirTrafficPageMissionSwitch.checked)
                                    idMapObject.airTrafficPageMissionEnabled = idAirTrafficPageMissionSwitch.checked
                                }

                                Component.onCompleted: {
                                    idAirTrafficPageMissionSwitch.checked = String(settings.get(SystemSettings.MapAirTrafficPageMissionEnabled)) === 'true'
                                    idMapObject.airTrafficPageMissionEnabled = idAirTrafficPageMissionSwitch.checked
                                }
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idUnitsMeasurementModelCart
                tittle: qsTr('واحد های اندازه گیری')
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.175, 0.475)
                font.family: font_fa_medium.name
                font.pixelSize: idDisplay.getFontScale(1, 2.25)

                Rectangle {
                    id: idUnitsMeasurementRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idUnitsMeasurementModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idUnitsMeasurementColumn
                        anchors.centerIn: parent
                        spacing: parent.height * 0.075

                        Item {
                            width: idUnitsMeasurementRectangle.width
                            height: idDistanceText.height * 1.75

                            Text {
                                id: idDistanceText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idUnitsMeasurementModelCart.font
                                text: qsTr('فاصله')
                            }

                            ModelCombobox {
                                id: idDistanceComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.75
                                height: parent.height
                                font: idUnitsMeasurementModelCart.font
                                model: [qsTr('فوت'), qsTr('متر'), qsTr('کیلومتر'), qsTr('مایل')]

                                property bool isExecutable: false

                                onCurrentIndexChanged: {
                                    if (isExecutable) {
                                        switch (currentIndex) {
                                        case 0:
                                            units.set(SystemUnits.Distance, SystemUnits.Foot)
                                            break
                                        case 1:
                                            units.set(SystemUnits.Distance, SystemUnits.Meter)
                                            break
                                        case 2:
                                            units.set(SystemUnits.Distance, SystemUnits.Kilometer)
                                            break
                                        case 3:
                                            units.set(SystemUnits.Distance, SystemUnits.Mile)
                                            break
                                        }
                                    } else {
                                        isExecutable = true
                                    }
                                }

                                Component.onCompleted: {
                                    idDistanceComboBox.currentIndex = units.getUnit(SystemUnits.Distance) - 1
                                }
                            }
                        }

                        Item {
                            width: idUnitsMeasurementRectangle.width
                            height: idSpeedText.height * 1.75

                            Text {
                                id: idSpeedText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idUnitsMeasurementModelCart.font
                                text: qsTr('سرعت')
                            }

                            ModelCombobox {
                                id: idSpeedComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.75
                                height: parent.height
                                font: idUnitsMeasurementModelCart.font
                                model: [qsTr('متر بر ثانیه'), qsTr('نات'), qsTr('مایل بر ساعت'), qsTr('کیلومتر بر ساعت')]

                                property bool isExecutable: false

                                onCurrentIndexChanged: {
                                    if (isExecutable) {
                                        switch (currentIndex) {
                                        case 0:
                                            units.set(SystemUnits.Speed, SystemUnits.Mps)
                                            break
                                        case 1:
                                            units.set(SystemUnits.Speed, SystemUnits.Knot)
                                            break
                                        case 2:
                                            units.set(SystemUnits.Speed, SystemUnits.Mph)
                                            break
                                        case 3:
                                            units.set(SystemUnits.Speed, SystemUnits.Kph)
                                            break
                                        }
                                    } else {
                                        isExecutable = true
                                    }
                                }

                                Component.onCompleted: {
                                    idSpeedComboBox.currentIndex = units.getUnit(SystemUnits.Speed)
                                }
                            }
                        }

                        Item {
                            width: idUnitsMeasurementRectangle.width
                            height: idVoltageText.height * 1.75

                            Text {
                                id: idVoltageText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idUnitsMeasurementModelCart.font
                                text: qsTr('ولتاژ')
                            }

                            ModelCombobox {
                                id: idVoltageComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.75
                                height: parent.height
                                font: idUnitsMeasurementModelCart.font
                                model: [qsTr('میلی ولت'), qsTr('ولت')]

                                property bool isExecutable: false

                                onCurrentIndexChanged: {
                                    if (isExecutable) {
                                        switch (currentIndex) {
                                        case 0:
                                            units.set(SystemUnits.Voltage, SystemUnits.MilliVolt)
                                            break
                                        case 1:
                                            units.set(SystemUnits.Voltage, SystemUnits.Volt)
                                            break
                                        }
                                    } else {
                                        isExecutable = true
                                    }
                                }

                                Component.onCompleted: {
                                    idVoltageComboBox.currentIndex = units.getUnit(SystemUnits.Voltage)
                                }
                            }
                        }
                    }
                }
            }

            ModelCart {
                id: idThemeSettingModelCart
                tittle: qsTr('رنگ زمینه نرم افزار')
                width: idFlickable.width
                height: idDisplay.getScaledHeight(0.085, 0.225)
                font.family: font_fa_medium.name
                font.pixelSize: idMapSettingModelCart.font.pixelSize

                Rectangle {
                    id: idThemeSettingRectangle
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.topMargin: idThemeSettingModelCart.itemVerticalMargin
                    color: theme.backgroundLight

                    Column {
                        id: idThemeSettingColumn
                        anchors.centerIn: parent
                        spacing: parent.height * 0.075

                        Item {
                            width: idThemeSettingRectangle.width
                            height: idThemeTypeText.height * 1.75

                            Text {
                                id: idThemeTypeText
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: theme.text
                                fontSizeMode: Text.Fit
                                font: idThemeSettingModelCart.font
                                text: qsTr('رنگ زمینه')
                            }

                            ModelCombobox {
                                id: idThemeTypeComboBox
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width * 0.7
                                height: parent.height
                                font: idThemeSettingModelCart.font
                                model: [qsTr('روشن'), qsTr('تیره')]

                                property bool isExecutable: false

                                onCurrentTextChanged: {
                                    if (idThemeTypeComboBox.isExecutable) {
                                        settings.set(SystemSettings.GUITheme, idThemeTypeComboBox.currentText === qsTr('روشن') ? 'LIGHT' : 'DARK')

                                    } else {
                                        idThemeTypeComboBox.isExecutable = true
                                    }
                                }
                            }

                            Component.onCompleted: {
                                idThemeTypeComboBox.currentIndex = String(settings.get(SystemSettings.GUITheme)) === 'LIGHT' ? 0 : 1
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: idToastHistoryContainerItem
        anchors.top: idFlickable.top
        anchors.bottom: idFlickable.bottom
        anchors.left: parent.left
        anchors.right: idFlickable.left
        anchors.leftMargin: anchors.rightMargin
        anchors.rightMargin: idFlickable.anchors.rightMargin

        Item {
            id: idToastHistoryTitleItem
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: idDisplay.getScaledHeight(0.0425, 0.1)

            Item {
                id: idToastHistoryTitleContainerItem
                anchors.fill: parent
                anchors.topMargin: parent.height * 0.25
                anchors.bottomMargin: anchors.topMargin

                Text {
                    id: idToastHistoryTitle
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.family: font_fa_black.name
                    font.pixelSize: parent.height
                    fontSizeMode: Text.Fit
                    color: theme.text
                    text: qsTr('اعلانات')
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: theme.primaryDark
            }
        }

        ScrollView {
            id: idToastHistoryScrollView
            anchors.top: idToastHistoryTitleItem.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: idToastHistoryTitleContainerItem.anchors.topMargin
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                model: idToastListModel
                spacing: 5
                clip: true

                delegate: Rectangle {
                    id: idToastHistoryRectangle
                    width: parent.width
                    height: idDisplay.getScaledHeight(0.035, 0.08)
                    color: theme.backgroundDark

                    Item {
                        anchors.fill: parent
                        anchors.topMargin: parent.height * 0.2
                        anchors.bottomMargin: anchors.topMargin

                        Text {
                            id: idToastHistoryTime
                            anchors.fill: parent
                            anchors.leftMargin: parent.height * 0.5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            font.family: font_fa_medium.name
                            font.pixelSize: parent.height
                            fontSizeMode: Text.Fit
                            color: idToastHistoryScrollView.getColor(type)
                            text: Qt.formatTime(new Date(), 'hh:mm:ss')
                        }

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: idToastHistoryTime.contentWidth + (idToastHistoryTime.anchors.leftMargin * 2)
                            anchors.rightMargin: parent.height * 0.5
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            font: idToastHistoryTime.font
                            fontSizeMode: Text.Fit
                            color: idToastHistoryTime.color
                            text: description
                            clip: true
                        }
                    }
                }
            }

            function getColor(type) {
                switch(type) {
                case 'INFO': return theme.primary
                case 'WARN': return '#a3a310'
                case 'ERROR': return 'red'
                }
            }
        }
    }
}
