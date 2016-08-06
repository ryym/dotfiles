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

# If $SYNC_DRYRUN has a non-empty value,
# just echo the given command without executing it.
# Note that you need to escape characters in some cases.
# For example, 'run eval $($ANYENV init -)' executes
# '$ANYENV init -' first and passes its output to the 'run' function.
# So if the $ANYENV path doesn't exist it causes an error.
run() {
    local commands="$@"
    local cmd=${commands%% *}
    local args=${commands#* }

    log_info \
        $(c_green $(c_bold RUN:)) \
        $(c_magenta $cmd) \
        $args

    if ! is_dryrun; then
        eval "$@"
    fi
}

is_dryrun() {
    return $(test ! -z ${SYNC_DRYRUN:-''})
}

detect_osname() {
    if is_osx; then
        echo 'osx'
    elif is_debian; then
        echo 'debian'
    elif is_centos; then
        echo 'centos'
    fi
}

is_osx() {
    return $(test $(uname) == 'Darwin')
}

is_debian() {
    return $(test -f /etc/debian_version)
}

is_centos() {
    return $(test -f /etc/centos-release)
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
