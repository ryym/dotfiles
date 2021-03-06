#!/usr/bin/env bash

# I created this file by `anyenv init -zsh > anyenv-init.sh`.
# And I commented out `rbenv rehash` and `nodenv rehash` because
# they are so slow and unnecessary (I think).

source "$HOME/.anyenv/libexec/../completions/anyenv.zsh"
anyenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi
  command anyenv "$command" "$@"
}
export NODENV_ROOT="$HOME/.anyenv/envs/nodenv"
export PATH="$HOME/.anyenv/envs/nodenv/bin:$PATH"
export PATH="$HOME/.anyenv/envs/nodenv/shims:${PATH}"
export NODENV_SHELL=zsh
source "$HOME/.anyenv/envs/nodenv/libexec/../completions/nodenv.zsh"
# (command nodenv rehash 2>/dev/null &)
nodenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(nodenv "sh-$command" "$@")";;
  *)
    command nodenv "$command" "$@";;
  esac
}
export PYENV_ROOT="$HOME/.anyenv/envs/pyenv"
export PATH="$HOME/.anyenv/envs/pyenv/bin:$PATH"
export PATH="$HOME/.anyenv/envs/pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
source "$HOME/.anyenv/envs/pyenv/libexec/../completions/pyenv.zsh"
# (command pyenv rehash 2>/dev/null &)
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}

export RBENV_ROOT="$HOME/.anyenv/envs/rbenv"
export PATH="$HOME/.anyenv/envs/rbenv/bin:$PATH"
export PATH="$HOME/.anyenv/envs/rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source "$HOME/.anyenv/envs/rbenv/libexec/../completions/rbenv.zsh"
# (command rbenv rehash 2>/dev/null &)
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}
