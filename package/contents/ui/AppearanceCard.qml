// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import "components" as Components

Components.CircleButton {
    id: root

    property bool dark: true
    property bool koiConnected: false
    property bool koiOnboarded: false
    property bool animationsEnabled: true

    readonly property bool ready: koiConnected && koiOnboarded

    iconName: Qt.resolvedUrl("../icons/appearance.svg")
    iconIsMask: true
    label: i18n("Appearance")
    statusText: !ready
        ? i18n("Set up")
        : (dark ? i18n("Dark") : i18n("Light"))
    active: root.ready ? root.dark : false
}
