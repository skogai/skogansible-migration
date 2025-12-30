#!/usr/bin/env zsh
mkcd() {
    [[ -z "$1" ]] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1"
}

extract() {
    [[ -z "$1" ]] && { echo "Usage: extract <archive>"; return 1; }
    [[ ! -f "$1" ]] && { echo "Error: '$1' not a file"; return 1; }

    case "$1" in
        *.tar.bz2)   tar xjf "$1" ;;
        *.tar.gz)    tar xzf "$1" ;;
        *.tar.xz)    tar xJf "$1" ;;
        *.tar.zst)   tar --zstd -xf "$1" ;;
        *.bz2)       bunzip2 "$1" ;;
        *.rar)       command -v unrar &>/dev/null || { echo "Need unrar"; return 1; }; unrar e "$1" ;;
        *.gz)        gunzip "$1" ;;
        *.tar)       tar xf "$1" ;;
        *.tbz2)      tar xjf "$1" ;;
        *.tgz)       tar xzf "$1" ;;
        *.zip)       unzip "$1" ;;
        *.Z)         uncompress "$1" ;;
        *.7z)        command -v 7z &>/dev/null || { echo "Need p7zip"; return 1; }; 7z x "$1" ;;
        *.xz)        xz -d "$1" ;;
        *.zst)       zstd -d "$1" ;;
        *)           echo "Unknown format: $1"; return 1 ;;
    esac
}

hist() {
    [[ -z "$1" ]] && { echo "Usage: hist <term>"; return 1; }
    fc -l 1 | grep "$1"
}

port() {
    [[ -z "$1" ]] && { echo "Usage: port <number>"; return 1; }
    lsof -i :"$1"
}

killport() {
    [[ -z "$1" ]] && { echo "Usage: killport <number>"; return 1; }
    local pids=$(lsof -ti :"$1" 2>/dev/null)
    [[ -z "$pids" ]] && { echo "No process on port $1"; return 0; }
    echo "$pids" | xargs kill -9
    echo "Killed processes on port $1"
}
