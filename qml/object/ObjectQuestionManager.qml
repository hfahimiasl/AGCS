import QtQuick 2.12

import '../model'


Item {
    function add(text, id) {
        idQuestionListModel.insert(0, {
                                       text: text,
                                       id: id
                                   })
    }

    function clear(id) {
        if (typeof id === 'undefined') {
            idQuestionListModel.clear()

        } else {
            for (let i=0 ; i<idQuestionListModel.count ; i++) {
                if (idQuestionListModel.get(i).id === id) {
                    idQuestionListModel.remove(i)
                }
            }
        }
    }

    signal event(string id, bool accept)

    ListView {
        z: Infinity
        spacing: 5
        anchors.fill: parent
        anchors.topMargin: 10
        verticalLayoutDirection: ListView.TopToBottom
        interactive: false

        model: ListModel {
            id: idQuestionListModel
        }

        delegate: ModelQuestionBox {
            Component.onCompleted: {
                show(text)
            }
        }
    }

    Connections {
        target: link

        onConnectionChanged: {
            if (!connected) {
                clear()
            }
        }
    }
}
