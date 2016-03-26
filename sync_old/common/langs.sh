#!/usr/bin/env bash

ANYENV_PATH=~/.anyenv
ANYENV="$ANYENV_PATH/bin/anyenv"

echo 'Install anyenv'
git clone https://github.com/riywo/anyenv "$ANYENV_PATH"
eval "$($ANYENV init -)"

$ANYENV install ndenv
$ANYENV install rbenv
$ANYENV install goenv
$ANYENV install jenv

# NOTE: $PATHにndenvなどを通す。なので、何度も実行しちゃだめ
eval "$($ANYENV init -)"

ndenv install 4.3.0
ndenv global 4.3.0

goenv install 1.5
goenv global 1.5

export GOPATH=$HOME/.go  # XXX: Where should it be?

# and others

