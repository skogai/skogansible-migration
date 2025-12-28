#
# aichat shell integration (if available)
source "$HOME/.local/src/aichat/scripts/shell-integration/integration.zsh"

export ARGC_COMPLETIONS_ROOT="/home/skogix/.local/src/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/linux:$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
# Generate completion scripts list
argc_scripts=( $(ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions/linux" "$ARGC_COMPLETIONS_ROOT/completions" 2>/dev/null | sed -n 's/\.sh$//p') )
source <(argc --argc-completions zsh $argc_scripts)

# aichat keybinding (Alt+E)
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
bindkey '\ee' _aichat_zsh

# Loads all environment variables managed by skogcli
# To add: skogcli config add skogai.env.VAR_NAME "value"
# To list: skogcli config list --env-only
eval "$(skogcli config export-env --namespace skogai,uv)"
