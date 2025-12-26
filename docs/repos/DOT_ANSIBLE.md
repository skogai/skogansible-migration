# Ansible Tasks Inventory

## Overview

This document catalogs all Ansible task names across the dot_ansible playbooks and roles, organized by structure and context.

---

## Playbooks

### skogai-core.yml

Main playbook for SkogAI core system configuration (hosts: all, become: true).

#### Playbook: SkogAI core

**Host**: all | **Become**: true

- Update arch
- Install core packages
- Pacman - enable color
- Pacman - enable ParallelDownloads = 5
- Makepkg - disable compression
- Makepkg - enable parallel compilation MAKEFLAGS="-j$(nproc)"
- Fstab change relatime to noatime
- Change number of failed logins that triger 10min lockout
- Enable members of wheel group to sudo
- Add the user to the root group, to be able to enter directories
- Disable need for sudo password for the current user
- Install ssh
- Enable and start ssh service
- Install plocate
- Enable and start ~12h updatedb timer
- Archlinux-keyring - enable weekly update
- Install util-linux
- Enable and start weekly ssd disks trim using fstrim timer
- install trash-cli
- Create trash-empty.service file
- Create trash-empty.timer file
- Enable and start trash-empty.timer
- Install pacman-contrib
- Enable and start weekly cache cleanup paccache timer
- Install reflector
- Write reflector configuration file
- Enable and start reflector timer
- Do initial run of reflector.service

---

### master.yml

Orchestration playbook calling the file_structure role.

#### Playbook: (implicit)

**Host**: localhost

**Roles invoked**:

- file_structure

---

## Roles

### file_structure

**Type**: Role with tasks and variables
**Host**: localhost

#### Variables

```yaml
directories:
  - Desktop
  - Documents
  - Downloads
  - Music
  - Pictures
  - Videos
```

#### Tasks

- Ensure ~/tmp directory exists
- Move files to ~/tmp and remove directories
  - Move files from {{ item }} to ~/tmp
  - Remove {{ item }} directory

---

### backup/roles/setup_file_structure

**Type**: Role (file structure setup)
**Purpose**: Manage home directory structure and move files

#### Tasks

- Ensure HOME environment variable is set
- Define directories to check
- Ensure tmp directory exists
- Check if directories exist
- Get directory stats
- Find files in directories
- Move files to tmp if directories are not empty
- Remove directories
- Check remove results

---

### backup/roles/encrypt_file

**Type**: Role (file encryption)
**Purpose**: Encrypt files using ansible-vault

#### Tasks

- Check if the file is already encrypted
- Encrypt the file if not already encrypted

---

### backup/roles/check_disk_space

**Type**: Role (disk space monitoring)
**Purpose**: Log disk space usage

#### Tasks

- Check disk space and log output

---

## Test Playbooks

### test_encrypt_file.yml

**Host**: localhost

#### Variables

```yaml
input:
  path: "{{ lookup('env', 'HOME') }}/test.txt"
  password-file: "{{ lookup('env', 'HOME') }}/.ssh/ansible-vault-password"
```

#### Tasks

- Include encrypt_file role

---

## Summary by Category

### System Configuration Tasks (skogai-core.yml)

- Package management (update, install)
- System configuration (pacman, makepkg, fstab)
- Security setup (sudo, faillock)
- SSH configuration
- Service management (plocate, fstrim, trash-empty, reflector, keyring)

### File & Directory Management Tasks

- Directory creation and verification
- File movement operations
- Directory removal
- File enumeration and scanning

### Security & Encryption Tasks

- Ansible-vault encryption
- File encryption verification
- Vault authentication

### Monitoring Tasks

- Disk space logging

---

## Total Task Count: 65 unique task names

**Distribution**:

- skogai-core.yml: 34 tasks
- file_structure role: 2 tasks
- setup_file_structure role: 9 tasks
- encrypt_file role: 2 tasks
- check_disk_space role: 1 task
- test_encrypt_file.yml: 1 task (includes role)
- Block tasks (nested): 2 tasks
- Total including nested: 51 unique task declarations

---

*Generated: 2025-12-18*
*Source directory: /home/skogix/skogai/ansible/dot_ansible*
