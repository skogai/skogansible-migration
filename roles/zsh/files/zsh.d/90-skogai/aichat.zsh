#!/usr/bin/env zsh
[[ -f "$HOME/.local/src/aichat/scripts/shell-integration/integration.zsh" ]] && \
    source "$HOME/.local/src/aichat/scripts/shell-integration/integration.zsh"

# Loop through all files in the ~/.config/fabric/patterns directory
for pattern_file in $HOME/.config/fabric/patterns/*; do
    # Get the base name of the file (i.e., remove the directory path)
    pattern_name=$(basename "$pattern_file")

    # Create an alias in the form: alias pattern_name="fabric --pattern pattern_name"
    alias_command="alias $pattern_name='fabric --pattern $pattern_name'"

    # Evaluate the alias command to add it to the current shell
    eval "$alias_command"
done

yt() {
    local video_link="$1"
    fabric -y "$video_link" --transcript --dry-run
}

_aichat_zsh() {
    if [[ -n "$BUFFER" ]]; then
        local _old=$BUFFER
        BUFFER+="⌛"
        zle -I && zle redisplay
        BUFFER=$(aichat -e "$_old")
        zle end-of-line
    fi
}
zle -N _aichat_zsh
bindkey '^s' _aichat_zsh
# zle -N _sgpt_zsh
# bindkey ^l _sgpt_zsh

