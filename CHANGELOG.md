# Changelog

All notable changes to Quick Settings will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Microphone volume and mute controls in the audio details view.
- Open the audio details view by clicking the volume card.
- Animation speed and close-on-outside-click settings.
- Opaque card fallback when the translucent glass effect is disabled.

### Changed

- Use the native Plasma popup background and keep the glass treatment on cards.
- Keep sliders in sync with external state changes without fighting user drags.
- Correct power settings shortcuts to the installed PowerDevil KCM.

## [1.0.0] - 2026-11-04

### Added

- Initial Plasma 6 widget package and installable applet skeleton.
- Compact panel icon with tooltip and hover feedback.
- Glass-styled popup with header, connectivity, brightness, volume, focus,
  appearance, media, battery and quick action sections.
- Expanded connectivity, audio and power views with back navigation.
- Configuration page for appearance, layout, behaviour and modules.
- Packaging and lint helper scripts.
