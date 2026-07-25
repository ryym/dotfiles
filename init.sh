#!/usr/bin/env bash

if ! $(which __dot_bin_enabled >/dev/null 2>&1); then
    PATH="$DOTPATH/bin:$PATH"
fi

export DOTPATH=${DOTPATH:-$HOME/.dotfiles}

export GOPATH=$HOME/ghq

export MISE_EXE_PATH="$HOME/.local/bin/mise"
export MISE_CONFIG_PATH="$HOME/.config/mise"
