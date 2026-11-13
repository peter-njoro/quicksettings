# Screenshots

Screenshots are generated from the real QML sources; no mockups are used.

1. `main-dark.png` — the main panel in dark appearance (405 × 534).
2. `main-light.png` — the main panel in light appearance (405 × 534).
3. `wifi.png` — the expanded Wi-Fi view (420 × 760).
4. `bluetooth.png` — the expanded Bluetooth view (420 × 760).
5. `audio.png` — the expanded audio view (420 × 800; taller when an application is playing).
6. `power.png` — the expanded power view (420 × 340).

The detail views show the current header shortcuts: the **Settings** button
opens the matching System Settings module, and Wi-Fi rows include
Connect/Disconnect controls. All six images come from the same QML sources:
the main pair was captured from the live widget in `plasmawindowed`, and the
detail views were rendered with an offscreen Qt Quick harness using the KDE
platform theme so the icon theme and accent colour match the live widget.
Keep the icon theme, accent colour and background consistent when refreshing
the set.
