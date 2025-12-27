#!/bin/zsh
source "/home/skogix/dev/zsh.d/00-skogai/00-skogai.env"
source "$SKOGAI_SCRIPTS/load_modules.zsh"
source "$SKOGAI_SCRIPTS/log_to_file.zsh"
source "$SKOGAI_SCRIPTS/debug_echo.zsh"

# Set SKOGAI_HOME to ~/skogai if not already set
: ${SKOGAI_HOME:="$HOME/skogai"}
PATH="$SKOGAI_CORE/bin:$HOME/.local/bin:$PATH"
load_modules "$HOME/.config/zsh.d"
