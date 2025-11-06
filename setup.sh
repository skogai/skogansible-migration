#!/usr/bin/env bash
uv venv --seed --clear
uv pip install ansible
ansible-galaxy collection install -r .requirements.yml --force
source $HOME/.ansible/.venv/bin/activate
