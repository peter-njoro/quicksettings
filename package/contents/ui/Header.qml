// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

RowLayout {
    id: root

    property var theme
    property bool showDate: true

    spacing: Kirigami.Units.smallSpacing

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0

        PlasmaComponents3.Label {
            text: i18n("Quick Settings")
            font.weight: Font.DemiBold
            font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
            textFormat: Text.PlainText
        }

        PlasmaExtras.DescriptiveLabel {
            visible: root.showDate
            text: Qt.formatDate(new Date(), Qt.DefaultLocaleLongDate)
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            textFormat: Text.PlainText
        }
    }

    PlasmaComponents3.ToolButton {
        icon.name: "application-menu"
        text: i18n("Widget menu")
        display: PlasmaComponents3.ToolButton.IconOnly
        onClicked: menu.open()

        QQC2.Menu {
            id: menu
            y: parent.height

            QQC2.MenuItem {
                text: i18n("Configure Quick Settings…")
                icon.name: "configure"
                onTriggered: plasmoid.internalAction("configure").trigger()
            }

            QQC2.MenuItem {
                text: i18n("About Quick Settings")
                icon.name: "help-about"
                onTriggered: aboutDialog.open()
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
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
            }

            PlasmaComponents3.Label {
                text: i18n("Version %1", "1.0.0")
                opacity: 0.75
            }

            PlasmaComponents3.Label {
                Layout.maximumWidth: Kirigami.Units.gridUnit * 18
                wrapMode: Text.WordWrap
                text: i18n("A modern, glass-inspired control panel for frequently used KDE Plasma 6 desktop settings.")
            }

            PlasmaComponents3.Label {
                text: i18n("Licensed under GPL-3.0-or-later.")
                opacity: 0.75
            }
        }
    }
}
