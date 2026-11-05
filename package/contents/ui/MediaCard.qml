// SPDX-FileCopyrightText: 2026 Peter Chege <peterchegen12@gmail.com>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.private.mpris as Mpris
import org.kde.kirigami as Kirigami

import "components" as Components

Components.GlassCard {
    id: root

    PlasmaComponents3.Label {
        Layout.fillWidth: true
        text: i18n("Now Playing")
        color: root.t.muted
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        font.weight: Font.DemiBold
        textFormat: Text.PlainText
    }

    Repeater {
        id: players

        model: Mpris.MultiplexerModel {}

        delegate: ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.smallSpacing
            visible: index === 0
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true
                spacing: Kirigami.Units.smallSpacing

                Rectangle {
                    Layout.preferredWidth: Kirigami.Units.iconSizes.large
                    Layout.preferredHeight: Layout.preferredWidth
                    radius: Kirigami.Units.cornerRadius
                    color: root.t.alpha(root.t.text, 0.10)
                    clip: true

                    Image {
                        id: artwork

                        anchors.fill: parent
                        source: model.artUrl || ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        visible: status === Image.Ready
                        sourceSize.width: width * Screen.devicePixelRatio
                        sourceSize.height: height * Screen.devicePixelRatio
                    }

                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.smallMedium
                        height: width
                        source: "media-playback-start"
                        visible: !artwork.visible
                        opacity: 0.7
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: model.track.length > 0 ? model.track : i18n("No title")
                        color: root.t.text
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        textFormat: Text.PlainText
                    }

                    PlasmaComponents3.Label {
                        Layout.fillWidth: true
                        text: model.artist.length > 0 ? model.artist : model.identity
                        color: root.t.muted
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        textFormat: Text.PlainText
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.smallSpacing

                Components.IconButton {
                    theme: root.t
                    iconName: "media-skip-backward"
                    tooltip: i18n("Previous track")
                    interactive: model.canGoPrevious
                    onClicked: model.container.Previous()
                }

                Components.IconButton {
                    theme: root.t
                    iconName: model.playbackStatus === Mpris.PlaybackStatus.Playing
                        ? "media-playback-pause" : "media-playback-start"
                    tooltip: model.playbackStatus === Mpris.PlaybackStatus.Playing
                        ? i18n("Pause") : i18n("Play")
                    interactive: model.canControl
                    iconSize: Kirigami.Units.iconSizes.smallMedium
                    onClicked: model.container.PlayPause()
                }

                Components.IconButton {
                    theme: root.t
                    iconName: "media-skip-forward"
                    tooltip: i18n("Next track")
                    interactive: model.canGoNext
                    onClicked: model.container.Next()
                }
            }
        }
    }

    PlasmaComponents3.Label {
        Layout.fillWidth: true
        Layout.topMargin: Kirigami.Units.smallSpacing
        visible: players.count === 0
        text: i18n("No media playing")
        color: root.t.muted
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        textFormat: Text.PlainText
    }
}
