# KRunner crash on Plasma theme switch

## Summary

Switching the Plasma light/dark theme can crash `krunner` with a `SIGSEGV`,
which Ubuntu reports as an "internal error". The crash happens inside KRunner's
Web Shortcuts runner while it reloads the KIO URI filters after a theme change.
This is a KDE bug, not a Quick Settings bug, but toggling the Quick Settings
Appearance card is one way to trigger it.

- Upstream KDE bug: <https://bugs.kde.org/show_bug.cgi?id=514440>
- Affected processes: `krunner` (thread `krunner_webshor`)
- Observed upstream versions: Plasma 6.5.4, KF 6.21
- Observed here: Plasma 6.6.6, KF 6.24, Qt 6.10.2, Ubuntu 26.04

## Symptoms

- The "Ubuntu has experienced an internal error" dialog appears.
- `/var/crash/_usr_bin_krunner.<uid>.crash` is written with a title such as
  `krunner crashed with SIGSEGV in resolve_map()`.
- The session journal shows the crash in the Web Shortcuts runner thread, for
  example:

  ```text
  krunner_webshor[...]: segfault ... in ld-linux-x86-64.so.2
  plasma-krunner.service: Main process exited, code=dumped, status=11/SEGV
  ```

- The crash often follows a Plasma theme/shell restart by a few seconds.
- KRunner restarts automatically, so the desktop keeps working.

## Root cause

KRunner's `WebshortcutRunner::loadSyntaxes()` calls into `KUriFilter`, which
loads the URI filter plugins (`fixhosturifilter`, `kuriikwsfilter`, …) and
reparses KConfig state. When this runs while the Plasma theme/configuration has
just changed, it can dereference state that is being reloaded and crash. The
faulting frames vary between reports (KConfig, QtCore, libc, the dynamic
loader), which is expected for this class of race/use of stale state.

Nothing in the Quick Settings codebase is in the faulting stack. The crash
occurs in a separate process and would also happen when switching themes from
System Settings, Koi itself, or Koi's scheduler.

## How Quick Settings is involved

The main view's Appearance card is a convenience trigger:

1. `AppearanceCard` is activated in `MainView.qml`.
2. `MainView` calls `KoiController.applyLightMode()` or
   `KoiController.applyDarkMode()`.
3. `KoiController` sends `goLightMode` / `goDarkMode` to Koi over D-Bus.
4. Koi switches the Plasma color scheme/theme.
5. KRunner's Web Shortcuts runner reloads KIO state and hits the KDE bug.

So the widget only requests a theme change; the crash is in KRunner's handling
of that change.

## Confirm the diagnosis

```bash
# Recent crash report (title, signal, command line)
ls -lt /var/crash | head
grep -aE '^(Title|Signal|ProcCmdline):' /var/crash/_usr_bin_krunner.*.crash

# Crash in the Web Shortcuts runner around the theme change
journalctl --since "-1 hour" | grep -iE 'krunner|segfault|plasmashell'
```

If the same crash appears after switching the theme from System Settings or by
running `koi`, the widget is not required to reproduce it.

## Workarounds

1. Disable the Web Shortcuts runner in KRunner (it is only needed for keyword
   searches such as `g foo`):

   ```bash
   kwriteconfig6 --file krunnerrc --group Plugins --key webshortcutsEnabled false
   kquitapp6 krunner
   ```

   Re-enable later with `true` and the same restart command.

2. Update `plasma-workspace`, `kio6` and the KF6/KRunner packages when a fixed
   build is available. Track the upstream bug for the fix release.

3. Restart KRunner after theme switches if it has crashed:

   ```bash
   kquitapp6 krunner
   ```

   KRunner is D-Bus activated and starts again on demand.

## References

- KDE bug 514440 — <https://bugs.kde.org/show_bug.cgi?id=514440>
- KRunner runner configuration lives in `~/.config/krunnerrc`.
- Koi: <https://github.com/baduhai/Koi>
