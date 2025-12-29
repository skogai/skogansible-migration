#!/usr/bin/env bash
set -e

# Bootstrap
sudo pacman -S python-uv --noconfirm && uv venv --seed --python 313 --link-mode=copy && uv pip install --link-mode=copy ansible ansible-core && source .venv/bin/activate && ansible-galaxy collection install -r .requirements.yml --upgrade && mkdir -p ./tmp && ansible-config dump --type all > ./tmp/ENV
echo "$?"

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

# Determine which playbook to run
ANSIBLE_PLAYBOOK="default.yml"

# If first argument is a .yml file, use it as the playbook
if [[ "$1" == *.yml ]]; then
  ANSIBLE_PLAYBOOK="$1"
  shift # Remove playbook from arguments
fi

# Run playbook with remaining arguments
ansible-playbook "./playbooks/$ANSIBLE_PLAYBOOK" -i .inventory \
  --vault-password-file=$ANSIBLE_VAULT_PASSWORD_FILE \
  --become-password-file=$ANSIBLE_BECOME_PASSWORD_FILE \
  "$@"
