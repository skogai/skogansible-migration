fpath+=~/.zsh-completions
fpath+=~/.zsh-completions/completions

autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored _approximate _list _history
zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"
