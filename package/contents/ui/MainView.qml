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

    signal configureRequested()

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
        clip: true
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.t.backgroundTop }
            GradientStop { position: 1.0; color: root.t.background }
        }
        border.width: 1
        border.color: root.t.border
    }

    Loader {
        id: pageLoader

        anchors.fill: parent
        anchors.margins: root.t.compact ? root.t.spacing : root.t.spacing * 1.25
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
            default:
                return mainPage;
            }
        }
    }

    Component {
        id: mainPage

        Item {
            ColumnLayout {
                anchors.fill: parent
                spacing: root.t.spacing

                Header {
                    Layout.fillWidth: true
                    theme: root.t
                    showDate: root.cfg.showHeaderDate !== false
                    onConfigureRequested: root.configureRequested()
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

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 0
                            Layout.minimumHeight: connectivityColumn.implicitHeight
                            visible: connectivityColumn.visible
                                || (root.cfg.showMedia !== false)

                            ColumnLayout {
                                id: connectivityColumn

                                Layout.minimumWidth: 0
                                Layout.preferredWidth: Math.max(0,
                                    (mainScroll.availableWidth - root.t.spacing) * 0.46)
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
                                    (mainScroll.availableWidth - root.t.spacing) * 0.54)
                                Layout.preferredHeight: connectivityColumn.implicitHeight
                                visible: root.cfg.showMedia !== false
                                theme: root.t
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: root.t.spacing
                            visible: root.cfg.showFocus !== false
                                || root.cfg.showAppearance !== false
                                || root.cfg.showNightLight !== false

                            FocusCard {
                                Layout.fillWidth: true
                                visible: root.cfg.showFocus !== false
                                theme: root.t
                            }

                            AppearanceCard {
                                Layout.fillWidth: true
                                visible: root.cfg.showAppearance !== false
                                theme: root.t
                                dark: root.dark
                                animationsEnabled: root.t.animations
                            }

                            NightLightCard {
                                Layout.fillWidth: true
                                visible: root.cfg.showNightLight !== false
                                theme: root.t
                            }
                        }

                        Components.GlassCard {
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

                PlasmaComponents3.Button {
                    id: editControlsButton

                    Layout.alignment: Qt.AlignHCenter
                    text: i18n("Edit Controls")
                    icon.name: "configure"
                    onClicked: root.configureRequested()

                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.Icon {
                            Layout.preferredWidth: Kirigami.Units.iconSizes.small
                            Layout.preferredHeight: Layout.preferredWidth
                            source: "configure"
                            opacity: 0.55
                        }

                        PlasmaComponents3.Label {
                            text: editControlsButton.text
                            color: root.t.muted
                            opacity: 0.62
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    background: Rectangle {
                        radius: height / 2
                        color: editControlsButton.hovered
                            ? root.t.alpha(root.t.text, 0.14)
                            : root.t.alpha(root.t.text, 0.08)
                        border.width: 1
                        border.color: root.t.border
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
}
