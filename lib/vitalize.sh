#!/usr/bin/env bash

# Define some generic utility functions and commands.
# Note that this script adds '$DOTPATH/bin' to the '$PATH'
# automatically if it isn't in the '$PATH'.

if ! $(which __dot_bin_enabled) >/dev/null 2>&1; then
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

# Detect OS type
ostype() {
    if test $(uname) == 'Darwin'; then
        echo 'macos'
    elif test -f /etc/arch-release; then
        echo 'arch'
    elif test -f /etc/debian_version; then
        echo 'debian'
    elif test -f /etc/centos-release; then
        echo 'centos'
    fi
}

deffunc() {
    eval "$1() {
        $2
    }"
}

# Define functions that format and colorize a text.
# Example:
#   echo $(c_red $(c_bold ERROR:)) $(c_line An error is occured!)
#
# Reference of escape sequences:
#   http://misc.flogisoft.com/bash/tip_colors_and_formatting
texteffects=(
    'bold:1'
    'line:4'
    'black:30'
    'red:31'
    'green:32'
    'yellow:33'
    'blue:34'
    'magenta:35'
    'cyan:36'
    'grey:37'
    'white:97'
)
for color in ${texteffects[@]}; do
    colorname=${color%%:*}
    fgcode=${color#*:}
    bgcode=$(($fgcode + 10))

    deffunc "c_$colorname" "
        printf \"\\033[${fgcode}m\$1\\033[0m\"
    "

    deffunc "c_bg_$colorname" "
        printf \"\\033[${bgcode}m\$1\\033[0m\"
    "
done
unset texteffects colorname fgcode bgcode
