#!/usre/bin/env bash
export GOOSE_SESSION_ID="20251231_4"
alias @goose='/home/skogix/.local/bin/goose term run'
alias @g='/home/skogix/.local/bin/goose term run'

goose_preexec() {{
    [[ "$1" =~ ^goose\ term ]] && return
    [[ "$1" =~ ^(@goose|@g)($|[[:space:]]) ]] && return
    ('/home/skogix/.local/bin/goose' term log "$1" &) 2>/dev/null
}}

autoload -Uz add-zsh-hook
add-zsh-hook preexec goose_preexec
