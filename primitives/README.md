# Ansible Primitives

Reusable, atomic Ansible task files organized into 7 categories.

## Philosophy

At scale, traditional Ansible role patterns break down. **Primitives** are the solution: atomic, reusable operations that all components compose together.

**Benefits:**

- **Consistency** - All components use the same operations
- **Discoverability** - `ls primitives/` shows all available operations
- **Testability** - Test primitives once, trust everywhere
- **Maintainability** - Update one primitive, affects all components
- **Composability** - Build new features by wiring primitives together

## The 7 Primitive Categories

### 1. ensure_state/ - Make Resources Exist

Make resources exist with specific properties (packages, users, services, directories).

**Primitives:**

- `package.yml` - Install/remove packages via pacman
- `user.yml` - Create/modify users
- `directory.yml` - Ensure directories exist
- `service.yml` - Manage systemd services

**Example:**

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: [git, vim, curl]
    package_state: present
    package_update_cache: true
```

### 2. ensure_content/ - Make Files Contain Content

Make files contain specific content (copy files, manage lines, templates).

**Primitives:**

- `file_copy.yml` - Copy file content
- `line_in_file.yml` - Ensure line exists in file
- `template.yml` - Template rendering

**Example:**

```yaml
- include_tasks: primitives/ensure_content/line_in_file.yml
  vars:
    line_path: /etc/sudoers.d/aur_builder
    line_content: 'aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman'
    line_create: true
    line_mode: '0644'
    line_validate: 'visudo -cf %s'
```

### 3. query_state/ - Check Current State

Check current state before making decisions (path existence, command output).

**Primitives:**

- `path_exists.yml` - Check if path exists
- `command.yml` - Query command output

**Example:**

```yaml
- include_tasks: primitives/query_state/path_exists.yml
  vars:
    query_path: /usr/bin/yay
    query_register: yay_exists

- debug:
    msg: "Yay is {{ 'installed' if yay_exists.stat.exists else 'not installed' }}"
```

### 4. sync/ - Synchronize Remote Resources

Synchronize remote resources (git repos, archives).

**Primitives:**

- `git_repo.yml` - Clone/update git repositories

**Example:**

```yaml
- include_tasks: primitives/sync/git_repo.yml
  vars:
    repo_url: https://github.com/zplug/zplug
    repo_dest: "{{ ansible_user_dir }}/zsh.d/.zplug"
    repo_version: master
```

### 5. execute/ - Run Commands

Run arbitrary commands when other primitives don't fit.

**Primitives:**

- `command.yml` - Run command
- `shell.yml` - Run shell script

**Example:**

```yaml
- include_tasks: primitives/execute/command.yml
  vars:
    exec_command: "makepkg -si --noconfirm"
    exec_chdir: /tmp/build
    exec_creates: /usr/bin/yay
    exec_become: true
    exec_become_user: aur_builder
```

### 6. compose/ - High-Level Compositions

Complex operations composed from other primitives.

**Primitives:**

- `aur_setup.yml` - Complete AUR infrastructure setup

**Example:**

```yaml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: [neovim-git, yay, spotify]
```

### 7. Package Cache Management

Built into `ensure_state/package.yml` via flags:

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: []
    package_update_cache: true
    package_upgrade: true
```

## Variable Naming Convention

All primitives use **prefixed variables** to avoid namespace collisions:

```yaml
# Package primitives
package_names: [...]
package_state: present
package_update_cache: false

# User primitives
user_name: skogix
user_password: "..."
user_shell: /bin/zsh

# File primitives
file_src: files/config
file_dest: /etc/config
file_mode: '0644'

# Query primitives
query_path: /usr/bin/yay
query_register: result_var

# Execute primitives
exec_command: "..."
exec_become: true
exec_register: result_var
```

This makes it clear which primitive a variable belongs to when reading composed tasks.

## Usage Patterns

### Simple Component (Single Primitive)

```yaml
# roles/neovim/tasks/main.yml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_packages_to_install: [neovim-git]
```

### Medium Component (Multiple Primitives)

```yaml
# roles/ssh/tasks/main.yml
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
    service_state: started
```

### Complex Component (Custom Logic)

```yaml
# roles/database/tasks/main.yml
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
    exec_become: true
    exec_become_user: postgres
```

## Integration with Existing Roles

Primitives are designed to coexist with traditional roles. You can:

1. **Use primitives in new roles** - All new development uses primitives
2. **Refactor existing roles** - Gradually replace task duplications with primitive calls
3. **Mix both approaches** - Use primitives where they add value, keep custom tasks where needed

Example of refactoring an existing role:

**Before:**

```yaml
# roles/packages/tasks/main.yml
- name: Install git
  become: true
  community.general.pacman:
    name: git
    state: present

- name: Install vim
  become: true
  community.general.pacman:
    name: vim
    state: present
```

**After:**

```yaml
# roles/packages/tasks/main.yml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_names: [git, vim]
    package_state: present
```

## Directory Structure

```
primitives/
├── ensure_state/        # Resource existence
│   ├── package.yml      # Package management
│   ├── user.yml         # User management
│   ├── directory.yml    # Directory management
│   └── service.yml      # Service management
│
├── ensure_content/      # File content
│   ├── file_copy.yml    # Copy files
│   ├── line_in_file.yml # Manage lines in files
│   └── template.yml     # Template rendering
│
├── query_state/         # State checking
│   ├── path_exists.yml  # Check if path exists
│   └── command.yml      # Query command output
│
├── sync/                # Remote resources
│   └── git_repo.yml     # Git repository sync
│
├── execute/             # Command execution
│   ├── command.yml      # Run command
│   └── shell.yml        # Run shell script
│
└── compose/             # High-level compositions
    └── aur_setup.yml    # Complete AUR setup
```

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

3. **Test:** Create example playbook demonstrating usage

4. **Document:** Update this README with new primitive

## Best Practices

1. **Use descriptive variable names** - `package_names`, not `packages`
2. **Provide defaults** - Make optional variables truly optional
3. **Include usage examples** - Every primitive has a working example in comments
4. **Document side effects** - Note if primitive modifies system state
5. **Maintain idempotency** - Primitives should be safe to run multiple times
6. **Use register pattern** - Return results via `query_register` or `exec_register`

## Testing Primitives

Test primitives individually before using in components:

```yaml
# test_primitive.yml
---
- name: Test Primitive
  hosts: localhost
  tasks:
    - include_tasks: primitives/ensure_state/package.yml
      vars:
        package_names: [git]
        package_state: present
        package_update_cache: true
```

Run with:

```bash
ansible-playbook test_primitive.yml --check  # Dry-run
ansible-playbook test_primitive.yml          # Apply
```

## Further Reading

- **docs/primitives/ansible-core.md** - Reference examples from this codebase
- **docs/primitives/system-inventory-by-primitives.md** - System automation roadmap
- **.skogix/PRIMITIVES_README.md** - Detailed architecture documentation

## License

MIT

## Author

SkogAI (skogansible repository)
