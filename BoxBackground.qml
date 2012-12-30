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


ShaderEffect {
    width: childrenRect.width+cornerRadius
    height: childrenRect.height+cornerRadius
    property color topColor: Qt.rgba(1.0,1.0,1.0,1.0)
    property color edgeColor: Qt.rgba(0.4,0.4,0.4,1.0)
    //anchors.horizontalCenter: parent.horizontalCenter
    property real cornerRadius: 20.0
    property real edgeBlur: 0.1
    property real edgeWidth: 0.5
    property real iedgeWidth: 1.0/edgeWidth
    vertexShader: "
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        varying highp vec2 corner;
        varying highp vec2 icorner;
        uniform float width;
        uniform float height;
        uniform float cornerRadius;
        void main() {
            corner = vec2(cornerRadius/width,cornerRadius/height);
            icorner = 1.0/corner;
            qt_TexCoord0 = 2.0*(vec2(0.5,0.5) - qt_MultiTexCoord0);
            qt_TexCoord1 = qt_MultiTexCoord0;
            gl_Position = qt_Matrix * qt_Vertex;
        }"
    fragmentShader: "
        uniform lowp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        varying highp vec2 corner;
        varying highp vec2 icorner;
        uniform float edgeBlur;
        uniform float iedgeWidth;
        uniform vec4 edgeColor;
        uniform vec4 topColor;
        void main() {
            float d = 1.0-length((clamp(abs(qt_TexCoord0) - (1.0 - corner),0.0,1.0))*icorner);
            float e = smoothstep(0.,edgeBlur,d);
            vec4 midColor = topColor*vec4(vec3(1.)*(1.0-smoothstep(0.45,0.55,qt_TexCoord1.y)*.3)*(1.0-qt_TexCoord1.y*0.3),1.);
            vec4 centerColor = mix(edgeColor,midColor,clamp(d*iedgeWidth,0.,1.));
           gl_FragColor = vec4(e)*centerColor*qt_Opacity;
        }"
}
