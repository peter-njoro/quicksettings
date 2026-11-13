// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.battery
import org.kde.plasma.private.batterymonitor
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme: null
    property var configuration: null

    signal backRequested()

    readonly property var t: theme || fallbackTheme

    Components.Theme { id: fallbackTheme }

    BatteryControlModel {
        id: battery
    }

    PowerProfilesControl {
        id: powerProfiles
    }

    function stateText() {
        switch (battery.state) {
        case BatteryControlModel.Charging:
            return i18n("Charging");
        case BatteryControlModel.FullyCharged:
            return i18n("Fully charged");
        case BatteryControlModel.Discharging:
            return i18n("Discharging");
        default:
            return battery.pluggedIn ? i18n("Plugged in") : i18n("On battery");
        }
    }

    function profileLabel(profile) {
        switch (profile) {
        case "power-saver":
            return i18n("Power Saver");
        case "balanced":
            return i18n("Balanced");
        case "performance":
            return i18n("Performance");
        default:
            return profile;
        }
    }

    function remainingText() {
        if (!battery.hasBatteries || battery.remainingMsec <= 0) {
            return "";
        }
        const minutes = Math.round(battery.remainingMsec / 60000);
        const hours = Math.floor(minutes / 60);
        const rest = minutes % 60;
        if (hours > 0) {
            return i18np("%1 hour remaining", "%1 hours remaining", hours)
                + (rest > 0 ? " " + i18np("%1 minute", "%1 minutes", rest) : "");
        }
        return i18np("%1 minute remaining", "%1 minutes remaining", minutes);
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: root.t.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Components.IconButton {
                theme: root.t
                iconName: "go-previous"
                tooltip: i18n("Back")
                onClicked: root.backRequested()
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                text: i18n("Power")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
                textFormat: Text.PlainText
            }
        }

        PlasmaComponents3.ScrollView {
            id: scroll

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth

            PlasmaComponents3.ScrollBar.horizontal.policy: PlasmaComponents3.ScrollBar.AlwaysOff
            background: null

            ColumnLayout {
                width: scroll.availableWidth
                spacing: root.t.spacing

                Components.GlassCard {
                    Layout.fillWidth: true
                    theme: root.t
                    visible: battery.hasBatteries || battery.hasCumulative

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        RowLayout {
                            Layout.fillWidth: true

                            PlasmaComponents3.Label {
                                Layout.fillWidth: true
                                text: battery.percent + "%"
                                color: root.t.text
                                font.weight: Font.DemiBold
                                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 10
                                textFormat: Text.PlainText
                            }

                            Components.BatteryIcon {
                                Layout.preferredWidth: Kirigami.Units.iconSizes.large
                                Layout.preferredHeight: Layout.preferredWidth
                                theme: root.t
                                percent: battery.percent
                                charging: battery.state === BatteryControlModel.Charging
                            }
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: root.stateText()
                            color: root.t.muted
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            visible: text.length > 0
                            text: root.remainingText()
                            color: root.t.muted
                            font.pointSize: Kirigami.Theme.smallFont.pointSize
                            textFormat: Text.PlainText
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    Layout.topMargin: root.t.spacing
                    text: i18n("Power mode")
                    color: root.t.muted
                    font.weight: Font.DemiBold
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing
                    visible: powerProfiles.isPowerProfileDaemonInstalled

                    Repeater {
                        model: powerProfiles.profiles

                        delegate: Components.ActionButton {
                            Layout.fillWidth: true
                            theme: root.t
                            primary: powerProfiles.activeProfile === modelData
                            text: root.profileLabel(modelData)
                            checkable: true
                            checked: powerProfiles.activeProfile === modelData
                            onClicked: powerProfiles.setProfile(modelData)
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: !powerProfiles.isPowerProfileDaemonInstalled
                    text: i18n("Power profiles are not available on this system.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    wrapMode: Text.WordWrap
                    textFormat: Text.PlainText
                }

                Components.GlassCard {
                    Layout.fillWidth: true
                    Layout.topMargin: root.t.spacing
                    theme: root.t
                    interactive: true
                    onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_powerdevilprofilesconfig")

                    RowLayout {
                        Layout.fillWidth: true

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: i18n("Open power settings")
                            color: root.t.text
                            textFormat: Text.PlainText
                        }

                        Kirigami.Icon {
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            Layout.preferredHeight: Layout.preferredWidth
                            source: "go-next"
                        }
                    }
                }
            }
        }
    }
}
