#!/usr/bin/env zsh
# PATH Configuration
# Sets up executable search paths

# User-specific binaries
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Programming language toolchains
export PATH="$HOME/.cargo/bin:$PATH"              # Rust
export PATH="$GOPATH/bin:$PATH"                   # Go
export PATH="$HOME/.local/share/pnpm:$PATH"       # Node/pnpm
export PATH="$HOME/.bun/bin:$PATH"       # Bun

# Custom tools
export PATH="$HOME/.claude/bin:$PATH"             # Claude Code tools
export PATH="$HOME/.opencode/bin:$PATH"           # OpenCode tools
