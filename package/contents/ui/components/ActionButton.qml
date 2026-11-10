// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents3

import "." as Components

PlasmaComponents3.Button {
    id: root

    property var theme: null
    property bool primary: false

    readonly property var t: theme || fallbackTheme
    readonly property color highlightText: {
        if (!root.primary) {
            return root.t.text;
        }
        return root.t.accent.hslLightness > 0.55 ? "#202127" : "#FFFFFF";
    }

    Components.Theme { id: fallbackTheme }

    implicitHeight: root.primary ? 40 : 36

    opacity: enabled ? 1.0 : 0.5

    icon.color: "transparent"

    background: Rectangle {
        radius: root.primary
            ? Math.round(root.t.controlRadius)
            : Math.round(root.t.controlRadius - 1)
        color: {
            if (root.primary) {
                if (root.pressed) {
                    return Qt.lighter(root.t.accent, 0.85);
                }
                if (root.hovered) {
                    return Qt.lighter(root.t.accent, 1.1);
                }
                return root.t.accent;
            }
            if (root.pressed) {
                return root.t.alpha(root.t.text, 0.18);
            }
            if (root.hovered) {
                return root.t.alpha(root.t.text, 0.14);
            }
            return root.t.alpha(root.t.text, 0.08);
        }
        border.width: root.primary ? 0 : 1
        border.color: root.t.border

        Behavior on color {
            ColorAnimation { duration: root.t.shortAnimationDuration }
        }
    }

    contentItem: RowLayout {
        spacing: root.t.spacingXs

        Kirigami.Icon {
            Layout.preferredWidth: root.icon.width > 0 ? root.icon.width : 0
            Layout.preferredHeight: root.icon.height > 0 ? root.icon.height : 0
            source: root.icon.name
            visible: root.icon.name.length > 0
            color: root.highlightText
            isMask: true
        }

        PlasmaComponents3.Label {
            Layout.fillWidth: true
            text: root.text
            font.weight: root.primary ? Font.Medium : Font.Normal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: root.highlightText
            textFormat: Text.PlainText
        }
    }
}
