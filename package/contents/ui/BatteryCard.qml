// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.battery
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    readonly property bool present: battery.hasBatteries || battery.hasCumulative
    readonly property int percent: battery.percent
    readonly property bool charging: battery.state === BatteryControlModel.Charging

    property bool animationsEnabled: true

    interactive: root.present
    signal activated()
    onClicked: root.activated()

    BatteryControlModel {
        id: battery
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Kirigami.Units.smallSpacing

        Components.BatteryIcon {
            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Layout.preferredWidth
            theme: root.t
            percent: root.percent
            charging: root.charging
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                text: i18n("Battery")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.smallFont.pointSize + 1
                textFormat: Text.PlainText
            }

            PlasmaComponents3.Label {
                text: root.percent + "% · " + root.stateText()
                color: root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                textFormat: Text.PlainText
            }
        }

        PlasmaComponents3.Label {
            text: i18n("Power settings")
            color: root.t.muted
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            textFormat: Text.PlainText
        }
    }

    function stateText() {
        switch (battery.state) {
        case BatteryControlModel.Charging:
            return i18n("Charging");
        case BatteryControlModel.FullyCharged:
            return i18n("Fully charged");
        case BatteryControlModel.Discharging:
            return i18n("Discharging");
        default:
            return battery.pluggedIn ? i18n("Plugged in") : i18n("On battery");
        }
    }
}
