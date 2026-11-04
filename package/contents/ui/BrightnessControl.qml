// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.brightnesscontrolplugin as Brightness
import org.kde.kirigami as Kirigami

import "components" as Components

ColumnLayout {
    id: root

    property var theme
    property bool showSeparator: false

    readonly property bool screenAvailable: screenControl.isBrightnessAvailable
    readonly property bool keyboardAvailable: keyboardControl.isBrightnessAvailable
    readonly property bool available: screenAvailable || keyboardAvailable

    property real screenBrightness: 0
    property real screenBrightnessMax: 1
    property string screenName: ""

    spacing: Kirigami.Units.smallSpacing

    Brightness.ScreenBrightnessControl {
        id: screenControl
    }

    Brightness.KeyboardBrightnessControl {
        id: keyboardControl
    }

    Repeater {
        model: screenControl.displays

        delegate: Item {
            visible: false
            width: 0
            height: 0

            Binding {
                target: root
                property: "screenBrightness"
                value: model.brightness
                when: index === 0
                restoreMode: Binding.RestoreNone
            }

            Binding {
                target: root
                property: "screenBrightnessMax"
                value: Math.max(1, model.maxBrightness)
                when: index === 0
                restoreMode: Binding.RestoreNone
            }

            Binding {
                target: root
                property: "screenName"
                value: model.displayName || ""
                when: index === 0
                restoreMode: Binding.RestoreNone
            }
        }
    }

    Components.SliderControl {
        visible: root.screenAvailable
        Layout.fillWidth: true
        theme: root.theme
        iconName: "brightness-high"
        label: i18n("Brightness")
        valueText: Math.round(root.screenBrightness / Math.max(1, root.screenBrightnessMax) * 100) + "%"
        from: 0
        to: root.screenBrightnessMax
        value: root.screenBrightness
        stepSize: Math.max(1, Math.round(root.screenBrightnessMax / 100))
        onMoved: screenControl.setBrightness(root.screenName, Math.round(value))
    }

    Components.SliderControl {
        visible: root.keyboardAvailable
        Layout.fillWidth: true
        theme: root.theme
        iconName: "input-keyboard-brightness"
        label: i18n("Keyboard backlight")
        valueText: Math.round(keyboardControl.brightness
            / Math.max(1, keyboardControl.brightnessMax) * 100) + "%"
        from: 0
        to: Math.max(1, keyboardControl.brightnessMax)
        value: keyboardControl.brightness
        stepSize: 1
        onMoved: keyboardControl.brightness = Math.round(value)
    }

    PlasmaComponents3.Label {
        visible: !root.available
        Layout.fillWidth: true
        text: i18n("Brightness control is unavailable")
        color: root.theme ? root.theme.muted : Kirigami.Theme.disabledTextColor
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        textFormat: Text.PlainText
    }
}
