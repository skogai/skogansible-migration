export ZPLUG_HOME="${HOME}/.zplug"

[[ ! -d $ZPLUG_HOME ]] && git clone https://github.com/zplug/zplug $ZPLUG_HOME

source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "geometry-zsh/geometry"

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh

ssh-agent plugin config
zstyle :omz:plugins:ssh-agent identities id_ecdsa id_rsa id_ed25519

zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/direnv", from:oh-my-zsh
zplug "plugins/virtualenv", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/ansible", from:oh-my-zsh

! zplug check && zplug install
zplug load
