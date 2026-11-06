// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme: null
    property var configuration: null

    signal backRequested()

    readonly property var t: theme || fallbackTheme

    Components.Theme { id: fallbackTheme }

    PlasmaNM.Handler {
        id: networkHandler
    }

    PlasmaNM.NetworkModel {
        id: networkModel
    }

    PlasmaNM.EnabledConnections {
        id: enabledConnections
    }

    function connectWifi(connectionPath, devicePath, specificPath) {
        if (connectionPath && connectionPath.length > 0) {
            networkHandler.activateConnection(connectionPath, devicePath, specificPath);
        } else {
            networkHandler.addAndActivateConnection(devicePath, specificPath, "");
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
                text: i18n("Wi-Fi")
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
                        text: i18n("Wi-Fi networks")
                        color: root.t.muted
                        font.weight: Font.DemiBold
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        textFormat: Text.PlainText
                    }

                    PlasmaComponents3.Label {
                        text: enabledConnections.wirelessEnabled ? i18n("On") : i18n("Off")
                        color: enabledConnections.wirelessEnabled ? root.t.accent : root.t.muted
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        textFormat: Text.PlainText
                    }
                }

                Repeater {
                    model: networkModel

                    delegate: Components.GlassCard {
                        Layout.fillWidth: true
                        visible: model.Type === PlasmaNM.Enums.Wireless
                        theme: root.t
                        interactive: true
                        onClicked: root.connectWifi(model.ConnectionPath, model.DevicePath,
                                                    model.SpecificPath)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            Kirigami.Icon {
                                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                                Layout.preferredHeight: Layout.preferredWidth
                                source: model.ConnectionState === PlasmaNM.Enums.Activated
                                    ? "network-wireless-connected" : "network-wireless"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: model.ItemUniqueName || model.Name || ""
                                    color: root.t.text
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    visible: model.SecurityTypeString !== undefined
                                    text: model.SecurityTypeString || ""
                                    color: root.t.muted
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }
                            }

                            PlasmaComponents3.Label {
                                text: model.ConnectionState === PlasmaNM.Enums.Activated
                                    ? i18n("Connected") : ""
                                color: root.t.accent
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                                textFormat: Text.PlainText
                            }
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: !enabledConnections.wirelessEnabled
                    text: i18n("Turn on Wi-Fi from the main view to see available networks.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    wrapMode: Text.WordWrap
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
