#!/usr/bin/env zsh
alias commit='aider --commit --model openrouter/google/gemini-2.5-flash --no-gitignore'
# alias gemini='node /home/skogix/.local/src/gemini-cli/scripts/start.js'
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
alias wts='wt select'
