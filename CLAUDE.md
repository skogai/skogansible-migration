# Ansible Setup

## Key Details

- `become` is on individual tasks (not playbook level) - gets `$ANSIBLE_BECOME_PASSWORD_FILE` set via `skogcli` loading and exporting $ENV's via .envrc. Ask user for more information when/if needed
- `ansible.cfg` uses hardcoded venv path to this project: `/home/skogix/.ansible/.venv/bin/python`
- `run-playbook.sh` sources the venv in this project `$HOME/.ansible/.venv/bin/activate` before running
- `vars/main.yml` controls everything - single source of truth for all configuration
