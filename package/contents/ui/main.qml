// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property bool systemDark: Kirigami.Theme.backgroundColor.hslLightness < 0.5
    readonly property bool dark: plasmoid.configuration.appearance === "dark"
        || (plasmoid.configuration.appearance === "automatic" && systemDark)

    Plasmoid.title: i18n("Quick Settings")
    Plasmoid.icon: "preferences-system"
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
        | PlasmaCore.Types.ConfigurableBackground
    hideOnWindowDeactivate: plasmoid.configuration.closeOnOutsideClick

    toolTipMainText: i18n("Quick Settings")
    toolTipSubText: i18n("Open the quick control panel")

    compactRepresentation: CompactView {
        onActivated: root.expanded = !root.expanded
    }

    fullRepresentation: MainView {
        dark: root.dark
        configuration: plasmoid.configuration
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Configure Quick Settings…")
            icon.name: "configure"
            onTriggered: Plasmoid.internalAction("configure").trigger()
        }
    ]

    Connections {
        target: root
        function onExpandedChanged() {
            if (!root.expanded && !plasmoid.configuration.rememberView
                    && root.fullRepresentationItem) {
                root.fullRepresentationItem.resetToMain();
            }
        }
    }

    Keys.onEscapePressed: {
        if (root.fullRepresentationItem && root.fullRepresentationItem.currentPage !== 0) {
            root.fullRepresentationItem.resetToMain();
        } else {
            root.expanded = false;
        }
    }
}
