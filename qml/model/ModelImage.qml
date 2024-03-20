import QtQuick 2.12
import QtGraphicalEffects 1.0

Image {
    id: idRoot
    property string type: ""                         //can be "normal" or "cirlce"
    Component.onCompleted: if(type==="circle")
                           {
                               idRoot.state = "circle"
                           }
                           else if(type==="normal")
                           {
                             idRoot.state = "normal"
                           }
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    states: [
        State
        {
            name: "circle"
            PropertyChanges { target: idRoot; layer.enabled: true ; fillMode: Image.PreserveAspectCrop  }
        }
    ]
}

