import QtQuick 2.12

import '../model'


Item {
    id: idRoot

    function info(text, duration) {
        idToastListModel.insert(0, {
                                    'type': 'INFO',
                                    'description': text,
                                    'duration': duration
                                })
    }

    function warn(text, duration) {
        idToastListModel.insert(0, {
                                    'type': 'WARN',
                                    'description': text,
                                    'duration': duration
                                })
    }

    function error(text, duration) {
        idToastListModel.insert(0, {
                                    'type': 'ERROR',
                                    'description': text,
                                    'duration': duration
                                })
    }

    ListView {
        z: Infinity
        anchors.fill: parent
        model: idToastListModel
        verticalLayoutDirection: ListView.BottomToTop
        interactive: false
        cacheBuffer: 0
        spacing: idDisplay.isLargeDisplay ? 5 : 3.5

        displaced: Transition {
            NumberAnimation {
                properties: 'y'
                easing.type: Easing.InOutQuad
            }
        }

        delegate: ModelToast {
            Component.onCompleted: {
                if (typeof duration === 'undefined') {
                    show(type, description, 5000)

                } else {
                    show(type, description, duration)
                }
            }
        }
    }

    Connections {
        target: system_toast

        onNotifyInfo: {
            idRoot.info(text, duration)
        }

        onNotifyWarn: {
            idRoot.warn(text, duration)
        }

        onNotifyError: {
            idRoot.error(text, duration)
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (connected) {
                idToastListModel.clear()
            }
        }
    }
}
