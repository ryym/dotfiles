Fcitx5 is an input method framework and an essential tool for Japanese input.
The configuration files in this directory were created via `fcitx5-config-tool` GUI app.

## Input Method configuration

First, open the Fcitx5 config and set these input methods in this order:

- Keyboard - English (US)
- Mozc

Next, in the Global Options tab, register these hotkeys:

- For `Activate Input Method`, set a key for enabling Japanese input (かな)
- For `Deactivate Input Method`, set a key for enabling English input (英数)

By this, we can switch IME statelessly in the same way as macOS.
You should also remove some hotkeys you may press unintentionally.

### Remove unwanted default hotkeys

The `Keyboard - English (US)` has several hotkeys I always use for other purposes. Remove these hotkeys.

- Ctrl+Alt+H
- Ctrl+Alt+J

## Additional configuration

In some apps on X11, the input text is not displayed until the IME conversion is comitted.
To fix this, follow these steps:

1. Open `fcitx5-config-tool`
2. Open the `Addons` tab
3. Open the configuration of `X Input Method Frontend`
4. Check `Use On The Spot Style (Needs restarting)`
