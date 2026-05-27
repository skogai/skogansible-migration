#!/usr/bin/env zsh
# claude() {
#     local args=("$@")
#     local extra=()
#     [[ -f .claude/AUTO_PLAN_MODE.txt ]] && extra+=("--append-system-prompt" "$(cat .claude/AUTO_PLAN_MODE.txt)")
#     command claude --dangerously-skip-permissions "${extra[@]}" "${args[@]}"
# }
#
# Claude Code
# export FORCE_AUTO_BACKGROUND_TASKS=1
# export ENABLE_BACKGROUND_TASKS=1

# codex() { AGENT=1 command codex --dangerously-bypass-approvals-and-sandbox "$@"; }
cursor-agent() { AGENT=1 command cursor-agent -f "$@"; }
gemini() { AGENT=1 command gemini -y "$@"; }
# opencode() { AGENT=1 command opencode "$@"; }

# alias oc="opencode"
