## OS Installation

- Official guide: <https://wiki.archlinux.org/title/installation_guide>
- Disk partitioning and bootloader settings: <https://itsfoss.com/install-arch-linux/>

## Configure touchpad

```
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag true
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.018
```

## Set up GNOME shell extension

To manage extentions in browser, you need to install this AUR package:
<https://aur.archlinux.org/packages/gnome-browser-connector>

If installation fails, you may use [`gnome-shell-extension-installer`][0] CLI tool instead.

[0]: github.com/brunelli/gnome-shell-extension-installer
