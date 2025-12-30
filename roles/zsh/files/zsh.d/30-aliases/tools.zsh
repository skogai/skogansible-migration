#!/usr/bin/env zsh
command -v lazygit &>/dev/null && { alias lg='lazygit'; alias lzg='lazygit'; }
command -v lazydocker &>/dev/null && { alias lzd='lazydocker'; alias ld='lazydocker'; }

if command -v delta &>/dev/null; then
    export GIT_PAGER='delta'
    export DELTA_PAGER='less -R'
fi

[[ -f "$HOME/.config/broot/launcher/bash/br" ]] && source "$HOME/.config/broot/launcher/bash/br"

command -v procs &>/dev/null && { alias ps='procs'; alias pst='procs --tree'; alias psw='procs --watch'; }
command -v hexyl &>/dev/null && { alias hex='hexyl'; alias hexdump='hexyl'; }
command -v chafa &>/dev/null && { alias img='chafa'; alias image='chafa'; }
command -v rg &>/dev/null && { alias rgi='rg -i'; alias rgl='rg -l'; alias rgv='rg -v'; }
command -v fd &>/dev/null && { alias fdi='fd -i'; alias fdh='fd -H'; }

if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
    alias catp='bat'
    export BAT_THEME="base16-256"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

command -v tilt &>/dev/null && { alias tu='tilt up'; alias td='tilt down'; }
command -v zellij &>/dev/null && { alias zj='zellij'; alias zja='zellij attach'; alias zjs='zellij session'; alias zjl='zellij list-sessions'; }
command -v ast-grep &>/dev/null && { alias sg='ast-grep'; alias sgs='ast-grep search'; alias sgr='ast-grep replace'; }

if command -v uv &>/dev/null; then
    alias uvs='uv sync'
    alias uvi='uv pip install'
    alias uvr='uv run'
    alias uvv='uv venv'
fi

alias tm='task-master'
alias taskmaster='task-master'
alias hamster='task-master'
alias ham='task-master'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
