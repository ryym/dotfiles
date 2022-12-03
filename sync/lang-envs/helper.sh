#!/usr/bin/env bash

has_env() {
    if is_dryrun; then
        return 1
    fi

    local env=$1
    if $ANYENV envs | grep $env >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

has_version() {
    if is_dryrun; then
        return 1
    fi

    local env=$1
    local version=$2
    if $env versions | grep $version >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

install_version() {
    local env=$1
    local version=$2
    if ! has_version $env $version; then
        run $env install $version
    fi
}

set_global_version() {
    local env=$1
    local version=$2
    run $env global $version
    run $env rehash
}
