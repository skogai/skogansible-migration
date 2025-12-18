#!/bin/bash
set -e

# move this to where it should be and what the fuck is this fucking script-kiddie sed shit?:

# export LC_ALL=C.UTF-8
# export LANG=C.UTF-8
# export PATH="$HOME/.local/bin:$PATH"
#
# sudo sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
# sudo locale-gen
# echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
#
# echo "==> Initializing pacman keyring..."
# sudo pacman -Sy --noconfirm archlinux-keyring
# sudo pacman-key --init
# sudo pacman-key --populate archlinux
#
# echo "==> Installing system dependencies..."
# sudo pacman -S --noconfirm git github-cli uv
#

sudo pacman -S python-uv uv ansible ansible-core --noconfirm
uv venv --seed --clear .venv
# uv tool install ansible --reinstall
# uv tool install ansible-core --reinstall
uv pip install detect-secrets
ansible-galaxy collection install -r .requirements.yml --force
ansible-config dump --type all >./tmp/ENV
