#!/bin/zsh

# Load debug_echo function
source "$SKOGAI_HOME/zsh.d/000-skogai.zsh"

# Ensure Zsh completion system is initialized
if ! type compdef &>/dev/null; then
  autoload -Uz compinit
  compinit
fi

# Run all .zsh files in the tests directory, excluding this script
for script in .skogai/tests/*.zsh; do
  if [ -f "$script" ] && [ "$script" != "$0" ]; then
    debug_echo "TEST" "Running $script"
    zsh -c 'autoload -Uz compinit && compinit; source "$0"' "$script"
  fi
done

# Run all .sh files in the tests directory
for script in .skogai/tests/*.sh; do
  if [ -f "$script" ]; then
    debug_echo "INFO" "Running $script"
    zsh -c 'autoload -Uz compinit && compinit; source "$0"' "$script"
  fi
done

# Run pytest for all .py files in the tests directory
if ls .skogai/tests/*.py 1>/dev/null 2>&1; then
  debug_echo "TEST" "Running pytest"
  pytest .skogai/tests
fi
