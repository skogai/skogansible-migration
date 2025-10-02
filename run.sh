#!/usr/bin/env bash
ansible-playbook --become-password-file /home/skogix/.ssh/ansible-become-password --vault-password-file /home/skogix/.ssh/ansible-vault-password playbooks/all.yml
