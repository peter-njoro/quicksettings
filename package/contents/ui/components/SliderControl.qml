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
        opacity: root.interactive ? 1.0 : 0.45

        Binding on value {
            value: root.value
            when: !slider.pressed
            restoreMode: Binding.RestoreNone
        }

        onMoved: root.moved(value)

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 6
            radius: height / 2
            color: root.t.alpha(root.t.text, 0.16)

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: parent.radius
                color: root.t.accent
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: 16
            height: width
            radius: width / 2
            color: "#ffffff"
            border.width: 1
            border.color: root.t.alpha(root.t.text, 0.48)
        }

        Behavior on value {
            enabled: !slider.pressed
            NumberAnimation { duration: root.t.shortAnimationDuration }
        }
    }
}
