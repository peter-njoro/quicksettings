// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme: null
    property var koiController: null
    property bool dark: true
    property bool onboarded: false

    signal backRequested()
    signal koiOnboarded()

    readonly property var t: theme || fallbackTheme
    readonly property var koi: koiController || fallbackKoi
    readonly property bool busy: koi.checking
    readonly property bool connectionReady: koi.connected && !busy
    readonly property bool showOnboarding: !connectionReady || !onboarded
    readonly property bool missingKoi: !koi.installed && !koi.connected
    readonly property bool needsLaunch: koi.installed && !koi.connected
    readonly property bool needsProfiles: koi.connected && !onboarded

    Components.Theme { id: fallbackTheme }
    KoiController { id: fallbackKoi }

    Component.onCompleted: koi.checkKoi()

    // Recheck periodically while Koi has been detected but is still starting up.
    Timer {
        running: root.visible && root.needsLaunch
        interval: 3000
        repeat: true
        onTriggered: koi.checkKoi()
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
                text: root.showOnboarding ? i18n("Set up Appearance") : i18n("Appearance")
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
                    visible: root.showOnboarding

                    ColumnLayout {
                        width: parent.width
                        spacing: root.t.spacing

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: root.missingKoi
                                ? i18n("Get started with Appearance")
                                : (root.needsLaunch ? i18n("Koi is not running") : i18n("Koi is connected"))
                            color: root.t.text
                            font.weight: Font.DemiBold
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: root.missingKoi
                                ? i18n("Quick Settings uses Koi to manage your desktop's light and dark appearance.\nKoi is a separate KDE application and is required for this feature to work. Install it before continuing.")
                                : (root.needsLaunch
                                    ? i18n("Start Koi and return here to check the connection.")
                                    : i18n("Finish configuring your appearance profiles in Koi before continuing."))
                            color: root.t.muted
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            visible: root.busy
                            text: i18n("Checking Koi…")
                            color: root.t.muted
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            visible: root.koi.lastError.length > 0 && !root.busy
                            text: root.koi.lastError
                            color: root.t.danger
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: root.t.spacing

                            PlasmaComponents3.Button {
                                Layout.fillWidth: true
                                text: root.missingKoi ? i18n("Get Koi") : i18n("Open Koi")
                                icon.name: root.missingKoi ? "install-hdd" : "application-x-kde-sysinfo"
                                onClicked: {
                                    if (root.missingKoi) {
                                        koi.openProjectPage();
                                        return;
                                    }
                                    koi.launchKoi();
                                }
                            }

                            PlasmaComponents3.Button {
                                Layout.fillWidth: true
                                visible: root.missingKoi || root.needsLaunch
                                text: root.missingKoi ? i18n("I've installed Koi") : i18n("Recheck connection")
                                onClicked: koi.checkKoi()
                            }

                            PlasmaComponents3.Button {
                                Layout.fillWidth: true
                                visible: root.needsProfiles
                                text: i18n("Continue")
                                onClicked: root.koiOnboarded()
                            }
                        }
                    }
                }

                Components.GlassCard {
                    Layout.fillWidth: true
                    visible: root.showOnboarding && !root.missingKoi && !root.needsLaunch
                    theme: root.t

                    ColumnLayout {
                        width: parent.width
                        spacing: root.t.spacing

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: i18n("Configure the profiles in Koi")
                            color: root.t.text
                            font.weight: Font.DemiBold
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: [
                                i18n("1. Start Koi"),
                                i18n("2. Open Koi preferences"),
                                i18n("3. Select the Light Plasma style, color scheme, icons and other options."),
                                i18n("4. Select the Dark Plasma style, color scheme, icons and other options."),
                                i18n("5. Save the preferences."),
                                i18n("6. Return to Quick Settings and continue when ready.")
                            ].join("\n")
                            color: root.t.muted
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }
                    }
                }

                Components.GlassCard {
                    Layout.fillWidth: true
                    visible: !root.showOnboarding
                    theme: root.t

                    ColumnLayout {
                        width: parent.width
                        spacing: root.t.spacing

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: i18n("Select appearance")
                            color: root.t.text
                            font.weight: Font.DemiBold
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            visible: root.busy
                            text: i18n("Checking Koi…")
                            color: root.t.muted
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            visible: root.koi.lastError.length > 0 && !root.busy
                            text: root.koi.lastError
                            color: root.t.danger
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            textFormat: Text.PlainText
                        }
                    }
                }

                Components.GlassCard {
                    Layout.fillWidth: true
                    visible: !root.showOnboarding
                    theme: root.t

                    RowLayout {
                        width: parent.width
                        spacing: root.t.spacing

                        Components.CircleButton {
                            Layout.fillWidth: true
                            theme: root.t
                            iconName: "weather-clear"
                            label: i18n("Light")
                            statusText: root.dark ? i18n("Inactive") : i18n("Active")
                            active: !root.dark
                            interactive: root.connectionReady && root.dark
                            onActivated: koi.applyLightMode()
                        }

                        Components.CircleButton {
                            Layout.fillWidth: true
                            theme: root.t
                            iconName: "weather-clear-night"
                            label: i18n("Dark")
                            statusText: root.dark ? i18n("Active") : i18n("Inactive")
                            active: root.dark
                            interactive: root.connectionReady && !root.dark
                            onActivated: koi.applyDarkMode()
                        }
                    }
                }

                Components.GlassCard {
                    Layout.fillWidth: true
                    visible: !root.showOnboarding
                    theme: root.t

                    ColumnLayout {
                        width: parent.width
                        spacing: root.t.spacing

                        PlasmaComponents3.Label {
                            Layout.fillWidth: true
                            text: i18n("Appearance integration")
                            color: root.t.text
                            font.weight: Font.DemiBold
                            textFormat: Text.PlainText
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: root.t.spacing

                            PlasmaComponents3.Label {
                                Layout.fillWidth: true
                                text: i18n("Koi")
                                color: root.t.muted
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                textFormat: Text.PlainText
                            }

                            PlasmaComponents3.Label {
                                text: root.connectionReady ? i18n("Connected") : i18n("Not connected")
                                color: root.connectionReady ? root.t.accent : root.t.muted
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                textFormat: Text.PlainText
                            }
                        }

                        Components.CircleButton {
                            Layout.fillWidth: true
                            theme: root.t
                            iconName: "view-refresh"
                            label: i18n("Check Koi connection")
                            statusText: i18n("Connection")
                            active: root.busy
                            onActivated: koi.checkKoi()
                        }

                        Components.CircleButton {
                            Layout.fillWidth: true
                            theme: root.t
                            iconName: "help-browser"
                            label: i18n("Why is Koi required?")
                            statusText: i18n("Help")
                            onActivated: koi.openProjectPage()
                        }
                    }
                }
            }
        }
    }
}
