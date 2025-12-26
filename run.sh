#!/usr/bin/env bash
set -e

export PATH="$HOME/.local/bin:$PATH"

# Activate virtual environment
source .venv/bin/activate

# Password file configuration with validation
VAULT_PASSWORD_FILE="${ANSIBLE_VAULT_PASSWORD_FILE:-$HOME/.ssh/ansible-vault-password}"
BECOME_PASSWORD_FILE="${ANSIBLE_BECOME_PASSWORD_FILE:-$HOME/.ssh/ansible-become-password}"

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

# Build ansible-playbook arguments
VAULT_PASS_ARG=""
BECOME_PASS_ARG=""

# Check vault password file
if [ -f "$VAULT_PASSWORD_FILE" ]; then
  check_password_file_permissions "$VAULT_PASSWORD_FILE"
  VAULT_PASS_ARG="--vault-password-file $VAULT_PASSWORD_FILE"
else
  echo "Warning: Vault password file not found at $VAULT_PASSWORD_FILE"
  echo "Will prompt for vault password if needed"
  VAULT_PASS_ARG="--ask-vault-pass"
fi

# Check become password file
if [ -f "$BECOME_PASSWORD_FILE" ]; then
  check_password_file_permissions "$BECOME_PASSWORD_FILE"
  BECOME_PASS_ARG="--become-password-file $BECOME_PASSWORD_FILE"
else
  echo "Warning: Become password file not found at $BECOME_PASSWORD_FILE"
  echo "Will prompt for become password if needed"
  BECOME_PASS_ARG="--ask-become-pass"
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
  $VAULT_PASS_ARG \
  $BECOME_PASS_ARG \
  "$@"
