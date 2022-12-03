#!/usr/bin/env bash

prepare_variables() {
    local link="$1"
    local head="${link%%:*}"

    if [ "$head" == '!sudo' ]; then
        link="${link#*:}"
        sudo=true
    else
        sudo=false
    fi

    dotfile="${link#*:}"
    srcpath="$DOTPATH/dotfiles/${link%%:*}"
    case "$dotfile" in
        /*) destpath="$dotfile" ;;
        *) destpath="$HOME/$dotfile" ;;
    esac
}

dotfile_type() {
    case "$1" in
        *.service) echo 'systemd' ;;
        *) echo 'normal' ;;
    esac
}
