// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

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
    readonly property bool hovered: slider.hovered || slider.pressed

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

    QQC2.Slider {
        id: slider

        property bool wheelAdjusting: false

        Layout.fillWidth: true
        implicitHeight: 34
        leftPadding: 4
        rightPadding: 4
        topPadding: 5
        bottomPadding: 5
        snapMode: QQC2.Slider.SnapOnRelease
        enabled: root.interactive
        from: root.from
        to: root.to
        stepSize: root.stepSize
        opacity: root.interactive ? 1.0 : 0.45

        Binding on value {
            value: root.value
            when: !slider.pressed && !slider.wheelAdjusting
            restoreMode: Binding.RestoreNone
        }

        onMoved: root.moved(value)

        // Keep the local thumb responsive while the brightness or audio
        // backend publishes the updated value.
        Timer {
            id: wheelAdjustReset

            interval: 300
            repeat: false
            onTriggered: slider.wheelAdjusting = false
        }

        // Adjust the slider while the pointer is over it. Using WheelHandler's
        // rotation keeps the direction consistent with the system's scrolling
        // preference and supports both mouse wheels and touchpads.
        WheelHandler {
            id: wheelHandler

            target: null
            orientation: Qt.Vertical
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            invertible: true
            enabled: root.interactive && !slider.pressed && root.to > root.from

            property real previousRotation: 0

            onWheel: function(event) {
                const rotationDelta = wheelHandler.rotation - wheelHandler.previousRotation;
                wheelHandler.previousRotation = wheelHandler.rotation;

                if (rotationDelta === 0) {
                    event.accepted = true;
                    return;
                }

                // WheelHandler.rotation is measured in degrees; a standard
                // wheel notch represents 15 degrees.
                const increment = rotationDelta / 15 * Math.max(1, root.stepSize);
                const nextValue = Math.max(root.from,
                    Math.min(root.to, slider.value + increment));

                if (Math.abs(nextValue - slider.value) > 0.000001) {
                    slider.wheelAdjusting = true;
                    slider.value = nextValue;
                    root.moved(nextValue);
                    wheelAdjustReset.restart();
                }

                // A wheel event over the slider adjusts the value instead of
                // scrolling the containing popup.
                event.accepted = true;
            }
        }

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 12
            radius: height / 2
            color: root.t.inactive

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: parent.radius
                color: root.t.accent
            }
        }

        handle: Rectangle {
            id: thumb

            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.hovered || slider.pressed ? 26 : 24
            height: width
            radius: width / 2
            color: "#ffffff"
            border.width: 1
            border.color: root.t.alpha("#000000", 0.14)

            Behavior on width {
                NumberAnimation { duration: root.t.shortAnimationDuration }
            }
        }

        Behavior on value {
            enabled: !slider.pressed
            NumberAnimation { duration: root.t.shortAnimationDuration }
        }
    }
}
