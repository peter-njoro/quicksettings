// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

QtObject {
    id: theme

    property bool dark: true
    property bool followAccent: true
    property bool animations: true
    property bool blur: true
    property bool compact: false
    property real transparency: 0.85
    property real radius: 22

    readonly property real glassStrength: 0.55 + 0.45 * Math.max(0, Math.min(1, transparency))

    readonly property color accent: followAccent ? Kirigami.Theme.highlightColor : "#3daee9"
    readonly property color background: dark
        ? Qt.rgba(0.09, 0.10, 0.12, 0.62 * glassStrength)
        : Qt.rgba(0.98, 0.98, 0.99, 0.72 * glassStrength)
    readonly property color card: dark
        ? Qt.rgba(0.16, 0.17, 0.20, blur ? 0.60 * glassStrength : 0.97)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.62 * glassStrength : 0.97)
    readonly property color cardHover: dark
        ? Qt.rgba(0.22, 0.23, 0.27, blur ? 0.72 * glassStrength : 1.0)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.82 * glassStrength : 1.0)
    readonly property color border: dark
        ? Qt.rgba(1, 1, 1, 0.10)
        : Qt.rgba(0, 0, 0, 0.08)
    readonly property color text: dark ? "#f2f3f5" : "#1b1c1e"
    readonly property color muted: dark ? "#a3a7ae" : "#5f6368"
    readonly property color inactive: dark ? "#6d7178" : "#a0a4ab"
    readonly property color danger: dark ? "#ff7b72" : "#c01c28"

    readonly property int spacing: compact ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
    readonly property int cardPadding: compact
        ? Math.round(Kirigami.Units.smallSpacing * 1.5)
        : Math.round(Kirigami.Units.gridUnit * 0.65)
    readonly property int animationDuration: animations ? Kirigami.Units.longDuration : 0
    readonly property int shortAnimationDuration: animations ? Kirigami.Units.shortDuration : 0

    function alpha(color, value) {
        return Qt.rgba(color.r, color.g, color.b, value);
    }
}
