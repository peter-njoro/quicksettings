// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

import "." as Components

Item {
    id: root

    property var theme: null
    property bool checked: false
    property bool interactive: true
    property bool busy: false

    signal toggled(bool checked)

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered

    Components.Theme { id: fallbackTheme }

    implicitWidth: Math.round(Kirigami.Units.gridUnit * 2.2)
    implicitHeight: Math.round(Kirigami.Units.gridUnit * 1.3)
    opacity: interactive ? 1.0 : 0.5

    Rectangle {
        id: track

        anchors.fill: parent
        radius: height / 2
        color: root.checked ? root.t.accent : root.t.inactive
        opacity: root.hovered && root.interactive ? 1.0 : 0.92
        border.width: 1
        border.color: root.checked ? root.t.alpha(root.t.accent, 0.7)
                                   : root.t.alpha(root.t.text, 0.12)

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }
    }

    Rectangle {
        id: knob

        width: Math.max(8, parent.height - 6)
        height: width
        radius: width / 2
        y: (parent.height - height) / 2
        x: root.checked ? parent.width - width - 3 : 3
        color: "#ffffff"
        opacity: 0.96

        Behavior on x {
            NumberAnimation {
                duration: root.t.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        enabled: root.interactive && !root.busy
        onTapped: root.toggled(!root.checked)
    }

    Keys.onSpacePressed: {
        if (root.interactive) {
            root.toggled(!root.checked);
        }
    }
}
