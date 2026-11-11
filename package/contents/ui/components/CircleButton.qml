// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

import "." as Components

Item {
    id: root

    property var theme: null
    property string iconName: ""
    property bool iconIsMask: false
    property string label: ""
    property string statusText: ""
    property bool active: false
    property bool interactive: true

    signal activated()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered

    Components.Theme { id: fallbackTheme }

    implicitWidth: 44
    implicitHeight: 44
    opacity: interactive ? 1.0 : 0.5

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.active ? root.t.accent
            : (root.interactive && root.hovered ? root.t.cardHover : root.t.card)
        border.width: 1
        border.color: root.interactive && root.hovered ? root.t.borderHover : root.t.border

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }

        Behavior on border.color {
            ColorAnimation { duration: root.t.shortAnimationDuration }
        }

        Components.GlassSheen {
            anchors.fill: parent
            theme: root.t
            radius: parent.radius
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.smallMedium
            height: width
            source: root.iconName
            isMask: true
            color: root.active ? root.t.onAccent : root.t.text
            opacity: root.interactive ? 1.0 : 0.6
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        enabled: root.interactive
        onTapped: root.activated()
    }

    Keys.onSpacePressed: {
        if (root.interactive) {
            root.activated();
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: root.statusText.length > 0
        ? root.label + ", " + root.statusText : root.label
    Accessible.checked: root.active
}
