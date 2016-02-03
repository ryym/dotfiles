#!/bin/bash

while getopts t opt
do
  case $opt in
    t) readonly DRY_RUN=1
      ;;
  esac
done

# Check if the dotfiles can be linked.
validate() {
  if [ -z "$dotfile" ]; then
    echo "dotfile name is empty." >&2
    exit 1
  fi

  if [ ! -e "$srcfile" ]; then
    echo "$srcfile doesn't exist." >&2
    exit 1
  fi

  if [ -e "$lnkfile" ] && [ ! -L "$lnkfile" ]; then
    echo "$lnkfile exists but is not a symlnk." >&2
    exit 1
  fi
}

# Create or update symbolic links in $HOME.
link_dotfile() {
  ln -nsf "$srcfile" "$lnkfile"
  echo "-- $dotfile is linked. --"
}

# The files to be linked.
dotfiles=(
  '.gitconfig'
  '.ideavimrc'
  '.vimperatorrc'
  '.vim'
  '.zshrc'
  '.tmux.conf'
  '.pryrc'
)

for dotfile in "${dotfiles[@]}"; do
  srcfile=~/dotfiles/$dotfile
  lnkfile=~/$dotfile

  validate && [ ${DRY_RUN:-0} -eq 0 ] && link_dotfile
done
