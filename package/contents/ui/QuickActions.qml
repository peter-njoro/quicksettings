// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kcmutils as KCMUtils
import org.kde.plasma.private.sessions as Sessions
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    property var configuration

    Sessions.SessionManagement {
        id: sessionManagement
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionSystemSettings
            theme: root.t
            iconName: "systemsettings"
            tooltip: i18n("Open System Settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_landingpage")
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionLock
            theme: root.t
            iconName: "system-lock-screen"
            tooltip: i18n("Lock screen")
            onClicked: sessionManagement.lock()
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionDisplay
            theme: root.t
            iconName: "preferences-desktop-display"
            tooltip: i18n("Display settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_kscreen")
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionPower
            theme: root.t
            iconName: "preferences-system-power-management"
            tooltip: i18n("Power settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_powerdevil")
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionNetwork
            theme: root.t
            iconName: "preferences-system-network"
            tooltip: i18n("Network settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_networkmanagement")
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionBluetooth
            theme: root.t
            iconName: "preferences-system-bluetooth"
            tooltip: i18n("Bluetooth settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_bluetooth")
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignHCenter
            visible: !root.configuration || root.configuration.quickActionAudio
            theme: root.t
            iconName: "audio-volume-high"
            tooltip: i18n("Audio settings")
            onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_pulseaudio")
        }
    }
}
