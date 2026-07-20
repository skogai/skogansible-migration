#!/usr/bin/env zsh
# PATH Configuration
# Sets up executable search paths

# User-specific binaries
export PATH="$HOME/.skogai/bin:$HOME/.local/bin:$HOME/bin:$PATH"

# Programming language toolchains
export PATH="/mnt/sda1/cargo/bin:$HOME/.cargo/bin:$PATH"              # Rust
export PATH="$GOPATH/bin:$PATH"                   # Go
export PATH="/mnt/sda1/pnpm:/mnt/sda1/.pnpm:$HOME/.local/share/pnpm:$PATH"       # Node/pnpm
export PATH="/mnt/sda1/bun: $HOME/.bun/bin:$PATH"       # Bun

# Custom tools
export PATH="$HOME/.claude/bin:$PATH"             # Claude Code tools
export PATH="$HOME/.opencode/bin:$PATH"           # OpenCode tools
