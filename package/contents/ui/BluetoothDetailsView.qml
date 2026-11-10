// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.bluezqt as BluezQt
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme: null
    property var configuration: null

    signal backRequested()

    readonly property var t: theme || fallbackTheme
    readonly property var btManager: BluezQt.Manager
    readonly property var btAdapter: btManager ? btManager.usableAdapter : null
    readonly property var btDevices: btManager && btManager.devices ? btManager.devices : []

    Components.Theme { id: fallbackTheme }

    function toggleBluetoothDevice(device) {
        if (!device || !btAdapter) {
            return;
        }
        if (device.connected) {
            device.disconnectFromDevice();
        } else {
            device.connectToDevice();
        }
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
                text: i18n("Bluetooth")
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

                RowLayout {
                    Layout.fillWidth: true

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: i18n("Bluetooth devices")
                        color: root.t.muted
                        font.weight: Font.DemiBold
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        textFormat: Text.PlainText
                    }

                    PlasmaComponents3.Label {
                        text: root.btAdapter && root.btAdapter.powered ? i18n("On") : i18n("Off")
                        color: root.btAdapter && root.btAdapter.powered
                            ? root.t.accent : root.t.muted
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        textFormat: Text.PlainText
                    }
                }

                Repeater {
                    model: root.btDevices

                    delegate: Components.GlassCard {
                        Layout.fillWidth: true
                        theme: root.t

                        readonly property var device: modelData

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            Kirigami.Icon {
                                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                                Layout.preferredHeight: Layout.preferredWidth
                                source: device.icon || Qt.resolvedUrl("../icons/bluetooth.svg")
                                isMask: !device.icon
                                color: root.t.text
                                opacity: device.connected ? 0.95 : 0.6
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: device.friendlyName || device.name || device.address
                                    color: root.t.text
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: device.connected ? i18n("Connected") : i18n("Not connected")
                                    color: root.t.muted
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                    textFormat: Text.PlainText
                                }
                            }

                            Components.ActionButton {
                                Layout.alignment: Qt.AlignVCenter
                                primary: !device.connected
                                text: device.connected ? i18n("Disconnect") : i18n("Connect")
                                enabled: root.btAdapter && root.btAdapter.powered
                                onClicked: root.toggleBluetoothDevice(device)
                            }
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: root.btDevices.length === 0
                    text: i18n("No Bluetooth devices found.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
