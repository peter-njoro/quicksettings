# Changelog

All notable changes to Quick Settings will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Microphone volume and mute controls in the audio details view.
- Open the audio details view by clicking the volume card.
- Open the power details view by clicking the battery card.
- Animation speed and close-on-outside-click settings.
- Opaque card fallback when the translucent glass effect is disabled.
- Custom panel icon option with an icon picker in the Appearance configuration tab.

### Changed

- Keep the native Plasma popup frame and draw a translucent glass panel over it.
- Keep the glass panel coherent when forcing light or dark appearance.
- Keep sliders in sync with external state changes without fighting user drags.
- Prevent mouse wheel scrolling over sliders from changing their values.
- Split the combined connectivity view into separate Wi-Fi and Bluetooth views.
- Correct power settings shortcuts to the installed PowerDevil KCM.
- Ship the default panel icon as a bundled SVG instead of a theme icon.

## [1.0.0] - 2026-11-04

### Added

- Initial Plasma 6 widget package and installable applet skeleton.
- Compact panel icon with tooltip and hover feedback.
- Glass-styled popup with header, connectivity, brightness, volume, focus,
  appearance, media, battery and quick action sections.
- Expanded connectivity, audio and power views with back navigation.
- Configuration page for appearance, layout, behaviour and modules.
- Packaging and lint helper scripts.
