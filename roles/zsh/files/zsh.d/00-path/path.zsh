# PATH Configuration
# Sets up executable search paths
# Loaded first (00-*) to ensure paths are available to other modules

# User-specific binaries
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Programming language toolchains
export PATH="$HOME/.cargo/bin:$PATH"              # Rust
export PATH="$GOPATH/bin:$PATH"                   # Go
export PATH="$HOME/.local/share/pnpm:$PATH"       # Node/pnpm

# Custom tools
export PATH="$HOME/.opencode/bin:$PATH"           # OpenCode tools
