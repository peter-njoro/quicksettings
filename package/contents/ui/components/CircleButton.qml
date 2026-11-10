// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.kirigami as Kirigami

import "." as Components

Item {
    id: root

    property var theme: null
    property string iconName: ""
    property bool iconIsMask: false
    property string label: ""
    property string statusText: ""
    property bool active: false
    property bool interactive: true

    signal activated()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered

    Components.Theme { id: fallbackTheme }

    implicitWidth: 0
    implicitHeight: 88
    opacity: interactive ? 1.0 : 0.5

    Rectangle {
        anchors.fill: parent
        radius: root.t.cardRadius
        color: root.interactive && root.hovered
            ? root.t.cardHover
            : (root.active
                ? root.t.alpha(root.t.accent, 0.10) : root.t.card)
        border.width: 1
        border.color: root.active
            ? root.t.alpha(root.t.accent, 0.5)
            : (root.interactive && root.hovered ? root.t.borderHover : root.t.border)

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }

        Behavior on border.color {
            ColorAnimation { duration: root.t.shortAnimationDuration }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.t.spacingS
            spacing: root.t.spacingXs

            Rectangle {
                // Round icon tile.
                Layout.alignment: Qt.AlignHCenter
                width: 28
                height: width
                radius: width / 2
                color: root.active
                    ? root.t.alpha(root.t.accent, 0.16)
                    : root.t.alpha(root.t.text, 0.06)

                Behavior on color {
                    ColorAnimation { duration: root.t.animationDuration }
                }

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: 16
                    height: width
                    source: root.iconName
                    isMask: root.iconIsMask
                    color: root.active ? root.t.accent : root.t.text
                    opacity: root.interactive ? 1.0 : 0.6
                }
            }

            PlasmaComponents3.Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                text: root.label
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                visible: root.statusText.length > 0
                text: root.statusText
                color: root.active ? root.t.accent : root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                maximumLineCount: 1
                textFormat: Text.PlainText
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        enabled: root.interactive
        onTapped: root.activated()
    }

    Keys.onSpacePressed: {
        if (root.interactive) {
            root.activated();
        }
    }

    Accessible.role: Accessible.Button
    Accessible.name: root.statusText.length > 0
        ? root.label + ", " + root.statusText : root.label
    Accessible.checked: root.active
}
