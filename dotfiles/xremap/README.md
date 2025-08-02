# Key binding strategy

In macOS, some shortcuts using the `Ctrl` key, so-called Emacs key bindings, work across applications.
For example:

- Ctrl-a ... Move the cursor to the beginning of the line.
- Ctrl-e ... Move the cursor to the end of the line.
- Ctrl-k ... Delete characters after the cursor.
- etc

Such a consistent behavior is very useful. But in Linux (and Windows), these key bindings work only in terminals.
That's why I make them work in any applications in Linux as well by remapping keys.

## Current remapping method

1. Map `Ctrl-*` shortcuts to the keys that have the same functionality in Linux.
    - Ctrl-a -> Home
    - Ctrl-e -> End
    - Ctrl-k -> Shift-End, Delete
    - etc
1. In terminal emulators, remap those keys (Home, End, etc) again to restore the original behaviors.

In Linux, standard navigation keys such as Home, End, Arrow keys, etc, provide expected functionality in most applications.
However, they don't work in terminals by default, in contrast of the `Ctrl` shortcuts.
Therefore, we need to _map them back_ to their original behaviors in terminals.
Fortunately, major terminal emulators allow such customization of key bindings. Examples:

- Alacritty provides [`chars` mapping](<https://alacritty.org/config-alacritty.html#keyboard>)
- Kitty provides [`send_key`](<https://sw.kovidgoyal.net/kitty/actions/#action-send_key>)
- Foot provides [`text-bindings`](<https://codeberg.org/dnkl/foot/src/commit/42f78b7f9c755d5fa7e04f0cbbbf88c58dabd44d/foot.ini#L240>)
- etc

That is how I realize the consistent `Ctrl` shortcuts across applications in Lnux.

Note that shells also provide their own key binding mechanisms, such as [`bindkey`](https://linux.die.net/man/1/zshzle) in Zsh.
These mechanisms allow key remapping independently of terminal emulator features.
However, shell-level key remapping cannot modify key behavior in applications running within the shell, such as Vim and fzf.
That limitation is why I prefer configuring key bindings at the terminal emulator level rather than the shell level.

## Alternative approach

The problem I wrote above can be solved by simply using per-application key bindings [Xremap] provides.
With that feature, it is possible to use `Ctrl` shortcuts on any applications other than terminals:

[Xremap]: https://github.com/xremap/xremap

```yml
application:
  not: [Xterm, Alacritty]
remap:
  Ctrl-a: Home
  Ctrl-e: End
  # ...
```

Actually I had used this approach first, but stopped after a while. The reason is Xremap's instability like below:

- It works most of the time, but some key mappings occasionally fail to work as expected.
- Some key mappings doesn't work on [Hyprland] most of the time, even if I use Xremap built with the `--features hypr` flag.
- It sometimes breaks my key inputs if I enter keys during its initialization.
    - It seems to occur when I enter keys during it grabs the keyboard device.

[Hyprland]: https://hyprland.org/

While I haven't thoroughly investigated these issues,
I decided to have an alternative approach that reduces dependency on Xremap.

I may back to the Xremap-centered approach in the future, but for now I'm using the terminal-level configration described above.
While I still use Xremap, I've eliminated application-specific key mappings.
That would make it easier to switch to another key remapping software if necessary.
