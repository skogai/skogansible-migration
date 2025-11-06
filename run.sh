#!/usr/bin/env bash
set -e

# Load environment variables
source $HOME/.ansible/.envrc

# Activate virtual environment
source $HOME/.ansible/.venv/bin/activate

# Run playbook
ansible-playbook playbook.yml "$@"
