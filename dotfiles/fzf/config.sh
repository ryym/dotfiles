#!/usr/bin/env zsh

export FZF_DEFAULT_OPTS="
    --ignore-case
    --cycle
    --reverse
    --ansi
    --highlight-line
    --prompt='❯ '
    --color=current-bg:#3d484d,pointer:#e67e80,marker:#d699b6,gutter:-1
    --bind=ctrl-k:kill-line
    --bind=ctrl-d:half-page-down
    --bind=ctrl-u:half-page-up
    --bind=ctrl-/:toggle-preview
    --bind=alt-k:preview-up
    --bind=alt-j:preview-down
    --bind=alt-h:preview-half-page-up
    --bind=alt-l:preview-half-page-down
    --bind=alt-up:preview-top
    --bind=alt-down:preview-bottom
    --bind=alt-/:toggle-wrap
"

# Make fzf super faster
# - https://github.com/junegunn/fzf#respecting-gitignore
# - https://github.com/sharkdp/fd
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"

function _search_history_by_fzf() {
    local result=$(
        # List the history in the reversed order.
        history -n -r 1 |
        # Filter the history by the current input.
        fzf --height 40% --query "$LBUFFER" --exact --scheme=history --expect=tab
    )
    if [[ -n $result ]]; then
        local key=$(echo "$result" | head -1)
        local selected=$(echo "$result" | tail -1)
        BUFFER="$selected"
        CURSOR=$#BUFFER
        if [[ "$key" == "tab" ]]; then
            zle redisplay
        else
            zle redisplay
            zle accept-line
        fi
    else
        zle reset-prompt
    fi
}
zle -N _search_history_by_fzf
bindkey '^r' _search_history_by_fzf

# http://qiita.com/strsk/items/9151cef7e68f0746820d
# http://qiita.com/udzura/items/3f120b5e4733fe85078d
function fzf-src() {
    local selected_dir=$(eval "$1" | fzf --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

function fzf-ghq() {
    fzf-src 'ghq list -p'
}
zle -N fzf-ghq
bindkey '^]' fzf-ghq
bindkey '^g' fzf-ghq
