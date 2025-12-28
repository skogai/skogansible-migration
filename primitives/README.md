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
  include_tasks: primitives/ensure_content/ensure_template.yml
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
```

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
