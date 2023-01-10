# Dotfiles

[![CircleCI][circleci-badge]](https://circleci.com/gh/ryym/dotfiles)

[circleci-badge]: https://circleci.com/gh/ryym/dotfiles.svg?style=svg

This repository manages:

* my configuration files for some basic development tools I usually use ([dotfiles]).
* the installation scripts of them ([sync]).

[dotfiles]: dotfiles
[sync]: sync

## Supported OS

* macOS
* Arch Linux

## Prerequisites

* [Git] - to download and update this repository.
* [Bash] - to run install scripts written in Bash.
* Package manager - to install basic libraries for your OS. You can use:
    * [Homebrew][Homebrew] (macOS)
    * [pacman][pacman] (Arch Linux)

[Git]: https://git-scm.com/
[Bash]: https://www.gnu.org/software/bash/
[Homebrew]: http://brew.sh/
[pacman]: https://wiki.archlinux.org/title/pacman

## Installation

```sh
git clone https://github.com/ryym/dotfiles ~/.dotfiles
cd ~/.dotfiles && make
```

## Available tasks

You can use [make] to sync your local environment with this repository.
And you can re-run these tasks anytime to re-sync the environment.

[make]: https://www.gnu.org/software/make/

```sh
# Run default task (make install link).
make

# Install tools.
make install
```

| Task | Description |
| ---- | ----------- |
| dryrun | Show install commands without executing them. |
| install | Install development tools. |
| link | Create symbolic links of the configuration files in your directory. |
| unlink | Remove symbolic links created by the link task. |

## Inspiration

* [b4b4r07/dotfiles](https://github.com/b4b4r07/dotfiles)
* [creasty/dotfiles](https://github.com/creasty/dotfiles)
* [cowboy/dotfiles](https://github.com/cowboy/dotfiles)
