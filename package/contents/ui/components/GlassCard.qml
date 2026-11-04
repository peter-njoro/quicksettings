// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import "." as Components

Rectangle {
    id: card

    default property alias content: contentItem.data
    property var theme: null
    property bool interactive: false
    property bool elevated: false

    signal clicked()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered

    Components.Theme { id: fallbackTheme }

    implicitWidth: contentItem.implicitWidth + t.cardPadding * 2
    implicitHeight: contentItem.implicitHeight + t.cardPadding * 2

    radius: Math.max(0, t.radius * 0.72)
    color: interactive && hovered ? t.cardHover : t.card
    border.width: 1
    border.color: t.border

    Behavior on color {
        ColorAnimation { duration: card.t.animationDuration }
    }

    ColumnLayout {
        id: contentItem

        anchors.fill: parent
        anchors.margins: card.t.cardPadding
        spacing: 0
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        enabled: card.interactive
        cursorShape: card.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: card.clicked()
    }

    HoverHandler {
        id: hoverHandler
    }
}
