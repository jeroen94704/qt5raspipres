/*
Copyright (C) 2012 Andrew Baldwin

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import QtQuick 2.0

FocusScope{
    property bool editorFocus: false
    id: root
    property string initialtext;
    Flickable {
        id: flick
        opacity: 1
        Behavior on opacity { NumberAnimation { duration: 300 } }
        anchors.fill: parent
        contentWidth:backbox.width
        contentHeight:backbox.height
        z: 100
        Behavior on contentX { SpringAnimation {spring: 2; damping: 0.2 } }
        Behavior on contentY { SpringAnimation {spring: 2; damping: 0.2 } }
        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }
        BackBox {
            id: backbox
            anchors.centerIn: parent
            width: editor.width+40
            height: editor.height+40
            Behavior on width { SpringAnimation { spring: 2; damping: 0.2} }
            Behavior on height{ SpringAnimation { spring: 2; damping: 0.2} }
            Behavior on x { SpringAnimation {spring: 2; damping: 0.2 } }
            Behavior on y { SpringAnimation {spring: 2; damping: 0.2 } }
        }
        TextEdit {
            id: editor
            x: backbox.x+20
            y: backbox.y+20
            focus: editorFocus
            onFocusChanged: { console.log("TextEdit focus",focus); }
            cursorDelegate: Rectangle { width: 10; color: "yellow"; opacity: 0.5 }
            onTextChanged: {
              var newtest = Qt.createQmlObject(text,testparent,"test");
              if (newtest) {
                if (testparent.test) testparent.test.destroy();
                  testparent.test = newtest;
                  testparent.test.anchors.centerIn = testparent;
                }
            }
            Component.onCompleted: {
              text=root.initialtext;
            }
            font.family: "Courier"
            font.pixelSize: 45
            font.weight: Font.Bold
            color: "white"
            Keys.onTabPressed: {
                // Wierd... tab didn't work on HW??
                var ocp;
                ocp = cursorPosition;
                text = text.slice(0,ocp) + "\t" + text.slice(ocp,text.length);
                cursorPosition = ocp+1;
            }
            Keys.onPressed: {
                if (event.key==Qt.Key_F1) {
                    if (flick.opacity==1) flick.opacity=0.;
                    else flick.opacity=1.0;
                }
            }
            //  Keys.onEscapePressed: { root.editorFocus=false; }
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
        }
    }
    Item {
        property Item test;
        id: testparent
        anchors.fill: parent
    }
}
