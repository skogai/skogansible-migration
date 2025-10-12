#!/usr/bin/env bash
# Run Ansible playbooks with proper configuration
# Usage: ./run.sh [playbook] [additional ansible-playbook options]
# Example: ./run.sh playbooks/site.yml --tags dotfiles
# Example: ./run.sh playbooks/all.yml --check

# Default to playbooks/all.yml if no playbook specified
PLAYBOOK="${1:-playbooks/all.yml}"
shift || true  # Remove first argument (playbook) from $@, or continue if no args

# Run ansible-playbook with configuration from ansible.cfg
# The become and vault password files are now configured in ansible.cfg
ansible-playbook "$PLAYBOOK" "$@"
