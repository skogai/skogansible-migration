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
├── .hosts              # Inventory file (localhost)
├── run.sh              # Playbook execution script (ALWAYS use this)
├── test.sh             # Local testing script (static analysis)
├── requirements.yml    # Ansible collections requirements
├── playbooks/          # Ansible playbooks
│   └── all.yml         # Main playbook
├── roles/              # Ansible roles
│   ├── 01_host_info/   # System info and sudo checks
│   └── 02_package_managers/  # Package installation (pacman + AUR)
├── vars/               # Variable files
│   ├── packages.yml    # Package lists (packages, aur_packages)
│   └── user.yml        # User configuration
├── logs/               # Ansible execution logs
├── .collections/       # Ansible collections storage
├── .cache/             # Fact caching storage
└── .claude/            # Claude Code hooks
```

---

## Usage Context

This configuration affects all Ansible commands run on the system. When working with Ansible:

1. Playbooks and roles are stored in this directory (`playbooks/` and `roles/`)
2. The `inventory = .hosts` setting points to the localhost inventory in this directory
3. Collections installed with `ansible-galaxy collection install` are stored in `~/.ansible/.collections`
4. Fact caching enables faster playbook runs by storing host facts in `~/.ansible/.cache`
5. Variable files in `vars/` define package lists and user configuration

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

**ALWAYS use run.sh for playbook execution:**
```bash
bash run.sh
```

**NEVER run ansible-playbook directly.** The `run.sh` script properly handles vault and become password files.

**For Claude Code:** Always run playbooks in background mode:
```bash
bash run.sh  # with run_in_background: true
```

Then check output with `BashOutput` tool. This prevents long-running package installations from blocking the CLI.

### AUR Package Installation

AUR packages require a special setup because `makepkg` refuses to run as root:

**The aur_builder user:**
- Created by the `02_package_managers` role
- Member of `wheel` group
- Has passwordless sudo for `/usr/bin/pacman` only (configured in `/etc/sudoers.d/11-install-aur_builder`)

**Workflow:**
1. `aur_builder` builds the AUR package (without sudo)
2. `yay` internally calls `sudo pacman` to install (using passwordless sudo)
3. No password prompts, no "Duplicate become password prompt" errors

**Example from roles/02_package_managers:**
```yaml
- name: Create the `aur_builder` user
  become: true
  ansible.builtin.user:
    name: aur_builder
    create_home: yes
    group: wheel

- name: Allow the `aur_builder` user to run `sudo pacman` without a password
  become: true
  ansible.builtin.lineinfile:
    path: /etc/sudoers.d/11-install-aur_builder
    line: "aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman"
    create: yes
    mode: 0644
    validate: "visudo -cf %s"

- name: Install AUR packages
  become: true
  become_user: aur_builder
  kewlfft.aur.aur:
    name: "{{ aur_packages }}"
    use: auto
    state: present
```

**Important:** `become` and `become_user` are task-level directives, NOT module parameters. Always place them at the task level, before the module name.

### Testing Locally

**ALWAYS use test.sh for local validation before pushing:**
```bash
./test.sh
```

**What it checks:**
1. Required tools (ansible-playbook, yamllint, ansible-lint)
2. Required collections (community.general, kewlfft.aur, ansible.posix)
3. Ansible syntax (--syntax-check)
4. YAML linting (yamllint)
5. Ansible best practices (ansible-lint)
6. Optional: Check mode dry-run (with --check flag)

**Setup requirements (first time only):**
```bash
pip install ansible ansible-lint yamllint
ansible-galaxy collection install -r requirements.yml
```

**For check mode testing:**
```bash
./test.sh --check  # Requires vault and become password files
```

**Note:** The test.sh script performs static analysis only by default. It does NOT execute the playbook unless --check flag is used.

### Assumptions to Avoid

- **Never assume it's a system/kernel/Ansible bug** - always check our configuration first
- **Never check external documentation** for basic functionality issues - investigate locally first
- **Never add unnecessary become checks** - check environment configuration, not actual privilege escalation
