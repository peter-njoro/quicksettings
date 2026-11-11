// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    id: page

    property alias cfg_showWifi: wifiCheck.checked
    property alias cfg_showBluetooth: bluetoothCheck.checked
    property alias cfg_showCaffeine: caffeineCheck.checked
    property alias cfg_showBrightness: brightnessCheck.checked
    property alias cfg_showVolume: volumeCheck.checked
    property alias cfg_showFocus: focusCheck.checked
    property alias cfg_showAppearance: appearanceCheck.checked
    property alias cfg_showNightLight: nightLightCheck.checked
    property alias cfg_showMedia: mediaCheck.checked
    property alias cfg_showBattery: batteryCheck.checked
    property alias cfg_showQuickActions: quickActionsCheck.checked

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: wifiCheck

            text: i18n("Wi-Fi")
        }

        QQC2.CheckBox {
            id: bluetoothCheck

            text: i18n("Bluetooth")
        }

        QQC2.CheckBox {
            id: caffeineCheck

            text: i18n("Caffeine (keep the screen on)")
        }

        QQC2.CheckBox {
            id: brightnessCheck

            text: i18n("Brightness")
        }

        QQC2.CheckBox {
            id: volumeCheck

            text: i18n("Volume")
        }

        QQC2.CheckBox {
            id: focusCheck

            text: i18n("Focus mode")
        }

        QQC2.CheckBox {
            id: appearanceCheck

            text: i18n("Appearance")
        }

        QQC2.CheckBox {
            id: nightLightCheck

            text: i18n("Night Light")
        }

        QQC2.CheckBox {
            id: mediaCheck

            text: i18n("Media controls")
        }

        QQC2.CheckBox {
            id: batteryCheck

            text: i18n("Battery")
        }

        QQC2.CheckBox {
            id: quickActionsCheck

            text: i18n("Quick actions")
        }
    }
}
