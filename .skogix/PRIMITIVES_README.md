---
# Ansible Primitives Architecture

## Philosophy

At scale (hundreds of components, multiple machines), traditional Ansible role patterns break down:
- Every component reinvents basic operations
- No consistency across components
- Hard to maintain, hard to test, hard to understand

**Solution:** Extract all Ansible operations into 7 core primitives. Components become simple compositions of these primitives.

---

## The 7 Primitives

### 1. ENSURE_STATE
Make resources exist with specific properties

**Primitives:**
- `primitives/ensure_state/package.yml` - Install/remove packages
- `primitives/ensure_state/user.yml` - Create/modify users
- `primitives/ensure_state/directory.yml` - Ensure directories exist
- `primitives/ensure_state/file.yml` - File state management
- `primitives/ensure_state/service.yml` - Systemd service state

**Example:**
```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: [git, vim, curl]
    package_state: present
```

### 2. ENSURE_CONTENT
Make files contain specific content

**Primitives:**
- `primitives/ensure_content/file_copy.yml` - Copy file content
- `primitives/ensure_content/line_in_file.yml` - Ensure line exists
- `primitives/ensure_content/template.yml` - Template rendering

**Example:**
```yaml
- include_tasks: primitives/ensure_content/file_copy.yml
  vars:
    file_src: files/etc/ssh/sshd_config
    file_dest: /etc/ssh/sshd_config
    file_mode: '0600'
```

### 3. QUERY_STATE
Check current state before making decisions

**Primitives:**
- `primitives/query_state/path_exists.yml` - Check if path exists
- `primitives/query_state/command.yml` - Check command output
- `primitives/query_state/package.yml` - Check package installation

**Example:**
```yaml
- include_tasks: primitives/query_state/path_exists.yml
  vars:
    query_path: /usr/bin/yay
    query_register: yay_exists
```

### 4. SYNC
Synchronize remote resources

**Primitives:**
- `primitives/sync/git_repo.yml` - Clone/update git repos
- `primitives/sync/archive.yml` - Download/extract archives

**Example:**
```yaml
- include_tasks: primitives/sync/git_repo.yml
  vars:
    repo_url: https://github.com/zplug/zplug
    repo_dest: "{{ ansible_user_dir }}/zsh.d/.zplug"
```

### 5. EXECUTE
Run arbitrary commands

**Primitives:**
- `primitives/execute/command.yml` - Run command
- `primitives/execute/shell.yml` - Run shell script
- `primitives/execute/script.yml` - Run script file

**Example:**
```yaml
- include_tasks: primitives/execute/command.yml
  vars:
    exec_command: udevadm control --reload-rules
    exec_become: true
```

### 6. COMPOSE
High-level compositions of primitives

**Primitives:**
- `primitives/compose/aur_setup.yml` - Complete AUR setup
- `primitives/compose/ssh_deploy.yml` - Deploy SSH keys
- `primitives/compose/systemd_unit.yml` - Create systemd unit

**Example:**
```yaml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: [neovim-git, yay, spotify]
```

### 7. UPDATE_CACHE
Package database operations

**Primitives:**
- Built into `ensure_state/package.yml` via flags

**Example:**
```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: []
    package_update_cache: true
```

---

## Architecture Layers

```
┌─────────────────────────────────────────────┐
│  PLAYBOOKS (Orchestration)                  │
│  - disaster_recovery.yml                    │
│  - workstation.yml                          │
│  - server.yml                               │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  COMPONENTS (Feature Bundles)               │
│  - base-system/                             │
│  - desktop-environment/                     │
│  - development-tools/                       │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  PRIMITIVES/COMPOSE (High-level patterns)   │
│  - aur_setup.yml                            │
│  - ssh_deploy.yml                           │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  PRIMITIVES (Core operations)               │
│  - ensure_state/                            │
│  - ensure_content/                          │
│  - query_state/                             │
│  - sync/                                    │
│  - execute/                                 │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  DATA (Configuration)                       │
│  - data/packages.yml                        │
│  - data/users.yml                           │
│  - data/services.yml                        │
│  - files/etc/...                            │
└─────────────────────────────────────────────┘
```

---

## Data/Logic Separation

### Data Layer (YAML files)
**What:** Lists of things (packages, users, services, config files)
**Where:** `data/*.yml`, `files/*`
**Changes:** Frequently (add packages, update configs)

**Example:**
```yaml
# data/packages.yml
official_packages:
  - git
  - vim
  - docker
```

### Logic Layer (Primitives)
**What:** How to process data (install package, create user, copy file)
**Where:** `primitives/*/`
**Changes:** Rarely (primitives are stable)

**Example:**
```yaml
# primitives/ensure_state/package.yml
- name: "Install packages"
  community.general.pacman:
    name: "{{ package_names }}"
    state: "{{ package_state }}"
```

### Composition Layer (Components)
**What:** Wire primitives together for specific features
**Where:** `components/*/`, `primitives/compose/`
**Changes:** Occasionally (new features, refactoring)

**Example:**
```yaml
# components/development-tools/tasks/main.yml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: "{{ dev_packages }}"

- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: "{{ dev_aur_packages }}"
```

---

## Benefits at Scale

### Consistency
**Problem:** 200 components × unique implementations = chaos
**Solution:** All components use same 7 primitives

### Discoverability
**Problem:** "How does this component install packages?"
**Solution:** `ls primitives/ensure_state/` → "These are the ways"

### Testability
**Problem:** Testing 200 unique implementations
**Solution:** Test 7 primitives thoroughly, test components minimally

### Maintainability
**Problem:** Need to add logging to all package installations
**Solution:** Update one primitive, affects all components

### Composability
**Problem:** Building new components requires reinventing the wheel
**Solution:** Wire up primitives, done in minutes

---

## Usage Patterns

### Simple Component (Direct primitive usage)
```yaml
# components/neovim/tasks/main.yml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: [neovim-git]
```

### Medium Component (Multiple primitives)
```yaml
# components/ssh/tasks/main.yml
- include_tasks: primitives/ensure_state/directory.yml
  vars:
    directory_path: "{{ ansible_user_dir }}/.ssh"
    directory_mode: '0700'

- include_tasks: primitives/ensure_content/file_copy.yml
  vars:
    file_src: "{{ ssh_private_key }}"
    file_dest: "{{ ansible_user_dir }}/.ssh/id_ed25519"
    file_mode: '0600'

- include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: sshd.service
    service_enabled: true
```

### Complex Component (Custom composition)
```yaml
# components/database/tasks/main.yml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: [postgresql]

- include_tasks: primitives/ensure_state/user.yml
  vars:
    user_name: postgres
    user_system: true

- include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: postgresql.service
    service_enabled: true

- include_tasks: primitives/execute/command.yml
  vars:
    exec_command: "psql -c 'CREATE DATABASE mydb'"
    exec_user: postgres
```

---

## Variable Naming Convention

All primitives use **prefixed variables** to avoid namespace collisions:

```yaml
# Package primitive
package_names: [...]
package_state: present
package_update_cache: false

# User primitive
user_name: skogix
user_password: "..."
user_shell: /bin/zsh

# File primitive
file_src: files/config
file_dest: /etc/config
file_mode: '0644'
```

This makes it clear which primitive a variable belongs to when reading composed tasks.

---

## Creating New Primitives

When you need a new primitive:

1. **Ask:** Is this a variation of an existing primitive?
   - Yes → Add parameters to existing primitive
   - No → Create new primitive

2. **Structure:**
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
#   - include_tasks: primitives/...
#     vars:
#       var_name: value

- name: "Primitive | [Clear description]"
  module.name:
    param: "{{ var_name }}"
    param2: "{{ var_name2 | default('default') }}"
```

3. **Test:** Create example playbook in `examples/primitives/`

4. **Document:** Update this README

---

## Directory Structure

```
dotfile-ansible/
├── primitives/              # Core operations (7 categories)
│   ├── ensure_state/        # Resource existence
│   ├── ensure_content/      # File content
│   ├── query_state/         # State checking
│   ├── sync/                # Remote resources
│   ├── execute/             # Command execution
│   └── compose/             # High-level patterns
│
├── data/                    # Configuration data
│   ├── packages.yml         # Package lists
│   ├── users.yml            # User definitions
│   ├── services.yml         # Service lists
│   ├── config_files.yml     # File mappings
│   └── secrets.yml          # Vaulted secrets
│
├── files/                   # Static files to deploy
│   ├── etc/                 # System configs
│   ├── systemd/             # Systemd units
│   └── udev/                # Udev rules
│
├── components/              # Feature bundles
│   ├── base-system/
│   ├── desktop/
│   └── development/
│
├── playbooks/               # Orchestration
│   ├── disaster_recovery.yml
│   ├── workstation.yml
│   └── server.yml
│
└── examples/                # Usage examples
    └── primitives/          # Primitive examples
```

---

## Next Steps

1. **Populate data files:** Copy all 477 packages, 67 AUR packages, etc. into data/*.yml
2. **Copy config files:** Move all files from backup into files/ directory
3. **Test primitives:** Run each primitive individually to verify
4. **Test disaster recovery:** Run in VM/container before production
5. **Create machine-specific playbooks:** workstation.yml, server.yml, etc.
6. **Build components:** Extract common patterns into reusable components

---

## FAQ

**Q: Why not just use roles?**
A: Roles are great for distribution but bad for internal consistency at scale. Primitives enforce consistency.

**Q: Isn't this just overengineering?**
A: For 10 components, yes. For 100+ components across 5-10 machines, this prevents chaos.

**Q: Do I need all 7 primitive categories?**
A: Start with what you need. You'll naturally discover the others as you build.

**Q: Can primitives call other primitives?**
A: Yes! That's what compose/ is for. Build higher-level primitives from lower-level ones.

**Q: What about idempotency?**
A: Ansible modules are idempotent by default. Primitives preserve this.

**Q: How do I handle secrets?**
A: Use data/secrets.yml with ansible-vault. Pass as vars to primitives.

---

**Last Updated:** 2025-12-16
**Status:** Architecture defined, examples created
**Next:** Populate data files and test
