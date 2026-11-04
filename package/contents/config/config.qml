// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "configGeneral.qml"
    }

    ConfigCategory {
        name: i18n("Sections")
        icon: "view-list-details"
        source: "configSections.qml"
    }

    ConfigCategory {
        name: i18n("Quick Actions")
        icon: "view-grid"
        source: "configQuickActions.qml"
    }
}
