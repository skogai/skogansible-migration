#!/usr/bin/env bash
set -e

export PATH="$HOME/.local/bin:$PATH"

# Activate virtual environment
source .venv/bin/activate

# Run playbook with optional arguments passed through
ansible-playbook playbook.yml -i .inventory \
    --vault-password-file ~/.ssh/ansible-vault-password \
    --become-password-file ~/.ssh/ansible-become-password \
    "$@"
