// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.plasma.plasma5support as Plasma5Support

import "components" as Components

Item {
    id: root

    property var theme: null
    property bool nightLightEnabled: false
    property bool stateAvailable: false
    property bool stateErrorReported: false

    readonly property string stateQuery: "qdbus6 org.kde.KWin "
        + "/org/kde/KWin/NightLight org.freedesktop.DBus.Properties.Get "
        + "org.kde.KWin.NightLight enabled"

    implicitWidth: circleButton.implicitWidth
    implicitHeight: circleButton.implicitHeight

    function setNightLightEnabled(enable) {
        root.nightLightEnabled = enable;
        executable.connectSource("kwriteconfig6 --file kwinrc --group NightColor "
            + "--key Active " + (enable ? "true" : "false") + " --type bool --notify");
    }

    Plasma5Support.DataSource {
        id: stateSource

        engine: "executable"
        interval: 5000
        connectedSources: [root.stateQuery]

        onNewData: function(sourceName, data) {
            if (sourceName !== root.stateQuery) {
                return;
            }

            if (data.exitCode !== undefined && Number(data.exitCode) !== 0) {
                root.stateAvailable = false;
                if (!root.stateErrorReported) {
                    console.warn("Could not read the KWin Night Light state:",
                                 data.stderr || data.exitStatus || "unknown error");
                    root.stateErrorReported = true;
                }
                return;
            }

            root.stateAvailable = true;
            root.stateErrorReported = false;
            root.nightLightEnabled = String(data.stdout || "").trim() === "true";
        }
    }

    Plasma5Support.DataSource {
        id: executable

        engine: "executable"

        onNewData: function(sourceName, data) {
            executable.disconnectSource(sourceName);
        }
    }

    Components.CircleButton {
        id: circleButton

        anchors.fill: parent
        theme: root.theme
        iconName: Qt.resolvedUrl("../icons/night-light.svg")
        iconIsMask: true
        label: i18n("Night Light")
        statusText: root.stateAvailable
            ? (root.nightLightEnabled ? i18n("On") : i18n("Off")) : i18n("Unavailable")
        active: root.stateAvailable && root.nightLightEnabled
        onActivated: {
            if (!root.stateAvailable) {
                return;
            }
            root.setNightLightEnabled(!root.nightLightEnabled);
        }
    }
}
