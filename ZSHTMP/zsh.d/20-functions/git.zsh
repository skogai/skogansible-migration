#!/usr/bin/env zsh

gbda() {
    git branch --no-color --merged | command grep -vE "^([+*]|\s*(main|master|develop|dev)\s*\$)" | command xargs git branch -d 2>/dev/null
}


gitlog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

glogf() {
    command -v fzf &>/dev/null || { echo "fzf required"; return 1; }
    git log --oneline --decorate --color=always | \
        fzf --ansi --no-sort --reverse \
            --preview 'git show --color=always {1}' \
            --bind 'enter:execute(git show --color=always {1} | less -R)+abort'
}

gdm() {
    local current=$(git branch --show-current)
    local protected=("main" "master")

    if [[ ! " ${protected[@]} " =~ " ${current} " ]]; then
        git show-ref --verify --quiet refs/heads/main && git checkout main || \
        git show-ref --verify --quiet refs/heads/master && git checkout master || \
        { echo "No main/master branch"; return 1; }
    fi

    git branch | sed 's/^[* ]*//' | grep -v '^main$' | grep -v '^master$' | while read -r b; do
        git branch -D "$b"
    done
}
