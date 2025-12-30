#!/usr/bin/env zsh
# ZSH Completion System Configuration
# Sets up command completion with custom completion directories

# Add custom completion directories to fpath
# These must be added BEFORE compinit runs
fpath+=~/.config/zsh.d/completions

# Initialize completion system
autoload -Uz compinit
if ! type _compinit &>/dev/null; then
  compinit
fi

# Completion behavior
zstyle ':completion:*' menu select                              # Interactive menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'      # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"        # Colored completion listings
zstyle ':completion:*' group-name ''                            # Group completions by category
zstyle ':completion:*' use-cache true                           # Cache completions
zstyle ':completion:*:default' menu select=1                    # Auto-select first match

# Advanced matching
zstyle ':completion:*' matcher-list '' \
    'm:{a-z}={A-Z}' \
    'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'

# Sudo completion - search all paths
zstyle ':completion:*:sudo:*' command-path \
    /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin \
    /sbin /bin

# Process completion
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# Keep prefix when completing
zstyle ':completion:*' keep-prefix

# Completion strategies in order
zstyle ':completion:*' completer \
    _oldlist _complete _match _ignored _approximate _list _history
