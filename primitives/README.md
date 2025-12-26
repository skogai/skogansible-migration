# Ansible Primitives

Reusable, atomic Ansible task files organized by the 7 core primitives pattern.

## Philosophy

**Primitives** are the atomic building blocks of Ansible automation. Every complex task can be decomposed into these 7 fundamental operations. This directory contains reusable task files that implement each primitive with a consistent interface.

**Design Principles:**

1. **Atomic** - Each primitive does one thing well
2. **Reusable** - Include from any role or playbook
3. **Namespaced** - Variable prefixes prevent conflicts (e.g., `package_`, `user_`, `file_`)
4. **Documented** - Each file has inline documentation
5. **Composable** - Combine primitives to build complex operations

## Directory Structure

```
primitives/
├── ensure_state/     # Resource existence (packages, users, services)
│   ├── package.yml
│   ├── user.yml
│   └── service.yml
├── ensure_content/   # File content management
│   ├── file_copy.yml
│   ├── line_in_file.yml
│   └── template.yml
├── query_state/      # State checking
│   └── path_exists.yml
├── sync/             # Remote resources
│   └── git_repo.yml
├── execute/          # Command execution
│   └── command.yml
└── compose/          # High-level compositions
    └── aur_setup.yml
```

## The 7 Core Primitives

### 1. ENSURE_STATE - Resource Existence

Make resources exist with specific properties.

**Examples:**

- `ensure_state/package.yml` - Ensure packages are installed/removed
- `ensure_state/user.yml` - Ensure users exist with properties
- `ensure_state/service.yml` - Ensure services are enabled/started

**Pattern:** `state=present|absent|started|stopped`

### 2. ENSURE_CONTENT - File Content Management

Make files contain specific content.

**Examples:**

- `ensure_content/file_copy.yml` - Copy files to destination
- `ensure_content/line_in_file.yml` - Ensure specific line exists
- `ensure_content/template.yml` - Template files with variables

**Pattern:** Define content source and destination

### 3. QUERY_STATE - State Checking

Discover current state before making decisions.

**Examples:**

- `query_state/path_exists.yml` - Check if path exists

**Pattern:** `stat` + `register` + `when` conditions

### 4. SYNC - Remote Resources

Clone/update remote resources.

**Examples:**

- `sync/git_repo.yml` - Clone or update git repositories

**Pattern:** Define source URL and destination

### 5. EXECUTE - Command Execution

Run arbitrary commands with proper idempotency.

**Examples:**

- `execute/command.yml` - Execute commands with `creates`/`removes` guards

**Pattern:** Command + context (chdir, creates, etc.)

### 6. COMPOSE - Task Orchestration

Combine primitives into higher-level operations.

**Examples:**

- `compose/aur_setup.yml` - Complete AUR setup using 6 primitives

**Pattern:** `include_tasks` to build complex workflows

### 7. UPDATE_CACHE / UPGRADE

Special package operations (handled by package primitive with appropriate state).

## Usage Examples

### Example 1: Install a Package

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_name: git
    package_state: present
```

### Example 2: Create a User

```yaml
- include_tasks: primitives/ensure_state/user.yml
  vars:
    user_name: aur_builder
    user_group: wheel
    user_shell: /bin/bash
    user_comment: "AUR package builder"
```

### Example 3: Ensure Line in File

```yaml
- include_tasks: primitives/ensure_content/line_in_file.yml
  vars:
    line_path: /etc/sudoers.d/11-install-aur_builder
    line_content: 'aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman'
    line_create: true
    line_mode: "0644"
    line_validate: 'visudo -cf %s'
    line_become: true
```

### Example 4: Check if Path Exists

```yaml
- include_tasks: primitives/query_state/path_exists.yml
  vars:
    path_to_check: /usr/bin/yay
    path_register_var: yay_stat

- debug:
    msg: "yay exists: {{ yay_stat.stat.exists }}"
```

### Example 5: Clone Git Repository

```yaml
- include_tasks: primitives/sync/git_repo.yml
  vars:
    git_repo: https://github.com/user/repo.git
    git_dest: /home/user/projects/repo
    git_version: main
    git_update: true
```

### Example 6: Execute Command

```yaml
- include_tasks: primitives/execute/command.yml
  vars:
    command_cmd: makepkg -si --noconfirm
    command_chdir: /home/aur_builder/yay
    command_creates: /usr/bin/yay
    command_become: true
    command_become_user: aur_builder
```

### Example 7: Composition (AUR Setup)

```yaml
# This single include handles the entire AUR setup workflow
- include_tasks: primitives/compose/aur_setup.yml
```

## Variable Naming Convention

Each primitive uses **namespaced variables** with consistent prefixes:

| Primitive | Prefix | Examples |
|-----------|--------|----------|
| Package | `package_` | `package_name`, `package_state` |
| User | `user_` | `user_name`, `user_group`, `user_shell` |
| Service | `service_` | `service_name`, `service_enabled`, `service_state` |
| File Copy | `file_` | `file_src`, `file_dest`, `file_mode` |
| Line in File | `line_` | `line_path`, `line_content`, `line_create` |
| Template | `template_` | `template_src`, `template_dest`, `template_mode` |
| Path Query | `path_` | `path_to_check`, `path_register_var` |
| Git | `git_` | `git_repo`, `git_dest`, `git_version` |
| Command | `command_` | `command_cmd`, `command_chdir`, `command_creates` |

This prevents variable name conflicts when including multiple primitives.

## Common Variables

Most primitives support these optional variables:

- `*_become: bool` - Run as root (default: false)
- `*_become_user: string` - Run as specific user
- `*_register_var: string` - Variable name for registering output

## Integration with Roles

### Before (Traditional Role Tasks)

```yaml
# roles/packages/tasks/aur_helper.yml
- name: Create aur_builder user
  become: true
  ansible.builtin.user:
    name: aur_builder
    group: wheel
    shell: /bin/bash
    # ... many parameters ...

- name: Configure sudoers
  become: true
  ansible.builtin.lineinfile:
    path: /etc/sudoers.d/11-install-aur_builder
    # ... many parameters ...

- name: Check if yay exists
  ansible.builtin.stat:
    path: /usr/bin/yay
  register: yay_stat

# ... many more tasks ...
```

### After (Using Primitives)

```yaml
# roles/packages/tasks/aur_helper.yml
- include_tasks: primitives/compose/aur_setup.yml
```

**Benefits:**

- **Less code** - Reuse instead of rewrite
- **Consistency** - Same patterns everywhere
- **Maintainability** - Fix bugs in one place
- **Testability** - Test primitives independently
- **Readability** - Clear intent

## Creating New Primitives

When creating a new primitive:

1. **Choose the right category** based on what it does
2. **Use namespaced variables** with consistent prefix
3. **Document inline** with header comment block
4. **Provide examples** in the documentation
5. **Make it atomic** - one responsibility only
6. **Use sensible defaults** via `| default(value)`
7. **Tag appropriately** for selective execution

**Template:**

```yaml
---
# Primitive: category/name
# Purpose: One-sentence description
# Usage: include_tasks with prefix_* variables
#
# Required variables:
#   prefix_var1: type - Description
#
# Optional variables:
#   prefix_var2: type - Description (default: value)
#
# Example:
#   - include_tasks: primitives/category/name.yml
#     vars:
#       prefix_var1: value

- name: "Descriptive task name"
  become: "{{ prefix_become | default(false) }}"
  ansible.builtin.module:
    param: "{{ prefix_var1 }}"
    other: "{{ prefix_var2 | default('default_value') }}"
  tags:
    - category
    - primitive
```

## Testing Primitives

Each primitive should be tested independently:

```yaml
# test_primitives.yml
- hosts: localhost
  tasks:
    # Test package installation
    - include_tasks: primitives/ensure_state/package.yml
      vars:
        package_name: git
        package_state: present

    # Test path query
    - include_tasks: primitives/query_state/path_exists.yml
      vars:
        path_to_check: /usr/bin/git
        path_register_var: git_stat

    - assert:
        that:
          - git_stat.stat.exists
        fail_msg: "Git should exist after installation"
```

## Migration Guide

To migrate existing roles to use primitives:

1. **Identify repeated patterns** in your task files
2. **Map to existing primitives** or create new ones
3. **Replace task blocks** with `include_tasks`
4. **Set variables** with appropriate prefix
5. **Test thoroughly** to ensure same behavior

## Further Reading

- **Core Concepts:** `docs/primitives/ansible-core.md` - Reference documentation with examples from this codebase
- **System Inventory:** `docs/primitives/system-inventory-by-primitives.md` - Complete system organized by primitives
- **Architecture:** Issue #91 - Primitives-based architecture adoption

## License

MIT

## Author

SkogAI (skogansible repository)
