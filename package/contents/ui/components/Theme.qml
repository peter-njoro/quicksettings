// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.kirigami as Kirigami

QtObject {
    id: theme

    property bool dark: true
    property bool followAccent: true
    property bool animations: true
    property real animationSpeed: 1.0
    property bool blur: true
    property bool compact: false
    property real transparency: 0.85
    property real radius: 22

    readonly property real glassStrength: 0.55 + 0.45 * Math.max(0, Math.min(1, transparency))

    readonly property color accent: followAccent ? Kirigami.Theme.highlightColor : "#0a84ff"
    readonly property color backgroundTop: dark
        ? Qt.rgba(0.10, 0.12, 0.17, blur ? 0.74 * glassStrength : 0.98)
        : Qt.rgba(0.95, 0.96, 0.99, blur ? 0.84 * glassStrength : 0.99)
    readonly property color background: dark
        ? Qt.rgba(0.055, 0.065, 0.095, blur ? 0.84 * glassStrength : 0.98)
        : Qt.rgba(0.88, 0.90, 0.95, blur ? 0.88 * glassStrength : 0.99)
    readonly property color card: dark
        ? Qt.rgba(0.29, 0.32, 0.39, blur ? 0.42 * glassStrength : 0.98)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.58 * glassStrength : 0.99)
    readonly property color cardHover: dark
        ? Qt.rgba(0.37, 0.40, 0.48, blur ? 0.54 * glassStrength : 1.0)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.76 * glassStrength : 1.0)
    readonly property color cardSheen: dark
        ? Qt.rgba(1.0, 1.0, 1.0, 0.035)
        : Qt.rgba(1.0, 1.0, 1.0, 0.12)
    readonly property color border: dark
        ? Qt.rgba(1, 1, 1, 0.15)
        : Qt.rgba(0.12, 0.15, 0.21, 0.10)
    readonly property color text: dark ? "#f5f6fa" : "#1d2430"
    readonly property color muted: dark ? "#b2b9c7" : "#626a78"
    readonly property color inactive: dark ? "#626b7a" : "#c2c7d0"
    readonly property color danger: dark ? "#ff7b72" : "#c01c28"

    readonly property int spacing: compact ? Kirigami.Units.smallSpacing : Kirigami.Units.largeSpacing
    readonly property int cardPadding: compact
        ? Math.round(Kirigami.Units.smallSpacing * 1.5)
        : Math.round(Kirigami.Units.gridUnit * 0.65)
    readonly property int animationDuration: animations
        ? Math.round(Kirigami.Units.longDuration * animationSpeed) : 0
    readonly property int shortAnimationDuration: animations
        ? Math.round(Kirigami.Units.shortDuration * animationSpeed) : 0

    function alpha(color, value) {
        return Qt.rgba(color.r, color.g, color.b, value);
    }
}
