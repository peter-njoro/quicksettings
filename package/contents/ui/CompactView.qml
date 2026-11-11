// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

Item {
    id: root

    signal activated()

    property bool useCustomIcon: false
    property string iconName: ""
    property bool popupOpen: false

    readonly property bool showCustomIcon: useCustomIcon && iconName.length > 0
    readonly property url defaultIcon: Qt.resolvedUrl("../icons/quick-settings.svg")

    implicitWidth: Kirigami.Units.iconSizes.smallMedium
        + Kirigami.Units.smallSpacing * 2
    implicitHeight: implicitWidth

    readonly property bool hovered: hoverHandler.hovered

    Rectangle {
        anchors.fill: parent
        radius: 11
        color: tapHandler.pressed
            ? Qt.rgba(1, 1, 1, 0.07)
            : ((root.hovered || root.popupOpen) ? Qt.rgba(1, 1, 1, 0.12)
                : (Kirigami.Theme.backgroundColor.hslLightness < 0.5
                    ? "transparent" : Qt.rgba(0, 0, 0, 0.06)))

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

        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.small
            height: width
            source: root.showCustomIcon ? root.iconName : root.defaultIcon
            isMask: !root.showCustomIcon
            color: Kirigami.Theme.textColor
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    TapHandler {
        id: tapHandler

        acceptedButtons: Qt.LeftButton
        onTapped: root.activated()
    }
}
