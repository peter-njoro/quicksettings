// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

import "../ui"

KCM.SimpleKCM {
    id: page

    property alias cfg_koiOnboarded: koiOnboardedCheck.checked

    KoiController {
        id: koi
    }

    Component.onCompleted: koi.checkKoi()

    readonly property string statusText: koi.checking
        ? i18n("Checking…")
        : !koi.installed ? i18n("Not installed")
        : !koi.connected ? i18n("Not running")
        : i18n("Connected")

    Kirigami.FormLayout {
        RowLayout {
            Kirigami.FormData.label: i18n("Status:")

            QQC2.Label {
                text: page.statusText
                textFormat: Text.PlainText
            }

            QQC2.Label {
                visible: koi.lastError.length > 0 && !koi.checking
                text: koi.lastError
                color: Kirigami.Theme.negativeTextColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: Text.PlainText
            }

            QQC2.Button {
                text: i18n("Check connection")
                onClicked: koi.checkKoi()
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Actions:")

            QQC2.Button {
                visible: koi.installed && !koi.connected && !koi.checking
                text: i18n("Open Koi")
                onClicked: koi.launchKoi()
            }

            QQC2.Button {
                visible: !koi.installed && !koi.connected && !koi.checking
                text: i18n("Get Koi")
                onClicked: koi.openProjectPage()
            }
        }

        QQC2.CheckBox {
            id: koiOnboardedCheck

            Kirigami.FormData.label: i18n("Setup:")
            text: i18n("Mark appearance setup as completed")
        }

        QQC2.Label {
            Kirigami.FormData.label: i18n("About:")
            Layout.fillWidth: true
            Layout.maximumWidth: Kirigami.Units.gridUnit * 22
            text: i18n("Quick Settings uses Koi to switch between light and dark appearance. Install Koi, configure its light and dark profiles, and mark the setup as completed above. When it is set up, the appearance card in the popup toggles light and dark with one click.")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.PlainText
        }
    }
}
