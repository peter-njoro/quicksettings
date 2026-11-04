// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    property bool dark: true
    property bool animationsEnabled: true

    signal activated()

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

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Layout.preferredWidth
            source: root.dark ? "weather-clear-night" : "weather-clear"
            opacity: 0.9
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                text: i18n("Appearance")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                text: root.dark ? i18n("Dark") : i18n("Light")
                color: root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                textFormat: Text.PlainText
            }
        }

        Components.ToggleButton {
            theme: root.t
            checked: root.dark
            onToggled: root.applyScheme(checked)
        }
    }
}
