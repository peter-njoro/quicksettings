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
    property var requestedNightLightEnabled: null

    readonly property string stateQuery: "qdbus6 org.kde.KWin "
        + "/org/kde/KWin/NightLight org.freedesktop.DBus.Properties.Get "
        + "org.kde.KWin.NightLight enabled"
    readonly property string reconfigureCommand: "qdbus6 org.kde.KWin /KWin reconfigure"

    implicitWidth: circleButton.implicitWidth
    implicitHeight: circleButton.implicitHeight
    function setNightLightEnabled(enable) {
        root.requestedNightLightEnabled = enable;
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

            if (data["exit code"] !== undefined && Number(data["exit code"]) !== 0) {
                root.stateAvailable = false;
                if (!root.stateErrorReported) {
                    console.warn("Could not read the KWin Night Light state:",
                                 data.stderr || data["exit status"] || "unknown error");
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

            const exitCode = data["exit code"];
            if (exitCode === undefined || Number(exitCode) !== 0) {
                console.warn("Night Light command failed:",
                             data.stderr || data["exit status"] || sourceName);
                root.requestedNightLightEnabled = null;
                return;
            }

            if (sourceName === root.reconfigureCommand) {
                if (root.requestedNightLightEnabled !== null) {
                    root.nightLightEnabled = root.requestedNightLightEnabled;
                }
                root.requestedNightLightEnabled = null;
                return;
            }

            if (root.requestedNightLightEnabled !== null) {
                executable.connectSource(root.reconfigureCommand);
            }
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
        interactive: root.stateAvailable && root.requestedNightLightEnabled === null
        onActivated: {
            if (!root.stateAvailable || root.requestedNightLightEnabled !== null) {
                return;
            }
            root.setNightLightEnabled(!root.nightLightEnabled);
        }
    }
}
