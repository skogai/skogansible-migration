#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

python -m unittest discover -s tests

ansible-galaxy collection install -r .requirements.yml

syntax_check() {
  local playbook="$1"
  shift

  ansible-playbook "./playbooks/${playbook}" -i .inventory --syntax-check "$@"
}

syntax_check bootstrap.yml
syntax_check maintenance.yml
syntax_check test_users.yml

vault_password_file="${ANSIBLE_VAULT_PASSWORD_FILE:-$HOME/.ssh/ansible-vault-password}"
if [[ -f "$vault_password_file" ]]; then
  syntax_check default.yml --vault-password-file "$vault_password_file"
  syntax_check site.yml --vault-password-file "$vault_password_file"
  syntax_check workstation.yml --vault-password-file "$vault_password_file"
fi
