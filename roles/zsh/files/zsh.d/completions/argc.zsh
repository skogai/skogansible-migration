export ARGC_COMPLETIONS_ROOT="/home/skogix/.local/src/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/linux:$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
argc_scripts=( $(ls -1 "$ARGC_COMPLETIONS_ROOT/completions/linux" "$ARGC_COMPLETIONS_ROOT/completions" 2>/dev/null | sed -n 's/\.sh$//p') )
source <(argc --argc-completions zsh $argc_scripts)
