#!/usr/bin/env bash

has_env() {
    local env=$1
    if $ANYENV envs | grep $env >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

has_version() {
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
        log_info "$env: Installing $(c_magenta $version)..."
        $env install $version | log
    fi
}

set_global_version() {
    local env=$1
    local version=$2
    log_info "$env: Set global version to $(c_magenta $version)"
    $env global $version | log
    $env rehash
}
