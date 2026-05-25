#!/usr/bin/env bash
set -e

export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PATH="$HOME/.local/bin:$PATH"

sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux

sudo pacman -S --noconfirm git github-cli uv

uv tool install --force ansible --with passlib
uv tool install --force ansible-core --with passlib
ansible-galaxy collection install community.general kewlfft.aur ansible.posix --force

echo "Bootstrap complete. Run ./run.sh to apply configuration."
