# Mac Manual Setups

## Trackpad

- Enable to click by tap
  1. Go to `System Settings > Trackpad`
  1. Enable `Tap to click`
- Enable to drag by double tap
  1. Go to `System Settings > Accessibility > Pointer Control > Trackpad Options`
  1. Set `Dragging style` to `Without Drag Lock`
     - (about drag lock: <https://apple.stackexchange.com/a/7195>)

## Keyboard

1. Install [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
2. Grant necessary permissions
   - Confirm the status in the `Setup` tab in Karabiner-Elements
3. If your Macbook's keyboard is the JIS layout
   1. Go to `Virtual Keyboard`
   2. Select `ANSI` to use the keyboard as ANSI
      (See [dotfiles/karabiner/README.md][karabiner-readme] for context)
4. Link Karabiner config to `~/.config/karabiner` by running `make link`

[karabiner-readme]: https://github.com/ryym/dotfiles/blob/main/dotfiles/karabiner/README.md

## Japanese Input

1. Install `Google 日本語入力` from <https://www.google.co.jp/ime/>
2. Restart the PC
3. In `System Settings > Keyboard > Input Sources`, add the `Hiragana (Google)` source

## Fonts

- Install `IntoneMono Nerd Font` from <https://www.nerdfonts.com/font-downloads>
  - which is [Intel One Mono](https://github.com/intel/intel-one-mono) + Nerd Font
- Install Japanese font `HackGen` from <https://github.com/yuru7/HackGen>

## Window Management

- Install [Magnet](https://magnet.crowdcafe.com/) from App Store and configure it

## Finder

- To display hidden files (dotfiles)
  - Run `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder` in shell
  - Or press `Command-Shift-.` in Finder (but its effect will be reset on PC restart)
- To display full paths
  - Press `Option-Command-p` (its effect will be persisted)

## Other System Settings

- `Desktop & Dock`
  - Enable `Automatically hide and show the Dock` to widen the screen space
- `Keyboard`
  - Enable `Keyboard navigation` to navigate controls by keys (e.g. tab to move focus)
  - Change `Key repeat rate` and `Delay until repeat` to repeat keys faster
    - `Key Repeat` : `Fast`
    - `Delay Until Repeat ` : `Short` - 1
- `Keyboard > Keyboard Shortcuts > Keyboard`
  - Set `Cmd-Shift-9` to `Move focus to next window` to switch windows of the same app
- `Keyboard > Keyboard Shortcuts > Input Sources`
  - Disable the `Ctrl-Space` shortcut to avoid accidental input sources switching in JIS keyboard
- `Keyboard > Keyboard Shortcuts > Function Keys`
  - Enable `Use F1, F2, etc. keys as standard function keys`
- `General > Sharing`
  - Change `Local hostname` to a shorter name if you want
- `Sound`
  - Disable `Play sound on startup`

### App Switcher

- Show app switcher ( `Cmd+Tab` ) in all displays
  (ref: [https://superuser.com/a/1625752](https://superuser.com/a/1625752))
  ```bash
  defaults write com.apple.Dock appswitcher-all-displays -bool true
  killall Dock
  ```

## Git Credentials

- Follow [dotfiles/git/README.md](https://github.com/ryym/dotfiles/blob/main/dotfiles/git/README.md)

## Appendix: Apps

- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
- [Google 日本語入力](https://www.google.co.jp/ime/)
- [Google Chrome](https://www.google.com/intl/ja/chrome/)
- [Magnet](https://magnet.crowdcafe.com/)
- [Raycast](https://www.raycast.com/)
- [Ghostty](https://ghostty.org/)
