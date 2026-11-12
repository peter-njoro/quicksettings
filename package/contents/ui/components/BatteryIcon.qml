// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Shapes

import "." as Components

Item {
    id: root

    property var theme: null
    property int percent: 75
    property bool charging: false
    property color color: root.t.text

    readonly property var t: theme || fallbackTheme
    readonly property int steppedPercent: percent <= 0
        ? 0
        : Math.max(25, Math.min(100, Math.round(percent / 25) * 25))
    readonly property real fraction: steppedPercent / 100
    readonly property string level: steppedPercent <= 25
        ? "low"
        : (steppedPercent <= 50 ? "medium" : "full")
    readonly property color chargeTop: level === "low"
        ? "#ff9a8a"
        : (level === "medium" ? "#ffd66b" : "#8ff08a")
    readonly property color chargeBottom: level === "low"
        ? "#e5484d"
        : (level === "medium" ? "#f0a020" : "#28c76f")
    readonly property real artSize: 128
    readonly property real artScale: Math.min(width / artSize, height / artSize)

    implicitWidth: 32
    implicitHeight: 32

    Components.Theme { id: fallbackTheme }

    Item {
        id: art

        width: root.artSize
        height: root.artSize
        anchors.centerIn: parent
        scale: root.artScale

        Rectangle {
            x: 106
            y: 52
            width: 9
            height: 24
            radius: 4.5
            color: root.t.alpha(root.color, 0.22)
            border.width: 2
            border.color: root.t.alpha(root.color, 0.58)
        }

        Rectangle {
            x: 9
            y: 27
            width: 100
            height: 74
            radius: 21
            border.width: 3
            border.color: root.t.alpha(root.color, 0.72)
            gradient: Gradient {
                GradientStop { position: 0; color: root.t.alpha(root.color, 0.15) }
                GradientStop { position: 1; color: root.t.alpha(root.color, 0.04) }
            }
        }

        Rectangle {
            x: 14
            y: 32
            width: 90
            height: 64
            radius: 16
            color: "transparent"
            border.width: 1.5
            border.color: Qt.rgba(1, 1, 1, 0.28)
        }

        Rectangle {
            x: 15
            y: 34
            height: 60
            width: 88 * root.fraction
            radius: 13
            gradient: Gradient {
                GradientStop { position: 0; color: root.chargeTop }
                GradientStop { position: 1; color: root.chargeBottom }
            }

            Behavior on width {
                NumberAnimation { duration: root.t.animationDuration }
            }
        }

        Rectangle {
            x: 15
            y: 34
            width: 88
            height: 60
            radius: 14
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.58) }
                GradientStop { position: 0.48; color: Qt.rgba(1, 1, 1, 0.08) }
                GradientStop { position: 1; color: Qt.rgba(1, 1, 1, 0) }
            }
        }

        Rectangle {
            x: 15
            y: 34
            width: 88
            height: 60
            radius: 14
            color: "transparent"
            border.width: 1.5
            border.color: root.t.alpha(root.color, 0.22)
        }

        Shape {
            width: root.artSize
            height: root.artSize

            ShapePath {
                strokeColor: Qt.rgba(1, 1, 1, 0.62)
                strokeWidth: 2.5
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin

                PathSvg {
                    path: "M25 35.5h65c5.5 0 9.5 3.8 10.8 8.5"
                }
            }
        }

        Shape {
            visible: root.charging
            width: root.artSize
            height: root.artSize

            ShapePath {
                fillColor: root.color
                strokeColor: "transparent"

                PathSvg {
                    path: "M64 44 L50 68 H59 L55 84 L70 60 H61 Z"
                }
            }
        }
    }
}
