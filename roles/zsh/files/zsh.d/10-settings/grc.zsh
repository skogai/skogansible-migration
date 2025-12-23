(( $+commands[grc] )) || return 0
[[ -o interactive ]] || return 0
[[ -n "$TERM" && "$TERM" != "dumb" ]] || return 0

local _grc_prefix
[[ -d "/opt/homebrew" ]] && _grc_prefix="/opt/homebrew" || \
[[ -d "/usr/local/Homebrew" ]] && _grc_prefix="/usr/local" || return 0

local _grc_zsh="${_grc_prefix}/etc/grc.zsh"
if [[ -f "$_grc_zsh" ]]; then
    source "$_grc_zsh"
    unfunction cat ps ls diff 2>/dev/null
fi
