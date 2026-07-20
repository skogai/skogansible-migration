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
        atuin init zsh --disable-ctrl-r --disable-up-arrow > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
fi

if [[ -o interactive ]] && command -v starship &>/dev/null; then
    local cache_dir="${HOME}/.cache/zsh/hooks"
    local cache_file="${cache_dir}/starship.zsh"
    local tool_path="$(command -v starship)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        starship init zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
fi

if command -v mise &>/dev/null; then
    local cache_file="${cache_dir}/mise.zsh"
    local tool_path="$(command -v mise)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        mise activate zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
fi

if command -v amq &>/dev/null; then
    local cache_file="${cache_dir}/amq.zsh"
    local tool_path="$(command -v amq)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        amq shell-setup --shell zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
    alias cdi='zi'
fi

if command -v cps &>/dev/null; then
    local cache_file="${cache_dir}/cps.zsh"
    local tool_path="$(command -v cps)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        cps shell-init > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
    alias cdi='zi'
fi

if command -v wt &>/dev/null; then
    local cache_file="${cache_dir}/wt.zsh"
    local tool_path="$(command -v wt)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        wt config shell init zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
    alias cdi='zi'
fi
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

if command -v direnv &>/dev/null; then
    local cache_file="${cache_dir}/direnv.zsh"
    local tool_path="$(command -v direnv)"
    if [[ ! -f "$cache_file" ]] || [[ "$tool_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        direnv hook zsh > "$cache_file" 2>/dev/null
    fi
    [[ -f "$cache_file" ]] && source "$cache_file"
    alias cdi='zi'
fi
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
