#!/usr/bin/env bash

# A simple test script. This just checks if:
#   - all the dotfiles to be linked exist
#   - all installation bash scripts are not broken
# So the test success doesn't mean the installations work correctly
# on every platforms.

link/check_dotfiles

for ospath in sync/os/*; do
    OS=${ospath##*/} make dryrun-install
    echo
done
