#!/usr/bin/env bash
set -e

# Source .envrc if direnv isn't loaded
source .env
if [ -z "$ANSIBLE_BECOME_PASSWORD_FILE" ]; then
  export ANSIBLE_BECOME_PASSWORD_FILE=/home/skogix/.ssh/ansible-become-password
  export ANSIBLE_VAULT_PASSWORD_FILE=/home/skogix/.ssh/ansible-vault-password
fi

# Function to check file permissions
check_password_file_permissions() {
  local file="$1"
  if [ -f "$file" ]; then
    local perms
    perms=$(stat -c "%a" "$file" 2>/dev/null || stat -f "%A" "$file" 2>/dev/null)
    if [ "$perms" != "700" ]; then
      echo "Warning: $file has permissions $perms (should be 700)"
      echo "Fixing permissions..."
      chmod 700 "$file"
    fi
  fi
}

# Check password file permissions
check_password_file_permissions "$ANSIBLE_BECOME_PASSWORD_FILE"
check_password_file_permissions "$ANSIBLE_VAULT_PASSWORD_FILE"

# Activate venv if not already active
uv venv --seed --clear
uv pip install ansible-core
uv pip install ansible
if [ -z "$VIRTUAL_ENV" ] && [ -d ".venv" ]; then
  source .venv/bin/activate
fi

# Determine which playbook to run
ANSIBLE_PLAYBOOK="default.yml"

# If first argument is a .yml file, use it as the playbook
if [[ "$1" == *.yml ]]; then
  ANSIBLE_PLAYBOOK="$1"
  shift # Remove playbook from arguments
fi

# Run playbook with remaining arguments
ansible-playbook "./playbooks/$ANSIBLE_PLAYBOOK" -i .inventory \
  --vault-password-file="$ANSIBLE_VAULT_PASSWORD_FILE" \
  --become-password-file="$ANSIBLE_BECOME_PASSWORD_FILE" \
  "$@"
