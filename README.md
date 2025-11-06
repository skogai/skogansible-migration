# Ansible Arch Linux Setup

Automated Arch Linux package management using Ansible.

## Features

- Package installation from official repos
- AUR package support via yay
- Dedicated AUR builder user for security
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
./run.sh --tags packages
./run.sh --tags aur
./run.sh --tags aur_user,yay
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

## Security Notes

- AUR packages are built and installed by a dedicated `aur_builder` user
- The aur_builder user can only run pacman with sudo (no password)
- Wheel group users can become aur_builder without password

## Directory Structure

```
.ansible/
├── ansible.cfg          # Ansible configuration
├── .envrc               # direnv environment setup
├── .inventory           # Inventory file (localhost)
├── .requirements.yml    # Ansible Galaxy requirements
├── playbook.yml         # Main playbook
├── run.sh               # Wrapper script to run playbook
├── setup.sh             # Initial setup script
├── vars/
│   └── main.yml         # Package lists and variables
└── roles/
    └── packages/
        ├── defaults/
        ├── handlers/
        ├── meta/
        └── tasks/
            ├── main.yml          # Main package tasks
            ├── aur_user.yml      # AUR user setup
            ├── aur_helper.yml    # yay installation
            └── aur_packages.yml  # AUR package installation
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
