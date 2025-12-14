# Ansible Arch Linux Setup

Ansible setup for managing Arch Linux system packages, AUR packages, SSH configuration, Git configuration, and filesystem mounts.

## Features

- Package installation from official repos
- AUR package support via yay
- Dedicated AUR builder user for security
- SSH configuration and key management
- Git installation and configuration
- Filesystem mounts management (UUID-based)
- Environment management via direnv

## Prerequisites

- Arch Linux system
- `uv` (Python package manager)
- `skogcli` for environment variable management
- `direnv` (optional, for automatic environment loading)

## Setup

1. Run the setup script to create the virtual environment and install dependencies:

```bash
./setup.sh
```

This will:
- Create a Python virtual environment using `uv`
- Install Ansible and required collections
- Activate the virtual environment

## Configuration

### Environment Variables

The `.envrc` file loads environment variables via `skogcli`:
- `$ANSIBLE_BECOME_PASSWORD_FILE` for sudo operations
- Other ansible/uv/skogai namespace variables

### Ansible Configuration

- `ansible.cfg` - Ansible configuration (inventory, Python interpreter)
- `.inventory` - Defines localhost target
- `.requirements.yml` - Ansible collections (community.general, kewlfft.aur)

### Package Lists

Edit `vars/main.yml` to customize:
- `packages` - Official repository packages
- `aur_packages` - AUR packages

## Usage

Run the playbook using the wrapper script:

```bash
./run.sh
```

Or with specific tags:

```bash
./run.sh --tags packages      # Package management
./run.sh --tags ssh           # SSH configuration
./run.sh --tags git           # Git configuration
./run.sh --tags filesystems   # Filesystem mounts
./run.sh --tags aur           # AUR packages only
```

Or run ansible-playbook directly:

```bash
source .venv/bin/activate
ansible-playbook playbook.yml
```

## How It Works

### Package Role

The `packages` role follows this sequence:

1. **AUR User Setup** (`aur_user.yml`)
   - Creates `aur_builder` user
   - Configures passwordless sudo for pacman
   - Allows wheel group to become aur_builder

2. **AUR Helper Installation** (`aur_helper.yml`)
   - Installs base-devel and git
   - Clones and builds yay from AUR
   - Cleans up build directory

3. **Official Package Installation** (`main.yml`)
   - Updates pacman database
   - Upgrades all packages
   - Installs packages from `packages` list

4. **AUR Package Installation** (`aur_packages.yml`)
   - Installs packages from `aur_packages` list using yay
   - Runs as `aur_builder` user

## Tags

- `packages` - All package-related tasks
- `install` - Package installation tasks
- `aur` - All AUR-related tasks
- `aur_user` - AUR builder user setup
- `yay` - yay installation
- `ssh` - SSH configuration and key management
- `git` - Git configuration and repository management
- `filesystems` - Filesystem mounts management
- `filesystems-mount-points` - Only create mount point directories
- `filesystems-fstab` - Only manage fstab entries

## Roles Overview

### Packages Role

Manages system packages from official Arch repositories and AUR:
- Creates `aur_builder` user for secure AUR package building
- Installs yay AUR helper
- Manages official packages via pacman
- Manages AUR packages via yay

### SSH Role

Manages SSH configuration and keys:
- SSH key deployment from encrypted vault
- SSH config template with connection multiplexing
- Known hosts and authorized keys management
- SSH directory backup functionality

### Git Role

Comprehensive Git configuration and repository management:
- Git installation and global configuration
- Git aliases and credential helper management
- Global .gitignore patterns
- Repository cloning and management
- Git hooks deployment and GPG/SSH commit signing

### Filesystems Role

**NEW**: Manages filesystem mounts using UUID-based mounting:
- Creates mount point directories with proper permissions
- Manages `/etc/fstab` entries using `ansible.posix.mount`
- Supports all filesystem types (ext4, xfs, btrfs, ntfs, etc.)
- Automatic fstab backup before changes
- Persistent across reboots

**Quick Start:**
```bash
# Configure your mounts in vars/filesystems.yml
# Find UUIDs with: sudo blkid

# Run the role
./run.sh --tags filesystems

# Or check what would change (dry-run)
./run.sh --tags filesystems --check
```

See `roles/filesystems/README.md` for complete documentation.

## Security Notes

- AUR packages are built and installed by a dedicated `aur_builder` user
- The aur_builder user can only run pacman with sudo (no password)
- Wheel group users can become aur_builder without password
- SSH keys can be stored encrypted using Ansible Vault
- Filesystem mounts use UUID-based mounting for reliability

## Directory Structure

```
.
├── ansible.cfg              # Ansible configuration
├── .inventory               # Localhost target
├── playbook.yml             # Main playbook (4 roles)
├── .requirements.yml        # Ansible Galaxy collections (3 collections)
├── vars/                    # Configuration variables (organized by role)
│   ├── main.yml             # Shared variables
│   ├── packages.yml         # Package lists (61 official + 7 AUR)
│   ├── ssh.yml              # SSH role configuration
│   ├── ssh_vault.yml        # Encrypted SSH keys
│   ├── git.yml              # Git configuration
│   ├── user.yml             # User-specific variables
│   └── filesystems.yml      # Filesystem mount definitions
├── roles/
│   ├── packages/            # Package management role
│   │   └── tasks/
│   │       ├── main.yml
│   │       ├── aur_user.yml
│   │       ├── aur_helper.yml
│   │       └── aur_packages.yml
│   ├── ssh/                 # SSH management role
│   │   └── tasks/main.yml
│   ├── git/                 # Git configuration role
│   │   └── tasks/
│   │       ├── main.yml
│   │       └── (11 task files)
│   └── filesystems/         # Filesystem mounts role
│       ├── tasks/main.yml
│       ├── defaults/main.yml
│       ├── handlers/main.yml
│       ├── meta/main.yml
│       └── README.md
├── setup.sh                 # Bootstrap script (creates venv, installs ansible)
├── run.sh                   # Execution script (runs playbook)
└── .envrc                   # direnv environment setup
```

## Troubleshooting

### Virtual environment not found

Run `./setup.sh` to create the virtual environment.

### Permission denied errors

Ensure `$ANSIBLE_BECOME_PASSWORD_FILE` is set correctly via skogcli.

### AUR package installation fails

1. Check that `aur_builder` user exists
2. Verify yay is installed: `which yay`
3. Check sudo configuration in `/etc/sudoers.d/`

### Collections not found

Run: `ansible-galaxy collection install -r .requirements.yml --force`
