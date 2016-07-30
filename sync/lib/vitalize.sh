#!/usr/bin/env bash

# Load basic utilities.
source "$DOTPATH/lib/vitalize.sh"

DOTFILES_LOGO='
==============================================
----------------------------------------------
        _       _    __ _ _
     __| | ___ | |_ / _(.) | ___  ___
    / _` |/ _ \| __| |_| | |/ \ \/ __|
   | (_| | (_) | |_|  _| | |  __/\__ \
    \..,.|\.../ \..|.| |.|.|\...||.../
                                       @ryym

         github.com/ryym/dotfiles
==============================================
'

# Source the specified file from $DOTPATH/sync.
load() {
    source "$DOTPATH/sync/$1"
}

detect_osname() {
    if is_osx; then
        echo 'osx'
    elif is_debian; then
        echo 'debian'
    fi
}

is_osx() {
    return $(test $(uname) == 'Darwin')
}

is_debian() {
    return $(test -f /etc/debian_version)
}

log_info() {
    echo [$(c_grey $(date '+%T'))] "$@"
}

log_success() {
    log_info "$(c_green "$@")"
}

log_warn() {
    log_info "$(c_yellow "$@")"
}

log_error() {
    log_info "$(c_red "$@")"
}

log_start() {
    log_info ">> START: $(c_cyan "$1")"
}

log_finish() {
    log_info "<< FINISH: $(c_cyan "$1")"
}
