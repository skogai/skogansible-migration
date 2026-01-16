#!/usr/bin/env zsh
# Completion Directories Setup
# Add custom completion directories to fpath
# This MUST run before any plugin manager (zplug, oh-my-zsh, etc.) calls compinit

# Add custom completions directory to fpath
fpath=(~/.config/zsh.d/completions $fpath)
