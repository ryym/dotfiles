# Fedora Official Guides

- https://fedoraproject.org/workstation/
- https://docs.fedoraproject.org/en-US/docs/

# Before synchronizing dotfiles

You have to install them to run the scripts.

- git
- make

# GNOME setup

## Change the hotkey for the overview screen

1. Clear 'Super_L' from the overlay key setting.
    ```
    gsettings set org.gnome.mutter overlay-key ''
    ```
2. Open the shortcuts in Settings, find `Show the overview` and change it.

## Install Tiling Assistant

<https://extensions.gnome.org/extension/3733/tiling-assistant/>

## Input Methods

Configuration using ibus-mozc:

1. In the Settings app, open `Keyboard`
2. Add `Japanese (Mozc:A_)` at the top of `Input Sources`

Mozc allows us to switch A/あ internally with 英数 and かな keys like Mac's JIS keyboard.
