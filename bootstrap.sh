#!/bin/bash
set -e

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH="$HOME/.local/bin:$PATH"

echo "==> Setting up system locale..."
# Fix locale permanently
sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sudo locale-gen
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf

echo "==> Initializing pacman keyring..."
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux

echo "==> Installing system dependencies..."
sudo pacman -S --noconfirm git github-cli uv

echo "==> Creating Python virtual environment..."
uv venv --seed --clear .venv

echo "==> Installing Ansible in virtual environment..."
uv pip install ansible --python .venv/bin/python

echo "==> Installing Ansible Galaxy collections..."
.venv/bin/ansible-galaxy collection install -r .requirements.yml --force

echo ""
echo "Bootstrap complete!"
echo "Run ./run.sh to apply configuration."
