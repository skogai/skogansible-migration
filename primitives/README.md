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
# Ansible Primitives - ensure_content

Reusable Ansible task primitives for content management operations. These primitives provide standardized, composable building blocks for managing file content across all roles.

## Architecture

Primitives follow these principles:

1. **Single Responsibility** - Each primitive does one thing well
2. **Variable Isolation** - Use prefixed variables (e.g., `template_*`, `config_*`)
3. **Composability** - Any role can include any primitive
4. **Idempotency** - Safe to run multiple times
5. **Validation** - Built-in support for content validation

## Available Primitives

### ensure_content/

Content management primitives for templates, configs, lines, and blocks.

| Primitive | Purpose | Use Case |
|-----------|---------|----------|
| `ensure_template.yml` | Deploy Jinja2 templates | Dynamic configs (sshd_config.j2, gitconfig.j2) |
| `ensure_config.yml` | Copy static config files | Static configs (pacman.conf, sudoers) |
| `ensure_line.yml` | Manage single lines in files | Environment vars, simple settings |
| `ensure_blockinfile.yml` | Manage text blocks in files | Multi-line configs, sections |

## Usage Patterns

### Template Deployment

Deploy a Jinja2 template with validation:

```yaml
- name: Deploy SSH server config
  include_tasks: priomitives/ensure_content/ensure_template.yml
  vars:
    template_src: sshd_config.j2
    template_dest: /etc/ssh/sshd_config
    template_mode: '0600'
    template_validate: 'sshd -t -f %s'
    template_become: true
    template_notify: restart sshd
```

### Config File Deployment

Copy a static configuration file:

```yaml
- name: Deploy pacman configuration
  include_tasks: primitives/ensure_content/ensure_config.yml
  vars:
    config_src: pacman.conf
    config_dest: /etc/pacman.conf
    config_mode: '0644'
    config_validate: 'pacman-conf -c %s'
    config_become: true
    config_notify: update pacman cache
```

### Line Management

Ensure a line exists in a file:

```yaml
- name: Set default editor
  include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/environment
    line_content: "EDITOR=nvim"
    line_regexp: '^EDITOR='
    line_create: true
    line_become: true
```

Remove a line from a file:

```yaml
- name: Remove deprecated setting
  include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/ssh/sshd_config
    line_content: "PermitRootLogin yes"
    line_regexp: '^PermitRootLogin'
    line_state: absent
    line_become: true
```

### Block Management

Insert a block of configuration:

```yaml
- name: Add SSH hardening block
  include_tasks: primitives/ensure_content/ensure_blockinfile.yml
  vars:
    block_path: /etc/ssh/sshd_config
    block_content: |
      # Modern crypto algorithms only
      KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
    block_marker: '# {mark} SSH HARDENING'
    block_insertafter: '^#?Port'
    block_validate: 'sshd -t -f %s'
    block_become: true
    block_notify: restart sshd
```

## Integration with Existing Roles

### SSH Role Integration

Replace inline template tasks with primitives:

**Before:**

```yaml
- name: Deploy SSH config
  ansible.builtin.template:
    src: ssh_config.j2
    dest: ~/.ssh/config
    mode: '0600'
```

**After:**

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: ssh_config.j2
    template_dest: "{{ ansible_user_dir }}/.ssh/config"
    template_mode: '0600'
```

### Git Role Integration

Replace config deployment with primitives:

**Before:**

```yaml
- name: Deploy gitconfig
  ansible.builtin.template:
    src: gitconfig.j2
    dest: ~/.gitconfig
    mode: '0644'
```

**After:**

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: gitconfig.j2
    template_dest: "{{ ansible_user_dir }}/.gitconfig"
    template_mode: '0644'
```

### Packages Role Integration

Replace sudoers management with primitives:

**Before:**

```yaml
- name: Allow the aur_builder user to run sudo pacman without a password
  become: true
  ansible.builtin.lineinfile:
    path: /etc/sudoers.d/11-install-aur_builder
    line: 'aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman'
    create: true
    mode: '0644'
    validate: 'visudo -cf %s'
```m

**After:**

```yaml
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/sudoers.d/11-install-aur_builder
    line_content: 'aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman'
    line_create: true
    line_mode: '0644'
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
## Validation Support

All primitives support validation via the `*_validate` parameter. The validation command is run before the file is moved to its final location.

### Common Validation Commands

| Config Type | Validation Command |
|-------------|-------------------|
| SSH server | `sshd -t -f %s` |
| SSH client | `ssh -G -F %s localhost` |
| Sudoers | `visudo -cf %s` |
| Pacman | `pacman-conf -c %s` |
| Nginx | `nginx -t -c %s` |
| Apache | `apachectl -t -f %s` |
| YAML | `python3 -c 'import yaml; yaml.safe_load(open("%s"))'` |
| JSON | `python3 -c 'import json; json.load(open("%s"))'` |

## Handler Integration

Primitives support automatic handler notification via the `*_notify` parameter:

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: sshd_config.j2
    template_dest: /etc/ssh/sshd_config
    template_mode: '0600'
    template_notify: restart sshd  # Handler called only if changed
```

Common handlers are defined in `primitives/handlers/main.yml`:

- `reload systemd`
- `restart sshd`
- `reload sshd`
- `restart NetworkManager`
- `update pacman cache`
- `reload X11`
- `reload shell profile`

## Variable Reference

### ensure_template.yml

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `template_src` | Yes | - | Source template file (relative to templates/) |
| `template_dest` | Yes | - | Destination path |
| `template_owner` | No | current user | File owner |
| `template_group` | No | user's group | File group |
| `template_mode` | No | `'0644'` | File permissions |
| `template_backup` | No | `false` | Create backup before overwrite |
| `template_validate` | No | - | Validation command (%s = temp file) |
| `template_become` | No | `false` | Run with sudo |
| `template_notify` | No | - | Handler to notify on change |

### ensure_config.yml

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `config_src` | Yes | - | Source config file (relative to files/) |
| `config_dest` | Yes | - | Destination path |
| `config_owner` | No | current user | File owner |
| `config_group` | No | user's group | File group |
| `config_mode` | No | `'0644'` | File permissions |
| `config_backup` | No | `false` | Create backup before overwrite |
| `config_validate` | No | - | Validation command (%s = temp file) |
| `config_become` | No | `false` | Run with sudo |
| `config_notify` | No | - | Handler to notify on change |
| `config_force` | No | `true` | Force overwrite if exists |

### ensure_line.yml

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `line_path` | Yes | - | Path to file |
| `line_content` | Yes | - | Line content |
| `line_state` | No | `'present'` | `present` or `absent` |
| `line_regexp` | No | - | Regex to match line for replacement |
| `line_insertafter` | No | EOF | Insert after this regex |
| `line_insertbefore` | No | - | Insert before this regex |
| `line_backrefs` | No | `false` | Use backreferences |
| `line_create` | No | `false` | Create file if missing |
| `line_owner` | No | current user | File owner |
| `line_group` | No | user's group | File group |
| `line_mode` | No | `'0644'` | File permissions |
| `line_backup` | No | `false` | Create backup |
| `line_validate` | No | - | Validation command |
| `line_become` | No | `false` | Run with sudo |

### ensure_blockinfile.yml

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `block_path` | Yes | - | Path to file |
| `block_content` | Yes | - | Block content (multi-line string) |
| `block_state` | No | `'present'` | `present` or `absent` |
| `block_marker` | No | `'# {mark} ANSIBLE MANAGED BLOCK'` | Marker template |
| `block_marker_begin` | No | `'BEGIN'` | Beginning marker |
| `block_marker_end` | No | `'END'` | Ending marker |
| `block_insertafter` | No | EOF | Insert after this regex |
| `block_insertbefore` | No | - | Insert before this regex |
| `block_create` | No | `false` | Create file if missing |
| `block_owner` | No | current user | File owner |
| `block_group` | No | user's group | File group |
| `block_mode` | No | `'0644'` | File permissions |
| `block_backup` | No | `false` | Create backup |
| `block_validate` | No | - | Validation command |
| `block_become` | No | `false` | Run with sudo |

## Best Practices

### 1. Use Validation When Available

Always use validation for critical system configs:

```yaml
# GOOD
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: sshd_config.j2
    template_dest: /etc/ssh/sshd_config
    template_validate: 'sshd -t -f %s'  # Prevents broken SSH

# BAD
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: sshd_config.j2
    template_dest: /etc/ssh/sshd_config
    # No validation - risky!
```

### 2. Use Handlers for Service Restarts

Let handlers manage service restarts to avoid unnecessary restarts:

```yaml
# GOOD
- include_tasks: primitives/ensure_content/ensure_config.yml
  vars:
    config_src: nginx.conf
    config_dest: /etc/nginx/nginx.conf
    config_notify: restart nginx  # Only restarts if changed

# BAD
- include_tasks: primitives/ensure_content/ensure_config.yml
  vars:
    config_src: nginx.conf
    config_dest: /etc/nginx/nginx.conf
- systemd:
    name: nginx
    state: restarted  # Always restarts, even if unchanged
```

### 3. Use Regexp for Replaceable Lines

Use `line_regexp` to make line updates idempotent:

```yaml
# GOOD
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/environment
    line_content: "EDITOR=nvim"
    line_regexp: '^EDITOR='  # Replaces existing EDITOR line

# BAD
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/environment
    line_content: "EDITOR=nvim"
    # No regexp - could create duplicate lines
```

### 4. Use Blocks for Multi-Line Sections

Use `ensure_blockinfile` instead of multiple `ensure_line` calls:

```yaml
# GOOD
- include_tasks: primitives/ensure_content/ensure_blockinfile.yml
  vars:
    block_path: ~/.bashrc
    block_content: |
      export EDITOR=nvim
      export VISUAL=nvim
      export PAGER=bat

# BAD
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: ~/.bashrc
    line_content: "export EDITOR=nvim"
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: ~/.bashrc
    line_content: "export VISUAL=nvim"
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: ~/.bashrc
    line_content: "export PAGER=bat"
```

## Debugging

All primitives include debug output at verbosity level 1:

```bash
# Run with verbose output to see primitive results
ansible-playbook playbook.yml -v
```

Output example:

```
TASK [Primitive | Deploy template sshd_config.j2 to /etc/ssh/sshd_config] ****
changed: [localhost]

TASK [Primitive | Template deployment result] *********************************
ok: [localhost] => {
    "msg": "Template sshd_config.j2 deployed to /etc/ssh/sshd_config - Changed: true"
}
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
Test primitives in isolation before integrating:

```yaml
---
- name: Test ensure_template primitive
  hosts: localhost
  tasks:
    - include_tasks: primitives/ensure_content/ensure_template.yml
      vars:
        template_src: test_config.j2
        template_dest: /tmp/test_config
        template_mode: '0644'
```

## Further Reading

- [ansible-core.md](../docs/primitives/ansible-core.md) - Core Ansible primitive patterns
- [system-inventory-by-primitives.md](../docs/primitives/system-inventory-by-primitives.md) - System automation roadmap
- [Ansible lineinfile module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html)
- [Ansible blockinfile module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/blockinfile_module.html)
- [Ansible template module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
- [Ansible copy module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html)

## Contributing

When adding new primitives:

1. Follow the variable naming convention (`primitive_*`)
2. Include comprehensive inline documentation
3. Provide usage examples in comments
4. Add debug output at verbosity 1
5. Update this README with integration examples
6. Test in isolation before committing

---

**Phase 2 Status:** ✅ Completed - All ensure_content primitives extracted and documented

**Next Phase:** Phase 3 - Extract ensure_state primitives (users, services, packages)
