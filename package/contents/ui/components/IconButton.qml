// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import "." as Components

Item {
    id: root

    property var theme: null
    property string iconName: ""
    property string tooltip: ""
    property bool interactive: true
    property bool checked: false
    property real iconSize: Kirigami.Units.iconSizes.smallMedium

    signal clicked()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered

    Components.Theme { id: fallbackTheme }

    implicitWidth: Math.max(iconSize + Kirigami.Units.smallSpacing * 1.5,
                            32)
    implicitHeight: implicitWidth
    opacity: interactive ? 1.0 : 0.45

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: root.checked
            ? root.t.alpha(root.t.accent, 0.24)
            : (root.hovered && root.interactive
                ? root.t.alpha(root.t.text, 0.12)
                : root.t.alpha(root.t.text, 0.0))

        Behavior on color {
            ColorAnimation { duration: root.t.shortAnimationDuration }
        }
    }

    Kirigami.Icon {
        anchors.centerIn: parent
        width: root.iconSize
        height: root.iconSize
        source: root.iconName
        opacity: root.interactive ? 1.0 : 0.7
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        enabled: root.interactive
        onTapped: root.clicked()
    }

    QQC2.ToolTip.text: root.tooltip
    QQC2.ToolTip.visible: root.hovered && root.tooltip.length > 0
    QQC2.ToolTip.delay: 600
}
