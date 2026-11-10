// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.plasma.components as PlasmaComponents3

import "." as Components

Item {
    id: root

    property var theme: null
    property bool checked: false
    property bool interactive: true
    property string tooltip: ""

    signal toggled()
    signal clicked()

    readonly property var t: theme || fallbackTheme

    Components.Theme { id: fallbackTheme }

    implicitWidth: 50
    implicitHeight: 30
    opacity: root.interactive ? 1.0 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.checked ? root.t.accent : root.t.inactive

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }
    }

    Rectangle {
        id: thumb

        width: 26
        height: width
        radius: width / 2
        color: "#FFFFFF"
        border.width: 1
        border.color: root.t.alpha("#000000", 0.1)
        y: (parent.height - height) / 2
        x: root.checked ? parent.width - width - 2 : 2

        Behavior on x {
            NumberAnimation {
                duration: root.t.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }
    }

    HoverHandler {
        id: hoverHandler

        enabled: root.interactive
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        enabled: root.interactive
        onTapped: {
            root.toggled();
            root.clicked();
        }
    }

    Keys.onSpacePressed: {
        if (root.interactive) {
            root.toggled();
            root.clicked();
        }
    }

    PlasmaComponents3.ToolTip.text: root.tooltip
    PlasmaComponents3.ToolTip.visible: hoverHandler.hovered && root.tooltip.length > 0
    PlasmaComponents3.ToolTip.delay: 600

    Accessible.role: Accessible.Button
    Accessible.name: tooltip
    Accessible.checked: root.checked
}
