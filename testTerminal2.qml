import QtQuick 2.0

GridView {
    width: 800
    height: 400
    model: 80*40
    property int time
    NumberAnimation on time { from:0;to:10000;duration:10000;loops:-1}
    delegate: Rectangle {
        color: index%2?"red":"blue"
        width: 10
        height: 10
        Text {
            text: (index+time)%9
            color: index%3==0?"cyan":index%3==1?"magenta":"yellow"
        }
    }
    cellWidth: 10
    cellHeight: 10
}
