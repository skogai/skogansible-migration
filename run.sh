#!/usr/bin/env bash
set -e

export PATH="$HOME/.local/bin:$PATH"

# Activate virtual environment
source .venv/bin/activate

# Determine which playbook to run
ANSIBLE_PLAYBOOK="default.yml"

# If first argument is a .yml file, use it as the playbook
if [[ "$1" == *.yml ]]; then
  ANSIBLE_PLAYBOOK="$1"
  shift # Remove playbook from arguments
fi

# Run playbook with remaining arguments
ansible-playbook "./playbooks/$ANSIBLE_PLAYBOOK" -i .inventory \
  --vault-password-file ~/.ssh/ansible-vault-password \
  --become-password-file ~/.ssh/ansible-become-password \
  "$@"
