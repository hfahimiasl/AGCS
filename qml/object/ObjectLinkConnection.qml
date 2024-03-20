import QtQuick 2.12
import QtQuick.Controls 2.12
import SystemSettings 2.6

import '../model'
import '../object'


ModelPopup {
    id: idRoot
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    readonly property string fontFamily: font_fa_medium.name
    readonly property real fontPixelSize: idDisplay.getFontScale(1.05, 2.5)

    Item {
        id: idConnectionRectangle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.8

        Item {
            id: idConnectionType
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 3

            Text {
                anchors.left: idConnectionTypeComboBox.right
                anchors.right: parent.right
                anchors.rightMargin: idRoot.rightPadding
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('نوع')
            }

            ModelCombobox {
                id: idConnectionTypeComboBox
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.75
                height: parent.height - (idRoot.topPadding * 0.5)
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                editable: true
                model: ['Serial', 'TCP', 'UDP']

                onCurrentTextChanged: {
                    if (currentText === 'Serial') {
                        idConnectionType.state = 'Serial'

                    } else if (currentText === 'TCP') {
                        idConnectionType.state = 'TCP'

                    } else if (currentText === 'UDP') {
                        idConnectionType.state = 'UDP'
                    }
                }
            }

            states: [
                State {
                    name: 'Serial'
                    PropertyChanges { target: idConnectionField2Text; text: qsTr('پورت') }
                    PropertyChanges { target: idConnectionField3Text; text: qsTr('سرعت') }
                    PropertyChanges { target: idSerialPort; visible: true }
                    PropertyChanges { target: idSerialBaudRate; visible: true }
                    PropertyChanges { target: idTCPHost; visible: false }
                    PropertyChanges { target: idTCPPort; visible: false }
                    PropertyChanges { target: idUDPHost; visible: false }
                    PropertyChanges { target: idUDPPort; visible: false }
                },
                State {
                    name: 'TCP'
                    PropertyChanges { target: idConnectionField2Text; text: qsTr('هاست') }
                    PropertyChanges { target: idConnectionField3Text; text: qsTr('پورت') }
                    PropertyChanges { target: idSerialPort; visible: false }
                    PropertyChanges { target: idSerialBaudRate; visible: false }
                    PropertyChanges { target: idTCPHost; visible: true }
                    PropertyChanges { target: idTCPPort; visible: true }
                    PropertyChanges { target: idUDPHost; visible: false }
                    PropertyChanges { target: idUDPPort; visible: false }
                },
                State {
                    name: 'UDP'
                    PropertyChanges { target: idConnectionField2Text; text: qsTr('هاست') }
                    PropertyChanges { target: idConnectionField3Text; text: qsTr('پورت') }
                    PropertyChanges { target: idSerialPort; visible: false }
                    PropertyChanges { target: idSerialBaudRate; visible: false }
                    PropertyChanges { target: idTCPHost; visible: false }
                    PropertyChanges { target: idTCPPort; visible: false }
                    PropertyChanges { target: idUDPHost; visible: true }
                    PropertyChanges { target: idUDPPort; visible: true }
                }
            ]
        }

        Item {
            id: idConnectionField2
            anchors.top: idConnectionType.bottom
            anchors.left: idConnectionType.left
            anchors.right: idConnectionType.right
            height: idConnectionType.height

            Text {
                id: idConnectionField2Text
                anchors.left: idSerialPort.right
                anchors.right: parent.right
                anchors.rightMargin: idRoot.rightPadding
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('نوع')
            }

            ModelCombobox {
                id: idSerialPort
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: idConnectionTypeComboBox.width
                height: idConnectionTypeComboBox.height
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                editable: true

                model: ListModel {
                    id: idSerialPortListModel
                }

                onPressedChanged: {
                    idSerialPortListModel.clear()

                    let ports = link.getSerialPortsList()

                    for (let i=0 ; i<ports.length ; i++) {
                        idSerialPortListModel.append({ port: ports[i] })
                    }
                }
            }

            ModelTextfield {
                id: idTCPHost
                anchors.top: idSerialPort.top
                anchors.bottom: idSerialPort.bottom
                anchors.left: idSerialPort.left
                anchors.right: idSerialPort.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                validator: RegExpValidator { regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/ }
            }

            ModelTextfield {
                id: idUDPHost
                anchors.top: idSerialPort.top
                anchors.bottom: idSerialPort.bottom
                anchors.left: idSerialPort.left
                anchors.right: idSerialPort.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                validator: RegExpValidator { regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/ }
            }
        }

        Item {
            id: idConnectionField3
            anchors.top: idConnectionField2.bottom
            anchors.left: idConnectionField2.left
            anchors.right: idConnectionField2.right
            height: idConnectionField2.height

            Text {
                id: idConnectionField3Text
                anchors.left: idSerialBaudRate.right
                anchors.right: parent.right
                anchors.rightMargin: idRoot.rightPadding
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('نوع')
            }

            ModelCombobox {
                id: idSerialBaudRate
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: idConnectionTypeComboBox.width
                height: idConnectionTypeComboBox.height
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                editable: true
                model: [
                    '2400',
                    '4800',
                    '9600',
                    '19200',
                    '38400',
                    '57600',
                    '115200',
                    '230400',
                    '460800',
                    '500000',
                    '921600'
                ]
            }

            ModelTextfield {
                id: idTCPPort
                anchors.top: idSerialBaudRate.top
                anchors.bottom: idSerialBaudRate.bottom
                anchors.left: idSerialBaudRate.left
                anchors.right: idSerialBaudRate.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                validator: RegExpValidator { regExp: /(?!(0))\d+/ }
            }

            ModelTextfield {
                id: idUDPPort
                anchors.top: idSerialBaudRate.top
                anchors.bottom: idSerialBaudRate.bottom
                anchors.left: idSerialBaudRate.left
                anchors.right: idSerialBaudRate.right
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                backgroundColor: theme.background
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                validator: RegExpValidator { regExp: /(?!(0))\d+/ }
            }
        }
    }

    Item {
        id: idButtons
        anchors.top: idConnectionRectangle.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: idRoot.topPadding * 0.5

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
                id: idConnectionButtonText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.primary
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('اتصال')

                states: [
                    State {
                        name: 'connect'
                        PropertyChanges { target: idConnectionButtonText; color: theme.primary; text: qsTr('اتصال') }
                        PropertyChanges { target: idConnectionTypeComboBox; enabled: true }
                        PropertyChanges { target: idSerialPort; enabled: true }
                        PropertyChanges { target: idSerialBaudRate; enabled: true }
                        PropertyChanges { target: idTCPHost; enabled: true }
                        PropertyChanges { target: idTCPPort; enabled: true }
                        PropertyChanges { target: idUDPHost; enabled: true }
                        PropertyChanges { target: idUDPPort; enabled: true }
                    },
                    State {
                        name: 'disconnect'
                        PropertyChanges { target: idConnectionButtonText; color: 'red'; text: qsTr('قطع اتصال') }
                        PropertyChanges { target: idConnectionTypeComboBox; enabled: false }
                        PropertyChanges { target: idSerialPort; enabled: false }
                        PropertyChanges { target: idSerialBaudRate; enabled: false }
                        PropertyChanges { target: idTCPHost; enabled: false }
                        PropertyChanges { target: idTCPPort; enabled: false }
                        PropertyChanges { target: idUDPHost; enabled: false }
                        PropertyChanges { target: idUDPPort; enabled: false }
                    }
                ]
            }

            onClicked: {
                if (link.isConnected()) {
                    link.disconnectAll()

                } else {
                    idRoot.connect()
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
                anchors.verticalCenterOffset: idRoot.bottomPadding * 0.5
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: theme.text
                fontSizeMode: Text.Fit
                font.family: idRoot.fontFamily
                font.pixelSize: idRoot.fontPixelSize
                text: qsTr('لغو')
            }

            onClicked: {
                idRoot.close()
            }
        }
    }

    function connect() {
        switch (idConnectionType.state) {
        case 'Serial':
            if (idSerialPort.currentText === '' || idSerialBaudRate.currentText === '') {
                if (idSerialPort.currentText === '') {
                    idSerialPort.borderColor = 'red'

                } else {
                    idSerialPort.resetBorderColor()
                }

                if (idSerialBaudRate.currentText === '') {
                    idSerialBaudRate.borderColor = 'red'

                } else {
                    idSerialBaudRate.resetBorderColor()
                }

                return
            }

            idRoot.reset()
            link.connectSerial(idSerialPort.currentText, parseInt(idSerialBaudRate.currentText), 8, 0, 1, 0)
            break

        case 'TCP':
            let tcp_ip = idTCPHost.text

            if (tcp_ip.split('.').length !== 4 || !tcp_ip.split('.')[3] || idTCPPort.text === '') {
                if (tcp_ip.split('.').length !== 4 || !tcp_ip.split('.')[3]) {
                    idTCPHost.borderColor = 'red'

                } else {
                    idTCPHost.resetBorderColor()
                }

                if (idTCPPort.text === '') {
                    idTCPPort.borderColor = 'red'

                } else {
                    idTCPPort.resetBorderColor()
                }

                return
            }

            idRoot.reset()
            link.connectTCP(tcp_ip, idTCPPort.text)
            break

        case 'UDP':
            let udp_ip = idUDPHost.text

            if (udp_ip.split('.').length !== 4 || !udp_ip.split('.')[3] || idUDPPort.text === '') {
                if (udp_ip.split('.').length !== 4 || !udp_ip.split('.')[3]) {
                    idUDPHost.borderColor = 'red'

                } else {
                    idUDPHost.resetBorderColor()
                }

                if (idUDPPort.text === '') {
                    idUDPPort.borderColor = 'red'

                } else {
                    idUDPPort.resetBorderColor()
                }

                return
            }

            idRoot.reset()
            link.connectUDP(udp_ip, idUDPPort.text)
            break

        default:
            break
        }
    }

    function reset() {
        idSerialPort.resetBorderColor()
        idSerialBaudRate.resetBorderColor()
        idTCPHost.resetBorderColor()
        idTCPPort.resetBorderColor()
        idUDPHost.resetBorderColor()
        idUDPPort.resetBorderColor()
    }

    function loadSession() {
        idConnectionTypeComboBox.currentIndex = parseInt(settings.get(SystemSettings.LinkLastConnectionType))

        idSerialPortListModel.clear()

        let ports = link.getSerialPortsList()
        let last_serial_port = String(settings.get(SystemSettings.LinkLastSerialPort))

        for (let i=0 ; i<ports.length ; i++) {
            idSerialPortListModel.append({ port: ports[i] })

            if (ports[i] === last_serial_port) {
                idSerialPort.currentIndex = i
                break
            }
        }

        idSerialBaudRate.currentIndex = parseInt(settings.get(SystemSettings.LinkLastSerialBaudRate))
        idTCPHost.text = String(settings.get(SystemSettings.LinkLastTCPHost))
        idTCPPort.text = String(settings.get(SystemSettings.LinkLastTCPPort))
        idUDPHost.text = String(settings.get(SystemSettings.LinkLastUDPHost))
        idUDPPort.text = String(settings.get(SystemSettings.LinkLastUDPPort))
    }

    function saveSession() {
        settings.set(SystemSettings.LinkLastConnectionType, idConnectionTypeComboBox.currentIndex)

        switch (idConnectionType.state) {
        case 'Serial':
            settings.set(SystemSettings.LinkLastSerialPort, idSerialPort.currentText)
            settings.set(SystemSettings.LinkLastSerialBaudRate, idSerialBaudRate.currentIndex)
            break

        case 'TCP':
            settings.set(SystemSettings.LinkLastTCPHost, idTCPHost.text)
            settings.set(SystemSettings.LinkLastTCPPort, idTCPPort.text)
            break

        case 'UDP':
            settings.set(SystemSettings.LinkLastUDPHost, idUDPHost.text)
            settings.set(SystemSettings.LinkLastUDPPort, idUDPPort.text)
            break

        default:
            break
        }
    }

    Component.onCompleted: {
        idRoot.loadSession()
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (connected) {
                idRoot.close()
                idRoot.saveSession()
                idConnectionButtonText.state = 'disconnect'

            } else {
                if (idConnectionType.state === 'Serial') {
                    idSerialPortListModel.clear()
                }

                idConnectionButtonText.state = 'connect'
                variable.resetAll(true)

                if (user_auth.isSignin()) {
                    idRoot.open()
                }
            }
        }
    }

    Connections {
        target: user_auth

        onNotifyLogout: {
            link.disconnectAll()
        }
    }
}
