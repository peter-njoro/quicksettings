// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import org.kde.bluezqt as BluezQt
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    property string kind: "wifi"
    property int revision: 0

    signal activated(string kind)

    readonly property bool isWifi: kind === "wifi"
    readonly property bool isBluetooth: kind === "bluetooth"

    readonly property bool wirelessEnabled: enabledConnections.wirelessEnabled
    readonly property var bluetoothAdapter: {
        if (!BluezQt.Manager) {
            return null;
        }
        const usable = BluezQt.Manager.usableAdapter;
        if (usable) {
            return usable;
        }
        const adapters = BluezQt.Manager.adapters;
        return adapters && adapters.length > 0 ? adapters[0] : null;
    }
    readonly property bool bluetoothPowered: bluetoothAdapter !== null
        && bluetoothAdapter !== undefined && bluetoothAdapter.powered
    readonly property bool bluetoothBlocked: BluezQt.Manager ? BluezQt.Manager.bluetoothBlocked : true
    readonly property int bluetoothDeviceCount: BluezQt.Manager && BluezQt.Manager.connectedDevices
        ? BluezQt.Manager.connectedDevices.length : 0

    readonly property bool serviceEnabled: isWifi
        ? wirelessEnabled
        : (!bluetoothBlocked && bluetoothPowered)
    readonly property bool adapterAvailable: isWifi || bluetoothAdapter !== null

    readonly property var activeWifi: firstActiveWifi()
    readonly property bool wifiConnected: activeWifi !== null
    readonly property string wifiName: activeWifi ? activeWifi.label : ""

    readonly property string statusText: {
        if (isWifi) {
            if (!wirelessEnabled) {
                return i18n("Off");
            }
            return wifiConnected ? i18n("Connected") : i18n("Not connected");
        }
        if (!serviceEnabled) {
            return i18n("Off");
        }
        return bluetoothDeviceCount > 0
            ? i18np("%1 device connected", "%1 devices connected", bluetoothDeviceCount)
            : i18n("No devices connected");
    }

    readonly property string detailText: {
        if (isWifi) {
            if (wifiConnected) {
                return wifiName;
            }
            return wirelessEnabled ? i18n("No active network") : i18n("Wi-Fi disabled");
        }
        return serviceEnabled ? i18n("Bluetooth enabled") : i18n("Bluetooth disabled");
    }

    interactive: adapterAvailable
    overrideRadius: t.popupRadius
    onClicked: toggleService()

    PlasmaNM.Handler {
        id: networkHandler
    }

    PlasmaNM.NetworkModel {
        id: networkModel
    }

    PlasmaNM.EnabledConnections {
        id: enabledConnections
    }

    Instantiator {
        id: wifiRows

        model: networkModel

        delegate: QtObject {
            readonly property bool wireless: model.Type === PlasmaNM.Enums.Wireless
            readonly property bool active: model.ConnectionState === PlasmaNM.Enums.Activated
            readonly property string label: model.ItemUniqueName || model.Name || ""
        }

        onObjectAdded: root.revision++
        onObjectRemoved: root.revision++
    }

    function firstActiveWifi() {
        root.revision;
        for (let i = 0; i < wifiRows.count; ++i) {
            const row = wifiRows.objectAt(i);
            if (row && row.wireless && row.active) {
                return row;
            }
        }
        return null;
    }

    function toggleService() {
        if (isWifi) {
            networkHandler.enableWireless(!wirelessEnabled);
            return;
        }

        const enable = !serviceEnabled;
        if (bluetoothBlocked) {
            BluezQt.Manager.bluetoothBlocked = false;
        }
        if (bluetoothAdapter) {
            bluetoothAdapter.powered = enable;
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Item {
            Layout.fillWidth: true
            implicitHeight: Math.max(Kirigami.Units.iconSizes.smallMedium,
                                    serviceColumn.implicitHeight)

            RowLayout {
                anchors.fill: parent
                spacing: Kirigami.Units.smallSpacing

                Item {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 1.8
                    Layout.preferredHeight: Layout.preferredWidth

                    Rectangle {
                        anchors.fill: parent
                        radius: Kirigami.Units.cornerRadius
                        color: root.t.alpha(root.t.text, 0.08)
                        border.width: 1
                        border.color: serviceEnabled
                            ? root.t.alpha(root.t.accent, 0.25)
                            : root.t.border
                    }

                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.smallMedium
                        height: width
                        source: root.isWifi
                            ? Qt.resolvedUrl("../icons/wifi.svg")
                            : Qt.resolvedUrl("../icons/bluetooth.svg")
                        isMask: true
                        color: root.serviceEnabled ? root.t.accent : root.t.text
                        opacity: root.adapterAvailable ? 1.0 : 0.4
                    }
                }

                ColumnLayout {
                    id: serviceColumn

                    Layout.fillWidth: true
                    spacing: 0

                    PlasmaComponents3.Label {
                        text: root.isWifi ? i18n("Wi-Fi") : i18n("Bluetooth")
                        color: root.t.text
                        font.weight: Font.DemiBold
                        font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                        textFormat: Text.PlainText
                    }

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: root.statusText
                        color: root.t.muted
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        textFormat: Text.PlainText
                    }

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        visible: text.length > 0 && text !== root.statusText
                        text: root.detailText
                        color: root.t.inactive
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        textFormat: Text.PlainText
                    }
                }
            }
        }

        Components.IconButton {
            Layout.alignment: Qt.AlignVCenter
            theme: root.t
            iconName: "go-next"
            tooltip: i18n("More %1 settings", root.isWifi ? i18n("Wi-Fi") : i18n("Bluetooth"))
            onClicked: root.activated(root.kind)
        }
    }
}
