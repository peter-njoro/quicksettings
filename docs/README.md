# Documentation notes

Working notes about known issues and integration behaviour encountered while
developing Quick Settings. These are observations and workarounds, not part of
the widget's public API.

- [KRunner crash on Plasma theme switch](krunner-crash-theme-switch.md) — the
  Appearance card can trigger a KDE bug that crashes `krunner`; the widget is
  not the cause.
- [Appearance switching uses Koi](appearance-koi.md) — theme changes are
  delegated to Koi over D-Bus, so there may be a slight delay before the new
  theme is fully applied.
