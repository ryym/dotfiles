# ZSHRC
# man zsh

export LANG=en_US.UTF-8

bindkey -e # Like Emacs.

autoload -Uz colors
colors

autoload -U compinit
compinit

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# Histories
HISTFILE=~/.zsh_history
HISTSIZE=500000 # メモリにロードされる件数(検索できる)
SAVEHIST=500000 # $HISTFILEに保存される件数

# History searching
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

setopt hist_ignore_dups
setopt share_history

# Options

setopt auto_cd
setopt auto_pushd

setopt correct
setopt list_packed
setopt nolistbeep

unsetopt nomatch

# Aliases
alias ls='ls -GF'
alias ll='ls -lGF'
alias la='ls -laGF'
alias g='git'
alias reload='source ~/.zshrc'

export JAVA_HOME=$(/usr/libexec/java_home)

PATH=/usr/local/bin/:$PATH
PATH=~/rubygems/bin/:$PATH

eval "$(rbenv init - zsh)"

# mkdir & cd
mkcd()
{
    mkdir -p "$1"
    cd "$1"
}

# Load local settings.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
