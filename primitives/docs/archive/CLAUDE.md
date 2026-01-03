# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Ansible configuration for bootstrapping and maintaining Arch Linux development environments using a **primitives-based architecture** that scales to hundreds of components across multiple machines.

## Core Architecture

### Primitives System (The Foundation)

All Ansible operations are extracted into **7 core primitive categories** located in `primitives/`:

1. **ensure_state/** - Resource existence (packages, users, directories, services)
2. **ensure_content/** - File content management (copy, templates, line-in-file)
3. **query_state/** - State checking before decisions
4. **sync/** - Remote resource synchronization (git repos, archives)
5. **execute/** - Command execution (command, shell, script)
6. **compose/** - High-level compositions of other primitives
7. **update_cache/** - Package database operations (built into package.yml)

**Key principle:** Components never implement Ansible operations directly - they compose primitives using `include_tasks`.

### Variable Naming Convention

All primitives use **prefixed variables** to avoid namespace collisions:

```yaml
# Package primitive
package_names: [git, vim]
package_state: present
package_update_cache: false

# User primitive
user_name: skogix
user_shell: /bin/zsh

# File primitive
file_src: files/config
file_dest: /etc/config
file_mode: '0644'
```

### Data/Logic Separation

**Data Layer** (`data/*.yml`): Lists of things (packages, users, services, config files)

- Changes frequently
- No Ansible logic

**Logic Layer** (`primitives/*/`): How to process data

- Changes rarely
- Stable, tested primitives

**Composition Layer** (`components/*/`, `primitives/compose/`): Wire primitives together

- Changes occasionally
- Feature implementations

## Directory Structure

```
dotfile-ansible/
├── primitives/              # Core operations (7 categories)
│   ├── ensure_state/        # package.yml, user.yml, service.yml
│   ├── ensure_content/      # file_copy.yml, line_in_file.yml
│   ├── compose/             # aur_setup.yml, ssh_deploy.yml
│   └── ...
├── data/                    # Configuration data (YAML lists)
│   ├── packages.yml         # Official packages (477 packages)
│   ├── aur_packages.yml     # AUR packages (67 packages)
│   ├── users.yml
│   ├── services.yml
│   └── secrets.yml          # Vaulted secrets
├── components/              # Feature bundles
│   └── ssh-role/            # Example: complete SSH management component
├── playbooks/               # Orchestration
│   └── disaster_recovery.yml
├── skogix.yml               # Main playbook (skogix user)
└── skogai.yml               # Alternative playbook
```

## Development Setup

### Prerequisites

```bash
# Install dependencies
sudo pacman -S python-uv uv

# Create virtual environment
uv venv --seed --python 3.13

# Install Ansible
uv pip install ansible ansible-core

# Activate environment
direnv allow  # or: source .venv/bin/activate
```

### Required Environment Variables

- `$ANSIBLE_BECOME_PASSWORD_FILE` - Points to become password file (usually `~/.ssh/ansible-become-password`)
- `$ANSIBLE_VAULT_PASSWORD_FILE` - Points to vault password file (usually `~/.ssh/ansible-vault-password`)

### Running Playbooks

```bash
# Main playbook
ansible-playbook skogix.yml

# Disaster recovery
ansible-playbook playbooks/disaster_recovery.yml

# Test single primitive
ansible-playbook -c local localhost -m include_tasks -a "file=primitives/ensure_state/package.yml" -e "package_names=[git,vim] package_state=present"
```

## Creating New Components

### Simple Component (Direct primitive usage)

```yaml
# components/neovim/tasks/main.yml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: [neovim-git]
```

### Medium Component (Multiple primitives)

```yaml
# components/myfeature/tasks/main.yml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: [git, vim]
    package_state: present

- include_tasks: primitives/ensure_content/file_copy.yml
  vars:
    file_src: files/myconfig
    file_dest: /etc/myconfig
    file_mode: '0644'
```

### Complex Component (See ssh-role)

Study `components/ssh-role/` for a complete example that demonstrates:

- Conditional blocks (`when:`)
- Multiple primitive compositions
- Vault integration for secrets
- Backup and encryption workflows
- Template usage

## Working with Primitives

### Key Files to Understand

1. **primitives/ensure_state/package.yml** - Basic package installation
   - Uses `community.general.pacman` module
   - Requires `become: true` (handled automatically)
   - Variables: `package_names`, `package_state`, `package_update_cache`

2. **primitives/compose/aur_setup.yml** - Complete AUR setup
   - Creates `aur_builder` user
   - Installs AUR helper (yay/paru)
   - Installs AUR packages
   - Variables: `aur_builder_user`, `aur_helper`, `aur_packages_to_install`

3. **components/ssh-role/** - Full-featured component example
   - Demonstrates all primitive composition patterns
   - See `components/ssh-role/examples/*.yml` for usage patterns

### When to Create New Primitives

**Add parameters to existing primitive if:**

- The operation is a variation of existing functionality
- Can be expressed through additional variables

**Create new primitive if:**

- Fundamentally different operation
- Would clutter existing primitive with unrelated logic
- Reusable across multiple components

### Primitive Structure Template

```yaml
---
# Primitive: [Name]
# Usage: include_tasks primitives/[category]/[name].yml
#
# Required vars:
#   var_name: description
#
# Optional vars:
#   var_name: description (default: value)
#
# Example:
#   - include_tasks: primitives/[category]/[name].yml
#     vars:
#       var_name: value

- name: "Primitive | [Clear description]"
  module.name:
    param: "{{ var_name }}"
    param2: "{{ var_name2 | default('default') }}"
```

## Common Patterns

### Pattern: Install packages from data file

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: "{{ official_packages }}"
    package_state: present
```

### Pattern: Conditional primitive execution

```yaml
- include_tasks: primitives/ensure_state/service.yml
  when: service_enabled | default(false)
  vars:
    service_name: sshd
    service_enabled: true
```

### Pattern: Loop over data with primitives

```yaml
- include_tasks: primitives/ensure_content/file_copy.yml
  loop: "{{ config_files }}"
  vars:
    file_src: "{{ item.src }}"
    file_dest: "{{ item.dest }}"
    file_mode: "{{ item.mode }}"
```

## Security Considerations

### Ansible Become (`become: true`)

- Abstracted in primitives - **never visible to component implementations**
- Pre-configured at infrastructure level
- All primitives requiring privilege escalation include `become: true`
- Password provided via `$ANSIBLE_BECOME_PASSWORD_FILE`

### Vault Usage

- Secrets stored in `data/secrets.yml` (vaulted)
- SSH keys in `vars/ssh_keys.yml` (vaulted)
- Decrypt with: `ansible-vault decrypt file.yml --vault-password-file ~/.ssh/ansible-vault-password`
- Encrypt with: `ansible-vault encrypt file.yml --vault-password-file ~/.ssh/ansible-vault-password`

### Philosophy: Isolation Over Policy Enforcement

The system enforces ~20 critical functions correctly, then provides users isolated environments (home folders) where mistakes become self-contained rather than systemic issues. Security through compartmentalization, not comprehensive policy enforcement.

## References

- **PRIMITIVES_README.md** - Detailed primitives architecture documentation
- **COMPONENT_BREAKDOWN.md** - Technical details of existing components
- **components/ssh-role/examples/** - Usage examples for SSH role
- **README.md** - Setup instructions and prerequisites

## Development Philosophy

- **Consistency:** All components use same 7 primitives
- **Discoverability:** `ls primitives/` shows all available operations
- **Testability:** Test primitives thoroughly, components minimally
- **Composability:** Wire primitives together, done in minutes
- **Data/Logic Separation:** Data changes frequently, primitives rarely

**Scale target:** Designed for hundreds of components across 5-10 machines, not 10 components.

---

Last updated: 2025-12-18
