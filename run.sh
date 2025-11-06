#!/usr/bin/env bash
source $HOME/.ansible/.envrc
ansible-playbook playbook.yml "$@"
