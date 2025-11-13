#!/usr/bin/env bash
set -e

# Load environment variables
source $HOME/.ansible/.envrc

# Activate virtual environment
source $HOME/.ansible/.venv/bin/activate

# Set Ansible config location
export ANSIBLE_CONFIG=$HOME/.ansible/.ansible/ansible.cfg

# Run playbook
ansible-playbook playbook.yml "$@"
