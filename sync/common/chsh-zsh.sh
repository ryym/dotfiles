#!/usr/bin/env bash

if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH is not set'
    exit 1
fi

source "$DOTPATH/sync/lib/helper.sh"

if ! has zsh; then
    return 1
fi

if [ "${SHELL##*/}" == "zsh" ]; then
    return 1
fi

zsh_path=$(which zsh)

if ! grep -xq "$zsh_path" /etc/shells; then
    echo "Add zsh path ($zsh_path) to /etc/shells"
    sudo echo "$zsh_path" >> /etc/shells
fi

sudo chsh -s "$zsh_path" "${USER:-root}"

