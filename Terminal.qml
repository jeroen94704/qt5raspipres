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
import "experimental" 1.0
import QtQuick.Particles 2.0

FocusScope {
    BackBox {
        id: bb
        anchors.fill: parent
    Process {
        anchors.centerIn: parent
        id:process
        Component.onCompleted: {
            process.cw=contentWidth;
            process.ch=contentHeight;
            launch("/bin/bash","-i");
            size = Qt.size(80,23);
        }
        //onStderrChanged: { terminal.text+=stderr; }
        onStdoutChanged: { text=stdout; }
        focus: true
        onFocusChanged: console.log("process focus",focus)
        //size: Qt.size(30,80)

        property real cw
        property real ch
        color: "white"
        font.pixelSize: 38
        font.weight: Font.Bold
        font.family: "Courier"
        textFormat: Text.PlainText
        text: "."

        onCursorChanged: {
            stars.burst(5);
            cursorRect.width = process.cw;
            cursorRect.height = process.ch;
            cursorRect.x = cursorRect.width*cursor.x;
            cursorRect.y = cursorRect.height*cursor.y;
            //console.log(cursor.x,cursor.y,size.width,size.height);
            stars.burst(5);
        }

        //NumberAnimation on visible { from: -1; to: 2; duration: 5000; loops: -1 }

        Text {
            id: cursorpad

        }
            Rectangle {
            id: cursorRect
            color: Qt.rgba(1,0,0,0.5)
            Behavior on x { SpringAnimation {spring: 4; damping: 0.2} }
            Behavior on y { SpringAnimation {spring: 4; damping: 0.2 } }
        }

        ParticleSystem {
            id: particles
        }

        ImageParticle {
            id: star
            system: particles
            anchors.fill: parent
            groups: ["A"]
            source: "star.png"
            colorVariation: 100
            color: "#00111111"
        }

        Emitter {
             id: stars
             group: "A"
             system: particles
             anchors.fill: cursorRect
             lifeSpan: 1000
             velocity : PointDirection {yVariation: 100; xVariation: 100}
             acceleration: PointDirection {xVariation: 100; yVariation: 100}
             size: 10
             sizeVariation: 8
             endSize: 16
             emitRate: 50
         }


        //Keys.onEscapePressed: { Qt.quit(); }
        //Keys.onPressed: {
        //    process.writeEvent(event);
            //process.writeString(event.text);
            //console.log(event.key);
        //}
        //Keys.onReturnPressed: {
        //    process.writeChar(13);
        //}
    }
    }
}
