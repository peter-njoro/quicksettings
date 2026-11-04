// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

Item {
    id: root

    signal activated()

    implicitWidth: Kirigami.Units.iconSizes.smallMedium
        + Kirigami.Units.smallSpacing * 2
    implicitHeight: implicitWidth

    readonly property bool hovered: hoverHandler.hovered

    Rectangle {
        id: background

        anchors.fill: parent
        radius: Kirigami.Units.cornerRadius
        color: root.hovered ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

        Behavior on color {
            ColorAnimation { duration: Kirigami.Units.shortDuration }
        }
    }

    Item {
        id: glyph

        anchors.centerIn: parent
        width: Kirigami.Units.iconSizes.small
        height: Kirigami.Units.iconSizes.small
        scale: root.hovered ? 1.08 : 1.0

        Behavior on scale {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }

        Repeater {
            model: [
                { knob: 0.22, offset: 2 },
                { knob: 0.72, offset: 9 },
                { knob: 0.42, offset: 5 }
            ]

            delegate: Item {
                required property var modelData
                required property int index

                x: 0
                y: index * (glyph.height / 3) + 1
                width: glyph.width
                height: Math.max(2, glyph.height / 9)

                Rectangle {
                    anchors.fill: parent
                    radius: height / 2
                    color: Kirigami.Theme.textColor
                    opacity: 0.85
                }

                Rectangle {
                    width: Math.max(4, glyph.height / 4.5)
                    height: width
                    radius: width / 2
                    color: Kirigami.Theme.highlightColor
                    anchors.verticalCenter: parent.verticalCenter
                    x: Math.round((parent.width - width) * modelData.knob)
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton
        onTapped: root.activated()
    }

    QQC2.ToolTip.text: i18n("Quick Settings")
    QQC2.ToolTip.visible: root.hovered
    QQC2.ToolTip.delay: 500
}
