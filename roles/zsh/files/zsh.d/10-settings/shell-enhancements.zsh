#!/usr/bin/env zsh
local cache_dir="${HOME}/.cache/zsh/hooks"

if command -v zoxide &>/dev/null; then
    local cache_file="${cache_dir}/zoxide.zsh"
    local tool_path="$(command -v zoxide)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        zoxide init zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
    alias cdi='zi'
fi

if command -v atuin &>/dev/null; then
    local cache_file="${cache_dir}/atuin.zsh"
    local tool_path="$(command -v atuin)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        atuin init zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
fi

