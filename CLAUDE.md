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

Primary Ansible configuration in repository root:

- **Collections path**: `~/.ansible/.collections` - Custom collection installation location
- **Fact caching**: Uses `community.general.yaml` backend with cache at `~/.ansible/.cache`
- **Inventory**: References `.hosts` file in repository root
- **Roles path**: `roles/` directory (relative to where ansible is executed)
- **Working directories**: `/tmp/.ansible` for both local and remote temporary files
- **Privilege escalation**: Configured via environment variables (see "Privilege Escalation" section)

### .envrc

Manages environment through direnv - sources `.env` and exports additional configuration.

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
- **Environment**: Environment variables are loaded via `.envrc` (uses direnv) which sources `.env`
- **Force handlers**: Enabled globally (`force_handlers = true`) - handlers run even when tasks fail
- **Diff mode**: Always enabled (`always = yes`) - shows file changes before applying
- **Color output**: Forced on (`force_color = true`) for better readability

---

## Common Problems and Solutions

### Checking Sudo/Privilege Access

If privileged tasks fail during playbook execution, check the following:

1. **Wrong directory**: Ensure you're in the correct directory where `.envrc` can be loaded
2. **Environment not sourced**: Your `.env` or `.envrc` files may not be properly sourced
3. **Missing sudo access**: You may not have appropriate sudo privileges configured

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

### Privilege Escalation

If a playbook aborts due to privilege issues, one of these is true:

1. **You should not run it** - The playbook requires privileges you don't have
2. **Wrong directory** - You're not in the correct folder (should be in repository root)
3. **Environment not loaded** - `.direnv` or `.env` is broken - ask the user to:
   - Run `direnv allow` to enable direnv
   - Source the file manually: `source .env`
   - Check that required environment variables are set
4. **You should not run it** - The task genuinely requires different permissions

**Environment variables needed** (set in `.env`):
- `ANSIBLE_BECOME_PASSWORD_FILE` - Path to file containing become password
- `ANSIBLE_VAULT_PASSWORD_FILE` - Path to file containing vault password

Ansible will use these environment variables automatically when they're set.

### Running Playbooks

**Available Playbooks:**

1. **`playbooks/all.yml`** - Original numbered roles (01-07) for sequential setup
   ```bash
   ./run.sh
   # or explicitly:
   ./run.sh playbooks/all.yml
   ```

2. **`playbooks/site.yml`** - NEW: Unified playbook with all roles
   ```bash
   # Run everything
   ./run.sh playbooks/site.yml

   # Run only numbered roles
   ./run.sh playbooks/site.yml -e numbered=true -e named=false

   # Run specific tags
   ./run.sh playbooks/site.yml --tags dotfiles,ssh
   ```

3. **`playbooks/skogai.yml`** - NEW: Comprehensive Arch Linux setup
   ```bash
   ./run.sh playbooks/skogai.yml
   ```

4. **`playbooks/update.yml`** - NEW: Quick system maintenance
   ```bash
   ./run.sh playbooks/update.yml
   ```

**Usage:** `./run.sh [playbook] [ansible-playbook options]`
- Defaults to `playbooks/all.yml` if no playbook specified
- Passes all additional arguments directly to ansible-playbook
- Relies on environment variables from `.env` (loaded via `.envrc`)

**For Claude Code:** Always run playbooks in background mode:
```bash
./run.sh  # with run_in_background: true
```

Then check output with `BashOutput` tool. This prevents long-running package installations from blocking the CLI.

### Pre-commit Hooks

**Automated testing before every commit** using pre-commit hooks:

```bash
# Install pre-commit (one-time setup)
pip install pre-commit

# Install hooks in the repository (one-time setup)
pre-commit install

# Hooks now run automatically on every commit
# To bypass hooks if needed: git commit --no-verify
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

This additionally runs Ansible in check mode (dry-run) to verify your changes would work on the target system without actually making changes.

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
3. No password prompts, no errors

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
./test.sh --check
```

**Note:** The test.sh script performs static analysis only by default. It does NOT execute the playbook unless --check flag is used.

### Assumptions to Avoid

- **Never assume it's a system/kernel/Ansible bug** - always check our configuration first
- **Never check external documentation** for basic functionality issues - investigate locally first
