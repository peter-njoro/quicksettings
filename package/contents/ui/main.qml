// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    readonly property bool systemDark: Kirigami.Theme.backgroundColor.hslLightness < 0.5
    readonly property bool dark: plasmoid.configuration.appearance === "dark"
        || (plasmoid.configuration.appearance === "automatic" && systemDark)
    readonly property bool useCustomIcon: plasmoid.configuration.useCustomIcon === true
    readonly property string customIcon: plasmoid.configuration.icon || ""
    readonly property string defaultIcon: Qt.resolvedUrl("../icons/quick-settings.svg")

    Plasmoid.title: i18n("Quick Settings")
    Plasmoid.icon: useCustomIcon && customIcon.length > 0 ? customIcon : defaultIcon
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground
        | PlasmaCore.Types.ConfigurableBackground
    hideOnWindowDeactivate: plasmoid.configuration.closeOnOutsideClick

    toolTipMainText: i18n("Quick Settings")
    toolTipSubText: i18n("Open the quick control panel")

    compactRepresentation: CompactView {
        useCustomIcon: root.useCustomIcon
        iconName: root.customIcon
        popupOpen: root.expanded
        onActivated: root.expanded = !root.expanded
    }

    fullRepresentation: MainView {
        // Give Plasma one fixed popup size. Matching the minimum, preferred
        // and maximum constraints prevents the popup from resizing to fit
        // individual pages or changes in the enabled controls.
        readonly property real fixedPopupWidth: implicitWidth
        readonly property real fixedPopupHeight: implicitHeight

        Layout.minimumWidth: fixedPopupWidth
        Layout.preferredWidth: fixedPopupWidth
        Layout.maximumWidth: fixedPopupWidth
        Layout.minimumHeight: fixedPopupHeight
        Layout.preferredHeight: fixedPopupHeight
        Layout.maximumHeight: fixedPopupHeight

        dark: root.dark
        systemDark: root.systemDark
        configuration: plasmoid.configuration
        onConfigureRequested: Plasmoid.internalAction("configure").trigger()
    }

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
