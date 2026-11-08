// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "../config/configGeneral.qml"
    }

    ConfigCategory {
        name: i18n("Koi")
        icon: "preferences-desktop-theme"
        source: "../config/configKoi.qml"
    }

    ConfigCategory {
        name: i18n("Sections")
        icon: "view-list-details"
        source: "../config/configSections.qml"
    }

    ConfigCategory {
        name: i18n("Quick Actions")
        icon: "view-grid"
        source: "../config/configQuickActions.qml"
    }
}
