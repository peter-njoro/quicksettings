// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import "." as Components

// Decorative highlight layer for glass surfaces. Never takes input.
Item {
    id: root

    property var theme: null
    property real radius: 0

    readonly property var t: theme || fallbackTheme

    Components.Theme { id: fallbackTheme }

    enabled: false

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.round(parent.height * 0.55)
        radius: root.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.t.sheenTop }
            GradientStop { position: 1.0; color: root.t.sheenBottom }
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.max(0, parent.width - root.radius * 1.4)
        height: 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: root.t.alpha(root.t.specular, 0) }
            GradientStop { position: 0.5; color: root.t.specular }
            GradientStop { position: 1.0; color: root.t.alpha(root.t.specular, 0) }
        }
    }
}
