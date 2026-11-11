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

    readonly property real glassStrength: 1.0 - Math.max(0, Math.min(1, transparency))

    // Surface levels: main popup (24), cards (~20), interactive elements (~14).
    readonly property int popupRadius: Math.round(radius)
    readonly property int cardRadius: Math.round(Math.max(14, Math.min(22, radius * 0.85)))
    readonly property int controlRadius: Math.round(Math.max(10, Math.min(16, radius * 0.6)))

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

    // Level 1: main popup uses a single tint so its transparency is uniform.
    readonly property color background: dark
        ? Qt.rgba(0.108, 0.108, 0.122, glassStrength)
        : Qt.rgba(0.945, 0.945, 0.96, glassStrength)

    // Level 2: card tints follow the same transparency setting as the popup.
    readonly property color card: dark
        ? Qt.rgba(1, 1, 1, 0.02 + 0.09 * glassStrength)
        : Qt.rgba(1, 1, 1, 0.55 * glassStrength)
    readonly property color cardHover: dark
        ? Qt.rgba(1, 1, 1, 0.02 + 0.14 * glassStrength)
        : Qt.rgba(1, 1, 1, 0.75 * glassStrength)

    readonly property color border: dark
        ? Qt.rgba(1, 1, 1, 0.14)
        : Qt.rgba(0, 0, 0, 0.08)
    readonly property color borderHover: dark
        ? Qt.rgba(1, 1, 1, 0.24)
        : Qt.rgba(0, 0, 0, 0.14)

    // Surface highlights: a soft sheen across the top and a thin specular line on the top edge.
    readonly property color sheenTop: dark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(1, 1, 1, 0.55)
    readonly property color sheenBottom: Qt.rgba(1, 1, 1, 0)
    readonly property color specular: dark ? Qt.rgba(1, 1, 1, 0.42) : Qt.rgba(1, 1, 1, 0.95)

    readonly property color text: dark ? "#F5F5F7" : "#1D1D1F"
    readonly property color muted: dark ? "#ABABB3" : "#76767E"
    readonly property color inactive: dark ? "#4A4A50" : "#D9D9DE"
    readonly property color danger: dark ? "#ff7b72" : "#c01c28"

    // Neutral fill for icon circles and other controls that are off.
    readonly property color controlOff: dark ? Qt.rgba(1, 1, 1, 0.14) : Qt.rgba(0, 0, 0, 0.08)
    // Glyph colour that stays readable on top of the accent.
    readonly property color onAccent: accent.hslLightness > 0.6 ? "#1D1D1F" : "#FFFFFF"

    readonly property int spacing: spacingM

    function alpha(color, value) {
        return Qt.rgba(color.r, color.g, color.b, value);
    }
}
