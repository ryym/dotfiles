#!/usr/bin/env zsh

export FZF_DEFAULT_OPTS=$(
    fzf_options=(
        '--ignore-case'
        '--cycle'
        # Styles
        '--layout=reverse'
        '--ansi'
        '--highlight-line'
        "--prompt='❯ '"
        '--color=current-bg:#3d484d,pointer:#e67e80,marker:#d699b6,gutter:-1'
        # Key bindings
        '--bind=ctrl-k:kill-line'
        '--bind=ctrl-d:half-page-down'
        '--bind=ctrl-u:half-page-up'
        '--bind=ctrl-/:toggle-preview'
        '--bind=alt-k:preview-up'
        '--bind=alt-j:preview-down'
        '--bind=alt-h:preview-half-page-up'
        '--bind=alt-l:preview-half-page-down'
        '--bind=alt-up:preview-top'
        '--bind=alt-down:preview-bottom'
        '--bind=alt-/:toggle-wrap'
    )
    echo "${fzf_options[@]}"
)



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

function _list_ghq_sources() {
    local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N _list_ghq_sources
bindkey '^]' _list_ghq_sources
