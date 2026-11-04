// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

Item {
    id: root

    property bool dark: true
    property int currentPage: 0

    implicitWidth: Kirigami.Units.gridUnit * 22
    implicitHeight: Kirigami.Units.gridUnit * 32

    function resetToMain() {
        currentPage = 0;
    }

    Rectangle {
        anchors.fill: parent
        radius: plasmoid.configuration.cornerRadius
        color: root.dark ? Qt.rgba(0.09, 0.10, 0.12, 0.55) : Qt.rgba(0.98, 0.98, 0.99, 0.65)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit * 0.75

        Header {
            Layout.fillWidth: true
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
