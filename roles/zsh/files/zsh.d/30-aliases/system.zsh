#!/usr/bin/env zsh
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias zshrc='nvim ~/.zshrc'
alias zshenv='nvim ~/.zshenv'
alias update='sudo pacman -Syu'
alias rmpkg='sudo pacman -Rsn'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq) 2>/dev/null || echo "No orphans"'
alias jctl='journalctl -p 3 -xb'
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
