// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.ScrollViewKCM {
    id: page

    property alias cfg_quickActionSystemSettings: systemSettingsCheck.checked
    property alias cfg_quickActionLock: lockCheck.checked
    property alias cfg_quickActionDisplay: displayCheck.checked
    property alias cfg_quickActionPower: powerCheck.checked
    property alias cfg_quickActionNetwork: networkCheck.checked
    property alias cfg_quickActionBluetooth: bluetoothCheck.checked
    property alias cfg_quickActionAudio: audioCheck.checked

    header: Kirigami.FormLayout {
        QQC2.CheckBox {
            id: systemSettingsCheck

            text: i18n("System Settings")
        }

        QQC2.CheckBox {
            id: lockCheck

            text: i18n("Lock screen")
        }

        QQC2.CheckBox {
            id: displayCheck

            text: i18n("Display settings")
        }

        QQC2.CheckBox {
            id: powerCheck

            text: i18n("Power settings")
        }

        QQC2.CheckBox {
            id: networkCheck

            text: i18n("Network settings")
        }

        QQC2.CheckBox {
            id: bluetoothCheck

            text: i18n("Bluetooth settings")
        }

        QQC2.CheckBox {
            id: audioCheck

            text: i18n("Audio settings")
        }
    }
}
