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
- **Vault**: Vault password file at `~/.ssh/ansible-vault-password` is used to decrypt become password
- **Force handlers**: Enabled globally (`force_handlers = true`) - handlers run even when tasks fail
- **Diff mode**: Always enabled (`always = yes`) - shows file changes before applying
- **Color output**: Forced on (`force_color = true`) for better readability

---

## Common Problems and Solutions

### Checking Sudo/Privilege Access

**NEVER** use `become: true` to check if sudo is configured. This will:
- Try to actually escalate privileges
- Fail with "Duplicate become password prompt" if vault is misconfigured
- Create unnecessary double-checks

**CORRECT approach:**
1. Use `ansible_user_id` fact to check current user identity
2. Check if `ANSIBLE_BECOME_PASSWORD_FILE` environment variable exists and file is readable
3. Set a fact like `sudo_configured` based on file existence
4. Skip privileged tasks if not configured - don't fail the entire playbook

**Example from roles/01_host_info:**
```yaml
- name: Display current user
  ansible.builtin.debug:
    msg: "Running as user: {{ ansible_user_id }}"

- name: Check become password file exists
  ansible.builtin.stat:
    path: "{{ lookup('env', 'ANSIBLE_BECOME_PASSWORD_FILE') }}"
  register: become_pass_file
  when: lookup('env', 'ANSIBLE_BECOME_PASSWORD_FILE') != ''

- name: Set sudo configuration status
  ansible.builtin.set_fact:
    sudo_configured: "{{ become_pass_file.stat.exists | default(false) }}"
```

### Vault Setup

Become password is stored vault-encrypted at `/home/skogix/.ssh/ansible-become-password`:
- Vault password file: `/home/skogix/.ssh/ansible-vault-password` (plaintext)
- Become password file: `/home/skogix/.ssh/ansible-become-password` (vault-encrypted)
- Environment variables set in `.env` and loaded via `.envrc`

Ansible 2.12+ supports `ANSIBLE_BECOME_PASSWORD_FILE` which can point to:
1. A plaintext file with the password
2. An executable that outputs the password to stdout

The vault-encrypted file works as-is when `ANSIBLE_VAULT_PASSWORD_FILE` is set, allowing Ansible to automatically decrypt it.

### Running Playbooks

**Simple execution:**
```bash
ansible-playbook playbooks/01.yml
```

Do NOT overcomplicate with direnv commands - the environment is already loaded via `.envrc`.

### Assumptions to Avoid

- **Never assume it's a system/kernel/Ansible bug** - always check our configuration first
- **Never check external documentation** for basic functionality issues - investigate locally first
- **Never add unnecessary become checks** - check environment configuration, not actual privilege escalation
