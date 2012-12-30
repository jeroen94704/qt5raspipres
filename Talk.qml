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

FocusScope {
    id: show
    Behavior on opacity { NumberAnimation { duration: 1000 } }
    opacity: 0
    Component.onCompleted: {
        opacity=1.0;
        goToSlide(0,true);
    }
    property real time: 0.0
    Background {
        time:show.time
        anchors.fill: parent
    }

    focus: true
    onFocusChanged: console.log("show focus",focus)
    onActiveFocusChanged: console.log("show active focus",focus)
    //property ListView foregroundSlide: view
    //property ListView backgroundSlide: view
    ShaderEffectSource {
        id: oldSlideSource
        anchors.fill: parent
        visible: false
        hideSource: false
        live: false
        textureSize: Qt.size(parent.width,parent.height)
        sourceItem: slides.children[0];
    }
    ShaderEffectSource {
        id: newSlideSource
        anchors.fill: parent
        visible: false
        hideSource: false
        live: false
        textureSize: Qt.size(parent.width,parent.height)
        sourceItem: slides.children[1];
    }

    SlideTransition2 {
        visible: false
        anchors.fill: parent
        id: transition
        oldSlide: oldSlideSource
        newSlide: newSlideSource
        onVisibleChanged: console.log("trans visible",visible);
        //onProgressChanged: console.log("progress",progress);
        SequentialAnimation {
            id: anim
            //ScriptAction { script: time.pause(); }
            PropertyAction { target: transition; property: "visible"; value: true }
            //PropertyAnimation { target: view; property: "visible"; to: false }
            NumberAnimation { target: transition; property: "progress"; from: 0.0; to: 1.0; duration: 1000 }
            PropertyAction { target: transition; property: "visible"; value: false }
            //PropertyAnimation { target: view; property: "visible"; to: true }
            //ScriptAction { script: show.goToSlide(show.currentSlide+1); }
            PropertyAction { target: oldSlideSource; property: "hideSource"; value: false }
            PropertyAction { target: newSlideSource; property: "hideSource"; value: false }
            ScriptAction { script: goToSlide(currentSlide+1,true); }
        }
    }

    function repositionQMark()
    {
    }

    function transitionToNextSlide()
    {
        if (anim.running&&transition.progress<1.0) return;
        if ((currentSlide+1)>=slides.children.length) return;
        // Hide the normal view
        // Snapshot old slide
        oldSlideSource.hideSource = true;
        oldSlideSource.sourceItem = slides.children[currentSlide];
        //slides.children[currentSlide].visible = true;
        //oldSlide.visible = false;
        oldSlideSource.scheduleUpdate();
        // Move to new slide
        //goToSlide(currentSlide+1,false);
        // Snapshot new slide
        newSlideSource.hideSource = true;
        newSlideSource.sourceItem = slides.children[currentSlide+1];
        //newSlide.anchors.fill = slides.children[currentSlide+1];
        //transition.anchors.fill = slides.children[currentSlide+1];
        //slides.children[currentSlide+1].visible = true;
        //newSlide.visible = false;
        newSlideSource.scheduleUpdate();
        //
        //transition.visible = true;
        //goToSlide(currentSlide+1,true);
        anim.restart();
    }

    Keys.onSpacePressed: { transitionToNextSlide();}

    //property ListView tempSlide: view
    property int currentSlide: 0
    property bool behaviorEnabled: false

    Keys.onPressed: {
        switch(event.key)
        {
        case 16777239:
            transitionToNextSlide();
            break;
        case 16777238:
            goToSlide(currentSlide-1,false);
            break;
        }
    }

    Keys.onEscapePressed: {
        if (slides.children[currentSlide].focus)
            slides.children[currentSlide].focus = false;
        else
            Qt.quit();
    }
    Keys.onLeftPressed: {goToSlide(currentSlide-1,false); }
    Keys.onRightPressed: {goToSlide(currentSlide+1,true); }
    Keys.onTabPressed: { slides.children[currentSlide].focus = true; }
    function goToSlide(target,leftToRight) {
        if (target<0) return;
        if (target>=slides.children.length) return;
        //if (anim.running&&transition.progress<1.0) return;
        console.log("go to ",target,slides.children.length);
        if (currentSlide!=target) {
            slides.children[currentSlide].visible = false;
            slides.children[currentSlide].timeRunning = false;
        }
        slides.children[target].x = show.x;
        slides.children[target].y = show.y;
        slides.children[target].width = show.width;
        slides.children[target].height = show.height;
        slides.children[target].visible = true;
        slides.children[target].timeRunning = true;
        //slides.children[target].focus = true;
        //foregroundSlide.positionViewAtIndex(target,ListView.Contain);
        currentSlide = target;
        //foregroundSlide.currentIndex = target;
    }

    Image {
        id : raspberry
        source : "raspgrid.png"
        anchors.centerIn : parenti
    visible : false;
    }

    FocusScope {
        id: slides
        anchors.fill: parent
        focus: true
        onFocusChanged: console.log("slides focus",focus)
        Slide {
            Column {
                anchors.centerIn: parent
                Box {
                    topColor : "red"
                    edgeColor: "red"
                    edgeBlur: 0.25
                    cornerRadius: 50
                    Column {
                        x: parent.cornerRadius/2
                        y: parent.cornerRadius/2
                        Title { text: "Qt 5 on Raspberry Pi" }
                        Body { text: "Jeroen Bouwens"; font.pixelSize: 80 }
                        Body { text: "With thanks to Andrew Baldwin"; font.pixelSize: 20 }
                    }
                }
            }
        }
        Slide {
            Column {
                anchors.centerIn: parent
                spacing: 20
                Title { text: "What is a Raspberry Pi?" }
                Body { text: "Small, cheap, ARM11-based computer" }
                Body { text: "700 MHz processor, 256 MB memory" }
                Body { text: "HDMI, Ethernet, USB, Audio, SD card reader" }
                Body { text: "Hardware accelerated graphics: OpenGL ES and Video" }
            }
        }
        Slide{
        Image {
            source : "myraspi.jpg"
            anchors.centerIn: parent
        scale : 1.3
        }
    }
        Slide{
        Image {
            source : "raspi_arduino.jpg"
            anchors.centerIn: parent
        scale : 1.3
        }
    }
    Slide {
            Column {
                anchors.centerIn: parent
                spacing: 20
                Title { text: "What is Qt?" }
                Body { text: "Cross-platform C++ toolkit" }
                Body { text: "Started as GUI toolkit, evolved into extensive framework" }
                Body { text: "More than 20 years development" }
                Body { text: "" }
            }
        }
        Slide {
            Column {
                anchors.centerIn: parent
                spacing: 20
                Title { text: "QtQuick / QML" }
                Body { text: "Declarative language to describe UI" }
                Body { text: "Rich UI's, both for desktop and mobile devices" }
                Body { text: "Imperative logic with JavaScript" }
                Body { text: "Integrate with C++" }
                Body { text: "Strong separation between model and presentation" }
            }
        }
        Slide {
            Column {
                anchors.centerIn: parent
                spacing: 20
                Title { text: "The big deal with Qt5" }
                Body { text: "Introduction of QML 2.0" }
                Body { text: "OpenGL-based rendering pipeline: kick-ass performance" }
                Body { text: "Shaders as first-class citizens" }
                Body { text: "No OpenGL == No Qt5!" }

            }
        }
    Slide {
            Column {
                anchors.centerIn: parent
                spacing: 20
                Title { text: "Current Caveats" }
                Body { text: "Bleeding edge, so Alpha/Beta status" }
                Body { text: "QtCreator does not yet support QML 2" }
                Body { text: "Project for standard components not ready" }
                Body { text: "" }

            }
    }
        Slide {
            Editor {
                id : codeEditor
                focus: true
                editorFocus: parent.focus
                initialtext: "import QtQuick 2.0

Rectangle {
\twidth: 200
\theight: 100
\tcolor:\"white\"
}";
                anchors.fill: parent
                BoxTitle {
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text:"QML";
                }
            }
        }
        Slide {
            id : shaderEditor
            Editor {
                focus: true
                editorFocus: parent.focus
                initialtext: "import QtQuick 2.0

ShaderEffect {
\tanchors.fill: parent
\tproperty variant tex: raspberry
\tproperty real time: shaderEditor.time*0.001
\tfragmentShader:\"
\tuniform sampler2D tex;
\tuniform lowp float qt_Opacity;
\tvarying highp vec2 qt_TexCoord0;
\tuniform float time;
\tvoid main() {
\t\thighp vec2 c = qt_TexCoord0;
\t\tgl_FragColor =
\t\t\tvec4(0.,0.,0.,0.)
\t\t\t*qt_Opacity;
\t}\"
}";
                anchors.fill: parent
                BoxTitle {
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text:"Shaders";
                }
            }
        }
        Slide {
            Text {
                x : parent.width / 2.0
                y : parent.height / 2.0
                id : qmark
                text : "?"
                color : "white"
                font.family : "Verdana"
                font.pixelSize : 200
                SequentialAnimation
                {
                    id : reposition
                    NumberAnimation { target: qmark; property: "opacity"; to: 0.0; duration: 1000; }
                    ScriptAction { script: {qmark.x = Math.random()*1800; qmark.y = Math.random()*900;} }
                    NumberAnimation { target: qmark; property: "opacity"; to: 1.0; duration: 1000; }
                }
                Timer {
                    interval : 5000; running: true; repeat: true;
                    onTriggered:
                    {
                        reposition.restart();
                    }
                }
            }
        }


    }
}
