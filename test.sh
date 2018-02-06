#!/usr/bin/env bash

# A simple test script. This just checks if:
#   - all the dotfiles to be linked exist
#   - all installation bash scripts are not broken
# So the test success doesn't mean the installations work correctly
# on every platforms.

if ! link/check_dotfiles; then
    exit 1
fi

for ospath in sync/os/*; do
    OS=${ospath##*/} make dryrun-install
    echo
done
