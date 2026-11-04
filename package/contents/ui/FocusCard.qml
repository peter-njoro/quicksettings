// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.notificationmanager as NotificationManager
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    signal activated()

    readonly property bool inhibited: NotificationManager.Server.inhibited

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Layout.preferredWidth
            source: root.inhibited ? "notifications-disabled" : "notifications"
            opacity: 0.9
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                text: i18n("Focus")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                text: root.inhibited ? i18n("Do Not Disturb") : i18n("Notifications on")
                color: root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                textFormat: Text.PlainText
            }
        }

        Components.ToggleButton {
            theme: root.t
            checked: root.inhibited
            onToggled: NotificationManager.Server.inhibited = checked
        }
    }
}
