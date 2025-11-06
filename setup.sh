#!/usr/bin/env bash
uv venv --seed --clear
uv pip install ansible
uv pip install ansible-core
ansible-galaxy collection install community.general --force
source $HOME/.ansible/.venv/bin/activate
