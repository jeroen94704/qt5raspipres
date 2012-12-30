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
import QtGraphicalEffects 1.0

Slide {
    id: slide
    Image {
        id: src
        source: "trees.png"
        Text {
            text: "QML"
            anchors.centerIn: parent
            color: "red"
            font.pixelSize: 90
            rotation: slide.time*0.01
            SequentialAnimation on color {
                running: true
                paused: !slide.timeRunning
                onRunningChanged: { console.log("color anim running",running) }
                loops: -1
                ColorAnimation {from: "red";to: "yellow";duration: 2300}
                ColorAnimation {from: "yellow";to: "green";duration: 2300}
                ColorAnimation {from: "green";to: "cyan";duration: 2300}
                ColorAnimation {from: "cyan";to: "blue";duration: 2300}
                ColorAnimation {from: "blue";to: "magenta";duration: 2300}
                ColorAnimation {from: "magenta";to: "red";duration: 2300}
            }
        }
    }
    Column {
        spacing: 80
        anchors.centerIn: parent
        Body { text: "import QtGraphicalEffects.EffectName 1.0"; font.family: "Courier"; font.weight: Font.Bold }
        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            rows: 2
            spacing: 80
            rowSpacing: 40
            ShaderEffectSource {
                id: ses
                sourceItem: src
                hideSource: true
                width: src.width
                height: src.height
            }
            Column {
                spacing: 10
                Desaturate {
                    width: src.width
                    height: src.height
                    desaturation: 0.5+Math.sin(slide.time*0.000489)*0.5
                    source: ses
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Body { text: "Desaturate" }
            }
            Column {
                spacing: 10
                Colorize {
                    width: src.width
                    height: src.height
                    hue: 0.5+Math.sin(slide.time*0.000589)*0.4
                    saturation: 0.5+Math.sin(slide.time*0.000389)*0.4
                    lightness: 0.5+Math.sin(slide.time*0.000489)*0.4
                    source: ses
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Body { text: "Colorize" }
            }
            Column {
                spacing: 10
                FastBlur {
                    width: src.width
                    height: src.height
                    radius: 32.0*(0.5+Math.sin(slide.time*0.002)*0.5)
                    transparentBorder: true
                    source: ses
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Body { text: "FastBlur" }
            }
            Column {
                spacing: 20
                ThresholdMask {
                    width: src.width
                    height: src.height
                    maskSource: Image { source: "treesmask.png" }
                    threshold: 0.5+Math.sin(slide.time*0.000789)*0.4
                    source: ses
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Body { text: "ThresholdMask";font.pixelSize: 40 }
            }
            Column {
                spacing: 10
                ZoomBlur {
                    width: src.width
                    height: src.height
                    source: ses
                    anchors.horizontalCenter: parent.horizontalCenter
                    length: (0.5+Math.sin(slide.time*0.005)*0.5) * 32.0
                    samples: 8
                    horizontalOffset: (0.5+Math.sin(slide.time*0.000489)*0.5) * width
                    verticalOffset: (0.5+Math.sin(slide.time*0.000689)*0.5) * height
                }
                Body { text: "ZoomBlur" }
            }

        }
     }
}
