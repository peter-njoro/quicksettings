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
    property bool systemDark: dark
    property int currentPage: 0
    property var configuration: null
    property var theme: null

    signal configureRequested()

    readonly property var cfg: configuration || plasmoid.configuration
    readonly property var t: theme || localTheme
    readonly property var koi: koiControllerInstance
    readonly property bool koiConnected: koiControllerInstance.connected
    readonly property bool koiOnboarded: cfg.koiOnboarded === true

    // Height of the main page's content, reported by the loaded main page.
    property real mainContentHeight: 0

    implicitWidth: 390
    implicitHeight: mainContentHeight > 0
        ? Math.ceil(mainContentHeight + 2 * t.padding)
        : Kirigami.Units.gridUnit * 32

    Component.onCompleted: koiControllerInstance.checkKoi()

    function resetToMain() {
        currentPage = 0;
    }

    KoiController {
        id: koiControllerInstance
    }

    Components.Theme {
        id: localTheme

        dark: root.dark
        followAccent: root.cfg.followAccent !== false
        transparency: (root.cfg.transparency !== undefined ? root.cfg.transparency : 85) / 100
        blur: root.cfg.blur !== false
        radius: root.cfg.cornerRadius !== undefined ? root.cfg.cornerRadius : 24
        animations: root.cfg.animations !== false
        animationSpeed: (root.cfg.animationSpeed !== undefined ? root.cfg.animationSpeed : 100) / 100
        compact: root.cfg.compactSpacing === true
    }

    Rectangle {
        anchors.fill: parent
        radius: root.t.popupRadius
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.t.backgroundTop }
            GradientStop { position: 1.0; color: root.t.background }
        }
        border.width: 1
        border.color: root.t.border
    }

    Components.GlassSheen {
        anchors.fill: parent
        theme: root.t
        radius: root.t.popupRadius
    }

    Loader {
        id: pageLoader

        anchors.fill: parent
        anchors.margins: root.t.padding
        sourceComponent: {
            switch (root.currentPage) {
            case 1:
                return wifiPage;
            case 2:
                return audioPage;
            case 3:
                return powerPage;
            case 4:
                return bluetoothPage;
            case 5:
                return appearancePage;
            default:
                return mainPage;
            }
        }
    }

    Component {
        id: mainPage

        Item {
            Binding {
                target: root
                property: "mainContentHeight"
                value: mainLayout.implicitHeight
                restoreMode: Binding.RestoreNone
            }

            ColumnLayout {
                id: mainLayout

                anchors.fill: parent
                spacing: root.t.spacing

                Header {
                    Layout.fillWidth: true
                    theme: root.t
                    showDate: root.cfg.showHeaderDate !== false
                    showBattery: root.cfg.showBattery !== false
                    onConfigureRequested: root.configureRequested()
                    onPowerRequested: root.currentPage = 3
                }

                ColumnLayout {
                    id: mainContent

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: root.t.spacing

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0
                        Layout.minimumHeight: connectivityColumn.implicitHeight
                        visible: connectivityColumn.visible
                            || (root.cfg.showMedia !== false)
                        spacing: root.t.spacing

                        ColumnLayout {
                            id: connectivityColumn

                            Layout.minimumWidth: 0
                            Layout.preferredWidth: Math.max(0,
                                (mainContent.width - root.t.spacing) * 0.46)
                            spacing: root.t.spacing
                            visible: wifiCard.visible || bluetoothCard.visible

                            ConnectivityCard {
                                id: wifiCard

                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                visible: root.cfg.showWifi !== false
                                theme: root.t
                                kind: "wifi"
                                onActivated: root.currentPage = 1
                            }

                            ConnectivityCard {
                                id: bluetoothCard

                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                visible: root.cfg.showBluetooth !== false
                                theme: root.t
                                kind: "bluetooth"
                                onActivated: root.currentPage = 4
                            }
                        }

                        MediaCard {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: connectivityColumn.implicitHeight
                            Layout.preferredWidth: Math.max(0,
                                (mainContent.width - root.t.spacing) * 0.54)
                            Layout.preferredHeight: connectivityColumn.implicitHeight
                            visible: root.cfg.showMedia !== false
                            theme: root.t
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: root.t.spacing
                        visible: root.cfg.showCaffeine !== false
                            || root.cfg.showFocus !== false
                            || root.cfg.showAppearance !== false
                            || root.cfg.showNightLight !== false

                        CaffeineCard {
                            Layout.preferredWidth: Math.max(0,
                                (mainContent.width - root.t.spacing) * 0.46)
                            Layout.alignment: Qt.AlignVCenter
                            visible: root.cfg.showCaffeine !== false
                            theme: root.t
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: circleRow.implicitHeight
                            Layout.alignment: Qt.AlignVCenter

                            RowLayout {
                                id: circleRow

                                anchors.centerIn: parent
                                spacing: root.t.spacing

                                FocusCard {
                                    visible: root.cfg.showFocus !== false
                                    theme: root.t
                                }

                                AppearanceCard {
                                    visible: root.cfg.showAppearance !== false
                                    theme: root.t
                                    dark: root.systemDark
                                    koiConnected: root.koiConnected
                                    koiOnboarded: root.koiOnboarded
                                    animationsEnabled: root.t.animations
                                    onActivated: {
                                        if (root.koiConnected && root.koiOnboarded) {
                                            if (root.systemDark) {
                                                root.koi.applyLightMode();
                                            } else {
                                                root.koi.applyDarkMode();
                                            }
                                        } else {
                                            root.currentPage = 5;
                                        }
                                    }
                                }

                                NightLightCard {
                                    visible: root.cfg.showNightLight !== false
                                    theme: root.t
                                }
                            }
                        }
                    }

                    Components.GlassCard {
                        Layout.fillWidth: true
                        visible: (root.cfg.showBrightness !== false && brightnessControl.available)
                            || (root.cfg.showVolume !== false && volumeControl.available)
                        theme: root.t

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: root.t.spacing

                            BrightnessControl {
                                id: brightnessControl
                                Layout.fillWidth: true
                                theme: root.t
                            }

                            VolumeControl {
                                id: volumeControl
                                Layout.fillWidth: true
                                theme: root.t
                            }
                        }
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

    Component {
        id: wifiPage

        WifiDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }
    }

    Component {
        id: bluetoothPage

        BluetoothDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }
    }

    Component {
        id: audioPage

        AudioDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }
    }

    Component {
        id: powerPage

        PowerDetailsView {
            theme: root.t
            configuration: root.cfg
            onBackRequested: root.currentPage = 0
        }
    }

    Component {
        id: appearancePage

        AppearanceDetailsView {
            theme: root.t
            koiController: root.koi
            onboarded: root.koiOnboarded
            onBackRequested: root.currentPage = 0
            onKoiOnboarded: {
                root.cfg.koiOnboarded = true;
                root.currentPage = 0;
            }
        }
    }
}
