// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: page

    property alias cfg_appearance: appearanceCombo.currentValue
    property alias cfg_useCustomIcon: useCustomIconCheck.checked
    property string cfg_icon
    property alias cfg_transparency: transparencySlider.value
    property alias cfg_blur: blurCheck.checked
    property alias cfg_cornerRadius: radiusSlider.value
    property alias cfg_animations: animationsCheck.checked
    property alias cfg_animationSpeed: animationSpeedSlider.value
    property alias cfg_followAccent: followAccentCheck.checked
    property alias cfg_compactSpacing: compactSpacingCheck.checked
    property alias cfg_rememberView: rememberViewCheck.checked
    property alias cfg_closeOnOutsideClick: closeOnOutsideClickCheck.checked
    property alias cfg_showHeaderDate: showHeaderDateCheck.checked

    readonly property bool customIconActive: useCustomIconCheck.checked
        && cfg_icon.length > 0
    readonly property bool systemDark: Kirigami.Theme.backgroundColor.hslLightness < 0.5
    readonly property url defaultIcon: Qt.resolvedUrl(page.systemDark
        ? "../icons/quick-settings-light.svg"
        : "../icons/quick-settings-dark.svg")

    KIconThemes.IconDialog {
        id: iconDialog

        onIconNameChanged: iconName => {
            if (iconName.length > 0) {
                page.cfg_icon = iconName;
                useCustomIconCheck.checked = true;
            }
        }
    }

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: appearanceCombo

            Kirigami.FormData.label: i18n("Appearance:")

            textRole: "text"
            valueRole: "value"
            model: [
                { text: i18n("Follow system color scheme"), value: "automatic" },
                { text: i18n("Dark"), value: "dark" },
                { text: i18n("Light"), value: "light" }
            ]

        }

        RowLayout {
            Kirigami.FormData.label: i18n("Panel icon:")

            Kirigami.Icon {
                Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                source: page.customIconActive ? page.cfg_icon : page.defaultIcon
            }

            QQC2.CheckBox {
                id: useCustomIconCheck

                text: i18n("Use a custom icon")
            }

            QQC2.Button {
                id: iconButton

                text: i18n("Choose…")
                onClicked: iconDialog.open()
            }

            QQC2.ToolButton {
                text: i18n("Reset")
                enabled: page.customIconActive
                onClicked: {
                    page.cfg_icon = "";
                    useCustomIconCheck.checked = false;
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Glass transparency:")

            QQC2.Slider {
                id: transparencySlider

                Layout.fillWidth: true
                from: 0
                to: 100
                stepSize: 1
            }

            QQC2.Label {
                Layout.minimumWidth: Kirigami.Units.gridUnit * 2
                horizontalAlignment: Text.AlignRight
                text: Math.round(transparencySlider.value) + "%"
            }
        }

        QQC2.CheckBox {
            id: blurCheck

            text: i18n("Use compositor blur behind the popup (requires compositor support)")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Corner radius:")

            QQC2.Slider {
                id: radiusSlider

                Layout.fillWidth: true
                from: 0
                to: 40
                stepSize: 1
            }

            QQC2.Label {
                Layout.minimumWidth: Kirigami.Units.gridUnit * 2
                horizontalAlignment: Text.AlignRight
                text: Math.round(radiusSlider.value) + " px"
            }
        }

        QQC2.CheckBox {
            id: animationsCheck

            Kirigami.FormData.label: i18n("Motion:")
            text: i18n("Enable animations")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Animation speed:")

            QQC2.Slider {
                id: animationSpeedSlider

                Layout.fillWidth: true
                from: 0
                to: 200
                stepSize: 10
            }

            QQC2.Label {
                Layout.minimumWidth: Kirigami.Units.gridUnit * 2
                horizontalAlignment: Text.AlignRight
                text: Math.round(animationSpeedSlider.value) + "%"
            }
        }

        QQC2.CheckBox {
            id: followAccentCheck

            Kirigami.FormData.label: i18n("Colors:")
            text: i18n("Use the system accent color")
        }

        QQC2.CheckBox {
            id: compactSpacingCheck

            Kirigami.FormData.label: i18n("Density:")
            text: i18n("Use compact spacing")
        }

        QQC2.CheckBox {
            id: rememberViewCheck

            Kirigami.FormData.label: i18n("Behavior:")
            text: i18n("Remember the last opened page")
        }

        QQC2.CheckBox {
            id: closeOnOutsideClickCheck

            text: i18n("Close when clicking outside the popup")
        }

        QQC2.CheckBox {
            id: showHeaderDateCheck

            text: i18n("Show today's date in the header")
        }
    }
}
