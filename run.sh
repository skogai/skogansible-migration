#!/usr/bin/env bash
# Run ansible-playbook with environment variables from .env
# Usage: ./run.sh [playbook] [ansible-playbook options]
# Example: ./run.sh playbooks/all.yml
# Example: ./run.sh playbooks/site.yml --tags dotfiles
# Example: ./run.sh playbooks/all.yml --check

PLAYBOOK="${1:-playbooks/all.yml}"
shift || true  # Remove first arg if present, continue if not

ansible-playbook "$PLAYBOOK" "$@"
