# Ansible Primitives

Reusable, atomic Ansible task files that serve as building blocks for roles and playbooks.

## Overview

Primitives are small, focused task files that perform single operations. They follow a consistent interface pattern using prefixed variables to avoid naming conflicts.

### Design Principles

1. **Single Responsibility** - Each primitive does one thing well
2. **Variable Isolation** - All variables are prefixed with the primitive name
3. **Idempotent** - Safe to run multiple times
4. **Composable** - Can be combined to build complex operations
5. **Well-documented** - Each file includes usage examples

## Categories

### ensure_state/

Primitives for ensuring resources exist in a desired state.

| Primitive | Purpose | Key Variables |
|-----------|---------|---------------|
| `directory.yml` | Directory creation with permissions | `directory_path`, `directory_mode` |
| `file.yml` | File state management | `file_path`, `file_state`, `file_mode` |
| `package.yml` | Package installation | `package_names`, `package_state` |
| `service.yml` | Service management | `service_name`, `service_state`, `service_enabled` |

## Usage Pattern

All primitives follow this pattern:

```yaml
- name: Example task
  include_tasks: primitives/ensure_state/directory.yml
  vars:
    directory_path: /path/to/dir
    directory_mode: '0755'
```

### Variable Naming Convention

Variables use a consistent prefix based on the primitive name:

- `directory_*` for directory.yml
- `file_*` for file.yml
- `package_*` for package.yml
- `service_*` for service.yml

This prevents variable name collisions when composing multiple primitives.

## Examples

### Create SSH Directory

```yaml
- name: Ensure .ssh directory exists
  include_tasks: primitives/ensure_state/directory.yml
  vars:
    directory_path: "{{ ansible_user_dir }}/.ssh"
    directory_mode: '0700'
```

### Install Package

```yaml
- name: Install git
  include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: git
    package_state: present
    package_update_cache: true
```

### Manage Service

```yaml
- name: Ensure sshd is running
  include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: sshd
    service_state: started
    service_enabled: true
```

### Copy Configuration File

```yaml
- name: Deploy SSH config
  include_tasks: primitives/ensure_state/file.yml
  vars:
    file_path: "{{ ansible_user_dir }}/.ssh/config"
    file_src: files/ssh_config
    file_mode: '0600'
```

## Composing Primitives

Primitives can be combined to create more complex operations:

```yaml
# Setup SSH infrastructure
- name: Create SSH directory
  include_tasks: primitives/ensure_state/directory.yml
  vars:
    directory_path: "{{ ansible_user_dir }}/.ssh"
    directory_mode: '0700'

- name: Deploy SSH config
  include_tasks: primitives/ensure_state/file.yml
  vars:
    file_path: "{{ ansible_user_dir }}/.ssh/config"
    file_src: templates/ssh_config.j2
    file_mode: '0600'

- name: Start SSH agent
  include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: ssh-agent
    service_state: started
```

## Converting Existing Roles to Primitives

When refactoring existing roles to use primitives:

1. **Identify atomic operations** - Find tasks that can be extracted
2. **Map to primitives** - Determine which primitive fits each operation
3. **Extract variables** - Rename variables to use primitive prefixes
4. **Replace with include_tasks** - Call primitives instead of inline tasks
5. **Test thoroughly** - Ensure behavior is preserved

### Example: Before and After

**Before (inline tasks):**

```yaml
- name: Create config directory
  ansible.builtin.file:
    path: /etc/myapp
    state: directory
    mode: '0755'

- name: Install myapp package
  become: true
  community.general.pacman:
    name: myapp
    state: present
```

**After (using primitives):**

```yaml
- name: Create config directory
  include_tasks: primitives/ensure_state/directory.yml
  vars:
    directory_path: /etc/myapp
    directory_mode: '0755'

- name: Install myapp package
  include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: myapp
    package_state: present
```

## Benefits

1. **DRY (Don't Repeat Yourself)** - Common operations in one place
2. **Consistency** - Same interface across all roles
3. **Testing** - Test primitives once, use everywhere
4. **Maintenance** - Fix bugs in one place
5. **Documentation** - Self-documenting through examples

## Reference

- See individual primitive files for detailed usage documentation
- See `docs/primitives/ansible-core.md` for core Ansible patterns
- See role READMEs for examples of primitive usage

## Future Primitives

Additional primitive categories planned:

- `ensure_content/` - File content management (lineinfile, template)
- `query_state/` - State checking (stat, file tests)
- `sync/` - Remote synchronization (git, rsync)
- `execute/` - Command execution (command, shell, script)

---

**Created:** 2025-12-26
**Source:** Extracted from dotfile-ansible architecture patterns
