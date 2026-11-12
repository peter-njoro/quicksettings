// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kcmutils as KCMUtils
import org.kde.plasma.private.battery
import org.kde.plasma.private.sessions as Sessions
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var configuration
    property var theme: null

    readonly property var actions: {
        const list = [];
        if (!root.configuration || root.configuration.quickActionSystemSettings) {
            list.push({
                iconName: "systemsettings",
                tooltip: i18n("Open System Settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_landingpage");
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionLock) {
            list.push({
                iconName: "system-lock-screen",
                tooltip: i18n("Lock screen"),
                action: function() {
                    sessionManagement.lock();
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionDisplay) {
            list.push({
                iconName: "preferences-desktop-display",
                tooltip: i18n("Display settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_kscreen");
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionPower) {
            list.push({
                iconName: "preferences-system-power-management",
                iconComponent: battery.hasBatteries || battery.hasCumulative
                    ? powerIconComponent : null,
                tooltip: i18n("Power settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_powerdevilprofilesconfig");
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionNetwork) {
            list.push({
                iconName: "preferences-system-network",
                tooltip: i18n("Network settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_networkmanagement");
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionBluetooth) {
            list.push({
                iconName: "preferences-system-bluetooth",
                tooltip: i18n("Bluetooth settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_bluetooth");
                }
            });
        }
        if (!root.configuration || root.configuration.quickActionAudio) {
            list.push({
                iconName: "audio-volume-high",
                tooltip: i18n("Audio settings"),
                action: function() {
                    KCMUtils.KCMLauncher.openSystemSettings("kcm_pulseaudio");
                }
            });
        }
        return list;
    }

    Sessions.SessionManagement {
        id: sessionManagement
    }

    BatteryControlModel {
        id: battery
    }

    Component {
        id: powerIconComponent

        Components.BatteryIcon {
            theme: root.theme
            percent: battery.percent
            charging: battery.state === BatteryControlModel.Charging
        }
    }

    implicitWidth: row.implicitWidth
    implicitHeight: 32

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: Kirigami.Units.smallSpacing * 2

        Repeater {
            model: root.actions

            delegate: Components.IconButton {
                required property var modelData
                required property int index

                theme: root.theme
                iconName: modelData.iconName
                iconComponent: modelData.iconComponent || null
                tooltip: modelData.tooltip
                iconSize: Kirigami.Units.iconSizes.small
                onClicked: modelData.action()
            }
        }
    }
}
