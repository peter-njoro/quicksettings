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
- Koi-powered appearance card that toggles light and dark themes with one click.
- Koi integration section in the configuration dialog with connection status, checks and setup reset.
- Pill-shaped toggle component with a smooth thumb animation.
- Primary and secondary button styles with rounded geometry for the detail views.

### Changed

- Apply the refined glass design system with layered translucent surfaces, rounded shapes and consistent spacing in light and dark appearance.
- Restyle the focus, appearance and Night Light tiles as compact rounded cards with icon tiles and subtle accent indicators.
- Add a pill toggle to the Night Light card with a subtle accent active state.
- Combine the brightness and volume sliders into one full-width card.
- Slim the sliders down to a minimal 5 px track with a small round thumb that grows while hovered.
- Show persistent hover, pressed and popup-open highlights on the panel icon.
- Widen the popup to 390 px with adjustable corner radius defaulting to 24 px and derived card and control radii.

### Changed

- Keep the native Plasma popup frame and draw a translucent glass panel over it.
- Keep the glass panel coherent when forcing light or dark appearance.
- Keep sliders in sync with external state changes without fighting user drags.
- Prevent mouse wheel scrolling over sliders from changing their values.
- Split the combined connectivity view into separate Wi-Fi and Bluetooth views.
- Correct power settings shortcuts to the installed PowerDevil KCM.
- Ship the default panel icon as a bundled SVG instead of a theme icon.
- Use bundled Wi-Fi and Bluetooth icons for connectivity cards and lists.
- Use bundled appearance and Night Light icons for their quick controls.
- Toggle Night Light from its card instead of opening Night Light settings.
- Base the appearance card state on the system color scheme so enabled means dark.
- Guide users through the appearance setup view until Koi is connected and onboarded, then switch themes straight from the card.

### Fixed

- Enable Bluetooth from the connectivity card when the adapter is powered off.
- Keep the Bluetooth card icon clearly visible while Bluetooth is off.
- Connect and disconnect Bluetooth devices from the Bluetooth detail view.
- Synchronize the focus card with the real Plasma do not disturb state and actually toggle it via the plasmashell notification shortcut.
- Update the focus card icon immediately when do not disturb is toggled and ignore stale state reads.

## [1.0.0] - 2026-11-04

### Added

- Initial Plasma 6 widget package and installable applet skeleton.
- Compact panel icon with tooltip and hover feedback.
- Glass-styled popup with header, connectivity, brightness, volume, focus,
  appearance, media, battery and quick action sections.
- Expanded connectivity, audio and power views with back navigation.
- Configuration page for appearance, layout, behaviour and modules.
- Packaging and lint helper scripts.
