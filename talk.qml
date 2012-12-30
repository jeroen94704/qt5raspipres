import QtQuick 2.0

Rectangle {
    color: "black"
    width: 1280
    height: 720

    Image { source: "console.png"; scale: 1280/1920; anchors.centerIn: parent } // Simulate startup screen

    Talk {
        anchors.fill: parent
    }
}
