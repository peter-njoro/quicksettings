// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

import "components" as Components

Components.CircleButton {
    id: root

    property bool dark: true
    property bool animationsEnabled: true

    function applyScheme(useDark) {
        executable.connectSource("plasma-apply-colorscheme "
            + (useDark ? "BreezeDark" : "BreezeLight"));
    }

    Plasma5Support.DataSource {
        id: executable

        engine: "executable"

        onNewData: function(sourceName, data) {
            executable.disconnectSource(sourceName);
        }
    }

    iconName: root.dark ? "weather-clear-night" : "weather-clear"
    label: i18n("Appearance")
    statusText: root.dark ? i18n("Dark") : i18n("Light")
    active: root.dark
    onActivated: root.applyScheme(!root.dark)
}
