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
    property real radius: 24

    readonly property real glassStrength: 0.55 + 0.45 * Math.max(0, Math.min(1, transparency))

    // Surface levels: main popup (24), cards (~17), interactive elements (12).
    readonly property int popupRadius: Math.round(radius)
    readonly property int cardRadius: Math.round(Math.max(12, Math.min(18, radius * 0.73)))
    readonly property int controlRadius: Math.round(Math.max(8, Math.min(13, radius * 0.5)))

    // Spacing scale (4/8/12/16/20/24), softened for compact mode.
    readonly property int spacingXs: Math.round(compact ? 3 : 4)
    readonly property int spacingS: Math.round(compact ? 6 : 8)
    readonly property int spacingM: Math.round(compact ? 9 : 12)
    readonly property int padding: Math.round(compact ? 12 : 16)
    readonly property int sectionSpacing: Math.round(compact ? 15 : 20)
    readonly property int majorSpacing: Math.round(compact ? 18 : 24)

    readonly property int cardPadding: compact
        ? Math.round(Kirigami.Units.smallSpacing * 1.25)
        : Math.round(Kirigami.Units.gridUnit * 0.55)

    readonly property int animationDuration: animations
        ? Math.round(Kirigami.Units.longDuration * animationSpeed) : 0
    readonly property int shortAnimationDuration: animations
        ? Math.round(Kirigami.Units.shortDuration * animationSpeed) : 0

    readonly property color accent: followAccent ? Kirigami.Theme.highlightColor : "#0a84ff"

    // Level 1: main popup. Slightly lighter at the top for depth.
    readonly property color backgroundTop: dark
        ? Qt.rgba(0.165, 0.169, 0.188, blur ? 0.9 * glassStrength : 1.0)
        : Qt.rgba(0.969, 0.973, 0.98, blur ? 0.92 * glassStrength : 1.0)
    readonly property color background: dark
        ? Qt.rgba(0.145, 0.149, 0.169, blur ? 0.9 * glassStrength : 1.0)
        : Qt.rgba(0.957, 0.961, 0.969, blur ? 0.92 * glassStrength : 1.0)

    // Level 2: cards. Translucent while blurred, opaque otherwise.
    readonly property color card: dark
        ? Qt.rgba(0.188, 0.192, 0.22, blur ? 0.78 * glassStrength : 1.0)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.78 * glassStrength : 1.0)
    readonly property color cardHover: dark
        ? Qt.rgba(0.235, 0.239, 0.267, blur ? 0.88 * glassStrength : 1.0)
        : Qt.rgba(1.0, 1.0, 1.0, blur ? 0.94 * glassStrength : 1.0)

    readonly property color border: dark
        ? Qt.rgba(1, 1, 1, 0.13)
        : Qt.rgba(0, 0, 0, 0.09)
    readonly property color borderHover: dark
        ? Qt.rgba(1, 1, 1, 0.2)
        : Qt.rgba(0, 0, 0, 0.14)

    readonly property color text: dark ? "#F4F4F5" : "#202127"
    readonly property color muted: dark ? "#A5A6AE" : "#777982"
    readonly property color inactive: dark ? "#55565D" : "#D5D6DB"
    readonly property color danger: dark ? "#ff7b72" : "#c01c28"

    readonly property int spacing: spacingM

    function alpha(color, value) {
        return Qt.rgba(color.r, color.g, color.b, value);
    }
}
