# Mac manual setups

Though there are some customizations and installations that can be automated, it is okey to do it manually since once you do them, it's done.

## System Settings

- Change system language to English
- Trackpad
    - Check `Tap to click`
    - Drag by Double tap
        - Accessibility > Pointer Control > Trackpad Options
        - Check `Enable dragging` and select `with drag lock`
            - about drag lock: <https://apple.stackexchange.com/a/7195>
- Finder
    - Show home directory in sidebar
    - Show file extensions
    - Show hidden files (dotfiles)
- Display
    - Uncheck `Automatically adjust brightness`
- Menu Bar
    - Show Bluetooth
- Dock
    - Make it hide automatically
    - Make it small
    - Remove unused apps
- Switch windows in same app by `Cmd+Shift+9`
    - Change `Move focus to next window` shortcut
- Navigate controls using Tab and Space 
    - Check `Use keyboard navigation to move focus between controls`
- Disable `Ctrl+Space` shortcut for input sources switching (JIS keyboard only)
    - Keyboard > Shortcuts > Input Source
- Use function keys as function keys
    - Check `Use F1, F2, etc. keys as standard function keys`
- Make key repeat faster
    - `Key Repeat` : `Fast`
    - `Delay Until Repeat ` : one before `Short`
- Show app switcher ( `Cmd+Tab` ) in all displays
    - [https://superuser.com/a/1625752](https://superuser.com/a/1625752)
    ```
    defaults write com.apple.Dock appswitcher-all-displays -bool true
    killall Dock
    ```

## Apps

Install them:

- Alfred
- Discord
- Docker for Mac
- Firefox
- Google 日本語入力
    - `¥` -> `\`
- Google Chrome
- Google Chrome Canary
- Karabiner
- LINE
- MacVim
- Magnet
    - [Key bindings](https://www.dropbox.com/s/htasvrp75bc9kbg/magnet-keys.png?dl=0)
- Skitch
- Slack
- Visual Studio Code

## Keyboard

- Let macOS recognize your JIS keyboard as ANSI (JIS keyboard only)
- Customize some key bindings using Karabiner
    - After installation, put configuration files in `./Karabiner/` into Karabiner's config directory:
    ```
    $HOME/.config/karabiner/assets/complex_modifications
    ```
About my favorite keyboard configuration: <https://ryym.tokyo/posts/ideal-keyboard/>

## Credentials

- Recreate SSH keys or copy from old PC
- Import GPG key
    - How to import: <https://makandracards.com/makandra-orga/37763-gpg-extract-private-key-and-import-on-different-machine>
        - `gpg --list-secret-keys user@example.com`
        - `gpg --export-secret-keys ID > private.key`
        - `gpg --import private.key`
    - Trust my key ultimately: <https://unix.stackexchange.com/a/407070>
        - `gpg --edit-key user@example.com`
        - `> trust`

## Others

- Rename PC hostname
- Change user full name



