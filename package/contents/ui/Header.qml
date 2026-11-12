// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.private.battery
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme
    property bool showDate: true
    property bool showBattery: true

    signal configureRequested()
    signal powerRequested()

    BatteryControlModel {
        id: battery
    }

    readonly property bool batteryPresent: battery.hasBatteries || battery.hasCumulative
    readonly property bool batteryCharging: battery.state === BatteryControlModel.Charging
    readonly property string batteryStateText: {
        switch (battery.state) {
        case BatteryControlModel.Charging:
            return i18n("Charging");
        case BatteryControlModel.FullyCharged:
            return i18n("Fully charged");
        case BatteryControlModel.Discharging:
            return i18n("On battery");
        default:
            return battery.pluggedIn ? i18n("Plugged in") : i18n("Battery status");
        }
    }
    readonly property string batteryTooltip: i18n("%1 percent · %2",
        battery.percent, batteryStateText)

    readonly property var t: theme || fallbackTheme

    Components.Theme { id: fallbackTheme }

    implicitWidth: headerRow.implicitWidth
    implicitHeight: headerRow.implicitHeight

    RowLayout {
        id: headerRow

        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                text: i18n("Quick Settings")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
                textFormat: Text.PlainText
            }

            PlasmaExtras.DescriptiveLabel {
                visible: root.showDate
                text: new Date().toLocaleDateString(Qt.locale(), Locale.LongFormat)
                color: root.t.muted
                font.pointSize: Kirigami.Theme.smallFont.pointSize
                textFormat: Text.PlainText
            }
        }

        PlasmaComponents3.ToolButton {
            id: batteryButton

            visible: root.showBattery && root.batteryPresent
            text: root.batteryTooltip
            display: PlasmaComponents3.ToolButton.IconOnly
            onClicked: root.powerRequested()

            contentItem: RowLayout {
                spacing: Kirigami.Units.smallSpacing

                Components.BatteryIcon {
                    Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                    Layout.preferredHeight: Layout.preferredWidth
                    theme: root.t
                    percent: battery.percent
                    charging: root.batteryCharging
                }

                PlasmaComponents3.Label {
                    text: battery.percent + "%"
                    color: root.t.text
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }
            }

            QQC2.ToolTip.visible: hovered
            QQC2.ToolTip.text: root.batteryTooltip
            QQC2.ToolTip.delay: 500

            background: Rectangle {
                implicitWidth: 32
                implicitHeight: 32
                radius: 10
                color: batteryButton.hovered
                    ? root.t.alpha(root.t.text, 0.08)
                    : root.t.alpha(root.t.text, 0.0)

                Behavior on color {
                    ColorAnimation { duration: root.t.shortAnimationDuration }
                }
            }

            Accessible.role: Accessible.Button
            Accessible.name: i18n("Power settings, %1", root.batteryTooltip)
        }

        PlasmaComponents3.ToolButton {
            id: menuButton

            icon.name: "application-menu"
            text: i18n("Widget menu")
            display: PlasmaComponents3.ToolButton.IconOnly
            onClicked: menu.open()

            background: Rectangle {
                implicitWidth: 32
                implicitHeight: 32
                radius: height / 2
                color: menuButton.hovered
                    ? root.t.alpha(root.t.text, 0.08)
                    : root.t.alpha(root.t.text, 0.0)

                Behavior on color {
                    ColorAnimation { duration: root.t.shortAnimationDuration }
                }
            }

            QQC2.Menu {
                id: menu
                y: parent.height

                QQC2.MenuItem {
                    text: i18n("Configure Quick Settings…")
                    icon.name: "configure"
                    onTriggered: root.configureRequested()
                }

                QQC2.MenuItem {
                    text: i18n("About Quick Settings")
                    icon.name: "help-about"
                    onTriggered: aboutDialog.open()
                }
            }
        }
    }

    QQC2.Dialog {
        id: aboutDialog

        title: i18n("About Quick Settings")
        modal: true
        standardButtons: QQC2.Dialog.Close
        anchors.centerIn: parent

        ColumnLayout {
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents3.Label {
                text: i18n("Quick Settings")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
            }

            PlasmaComponents3.Label {
                text: i18n("Version %1", "1.0.0")
                color: root.t.muted
            }

            PlasmaComponents3.Label {
                Layout.maximumWidth: Kirigami.Units.gridUnit * 18
                color: root.t.text
                wrapMode: Text.WordWrap
                text: i18n("A modern, glass-inspired control panel for frequently used KDE Plasma 6 desktop settings.")
            }

            PlasmaComponents3.Label {
                text: i18n("Licensed under GPL-3.0-or-later.")
                color: root.t.muted
            }
        }
    }
}
