# ZSHRC
# man zsh

# On My Zsh
if [ -d $HOME/.oh-my-zsh ]; then
    ZSH=$HOME/.oh-my-zsh
    ZSH_CUSTOM=$HOME/.zsh
    plugins=(osx)
    source $ZSH/oh-my-zsh.sh
fi

export LANG=en_US.UTF-8

bindkey -e # Like Emacs.

autoload -Uz colors
colors

autoload -U compinit
compinit

# Use completion with case-insensitivity.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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

# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

setopt hist_ignore_dups
setopt share_history

# Options

setopt auto_cd
setopt auto_pushd

setopt nocorrect
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
PATH=~/.rbenv/bin:$PATH

eval "$(rbenv init - zsh)"

# Go
export GOPATH=$HOME/.go
PATH=$PATH:$GOPATH/bin/

# Node modules
PATH=$PATH:./node_modules/.bin

# mkdir & cd
mkcd()
{
    mkdir -p "$1"
    cd "$1"
}

## Peco

# ghq
# http://qiita.com/strsk/items/9151cef7e68f0746820d
# http://qiita.com/udzura/items/3f120b5e4733fe85078d
function peco-src() {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# Load local settings.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
