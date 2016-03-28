#!/usr/bin/env bash

# Load basic utilities.
source "$DOTPATH/lib/vitalize.sh"

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

log() {
    cat - >> "$SYNCLOG"
}

teelog() {
    cat - | tee -a "$SYNCLOG"
}
