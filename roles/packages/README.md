# Ansible Role: Packages

Comprehensive package management role for Arch Linux systems using pacman and AUR.

This role provides secure, idempotent package management including:

- Official repository packages via pacman
- AUR packages via yay helper
- Dedicated AUR builder user for security
- Automatic yay installation from source
- Package database updates and system upgrades

## Requirements

- Ansible 2.10 or higher
- `community.general` collection (for `pacman` module)
- `kewlfft.aur` collection (for `aur` module)
- Target system: Arch Linux
- User must have sudo privileges

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/packages.yml`.

### Package Lists

```yaml
packages: []                 # List of packages from official repos
aur_packages: []             # List of packages from AUR
```

### AUR Builder User

```yaml
aur_builder_user: aur_builder          # Username for AUR package building
aur_builder_group: wheel               # Primary group (for sudo access)
aur_builder_home: /home/aur_builder    # Home directory
aur_builder_shell: /bin/bash           # Shell
```

### System Updates

```yaml
pacman_update_cache: true              # Update package database
pacman_upgrade_system: true            # Upgrade all packages before installing
```

### Python Interpreter

```yaml
ansible_python_interpreter: /usr/bin/python  # Python for AUR tasks
```

## Dependencies

None. This role installs all required dependencies including:

- base-devel (for building AUR packages)
- git (for cloning AUR repositories)
- yay (AUR helper, installed from source)

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: packages
      vars:
        packages:
          - git
          - vim
          - htop
        aur_packages:
          - google-chrome
          - yay
```

### Advanced Configuration

```yaml
- hosts: localhost
  vars_files:
    - vars/packages.yml
  roles:
    - packages
  tags:
    - packages
```

### With Custom AUR Builder

```yaml
- hosts: localhost
  roles:
    - role: packages
      vars:
        aur_builder_user: custom_builder
        aur_builder_home: /srv/aur_builder
        packages:
          - base-devel
          - git
        aur_packages:
          - yay-bin
```

## Role Tasks

The role executes tasks in this order:

### 1. AUR User Setup (`aur_user.yml`)

Creates a dedicated user for building AUR packages:

- Creates `aur_builder` user with wheel group membership
- Configures passwordless sudo for pacman operations only
- Allows wheel group users to become aur_builder without password
- Stores sudoers config in `/etc/sudoers.d/11-install-aur_builder`

**Security Note:** The aur_builder user can only run `/usr/bin/pacman` with sudo, preventing privilege escalation while allowing package installation.

### 2. AUR Helper Installation (`aur_helper.yml`)

Installs yay AUR helper from source:

- Ensures base-devel and git are installed
- Checks if yay already exists
- Clones yay repository from AUR
- Builds and installs yay using makepkg
- Cleans up build directory after installation

**Idempotency:** Uses `creates` parameter and stat checks to skip installation if yay already exists.

### 3. Official Package Installation (`main.yml`)

Manages official repository packages:

- Updates pacman package database cache
- Upgrades all installed packages (optional)
- Installs packages from `packages` list
- Uses `state: present` for idempotency

### 4. AUR Package Installation (`aur_packages.yml`)

Installs packages from AUR:

- Runs as `aur_builder` user (via become_user)
- Uses kewlfft.aur collection
- Installs packages with yay helper
- Only runs if `aur_packages` is defined and non-empty

## Tags

The role supports granular execution via tags:

- `packages` - All package-related tasks
- `install` - Package installation tasks only
- `aur` - All AUR-related tasks (user, helper, packages)
- `aur_user` - AUR builder user setup only
- `yay` - yay AUR helper installation only

### Tag Usage Examples

```bash
# Install only official packages
ansible-playbook playbook.yml --tags install

# Setup AUR infrastructure only
ansible-playbook playbook.yml --tags aur_user,yay

# Install AUR packages only (requires aur_builder and yay)
ansible-playbook playbook.yml --tags aur

# Full package management
ansible-playbook playbook.yml --tags packages
```

## Variables File Example

Create `vars/packages.yml`:

```yaml
---
# Official repository packages
packages:
  - base
  - base-devel
  - git
  - vim
  - htop
  - tree
  - wget
  - curl
  - zsh
  - fzf
  - ripgrep
  - bat

# AUR packages
aur_packages:
  - yay
  - google-chrome
  - visual-studio-code-bin
  - spotify
```

## Security Considerations

### AUR Builder Isolation

The role creates a dedicated `aur_builder` user to isolate AUR package building from your main user account:

1. **Limited sudo access**: Can only run `/usr/bin/pacman` with sudo
2. **No password required**: Wheel group users can become aur_builder for convenience
3. **Separate home directory**: Build artifacts isolated from user data
4. **Standard permissions**: No special capabilities beyond package building

### Sudoers Configuration

The role creates `/etc/sudoers.d/11-install-aur_builder` with:

```
aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman
%wheel ALL=(aur_builder) NOPASSWD: ALL
```

This configuration:

- Allows aur_builder to install packages without password
- Allows wheel group to switch to aur_builder without password
- Validates sudoers syntax with `visudo -cf` before applying

## Troubleshooting

### AUR Builder User Already Exists

If the `aur_builder` user already exists from a previous installation, the role will skip user creation but verify sudo configuration.

### Yay Already Installed

The role checks for yay existence before attempting installation. If yay is already present, the installation tasks are skipped.

### Permission Denied Errors

Ensure your user is in the `wheel` group and can use sudo:

```bash
groups $USER  # Should include 'wheel'
sudo -v       # Should succeed without errors
```

### AUR Package Installation Fails

1. Verify yay is installed: `which yay`
2. Verify aur_builder user exists: `id aur_builder`
3. Check sudoers configuration: `sudo cat /etc/sudoers.d/11-install-aur_builder`
4. Test manual AUR installation as aur_builder: `sudo -u aur_builder yay -S <package>`

### Python Interpreter Issues

The role uses `/usr/bin/python` for AUR tasks. If you encounter Python-related errors:

1. Ensure Python is installed: `pacman -S python`
2. Check ansible.cfg interpreter setting
3. Verify the aur_builder user can execute Python: `sudo -u aur_builder python --version`

## Testing

Test the role in check mode (dry-run):

```bash
ansible-playbook playbook.yml --tags packages --check
```

Test specific components:

```bash
# Test AUR user setup
ansible-playbook playbook.yml --tags aur_user --check

# Test yay installation
ansible-playbook playbook.yml --tags yay --check

# Test package installation
ansible-playbook playbook.yml --tags install --check
```

## Role Structure

```
roles/packages/
├── tasks/
│   ├── main.yml           # Main package installation and orchestration
│   ├── aur_user.yml       # AUR builder user setup
│   ├── aur_helper.yml     # yay installation from source
│   └── aur_packages.yml   # AUR package installation
├── defaults/main.yml      # Default variables
├── handlers/main.yml      # Handlers (currently empty)
├── meta/main.yml          # Role metadata
└── README.md              # This file
```

## License

MIT

## Author

SkogAI (skogansible repository)
