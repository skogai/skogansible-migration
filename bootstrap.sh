#!/bin/bash
set -e

# Bootstrap script for setting up Ansible environment
# This script installs required packages and sets up the Python virtual environment

echo "==> Starting Ansible bootstrap..."

# Check if running with sudo privileges
if ! sudo -v; then
    echo "ERROR: This script requires sudo access"
    exit 1
fi

# Check if packages are already installed (skip if yes)
PACKAGES_TO_INSTALL=()
for pkg in python-uv uv ansible ansible-core; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        PACKAGES_TO_INSTALL+=("$pkg")
    fi
done

# Install missing packages
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    echo "==> Installing packages: ${PACKAGES_TO_INSTALL[*]}"
    if ! sudo pacman -S --noconfirm "${PACKAGES_TO_INSTALL[@]}"; then
        echo "ERROR: Failed to install packages"
        exit 1
    fi
else
    echo "==> All required packages already installed"
fi

# Create and setup virtual environment
echo "==> Setting up Python virtual environment..."
if ! uv venv --seed --clear .venv; then
    echo "ERROR: Failed to create virtual environment"
    exit 1
fi

# Install detect-secrets for secret scanning
echo "==> Installing detect-secrets..."
if ! uv pip install detect-secrets; then
    echo "ERROR: Failed to install detect-secrets"
    exit 1
fi

# Install Ansible collections
echo "==> Installing Ansible Galaxy collections..."
if ! ansible-galaxy collection install -r .requirements.yml --force; then
    echo "ERROR: Failed to install Ansible collections"
    exit 1
fi

# Create tmp directory if it doesn't exist
mkdir -p ./tmp

# Dump Ansible configuration for debugging
echo "==> Saving Ansible configuration to ./tmp/ENV..."
if ! ansible-config dump --type all >./tmp/ENV 2>&1; then
    echo "WARNING: Failed to dump Ansible configuration (non-fatal)"
fi

echo "==> Bootstrap completed successfully!"
echo ""
echo "Next steps:"
echo "  1. Activate the virtual environment: source .venv/bin/activate"
echo "  2. Run the playbook: ./run.sh"
echo ""
