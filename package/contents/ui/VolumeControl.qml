// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
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
    readonly property int volumePercent: available
        ? Math.round(sink.volume / Math.max(1, normalVolume) * 100)
        : 0

    spacing: Kirigami.Units.smallSpacing

    Components.SliderControl {
        Layout.fillWidth: true
        visible: root.available
        theme: root.theme
        iconName: root.sink && root.sink.muted ? "audio-volume-muted" : "audio-volume-high"
        label: i18n("Volume")
        valueText: root.volumePercent + "%"
        from: root.minimalVolume
        to: root.normalVolume
        value: root.sink ? root.sink.volume : 0
        stepSize: Math.max(1, Math.round(root.normalVolume / 100))
        muted: root.sink ? root.sink.muted : false
        onMoved: {
            if (root.sink) {
                root.sink.volume = Math.round(value);
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
