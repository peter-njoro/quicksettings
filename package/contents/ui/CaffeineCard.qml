// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    property bool active: false
    property bool available: true
    property bool pendingSync: false
    property real pendingSince: 0

    // A transient user unit keeps the inhibition alive across plasmashell
    // restarts and is removed automatically when it is stopped.
    readonly property string unitName: "quick-settings-caffeine"
    readonly property string statusCommand: "systemctl --user is-active --quiet "
        + root.unitName + ".service"
    readonly property string availabilityCommand: "sh -c 'command -v systemd-run >/dev/null"
        + " && command -v systemctl >/dev/null'"
    readonly property string startCommand: "sh -c 'systemctl --user stop "
        + root.unitName + ".service >/dev/null 2>&1; systemd-run --user --unit="
        + root.unitName + " --collect --description=QuickSettingsCaffeine"
        + " systemd-inhibit --what=idle:sleep --who=QuickSettings"
        + " --why=Caffeine sleep infinity'"
    readonly property string stopCommand: "systemctl --user stop "
        + root.unitName + ".service"

    overrideRadius: t.popupRadius
    interactive: root.available
    onClicked: root.toggle()

    Component.onCompleted: {
        availabilitySource.connectSource(root.availabilityCommand);
        root.refresh();
    }

    function refresh() {
        statusSource.disconnectSource(root.statusCommand);
        statusSource.connectSource(root.statusCommand);
    }

    function toggle() {
        if (!root.available) {
            return;
        }
        // Update the card immediately; the poll below confirms the result and
        // ignores stale reads until the unit agrees with the flip.
        root.pendingSince = Date.now();
        root.pendingSync = true;
        root.active = !root.active;
        const command = root.active ? root.startCommand : root.stopCommand;
        commandSource.disconnectSource(command);
        commandSource.connectSource(command);
    }

    Plasma5Support.DataSource {
        id: statusSource

        engine: "executable"
        interval: 2000
        connectedSources: root.available ? [root.statusCommand] : []

        onNewData: function(sourceName, data) {
            if (sourceName !== root.statusCommand) {
                return;
            }
            const exitCode = Number(data["exit code"] !== undefined
                ? data["exit code"] : data["exit status"]);
            const isActive = exitCode === 0;
            if (root.pendingSync) {
                if (isActive === root.active) {
                    root.pendingSync = false;
                } else if (Date.now() - root.pendingSince > 5000) {
                    root.pendingSync = false;
                    root.active = isActive;
                } else {
                    return;
                }
            }
            root.active = isActive;
        }
    }

    Plasma5Support.DataSource {
        id: availabilitySource

        engine: "executable"
        interval: 0
        connectedSources: []

        onNewData: function(sourceName, data) {
            availabilitySource.disconnectSource(sourceName);
            if (sourceName !== root.availabilityCommand) {
                return;
            }
            const exitCode = Number(data["exit code"] !== undefined
                ? data["exit code"] : data["exit status"]);
            root.available = exitCode === 0;
            root.refresh();
        }
    }

    Plasma5Support.DataSource {
        id: commandSource

        engine: "executable"
        interval: 0
        connectedSources: []

        onNewData: function(sourceName, data) {
            commandSource.disconnectSource(sourceName);
            root.refresh();
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Item {
            Layout.preferredWidth: Kirigami.Units.gridUnit * 1.8
            Layout.preferredHeight: Layout.preferredWidth

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: root.active ? root.t.accent : root.t.controlOff

                Behavior on color {
                    ColorAnimation { duration: root.t.animationDuration }
                }
            }

            Kirigami.Icon {
                anchors.centerIn: parent
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                source: Qt.resolvedUrl("../icons/caffeine-cup.svg")
                isMask: true
                color: root.active ? root.t.onAccent : root.t.text
                opacity: root.available ? 1.0 : 0.4
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                text: i18n("Caffeine")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                text: !root.available
                    ? i18n("Unavailable")
                    : (root.active ? i18n("On") : i18n("Off"))
                color: root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                elide: Text.ElideRight
                maximumLineCount: 1
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                text: !root.available
                    ? i18n("systemd is required")
                    : (root.active ? i18n("Screen stays on") : i18n("Screen can turn off"))
                color: root.t.inactive
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                elide: Text.ElideRight
                maximumLineCount: 1
                textFormat: Text.PlainText
            }
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: root.available
        ? i18n("Caffeine, %1", root.active ? i18n("on") : i18n("off"))
        : i18n("Caffeine, unavailable")
    Accessible.checked: root.active
}
