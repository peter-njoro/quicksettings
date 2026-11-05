// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.volume
import org.kde.kirigami as Kirigami

import "components" as Components

Item {
    id: root

    property var theme: null
    property var configuration: null

    signal backRequested()

    readonly property var t: theme || fallbackTheme
    readonly property int normalVolume: PulseAudio.NormalVolume || 65536

    Components.Theme { id: fallbackTheme }

    SinkModel {
        id: sinkModel
    }

    SourceModel {
        id: sourceModel
    }

    SinkInputModel {
        id: sinkInputModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: root.t.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            Components.IconButton {
                theme: root.t
                iconName: "go-previous"
                tooltip: i18n("Back")
                onClicked: root.backRequested()
            }

            PlasmaComponents3.Label {
                Layout.fillWidth: true
                text: i18n("Audio")
                color: root.t.text
                font.weight: Font.DemiBold
                font.pointSize: Kirigami.Theme.defaultFont.pointSize + 2
                textFormat: Text.PlainText
            }
        }

        PlasmaComponents3.ScrollView {
            id: scroll

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: availableWidth

            PlasmaComponents3.ScrollBar.horizontal.policy: PlasmaComponents3.ScrollBar.AlwaysOff
            background: null

            ColumnLayout {
                width: scroll.availableWidth
                spacing: root.t.spacing

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    text: i18n("Output devices")
                    color: root.t.muted
                    font.weight: Font.DemiBold
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                Repeater {
                    id: outputsRepeater

                    model: sinkModel

                    delegate: Components.GlassCard {
                        Layout.fillWidth: true
                        theme: root.t

                        readonly property var device: model.PulseObject

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            RowLayout {
                                Layout.fillWidth: true

                                Kirigami.Icon {
                                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                    Layout.preferredHeight: Layout.preferredWidth
                                    source: device.isDefault
                                        ? "audio-card" : "audio-card-bluetooth"
                                    opacity: device.isDefault ? 1.0 : 0.6
                                }

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: device.description || device.name
                                    color: root.t.text
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }
                            }

                            Components.SliderControl {
                                Layout.fillWidth: true
                                theme: root.t
                                iconName: "audio-volume-high"
                                label: ""
                                showLabel: false
                                muted: device.muted
                                valueText: Math.round(device.volume
                                    / Math.max(1, root.normalVolume) * 100) + "%"
                                from: 0
                                to: root.normalVolume
                                value: device.volume
                                stepSize: Math.max(1, Math.round(root.normalVolume / 100))
                                onMoved: device.volume = Math.round(value)
                                onIconClicked: device.muted = !device.muted
                            }
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: outputsRepeater.count === 0
                    text: i18n("No audio output devices available.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    Layout.topMargin: root.t.spacing
                    text: i18n("Input devices")
                    color: root.t.muted
                    font.weight: Font.DemiBold
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                Repeater {
                    id: inputsRepeater

                    model: sourceModel

                    delegate: Components.GlassCard {
                        Layout.fillWidth: true
                        theme: root.t

                        readonly property var device: model.PulseObject

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            RowLayout {
                                Layout.fillWidth: true

                                Kirigami.Icon {
                                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                    Layout.preferredHeight: Layout.preferredWidth
                                    source: "audio-input-microphone"
                                    opacity: device.isDefault ? 1.0 : 0.6
                                }

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: device.description || device.name
                                    color: root.t.text
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }
                            }

                            Components.SliderControl {
                                Layout.fillWidth: true
                                theme: root.t
                                iconName: "audio-input-microphone"
                                label: ""
                                showLabel: false
                                muted: device.muted
                                valueText: Math.round(device.volume
                                    / Math.max(1, root.normalVolume) * 100) + "%"
                                from: 0
                                to: root.normalVolume
                                value: device.volume
                                stepSize: Math.max(1, Math.round(root.normalVolume / 100))
                                onMoved: device.volume = Math.round(value)
                                onIconClicked: device.muted = !device.muted
                            }
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: inputsRepeater.count === 0
                    text: i18n("No microphone devices available.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    Layout.topMargin: root.t.spacing
                    text: i18n("Applications")
                    color: root.t.muted
                    font.weight: Font.DemiBold
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }

                Repeater {
                    id: appsRepeater

                    model: sinkInputModel

                    delegate: Components.GlassCard {
                        Layout.fillWidth: true
                        theme: root.t

                        readonly property var device: model.PulseObject

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            Kirigami.Icon {
                                Layout.preferredWidth: Kirigami.Units.iconSizes.small
                                Layout.preferredHeight: Layout.preferredWidth
                                source: "audio-x-generic"
                                opacity: 0.7
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: device.description || device.name || i18n("Application")
                                    color: root.t.text
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                }

                                Components.SliderControl {
                                    Layout.fillWidth: true
                                    theme: root.t
                                    iconName: "audio-volume-high"
                                    label: ""
                                    showLabel: false
                                    muted: device.muted
                                    valueText: Math.round(device.volume
                                        / Math.max(1, root.normalVolume) * 100) + "%"
                                    from: 0
                                    to: root.normalVolume
                                    value: device.volume
                                    stepSize: Math.max(1, Math.round(root.normalVolume / 100))
                                    onMoved: device.volume = Math.round(value)
                                    onIconClicked: device.muted = !device.muted
                                }
                            }
                        }
                    }
                }

                PlasmaComponents3.Label {
                    Layout.fillWidth: true
                    visible: appsRepeater.count === 0
                    text: i18n("No applications are playing audio.")
                    color: root.t.muted
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
