# Ansible Role: Users

User and group management role for Arch Linux systems. This role ensures users and groups defined in configuration are reflected on the system and provides a foundation for future security and privilege management.

This role provides:

- **User Management** - Ensures users from `vars/user.yml` exist on the system
- **Group Management** - Creates system groups and manages user group membership
- **Security Foundation** - Prepared for future sudo configuration and privilege management

## Requirements

- Ansible 2.10 or higher
- Target system: Arch Linux
- `vars/user.yml` with user definitions

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/user.yml`.

### User Management

```yaml
users_ensure_users: true              # Ensure users exist on system
users_create_home: true               # Create home directories
users_default_shell: "/bin/bash"     # Default shell for users
```

### Group Management

```yaml
users_ensure_groups: true             # Ensure groups exist
users_system_groups:                  # System groups to create
  - name: skogai
    gid: 1100
    system: false
```

### Security & Privileges

```yaml
users_configure_sudo: true           # Configure sudo access (disabled by default)
users_validate_sudoers: true          # Validate sudoers after changes
```

## User Configuration

Users are defined in `vars/user.yml`:

```yaml
users:
  - name: skogix
    git_email: emil@skogsund.se
    git_name: skogix
    editor: nvim
    groups_base:
      - wheel        # sudo access
      - skogai       # SkogAI group
    # Optional fields:
    # shell: /bin/zsh
    # comment: "Primary User"
```

**Supported fields:**

- `name` (required) - Username
- `groups_base` (optional) - List of groups to add user to
- `shell` (optional) - Login shell (defaults to `users_default_shell`)
- `comment` (optional) - User description/full name
- `git_email`, `git_name`, `editor` - Used by other roles (git, chezmoi, etc.)

## Dependencies

None

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: users
      vars:
        users_ensure_users: true
        users_ensure_groups: true
```

### Custom System Groups

```yaml
- hosts: localhost
  roles:
    - role: users
      vars:
        users_system_groups:
          - name: developers
            gid: 2000
            system: false
          - name: skogai
            gid: 1100
            system: false
```

### Disable Home Directory Creation

```yaml
- hosts: localhost
  roles:
    - role: users
      vars:
        users_ensure_users: true
        users_create_home: true
```

## Tags

Run specific parts of the role:

```bash
# Run entire role
./run.sh --tags users

# Run only group management
./run.sh --tags users-groups

# Run only user management
./run.sh --tags users-ensure
```

Available tags:

- `users` - Run all tasks
- `users-groups` - Group management tasks
- `users-ensure` - User management tasks

## Execution Order

The role executes tasks in this order:

1. **Group Creation** - System groups (e.g., `skogai`)
2. **User Management** - Create/update users with group membership

This ensures groups exist before users are added to them.

## Separation from Packages Role

This role is separate from the `packages` role because:

- **Conceptual Clarity** - User management is not package installation
- **Reusability** - User management can run independently
- **Future Security** - Foundation for sudo, chown, chmod operations
- **Maintainability** - Easier to understand and modify

**Note:** The `aur_builder` user remains in the packages role because it's specific to AUR package management and not a general system user.

## Future Enhancements

This role provides a foundation for:

- Sudo configuration and privilege management
- File ownership (chown) operations
- Permission (chmod) management
- Password policies
- User deletion/cleanup
- SSH key deployment per user

## License

MIT

## Author Information

Created by SkogAI for the skogansible project.
