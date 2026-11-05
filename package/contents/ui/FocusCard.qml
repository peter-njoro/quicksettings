// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.notificationmanager as NotificationManager

import "components" as Components

Components.CircleButton {
    id: root

    readonly property bool inhibited: NotificationManager.Server.inhibited

    iconName: root.inhibited ? "notifications-disabled" : "notifications"
    label: i18n("Focus")
    statusText: root.inhibited ? i18n("On") : i18n("Off")
    active: root.inhibited
    onActivated: NotificationManager.Server.inhibited = !root.inhibited
}
