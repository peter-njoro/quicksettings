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
    property string label: ""
    property string statusText: ""
    property bool active: false
    property bool interactive: true

    signal activated()

    readonly property var t: theme || fallbackTheme
    readonly property bool hovered: hoverHandler.hovered
    readonly property real circleSize: Math.min(width, Kirigami.Units.gridUnit * 3.2)

    Components.Theme { id: fallbackTheme }

    implicitWidth: Kirigami.Units.gridUnit * 4
    implicitHeight: Kirigami.Units.gridUnit * 3.2 + Kirigami.Units.largeSpacing
        + labelColumn.implicitHeight
    opacity: interactive ? 1.0 : 0.5

    Rectangle {
        anchors.centerIn: circle
        width: circle.width + 8
        height: width
        radius: width / 2
        color: root.active ? root.t.alpha(root.t.accent, 0.12) : "transparent"
        visible: root.active

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }
    }

    Rectangle {
        id: circle

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        width: root.circleSize
        height: width
        radius: width / 2
        color: root.active
            ? root.t.alpha(root.t.accent, root.hovered ? 0.34 : 0.25)
            : (root.hovered ? root.t.cardHover : root.t.card)
        border.width: 1
        border.color: root.active
            ? root.t.alpha(root.t.accent, 0.72) : root.t.border

        Behavior on color {
            ColorAnimation { duration: root.t.animationDuration }
        }
        Behavior on border.color {
            ColorAnimation { duration: root.t.shortAnimationDuration }
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.medium
            height: width
            source: root.iconName
            color: root.active ? root.t.accent : root.t.text
        }
    }

    ColumnLayout {
        id: labelColumn

        anchors.top: circle.bottom
        anchors.topMargin: Kirigami.Units.smallSpacing
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        spacing: 0

        PlasmaComponents3.Label {
            Layout.fillWidth: true
            text: root.label
            color: root.t.text
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            textFormat: Text.PlainText
        }

        PlasmaComponents3.Label {
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
