// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property bool dark: true
    property int currentPage: 0
    property var configuration: null
    property var theme: null

    readonly property var cfg: configuration || plasmoid.configuration
    readonly property var t: theme || localTheme

    implicitWidth: Kirigami.Units.gridUnit * 22
    implicitHeight: Kirigami.Units.gridUnit * 32

    function resetToMain() {
        currentPage = 0;
    }

    Components.Theme {
        id: localTheme

        dark: root.dark
        followAccent: root.cfg.followAccent !== false
        transparency: (root.cfg.transparency !== undefined ? root.cfg.transparency : 85) / 100
        blur: root.cfg.blur !== false
        radius: root.cfg.cornerRadius !== undefined ? root.cfg.cornerRadius : 22
        animations: root.cfg.animations !== false
        animationSpeed: (root.cfg.animationSpeed !== undefined ? root.cfg.animationSpeed : 100) / 100
        compact: root.cfg.compactSpacing === true
    }

    Rectangle {
        anchors.fill: parent
        radius: root.t.radius
        color: root.t.background
        border.width: 1
        border.color: root.t.border
    }

    StackLayout {
        anchors.fill: parent
        anchors.margins: root.t.compact ? root.t.spacing : root.t.spacing * 1.25
        currentIndex: root.currentPage

        Item {
            ColumnLayout {
                anchors.fill: parent
                spacing: root.t.spacing

                Header {
                    Layout.fillWidth: true
                    theme: root.t
                    showDate: root.cfg.showHeaderDate !== false
                }

                PlasmaComponents3.ScrollView {
                    id: mainScroll

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    contentWidth: availableWidth

                    PlasmaComponents3.ScrollBar.horizontal.policy: PlasmaComponents3.ScrollBar.AlwaysOff
                    background: null

                    ColumnLayout {
                        width: mainScroll.availableWidth
                        spacing: root.t.spacing

                        ConnectivityCard {
                            Layout.fillWidth: true
                            visible: root.cfg.showWifi !== false
                            theme: root.t
                            kind: "wifi"
                            onActivated: root.currentPage = 1
                        }

                        ConnectivityCard {
                            Layout.fillWidth: true
                            visible: root.cfg.showBluetooth !== false
                            theme: root.t
                            kind: "bluetooth"
                            onActivated: root.currentPage = 1
                        }

                        Components.GlassCard {
                            id: brightnessCard

                            Layout.fillWidth: true
                            visible: root.cfg.showBrightness !== false && brightnessControl.available
                            theme: root.t

                            BrightnessControl {
                                id: brightnessControl
                                Layout.fillWidth: true
                                theme: root.t
                            }
                        }

                        Components.GlassCard {
                            id: volumeCard

                            Layout.fillWidth: true
                            visible: root.cfg.showVolume !== false && volumeControl.available
                            theme: root.t
                            interactive: volumeControl.available
                            onClicked: root.currentPage = 2

                            VolumeControl {
                                id: volumeControl
                                Layout.fillWidth: true
                                theme: root.t
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: root.t.spacing
                            visible: root.cfg.showFocus !== false
                                || root.cfg.showAppearance !== false

                            FocusCard {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: root.cfg.showFocus !== false
                                theme: root.t
                            }

                            AppearanceCard {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: root.cfg.showAppearance !== false
                                theme: root.t
                                dark: root.dark
                                animationsEnabled: root.t.animations
                            }
                        }

                        MediaCard {
                            Layout.fillWidth: true
                            visible: root.cfg.showMedia !== false
                            theme: root.t
                        }

                        BatteryCard {
                            id: batteryCard

                            Layout.fillWidth: true
                            visible: root.cfg.showBattery !== false && batteryCard.present
                            theme: root.t
                            onActivated: root.currentPage = 3
                        }

                        QuickActions {
                            Layout.fillWidth: true
                            visible: root.cfg.showQuickActions !== false
                            theme: root.t
                            configuration: root.cfg
                        }
                    }
                }
            }
        }

        ConnectivityDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }

        AudioDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }

        PowerDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }
    }
}
