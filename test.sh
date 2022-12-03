#!/usr/bin/env bash

# A simple test script. This just checks if:
#   - all the dotfiles to be linked exist
#   - all installation bash scripts are not broken
# So the test success doesn't mean the installations work correctly
# on every platforms.

make test-link
code=$?
test $code -ne 0 && exit $code

for ospath in sync/os/*; do
    OS=${ospath##*/} make dryrun-install
    code=$?
    test $code -ne 0 && exit $code
    echo ''
done
