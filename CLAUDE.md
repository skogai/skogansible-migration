# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Repository Purpose

This is a consolidated Ansible repository that combines multiple projects into a unified structure for Arch Linux system configuration and management.

**Features:**
- Numbered roles (01-07) for sequential system setup
- Named roles for specific configurations (cloud, docker, dotfiles, etc.)
- Comprehensive SkogAI core setup for Arch Linux
- Multiple playbook options for different use cases

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
skogansible/
├── ansible.cfg          # Ansible configuration
├── .envrc              # direnv environment setup
├── .env                # Protected environment variables
├── .hosts              # Inventory file (localhost)
├── run.sh              # Playbook execution script (ALWAYS use this)
├── test.sh             # Local testing script (run before pushing)
├── requirements.yml    # Ansible collections (includes community.crypto)
├── playbooks/          # Ansible playbooks
│   ├── all.yml         # Original numbered roles (01-07)
│   ├── site.yml        # NEW: Unified playbook (numbered + named roles)
│   ├── skogai.yml      # NEW: Comprehensive Arch setup
│   └── update.yml      # NEW: Quick system maintenance
├── tasks/              # Reusable task files
│   ├── bootstrap.yml   # Initial system setup
│   ├── maintenance.yml # System update tasks
│   └── skogai-core.yml # Comprehensive Arch configuration
├── roles/              # Ansible roles
│   ├── 01_host_info/   # System info and sudo checks
│   ├── 02_package_managers/  # Package installation (pacman + AUR)
│   ├── 03_dotfiles/    # Dotfile management (numbered version)
│   ├── 04_shell_config/# Shell configuration
│   ├── 05_systemd_services/# Service management
│   ├── 06_ai_tools/    # AI tool setup
│   ├── 07_development/ # Development tools
│   ├── cloud/          # Cloud CLI tools (named version)
│   ├── dock/           # Docker configuration
│   ├── dotfiles/       # Dotfile management (named version)
│   ├── fonts/          # Font installation
│   ├── git/            # Git configuration and repos
│   ├── packages/       # Cross-platform package management
│   ├── ssh/            # SSH configuration and hardening
│   ├── system/         # System-level configuration
│   ├── tmux/           # Tmux configuration
│   ├── vim/            # Vim configuration
│   └── zsh/            # Zsh shell setup
├── vars/               # Variable files
│   ├── packages.yml    # Package lists (packages, aur_packages)
│   └── user.yml        # User configuration
├── logs/               # Ansible execution logs
├── .collections/       # Ansible collections storage
├── .cache/             # Fact caching storage
└── .claude/            # Claude Code hooks
```

---

## Consolidation History (October 2024)

This repository was created by consolidating multiple Ansible projects:

1. **Original skogansible**: Clean numbered roles (01-07) for sequential setup
2. **Merged ansible project**: Added named roles (cloud, dock, dotfiles, etc.)
3. **SkogAI core**: Comprehensive Arch Linux setup with 40+ packages and system optimizations

The consolidation preserved backward compatibility while adding flexibility through:
- Multiple playbook entry points
- Tag-based selective execution
- Variable-controlled role groups (numbered vs named)
- Reusable task files for common operations

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

**Available Playbooks:**

1. **`playbooks/all.yml`** - Original numbered roles (01-07) for sequential setup
   ```bash
   bash run.sh playbooks/all.yml
   ```

2. **`playbooks/site.yml`** - NEW: Unified playbook with all roles
   ```bash
   # Run everything
   bash run.sh playbooks/site.yml

   # Run only numbered roles
   bash run.sh playbooks/site.yml -e numbered=true -e named=false

   # Run specific tags
   bash run.sh playbooks/site.yml --tags dotfiles,ssh
   ```

3. **`playbooks/skogai.yml`** - NEW: Comprehensive Arch Linux setup
   ```bash
   bash run.sh playbooks/skogai.yml --become
   ```

4. **`playbooks/update.yml`** - NEW: Quick system maintenance
   ```bash
   bash run.sh playbooks/update.yml
   ```

**NEVER run ansible-playbook directly.** The `run.sh` script properly handles vault and become password files.

**For Claude Code:** Always run playbooks in background mode:
```bash
bash run.sh  # with run_in_background: true
```

Then check output with `BashOutput` tool. This prevents long-running package installations from blocking the CLI.

### Pre-commit Hooks

**Automated testing before every commit** using pre-commit hooks.

**Quick Setup (Recommended):**
```bash
# Run the setup script (installs pre-commit and all hooks)
./setup-precommit.sh
```

**Manual Setup:**
```bash
# 1. Install pre-commit
pip install pre-commit

# 2. Install the git hooks
pre-commit install

# 3. Install hook environments (downloads and sets up tools)
pre-commit install-hooks
```

The pre-commit hooks run automatically before each commit and include:
1. **yamllint** - YAML file linting
2. **ansible-lint** - Ansible best practices checking
3. **ansible-syntax-check** - Playbook syntax validation
4. **trailing-whitespace** - Auto-fixes trailing spaces
5. **end-of-file-fixer** - Auto-fixes missing newlines at EOF
6. **check-merge-conflict** - Detects merge conflict markers
7. **mixed-line-ending** - Auto-fixes line endings (LF)

**Important Notes:**
- The hooks use official pre-commit repositories that automatically install their dependencies
- You don't need to manually install `yamllint` or `ansible-lint` - pre-commit handles this
- First run will be slow as it downloads and caches the hook environments
- Subsequent runs are fast using the cached environments

**Manual run of pre-commit hooks:**
```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Run specific hook
pre-commit run ansible-lint

# Bypass hooks if needed (use sparingly!)
git commit --no-verify
```

### Testing Locally

**ALWAYS test your changes locally before pushing** using the test.sh script:

```bash
./test.sh
```

This runs the same checks as the GitHub Actions CI workflow:
1. **Ansible syntax check** - Validates playbook syntax
2. **ansible-lint** - Checks for best practices and potential issues
3. **yamllint** - Validates YAML formatting

**Optional check mode:**
```bash
./test.sh --check
```

This additionally runs Ansible in check mode (dry-run) to verify your changes would work on the target system without actually making changes. Requires vault and become password files to be configured.

**What each test does:**

- **Syntax Check**: Validates that all playbooks have valid Ansible syntax. Note that without collections installed, it will warn about missing modules but still pass for local development.

- **ansible-lint**: Checks for Ansible best practices, security issues, and potential bugs. See `.ansible-lint` for configuration. Some rules are warnings only (won't fail the build).

- **yamllint**: Ensures YAML files follow consistent formatting rules. See `.yamllint` for configuration.

**Installing testing tools:**

```bash
pip install ansible-lint yamllint
```

The `ansible-playbook` command is required (comes with ansible), while `ansible-lint` and `yamllint` are optional but recommended. The script will warn if they're missing.

**Interpreting results:**

- ✓ Green checkmarks indicate passed tests
- ✗ Red X marks indicate failed tests
- ⊘ Yellow marks indicate skipped tests (missing tool or configuration)

The script exits with code 0 on success, non-zero on failure, making it suitable for use in git hooks or CI pipelines.

**Optional molecule tests:**
```bash
./test.sh --molecule
```

This runs molecule tests for roles that have molecule scenarios configured. Requires molecule and molecule-plugins[docker] to be installed. See `MOLECULE.md` for details.

### Molecule Testing

**Molecule** provides isolated role testing in Docker containers. See `MOLECULE.md` for complete documentation.

**Quick start:**
```bash
pip install molecule molecule-plugins[docker]
ansible-galaxy collection install community.docker ansible.posix
cd roles/01_host_info
molecule test
```

**Key files per role:**
- `roles/<role>/molecule/default/molecule.yml` - Molecule configuration
- `roles/<role>/molecule/default/converge.yml` - Playbook to apply the role
- `roles/<role>/molecule/default/verify.yml` - Verification tests
- `roles/<role>/molecule/default/README.md` - Role-specific testing docs

**Test-friendly role design:**
- Roles should be flexible for testing (e.g., skip OS-specific checks when `molecule_yml` is defined)
- Use configurable variables instead of hardcoded paths (e.g., `ansible_facts_file`)
- Handle missing dependencies gracefully (skip tasks rather than fail)
- Document test requirements and assumptions

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

### Ansible Documentation - MANDATORY USAGE

**CRITICAL: Claude Code MUST use `ansible-doc` for ALL module documentation lookups. NEVER guess module parameters or syntax.**

You have **699 Ansible modules** installed locally with complete documentation. **ALWAYS** use `ansible-doc` before writing any Ansible task.

**Required workflow for writing Ansible tasks:**

1. **FIRST**: Look up the module documentation using `ansible-doc`
2. **THEN**: Write the task using the exact syntax from the documentation
3. **NEVER**: Guess parameters, assume syntax, or use outdated examples

**Essential `ansible-doc` commands:**

```bash
# List all available modules (699 modules available)
ansible-doc -l

# Search for specific modules
ansible-doc -l | grep systemd
ansible-doc -l | grep user
ansible-doc -l | grep copy

# Get detailed documentation for a specific module (REQUIRED before using module)
ansible-doc ansible.builtin.systemd
ansible-doc ansible.builtin.user
ansible-doc ansible.builtin.copy
ansible-doc ansible.builtin.file
ansible-doc ansible.builtin.lineinfile
ansible-doc ansible.builtin.template

# Collection modules (check these for community/AUR modules)
ansible-doc community.general.pacman
ansible-doc kewlfft.aur.aur
ansible-doc community.crypto.openssh_keypair

# List other plugin types
ansible-doc -t lookup -l      # Lookup plugins
ansible-doc -t callback -l    # Callback plugins
ansible-doc -t filter -l      # Filter plugins
```

**Example workflow:**

```bash
# WRONG: Writing task without checking docs
- name: Enable service
  systemd:
    name: myservice
    # Missing required parameters! Will fail!

# CORRECT: Check docs first
$ ansible-doc ansible.builtin.systemd

# Then write task with correct syntax
- name: Enable service
  ansible.builtin.systemd_service:
    name: myservice
    enabled: true
    state: started
```

**Module documentation includes:**

- **Required vs optional parameters** - Know what you MUST provide
- **Parameter types** - string, bool, list, dict, etc.
- **Default values** - What happens if you omit parameters
- **Examples** - Real working code snippets
- **Return values** - What data the module provides
- **Platform support** - Linux/Darwin/Windows compatibility
- **Version information** - When features were added/changed

**Common modules you'll use (CHECK DOCS for each):**

- `ansible.builtin.systemd_service` - Service management
- `ansible.builtin.user` - User creation/management
- `ansible.builtin.group` - Group management
- `ansible.builtin.copy` - Copy files
- `ansible.builtin.file` - File/directory operations
- `ansible.builtin.lineinfile` - Edit single lines in files
- `ansible.builtin.template` - Template files with Jinja2
- `ansible.builtin.command` - Run commands
- `ansible.builtin.shell` - Run shell commands
- `ansible.builtin.git` - Git repository operations
- `ansible.builtin.package` - Generic package management
- `community.general.pacman` - Arch Linux package manager
- `kewlfft.aur.aur` - AUR package installation

**When implementing a new role:**

```bash
# Example: Implementing role 05_systemd_services

# STEP 1: Check what systemd module can do
ansible-doc ansible.builtin.systemd_service

# STEP 2: Check if you need file operations
ansible-doc ansible.builtin.file

# STEP 3: Check if you need to symlink
ansible-doc ansible.builtin.file  # Look for 'state: link'

# STEP 4: Write tasks using documented parameters only
```

**This is NOT optional. Using ansible-doc is MANDATORY for:**

- Writing new tasks
- Modifying existing tasks
- Debugging task failures
- Understanding module capabilities
- Ensuring compatibility with your Ansible version (2.19.3)

### Assumptions to Avoid

- **Never assume it's a system/kernel/Ansible bug** - always check our configuration first
- **Never guess module syntax** - ALWAYS use `ansible-doc` first
- **Never check external documentation** for basic functionality issues - use `ansible-doc` locally first
- **Never add unnecessary become checks** - check environment configuration, not actual privilege escalation
