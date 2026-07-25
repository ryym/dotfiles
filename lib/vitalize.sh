#!/usr/bin/env bash

# Define some generic utility functions and commands.
# Note that this script adds '$DOTPATH/bin' to the '$PATH'
# automatically if it isn't in the '$PATH'.

if ! $(which __dot_bin_enabled >/dev/null 2>&1); then
    PATH="$DOTPATH/bin:$PATH"
fi

source "$DOTPATH/CONST.sh"

# mkdir & cd
mkcd() {
    mkdir -p "$1"
    cd "$1"
}

# Go to dotfiles quickly
dot() {
    cd ~/.dotfiles
}

# Go to .config quickly
dotc() {
    cd ~/.config
}
