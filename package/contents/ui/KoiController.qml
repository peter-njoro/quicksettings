// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: root

    readonly property string dbusService: "dev.baduhai.Koi"
    readonly property string dbusPath: "/Koi"
    readonly property string dbusInterface: "local.KoiDbusInterface"
    readonly property string projectUrl: "https://github.com/baduhai/Koi"
    readonly property string installCheckCommand: "sh -c 'command -v koi'"
    readonly property string checkCommand: "qdbus6 " + dbusService + " " + dbusPath
        + " org.freedesktop.DBus.Introspectable.Introspect"
    readonly property bool ready: connected
    property bool checking: false
    property bool connected: false
    property bool installed: false
    property string lastError: ""

    signal installedChecked(bool installed)
    signal connectionChecked(bool connected)
    signal lightApplied(bool ok)
    signal darkApplied(bool ok)
    signal openedProjectPage(bool ok)
    signal launchedKoi(bool ok)

    Plasma5Support.DataSource {
        id: dataSource

        engine: "executable"
        interval: 0
        connectedSources: []

        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
            const exitCode = Number(data["exit code"] !== undefined
                ? data["exit code"] : data["exit status"]);
            if (sourceName === root.installCheckCommand) {
                root.installed = exitCode === 0;
                root.installedChecked(root.installed);
            } else if (sourceName === root.checkCommand) {
                const stdout = String(data.stdout || "");
                root.installed = exitCode === 0;
                root.connected = root.installed
                    && stdout.indexOf(root.dbusInterface) >= 0
                    && stdout.indexOf("goLightMode") >= 0;
                if (root.connected) {
                    root.lastError = "";
                } else {
                    root.lastError = String(data.stderr || "").trim();
                }
                root.checking = false;
                root.connectionChecked(root.connected);
            } else if (sourceName.indexOf(root.dbusInterface + ".goLightMode") >= 0) {
                if (exitCode !== 0) {
                    root.lastError = String(data.stderr || "").trim();
                }
                root.lightApplied(exitCode === 0);
            } else if (sourceName.indexOf(root.dbusInterface + ".goDarkMode") >= 0) {
                if (exitCode !== 0) {
                    root.lastError = String(data.stderr || "").trim();
                }
                root.darkApplied(exitCode === 0);
            } else if (sourceName === "koi") {
                root.launchedKoi(exitCode === 0);
            } else if (sourceName === "xdg-open " + root.projectUrl) {
                root.openedProjectPage(exitCode === 0);
            }
        }
    }

    function checkKoi() {
        root.checking = true;
        dataSource.disconnectSource(root.installCheckCommand);
        dataSource.disconnectSource(root.checkCommand);
        dataSource.connectSource(root.installCheckCommand);
        dataSource.connectSource(root.checkCommand);
    }

    function launchKoi() {
        dataSource.disconnectSource("koi");
        dataSource.connectSource("koi");
    }

    function openProjectPage() {
        const command = "xdg-open " + root.projectUrl;
        dataSource.disconnectSource(command);
        dataSource.connectSource(command);
    }

    function applyLightMode() {
        if (!root.connected) {
            return;
        }
        const command = "qdbus6 " + root.dbusService + " " + root.dbusPath
            + " " + root.dbusInterface + ".goLightMode";
        dataSource.disconnectSource(command);
        dataSource.connectSource(command);
    }

    function applyDarkMode() {
        if (!root.connected) {
            return;
        }
        const command = "qdbus6 " + root.dbusService + " " + root.dbusPath
            + " " + root.dbusInterface + ".goDarkMode";
        dataSource.disconnectSource(command);
        dataSource.connectSource(command);
    }
}
