// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.private.volume
import org.kde.kirigami as Kirigami

import "components" as Components

ColumnLayout {
    id: root

    property var theme
    property bool showSeparator: false

    readonly property var sink: Server.defaultSink
    readonly property bool available: sink !== null && sink !== undefined
    readonly property int normalVolume: PulseAudio.NormalVolume || 65536
    readonly property int minimalVolume: PulseAudio.MinimalVolume || 0

    // The plugin's sink.volume property does not echo server changes reliably
    // (especially on Bluetooth sinks), so the authoritative state is read via
    // pactl and kept in serverVolume.
    readonly property string readCommand: "sh -c 'pactl get-sink-volume @DEFAULT_SINK@'"

    property int serverVolume: -1
    property int pendingVolume: -1

    readonly property real displayVolume: pendingVolume >= 0
        ? pendingVolume
        : (serverVolume >= 0 ? serverVolume : (available ? sink.volume : 0))
    readonly property int volumePercent: Math.round(
        displayVolume / Math.max(1, normalVolume) * 100)

    spacing: Kirigami.Units.smallSpacing

    Plasma5Support.DataSource {
        id: stateSource

        engine: "executable"
        interval: 2000
        connectedSources: []

        onNewData: function(sourceName, data) {
            if (data["exit code"] !== undefined && Number(data["exit code"]) !== 0) {
                console.warn("QuickSettings/Volume pactl read failed:",
                             data.stderr || data["exit status"]);
                return;
            }
            const m = /:\s*(\d+)/.exec(String(data.stdout || ""));
            if (!m) {
                return;
            }
            const raw = Number(m[1]);
            // Always keep the authoritative reading current, pending or not,
            // so clearing a pending value can never fall back to a stale one.
            root.serverVolume = raw;
            if (root.pendingVolume >= 0) {
                if (Math.abs(raw - root.pendingVolume) <= 500) {
                    root.pendingVolume = -1;
                } else {
                    // Server echoes may lag; keep defending the pending value
                    // (up to the timeout) and let the next read confirm it.
                    pendingTimeout.restart();
                    return;
                }
            } else {
                root.serverVolume = raw;
            }
        }
    }

    Timer {
        // Safety net: stop defending the pending value if the server never
        // reflects it.
        id: pendingTimeout

        interval: 12000
        repeat: false
        onTriggered: {
            if (root.pendingVolume < 0) {
                return;
            }
            console.warn("QuickSettings/Volume pending timeout, pending was:",
                         root.pendingVolume);
            root.pendingVolume = -1;
        }
    }

    Timer {
        // Initial pump once a sink exists.
        id: enablePolling

        interval: 250
        repeat: false
        onTriggered: refresh()
    }

    function refresh() {
        if (root.available) {
            stateSource.disconnectSource(root.readCommand);
            stateSource.connectSource(root.readCommand);
        }
    }

    onAvailableChanged: enablePolling.restart()

    Components.SliderControl {
        Layout.fillWidth: true
        visible: root.available
        theme: root.theme
        iconName: root.sink && root.sink.muted ? "audio-volume-muted" : "audio-volume-high"
        label: i18n("Volume")
        valueText: root.volumePercent + "%"
        from: root.minimalVolume
        to: root.normalVolume
        value: root.displayVolume
        stepSize: Math.max(1, Math.round(root.normalVolume / 100))
        muted: root.sink ? root.sink.muted : false
        onMoved: {
            if (root.sink) {
                const v = Math.round(value);
                root.pendingVolume = v;
                root.sink.volume = v;
                pendingTimeout.restart();
            }
        }
        onIconClicked: {
            if (root.sink) {
                root.sink.muted = !root.sink.muted;
            }
        }
    }

    PlasmaComponents3.Label {
        visible: !root.available
        Layout.fillWidth: true
        text: i18n("No audio output device available")
        color: root.theme ? root.theme.muted : Kirigami.Theme.disabledTextColor
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        textFormat: Text.PlainText
    }
}
