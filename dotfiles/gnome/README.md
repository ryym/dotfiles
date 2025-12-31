# Miscellaneous GNOME setups

## Change the hotkey for the overview screen (app launcher)

1. Clear 'Super_L' from the overlay key setting.
   ```
   gsettings set org.gnome.mutter overlay-key ''
   ```
2. Open the shortcuts in Settings, find `Show the overview` and change it.

## Set up input methods like macOS

Install `ibus-mozc` and configure it.

1. In the Settings app, open `Keyboard`.
2. Add `Japanese (Mozc:A_)` at the top of `Input Sources`.

Mozc allows you to switch A/あ internally with 英数 and かな keys like Mac's JIS keyboard.

## Configure touchpad

If your GNOME Settings app does not have options for touchpad:

```
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag true
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.018
```

## Back/Forward history by two-finger swipe in Chrome

To do that, you need to launch Chrome with the command line flag.

1. Do `cp /usr/share/applications/google-chrome.desktop ~/.local/share/applications/google-chrome.desktop`.
2. Edit the copied file and add `--enable-features=TouchpadOverscrollHistoryNavigation` to all `google-chrome` in each `Exec` line.
3. Reboot

## Favorite extensions

### Install Tiling Assistant

<https://extensions.gnome.org/extension/3733/tiling-assistant/>
