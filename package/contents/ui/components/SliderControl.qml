// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "." as Components

ColumnLayout {
    id: root

    property var theme: null
    property string iconName: "audio-volume-medium"
    property string label: ""
    property string valueText: ""
    property bool muted: false
    property real from: 0
    property real to: 100
    property real value: 0
    property int stepSize: 1
    property bool interactive: true
    property bool showLabel: true

    signal moved(real value)
    signal iconClicked()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: iconButton.hovered

    Components.Theme { id: fallbackTheme }

    spacing: Math.round(Kirigami.Units.smallSpacing * 0.5)

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Components.IconButton {
            id: iconButton
            theme: root.t
            iconName: root.muted ? "audio-volume-muted" : root.iconName
            interactive: root.interactive
            iconSize: Kirigami.Units.iconSizes.small
            onClicked: root.iconClicked()
        }

        PlasmaComponents3.Label {
            visible: root.showLabel
            Layout.fillWidth: true
            text: root.label
            color: root.t.muted
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            textFormat: Text.PlainText
        }

        PlasmaComponents3.Label {
            text: root.valueText
            color: root.t.text
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            font.weight: Font.DemiBold
            textFormat: Text.PlainText
        }
    }

    PlasmaComponents3.Slider {
        id: slider

        Layout.fillWidth: true
        enabled: root.interactive
        from: root.from
        to: root.to
        stepSize: root.stepSize
        value: root.value
        opacity: root.interactive ? 1.0 : 0.45

        onMoved: root.moved(value)

        Behavior on value {
            enabled: !slider.pressed
            NumberAnimation { duration: root.t.shortAnimationDuration }
        }
    }
}
