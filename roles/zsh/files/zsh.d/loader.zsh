#!/usr/bin/env zsh
# ZSH Configuration Loader
# Loads all config files from numbered directories in order

local zsh_d="${0:h}"

# Enable nullglob to avoid errors when no matches found
setopt nullglob

# Load numbered directories in sequence (00, 10, 20, etc.)
for dir in "$zsh_d"/[0-9]*(/N); do
    # Load all config files recursively from each directory
    for file in "$dir"/**/*.conf "$dir"/**/*.sh "$dir"/**/*.zsh "$dir"/**/*.env; do
        if [[ -r "$file" ]]; then
            if [[ "$file" == *.env ]]; then
                # .env files: source with allexport enabled
                set -o allexport
                source "$file"
                set +o allexport
            else
                # All other files: source normally
                source "$file"
            fi
        fi
    done
done

# Disable nullglob after use
unsetopt nullglob
