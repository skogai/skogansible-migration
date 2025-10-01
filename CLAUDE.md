# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Repository Purpose

This is the centralized Ansible configuration directory (`~/.ansible`) that provides global settings and paths for all Ansible operations on this system.

**This is NOT a playbook repository.** It contains configuration files that define how Ansible behaves system-wide.

---

## Configuration Files

### ansible.cfg

Primary Ansible configuration located at `/home/skogix/.ansible/ansible.cfg`:

- **Collections path**: `~/.ansible/.collections` - Custom collection installation location
- **Fact caching**: Uses `community.general.yaml` backend with cache at `~/.ansible/.cache`
- **Inventory**: References `.hosts` file (not currently present in this directory)
- **Roles path**: `roles/` directory (relative to where ansible is executed)
- **Working directories**: `/tmp/.ansible` for both local and remote temporary files
- **Vault password**: Commented out, located at `~/.ssh/ansible-vault-password`

### .envrc

Manages environment through direnv with `use_ansible` directive.

### .env

Contains sensitive environment variables. Protected by pre-tool-use hooks - cannot be read or modified directly.

---

## Directory Structure

```
~/.ansible/
├── ansible.cfg          # Global Ansible configuration
├── .envrc              # direnv environment setup
├── .env                # Protected environment variables
├── logs/               # Ansible execution logs
└── .claude/            # Claude Code hooks (pre/post tool use, status line, etc.)
```

**Expected directories** (referenced in ansible.cfg but not yet created):
- `.collections/` - Ansible collections storage
- `.cache/` - Fact caching storage
- `roles/` - Ansible roles (relative to execution location)

---

## Usage Context

This configuration affects all Ansible commands run on the system. When working with Ansible:

1. Playbooks and inventories are typically located elsewhere (not in this directory)
2. The `inventory = .hosts` setting means Ansible looks for `.hosts` in the current working directory where commands are executed
3. Collections installed with `ansible-galaxy collection install` will be stored in `~/.ansible/.collections`
4. Fact caching enables faster playbook runs by storing host facts between executions

---

## Important Notes

- **Security**: The `.env` file contains sensitive data and is protected by pre-tool-use hooks
- **Vault**: Vault password file references are commented out but indicate vault usage at `~/.ssh/ansible-vault-password`
- **Force handlers**: Enabled globally (`force_handlers = true`) - handlers run even when tasks fail
- **Diff mode**: Always enabled (`always = yes`) - shows file changes before applying
- **Color output**: Forced on (`force_color = true`) for better readability
