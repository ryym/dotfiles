# Dotfiles

[![Travis][travis-badge]](https://travis-ci.org/ryym/dotfiles)

[travis-badge]: https://travis-ci.org/ryym/dotfiles.svg

This repository manages:

* my configuration files for some basic development tools I usually use ([dotfiles]).
* the installation scripts of them ([sync]).

[dotfiles]: dotfiles
[sync]: sync

## Supported OS

* Mac OSX
* Ubuntu / Debian
* CentOS

## Prerequisites

* [Git] - to download and update this repository.
* [Bash] - to run install scripts written in Bash.
* Package manager - to install basic libraries for your OS. You can use:
    * [Homebrew][Homebrew] (Mac OSX)
    * [APT][APT] (Ubuntu, Debian)
    * [Yum][Yum] (CentOS)

[Git]: https://git-scm.com/
[Bash]: https://www.gnu.org/software/bash/
[Homebrew]: http://brew.sh/
[APT]: https://en.wikipedia.org/wiki/Advanced_Packaging_Tool
[Yum]: http://yum.baseurl.org/

## Installation

```sh
git clone --recursive https://github.com/ryym/dotfiles ~/.dotfiles
cd ~/.dotfiles && make
```

Note that the `--recursive` option is necessary to install with [Git Submodules].

[Git Submodules]: <https://git-scm.com/book/en/v2/Git-Tools-Submodules>

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
| uninstall | Not implemented yet. |
| unlink | Remove symbolic links created by the link task. |

## Inspiration

* [b4b4r07/dotfiles](https://github.com/b4b4r07/dotfiles)
* [creasty/dotfiles](https://github.com/creasty/dotfiles)
* [cowboy/dotfiles](https://github.com/cowboy/dotfiles)
