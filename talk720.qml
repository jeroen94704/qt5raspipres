import QtQuick 2.0

Rectangle {
    color: "black"
    width: 1280
    height: 720

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
            anchors.centerIn: parent
            width: 1920
            height: 1080
            scale: 1280/1920
            id: background
            focus: true
        }
    }
}
