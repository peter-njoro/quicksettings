// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

import org.kde.kcmutils as KCMUtils
import org.kde.plasma.plasma5support as Plasma5Support

import "components" as Components

Item {
    id: root

    property var theme: null
    property bool running: false
    property bool stateAvailable: false
    property bool stateErrorReported: false

    readonly property string stateQuery: "qdbus6 org.kde.KWin "
        + "/org/kde/KWin/NightLight org.freedesktop.DBus.Properties.Get "
        + "org.kde.KWin.NightLight running"

    implicitWidth: circleButton.implicitWidth
    implicitHeight: circleButton.implicitHeight

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
                                 data.stderr || data.exitStatus || i18n("Unknown error"));
                    root.stateErrorReported = true;
                }
                return;
            }

            root.stateAvailable = true;
            root.stateErrorReported = false;
            root.running = String(data.stdout || "").trim() === "true";
        }
    }

    Components.CircleButton {
        id: circleButton

        anchors.fill: parent
        theme: root.theme
        iconName: "weather-clear-night"
        label: i18n("Night Light")
        statusText: root.stateAvailable
            ? (root.running ? i18n("On") : i18n("Off")) : i18n("Unavailable")
        active: root.stateAvailable && root.running
        onActivated: KCMUtils.KCMLauncher.openSystemSettings("kcm_nightlight")
    }
}
