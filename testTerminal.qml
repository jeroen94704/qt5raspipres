import QtQuick 2.0

Rectangle {
    width: 960
    height: 540
    color: "black"
    Terminal {
        anchors.centerIn: parent
        width: 1920
        height: 1080
        focus: true
        scale: 0.5
    }
}
