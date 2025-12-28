# argc-completions
export ARGC_COMPLETIONS_ROOT="/home/skogix/skogai/argc-completions"
export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/linux:$ARGC_COMPLETIONS_ROOT/completions"
export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
# To add completions for only the specified command, modify next line e.g. argc_scripts=( cargo git )
argc_scripts=($(ls -1 "$ARGC_COMPLETIONS_ROOT/completions/linux" "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p'))
source <(argc --argc-completions zsh $argc_scripts)
# # argc-completions
# export ARGC_COMPLETIONS_ROOT="/home/skogix/skogai/argc-completions"
# export ARGC_COMPLETIONS_PATH="$ARGC_COMPLETIONS_ROOT/completions/linux:$ARGC_COMPLETIONS_ROOT/completions"
# export PATH="$ARGC_COMPLETIONS_ROOT/bin:$PATH"
# # To add completions for only the specified command, modify next line e.g. argc_scripts=( cargo git )
# argc_scripts=( $(ls -p -1 "$ARGC_COMPLETIONS_ROOT/completions/linux" "$ARGC_COMPLETIONS_ROOT/completions" | sed -n 's/\.sh$//p') )
# source <(argc --argc-completions zsh $argc_scripts)


# _argc_completer() {
#     local new_words
#     _argc_completer_reassemble_words
#
#     local candidates=() values=() displays=() colors display_value
#     while IFS=$'\n' read -r line; do
#         if [[ "$line" == "" ]]; then line=$'\0'; fi
#         candidates+=( "$line" )
#     done < <(argc --argc-compgen zsh $'\0' $new_words 2>/dev/null)
#     for candidate in ${candidates[@]}; do
#         IFS=$'\t' read -r value display color_key color <<< "$candidate"
#         colors="$colors:=(#b)($color_key)( * -- *)=0=$color=2;37:=(#b)($color_key)()=0=$color=2;37"
#         values+=( "${value}" )
#         displays+=( "$display" )
#     done
#     zstyle ":completion:${curcontext}:*" list-colors "${colors:1}:=(#b)(-- *)=0=2;37:=(#b)(--[A-Za-z0-9_-]#)( * -- *)=0==2;37"
#     _describe "" displays values -Q -S '' -o nosort
# }
#
# _argc_completer_reassemble_words() {
#     local i cword
#     new_words=()
#     for ((i=1; i<=$CURRENT; i++)); do
#         cword="$words[$i]"
#         if [[ "$cword" == "" ]]; then
#             new_words+=( $'\0' )
#         else
#             if [[ "$cword" == *"\\"* ]]; then
#                 local j char next_char cword_len word
#                 cword_len="${#cword}"
#                 for ((j=0; j<$cword_len; j++)); do
#                     char="${cword:$j:1}"
#                     if [[ "$char" == "\\" ]]; then
#                         next_char="${cword:$((j+1)):1}"
#                         if [[ "$next_char" == "\\" ]]; then
#                             word="$word$char"
#                             j=$((j+1))
#                         fi
#                     else
#                         word="$word$char"
#                     fi
#                 done
#                 cword="$word"
#             fi
#             new_words+=( "$cword" )
#         fi
#     done
# }
#
# compdef _argc_completer \
#     argc

#compdef aichat

autoload -U is-at-least

_aichat() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    local common=(
'-m[Select a LLM model]:MODEL:->models' \
'--model[Select a LLM model]:MODEL:->models' \
'--prompt[Use the system prompt]:PROMPT: ' \
'-r[Select a role]:ROLE:->roles' \
'--role[Select a role]:ROLE:->roles' \
'-s[Start or join a session]:SESSION:->sessions' \
'--session[Start or join a session]:SESSION:->sessions' \
'--empty-session[Ensure the session is empty]' \
'--save-session[Ensure the new conversation is saved to the session]' \
'-a[Start a agent]:AGENT:->agents' \
'--agent[Start a agent]:AGENT:->agents' \
'--agent-variable[Set agent variables]' \
'--rag[Start a RAG]:RAG:->rags' \
'--serve[Serve the LLM API and WebAPP]' \
'-e[Execute commands in natural language]' \
'--execute[Execute commands in natural language]' \
'-c[Output code only]' \
'--code[Output code only]' \
'*-f[Include files with the message]:FILE:_files' \
'*--file[Include files with the message]:FILE:_files' \
'-S[Turn off stream mode]' \
'--no-stream[Turn off stream mode]' \
'--dry-run[Display the message without sending it]' \
'--info[Display information]' \
'--list-models[List all available chat models]' \
'--list-roles[List all roles]' \
'--list-sessions[List all sessions]' \
'--list-agents[List all agents]' \
'--list-rags[List all RAGs]' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
'*::text -- Input text:' \
    )


    _arguments "${_arguments_options[@]}" $common \
        && ret=0
    case $state in
        models|roles|sessions|agents|rags)
            local -a values expl
            values=( ${(f)"$(_call_program values aichat --list-$state)"} )
            _wanted values expl $state compadd -a values && ret=0
            ;;
    esac
    return ret
}

(( $+functions[_aichat_commands] )) ||
_aichat_commands() {
    local commands; commands=()
    _describe -t commands 'aichat commands' commands "$@"
}

if [ "$funcstack[1]" = "_aichat" ]; then
    _aichat "$@"
else
    compdef _aichat aichat
fi
