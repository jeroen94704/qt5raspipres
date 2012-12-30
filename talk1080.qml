 import QtQuick 2.0

Rectangle {
    id: root
    color: "black"
    width: 1920
    height: 1080

    Image { source: "console.png"; anchors.centerIn: parent } // Simulate startup screen

    MouseArea {
        anchors.fill: parent
        onClicked: {
            fs.focus = true
        }
    }

    MouseArea {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 2
        height: 2
        hoverEnabled: true
        onEntered: {
            fs.focus = true
        }
        z: 10
    }

    FocusScope {
        id: fs
        focus: true
        anchors.fill: parent
        Talk {
            id: background
            anchors.fill: parent
            focus: true
        }
    }

}
