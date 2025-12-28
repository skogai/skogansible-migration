#!/usr/bin/env bash
# Quick check script for pre-commit hooks
# Runs ansible in check mode with minimal output

export ANSIBLE_STDOUT_CALLBACK=dense
export ANSIBLE_DISPLAY_OK_HOSTS=no
export ANSIBLE_DISPLAY_SKIPPED_HOSTS=no

./run.sh --check "$@" 2>&1 | grep -E '(TASK|PLAY|changed|failed|ERROR)'
exit ${PIPESTATUS[0]}
