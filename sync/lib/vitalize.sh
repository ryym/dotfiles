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
    source "$DOTPATH/sync/$1" "${@:2}"
}

# Run given commands or just echo them on dryrun mode.
# Note that you need to escape characters in some cases.
# For example, 'run eval $(rbenv init -)' executes
# 'rbenv init -' first and passes its output to the 'run' function.
# So if the rbenv path doesn't exist it causes an error.
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
    return $(test ! -z ${DOTFILES_DRYRUN:-''})
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
