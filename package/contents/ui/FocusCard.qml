// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

import "components" as Components

Components.CircleButton {
    id: root

    readonly property string readCommand: "qdbus6 org.freedesktop.Notifications /org/freedesktop/Notifications"
        + " org.freedesktop.Notifications.Inhibited"
    readonly property string toggleCommand: "qdbus6 org.kde.kglobalaccel /component/plasmashell"
        + " invokeShortcut 'toggle do not disturb'"

    property bool doNotDisturb: false
    // Set while waiting for a read to agree with our optimistic toggle result;
    // stale reads (the pre-toggle value) are ignored until then.
    property bool pendingSync: false
    property real pendingSince: 0

    iconName: root.doNotDisturb ? "notifications-disabled" : "notifications"
    label: i18n("Focus")
    statusText: root.doNotDisturb ? i18n("On") : i18n("Off")
    active: root.doNotDisturb
    onActivated: root.toggle()

    Component.onCompleted: root.refresh()

    function refresh() {
        stateSource.disconnectSource(root.readCommand);
        stateSource.connectSource(root.readCommand);
    }

    function toggle() {
        // Update the icon immediately; the toggle is confirmed by the accelerated
        // poll below and made authoritative once a read agrees with the flip.
        root.pendingSince = Date.now();
        root.pendingSync = true;
        root.doNotDisturb = !root.doNotDisturb;
        toggleSource.disconnectSource(root.toggleCommand);
        toggleSource.connectSource(root.toggleCommand);
    }

    Plasma5Support.DataSource {
        id: stateSource

        engine: "executable"
        interval: root.pendingSync ? 500 : 5000
        connectedSources: []

        onNewData: function(sourceName, data) {
            const exitCode = Number(data["exit code"]);
            if (sourceName !== root.readCommand) {
                console.warn("QuickSettings/Focus unexpected source:", sourceName);
                return;
            }
            if (exitCode !== 0) {
                console.warn("QuickSettings/Focus read failed:", exitCode,
                             String(data.stderr || "").trim(), String(data["exit status"] || ""));
                return;
            }
            const read = String(data.stdout || "").trim() === "true";
            if (root.pendingSync) {
                if (read === root.doNotDisturb) {
                    root.pendingSync = false;
                } else if (Date.now() - root.pendingSince > 5000) {
                    console.warn("QuickSettings/Focus toggle confirmation timed out, read:", read);
                    root.pendingSync = false;
                    root.doNotDisturb = read;
                } else {
                    return;
                }
            }
            root.doNotDisturb = read;
        }
    }

    Plasma5Support.DataSource {
        id: toggleSource

        engine: "executable"
        interval: 0
        connectedSources: []

        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            root.refresh();
        }
    }
}
