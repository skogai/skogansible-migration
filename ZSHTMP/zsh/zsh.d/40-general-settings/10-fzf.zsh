# https://github.com/BartSte/fzf-help
# bash -c 'tmp_dir=$(mktemp -d); git clone https://github.com/BartSte/fzf-help.git $tmp_dir; $tmp_dir/install --user; rm -rf $tmp_dir;'
# source $HOME/.local/share/fzf-help/fzf-help.zsh
# zle -N fzf-help-widget
# bindkey "^A" fzf-help-widget

# TODO:
# https://github.com/ytet5uy4/fzf-widgets
# https://github.com/tom-power/fzf-tab-widgets
# https://github.com/laloch/xontrib-fzf-widgets
# https://github.com/amaya382/zsh-fzf-widgets

#!/bin/zsh
#  _____ __________  __        ___     _            _
# |  ___|__  /  ___| \ \      / (_) __| | __ _  ___| |_ ___
# | |_    / /| |_     \ \ /\ / /| |/ _` |/ _` |/ _ \ __/ __|
# |  _|  / /_|  _|     \ V  V / | | (_| | (_| |  __/ |_\__ \
# |_|   /____|_|        \_/\_/  |_|\__,_|\__, |\___|\__|___/
#                                        |___/
#

# # CD scripts ls files on right window ctrl space
# HISTORY_PATH="${HOME}/.zsh_history"
# FZF_HEIGHT=30
# EDITOR="nvim"
#
#
# FILE_PATH=$0
# err_msg() { echo "${FILE_PATH}: Error: $1" 1>&2 }
# [[ ${SHELL} = "*zsh" ]] && err_msg "Only Z-shell is supported." && return
# [[ -f ${HISTORY_PATH} ]] || (err_msg "File does not exist: $HISTORY_PATH" && return)
# which fzf > /dev/null; [[ $? != 0 ]] && err_msg "Fzf is not installed." && return
# which fd > /dev/null; [[ $? != 0 ]] && err_msg "Fd is not installed." && return
# which exa > /dev/null; [[ $? != 0 ]] && err_msg "Exa is not installed." && return
#
#
# #  TODO: rg file extension input
# fzf-rg-widget() {
#     [[ -n $1 ]] && QUERY=$1
#
#     RG_PREFIX="rg --line-number --no-heading --color=always --smart-case -C 1"
#
#     if [[ -n ${LBUFFER} ]]; then
#         GLOB="${LBUFFER}"
#         RG_PREFIX="${RG_PREFIX} --glob \"${GLOB}\""
#     fi
#
#     fzf_output=$( fzf --height=${FZF_HEIGHT} --layout=reverse --bind "change:reload:$RG_PREFIX {q} ${QUERY} || true"  --ansi --phony --print-query \
#          --bind 'ctrl-d:page-down','ctrl-u:page-up')
#     fzf_status=$?
#
#     if [[ ${fzf_status} -eq 0 ]]; then
#         IFS=":"
#         arr=( $(echo "${fzf_output}" | tr '\n' ':') )
#         LBUFFER="${EDITOR} ${arr[2]} +${arr[3]}"
#         zle reset-prompt
#         zle accept-line # Execute line
#
#         #fzf_output=$( fzf --height=${FZF_HEIGHT} --layout=reverse --bind "change:reload:$RG_PREFIX {q} ${QUERY} || true"  --ansi --phony --print-query)
#         #QUERY=${arr[1]}
#         #fzf-rg-widget "${QUERY}"
#     else
#         zle kill-whole-line
#         LBUFFER=${GLOB}
#         zle reset-prompt
#         #zle end-of-line
#     fi
#
# }
# zle -N fzf-rg-widget
# bindkey '^U' fzf-rg-widget
#
# fzf-pdf-widget() {
#     #PDFGREP_PREFIX="pdfgrep --line-number --color=always --ignore-case -C 1"
#     PDFGREP_PREFIX="pdfgrep --ignore-case --page-number --color=always -C 1"
#
#     #eval ${PDFGREP_PREFIX}
#
#     INITIAL_BUFFER=${LBUFFER}
#     FILE="*.pdf"
#     [[ -n ${LBUFFER} ]] && FILE="${LBUFFER}"
#     fzf_output=$( fzf --height=${FZF_HEIGHT} --layout=reverse --bind "change:reload:$PDFGREP_PREFIX {q} . ${FILE} || true"  --ansi --phony --print-query \
#          --bind 'ctrl-d:page-down','ctrl-u:page-up')
#     fzf_status=$?
#
#     if [[ ${fzf_status} -eq 0 ]]; then
#         IFS=":"
#         arr=( $(echo "${fzf_output}" | tr '\n' ':') )
#         # strip search array[4]
#         LBUFFER="okular -page ${arr[3]} --find \"${arr[1]}\" ${arr[2]}"
#         zle reset-prompt
#         zle accept-line # Execute line
#     else
#         zle kill-whole-line
#         LBUFFER=${INITIAL_BUFFER}
#         zle reset-prompt
#         #zle end-of-line
#     fi
#
# }
# zle -N fzf-pdf-widget
# bindkey '^Y' fzf-pdf-widget
#
# fzf-dir-widget() {
#     search="."
#     fzf_prev="--preview-window 50%,wrap --preview='exa -1a {}' --preview-window hidden --bind 'ctrl-space:toggle-preview','ctrl-d:preview-page-down','ctrl-u:preview-page-up'"
#     DIR=$(fd -H -i -t d ${search} $(pwd)| eval fzf --height=${FZF_HEIGHT} --layout=reverse ${fzf_prev})
#     fzf_status=$?
#     [[ ${DIR} == *" "* ]] && DIR=\"${DIR}\" # Add quotes if dir contains space
#     if [[ -n $LBUFFER ]]; then
#         LBUFFER="${LBUFFER}${DIR}"
#         [[ $fzf_status -eq 0 ]] && LBUFFER="${LBUFFER} " # add white space if exit status = 0
#         zle reset-prompt
#     else
#         LBUFFER="cd ${DIR}"
#         if [ $fzf_status -eq 0 ]; then
#             exa ${DIR} -a
#             zle reset-prompt
#             zle accept-line # Execute line
#         else
#             zle kill-whole-line # Do not jump to next line
#             zle reset-prompt
#         fi
#     fi
# }
# zle -N fzf-dir-widget
# bindkey '^O' fzf-dir-widget
#
# fzf-file-widget() {
#     search="."
#     fzf_args="--height=${FZF_HEIGHT} --layout=reverse"
#     #fzf_prev="--preview='less {}' --preview-window hidden --bind 'ctrl-space:toggle-preview','ctrl-d:preview-page-down','ctrl-u:preview-page-up'"
#     fzf_prev="--preview='bat --plain --color always {}' --preview-window hidden --bind 'ctrl-space:toggle-preview','ctrl-d:preview-page-down','ctrl-u:preview-page-up'"
#     FILE=$(fd -H -i -t f --no-ignore --exclude '.git' ${search} $(pwd)| eval fzf ${fzf_args} ${fzf_prev})
#     #FILE=$(fd -H -i -t f ${search} $(pwd)| fzf --height=20 --layout=reverse --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down)
#     fzf_status=$?
#     [[ ${FILE} == *" "* ]] && FILE=\"${FILE}\" #Add quotes if file contains space
#
#     if [[ -n $LBUFFER ]]; then
#         LBUFFER="${LBUFFER}${FILE}"
#         [[ $fzf_status -eq 0 ]] && LBUFFER="${LBUFFER} " # add white space if exit == 0
#         zle reset-prompt
#     else
#         LBUFFER="${EDITOR} ${FILE}"
#         if [ $fzf_status -eq 0 ]; then
#             zle reset-prompt
#             zle accept-line
#         else
#             zle kill-whole-line
#             zle reset-prompt
#         fi
#     fi
# }
# zle -N fzf-file-widget
# bindkey '^P' fzf-file-widget
#
# fzf-history-widget() {
#     query=${LBUFFER}
#     #fzf_args="--height=${FZF_HEIGHT} --layout=reverse --no-sort --tac --exact --header \"History\""
#     exec_on_enter=false
#     if [[ -n ${query} ]]; then
#         #LBUFFER=$(cat ${HISTORY_PATH} | eval fzf --query ${query} ${fzf_args})
#         LBUFFER=$(cat ${HISTORY_PATH} | fzf --query ${query} --height=${FZF_HEIGHT} --layout=reverse --no-sort --tac --exact --header "History")
#     else
#         exec_on_enter=true
#         #LBUFFER=$(cat ${HISTORY_PATH} | eval fzf ${fzf_args})
#         LBUFFER=$(cat ${HISTORY_PATH} | fzf --height=${FZF_HEIGHT} --layout=reverse --no-sort --tac --exact --header "History")
#     fi
#
#     fzf_status=$?
#
#     if [[ ${fzf_status} -eq 0 ]]; then
#         zle reset-prompt
#         ${exec_on_enter} && zle accept-line
#     else
#         LBUFFER=${query}
#         zle reset-prompt
#     fi
# }
# zle     -N   fzf-history-widget
# bindkey '^R' fzf-history-widget
#
