#!/usr/bin/env bash
uv venv --seed --clear
uv pip install ansible ansible-core
ansible-galaxy collection install -r .requirements.yml --force
source .venv/bin/activate
