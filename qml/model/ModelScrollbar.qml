import QtQuick 2.12
import QtQml 2.14
Item {
    id: idRoot;
    property Flickable flickable : null;
    property int       handleSize :10;
    width: (handleSize + 2 * (idBackScrollbar.border.width +1));
    visible: (flickable.visibleArea.heightRatio < 1.0);
    anchors {
        top: flickable.top;
        right: flickable.left;
        bottom: flickable.bottom;
    }
    function scrollDown () {
        flickable.contentY = Math.min (flickable.contentY + (flickable.height /4), flickable.contentHeight - flickable.height);
    }
    function scrollUp () {
        flickable.contentY = Math.max (flickable.contentY - (flickable.height / 4), 0);
    }
    Binding {
        target: idHandle;
        property: "y";
        value: (flickable.contentY * idClicker.drag.maximumY / (flickable.contentHeight - flickable.height));
        when: (!idClicker.drag.active);
        restoreMode: Binding.RestoreBinding
    }
    Binding {
        target: flickable;
        property: "contentY";
        value: (idHandle.y * (flickable.contentHeight - flickable.height) / idClicker.drag.maximumY);
        when: (idClicker.drag.active || idClicker.pressed);
        restoreMode: Binding.RestoreBinding
    }
    Rectangle {
        id: idBackScrollbar;
        radius: 2;
        antialiasing: true;
        color: "transparent"
        border {
            width: 1;
            color: "transparent";
        }
        anchors { fill: parent; }
    }
    MouseArea {
        id: idBtnUp;
        height: width;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            margins: (idBackScrollbar.border.width +1);
        }
        onClicked: { scrollUp (); }
        Text {
            text: "\uf0d7"
            font.family: fontAwesome.name
            color: (idBtnUp.pressed ? theme.primaryDark : "black");
            rotation: -180;
            anchors.centerIn: parent;
        }
    }
    MouseArea {
        id: idBtnDown;
        height: width;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
            margins: (idBackScrollbar.border.width +1);
        }
        onClicked: { scrollDown (); }
        Text {
            text: "\uf0d7"
            font.family: fontAwesome.name
            color: (idBtnDown.pressed ?  theme.primaryDark : "black");
            anchors.centerIn: parent;
        }
    }
    Item {
        id: idGroove;
        clip: true;
        anchors {
            fill: parent;
            topMargin: (idBackScrollbar.border.width +1 + idBtnUp.height +1);
            leftMargin: (idBackScrollbar.border.width +1);
            rightMargin: (idBackScrollbar.border.width +1);
            bottomMargin: (idBackScrollbar.border.width +1 + idBtnDown.height +1);
        }
        MouseArea {
            id: idClicker;
            drag {
                target: idHandle;
                minimumY: 0;
                maximumY: (idGroove.height - idHandle.height);
                axis: Drag.YAxis;
            }
            anchors { fill: parent; }
            onClicked: { flickable.contentY = (mouse.y / idGroove.height * (flickable.contentHeight - flickable.height)); }
        }
        Item {
            id: idHandle;
            height: Math.max (20, (flickable.visibleArea.heightRatio * idGroove.height));
            width: 1
            anchors {
                left: parent.left;
                right: parent.right;
            }
            Rectangle {
                id: idBackHandle;
                opacity: (flickable.moving ? 1 : 0.6);
                radius: width / 2
                color: theme.primary
                anchors { fill: parent; }
                Behavior on opacity { NumberAnimation { duration: 150; } }
            }
        }
    }
}
