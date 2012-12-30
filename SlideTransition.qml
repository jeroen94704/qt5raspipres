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
    property variant oldSlide
    property variant newSlide
    property real progress: 0.0
    vertexShader: "
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        uniform float progress;
        void main() {
            qt_TexCoord0 = qt_MultiTexCoord0;
            qt_TexCoord1 = qt_MultiTexCoord0-vec2(0.5);
            gl_Position = qt_Matrix * qt_Vertex;
        }"

        fragmentShader: "
        uniform lowp float qt_Opacity;
        varying highp vec2 qt_TexCoord0;
        varying highp vec2 qt_TexCoord1;
        uniform sampler2D oldSlide;
        uniform sampler2D newSlide;
        uniform float progress;

        void main() {
            const float width = 0.1;
            const float sp = 1.0+width;
            lowp float xdep = smoothstep(sp*progress-width,sp*progress,1.0-qt_TexCoord0.x);
            lowp vec4 old = texture2D(oldSlide,clamp(qt_TexCoord0-(1.0-xdep)*vec2(0.0,qt_TexCoord1.y),0.,1.));
            lowp vec4 new = texture2D(newSlide,qt_TexCoord0)*(1.0-xdep);
            gl_FragColor = mix(old,new,(1.0-xdep))*qt_Opacity;
        }"
}



