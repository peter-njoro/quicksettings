# Appearance switching uses Koi

## Summary

The Appearance card and the Appearance details view do not change the Plasma
theme directly. They delegate to [Koi](https://github.com/baduhai/Koi) over
D-Bus:

- Quick Settings calls `goLightMode` / `goDarkMode` on `dev.baduhai.Koi`.
- Koi applies the color scheme, style and icons.
- Quick Settings only tracks whether Koi is connected and onboarded; it does
  not know when the theme change has finished.

The switch is therefore asynchronous and runs in another process. Users may
notice a short delay before the panel, icons and other apps finish updating.

## What users may see

- The Appearance card briefly continues to show the old state after tapping.
- Icons, the Plasma style and open windows may update over a short interval
  rather than all at once.
- The delay depends on Koi and the desktop load; it is usually brief, but can
  be a second or more on slower systems.
- A theme change can also trigger the unrelated
  [KRunner crash](krunner-crash-theme-switch.md) in some KDE versions.

## Behaviour without Koi

- If Koi is not installed or not running, the card shows the setup flow and
  can launch Koi or open its project page.
- Tapping the card without a connected, onboarded Koi opens the Appearance
  details view instead of switching the theme.

## Relevant code

- `package/contents/ui/AppearanceCard.qml` — card state and labels.
- `package/contents/ui/MainView.qml` — invokes
  `KoiController.applyLightMode()` / `applyDarkMode()`.
- `package/contents/ui/KoiController.qml` — D-Bus calls to Koi.
- `package/contents/ui/AppearanceDetailsView.qml` — setup/onboarding flow.
