import QtQuick 2.0

Rectangle {
    color: "black"
    width: 1024
    height: 768

    Image { source: "console.png"; scale: 1024/1920; anchors.centerIn: parent } // Simulate startup screen

    Talk {
        x:0
        y:0
        width: 1920
        height: 1080
        anchors.centerIn: parent
        scale: 1024/1920;
    }
}
