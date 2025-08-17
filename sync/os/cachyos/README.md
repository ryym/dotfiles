# About CachyOS

- Official guide: <https://wiki.cachyos.org/>

# Installation

## Select locale matching language

If you use English as the system language, make sure to change the locale to `en_US.UTF-8` as well.
By default the locale is set to JP and probably due to that, keyboard layout is sometines wrongly detected as JIS keyboard.
You can also change it after installation via the `localectl` command.

- Run `localectl status` to check the current locale.
- Fix locale variables like `sudo localectlctl set-locale LC_ADDRESS=en_US.UTF-8`.
