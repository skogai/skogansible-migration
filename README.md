# Ansible Arch Linux Setup

**Repository:** SkogAI/skogansible (active/canonical ansible repository)

Automated Arch Linux system configuration using Ansible with comprehensive role-based management.

## Features

- **Package Management** - Official repos (61 packages) + AUR packages (7 packages) via yay
- **SSH Configuration** - Key deployment, config templating, known_hosts management
- **Git Configuration** - Complete git setup with aliases, hooks, signing, LFS support
- **Chezmoi Integration** - Machine-specific dotfiles templating and deployment
- **Zsh Configuration** - Modular shell config with numbered load-order directories
- **Filesystem Mounts** - UUID-based filesystem mount management with fstab integration
- **Security** - Dedicated AUR builder user, vault-encrypted secrets
- **Documentation** - Primitives-based reference architecture and system inventory

## Quick Start

**Bootstrap (first time):**

```bash
./bootstrap.sh    # Creates venv, installs Ansible + collections
```

**Run playbook:**

```bash
./run.sh                      # Run all roles
./run.sh --tags packages      # Only packages
./run.sh --tags ssh           # Only SSH setup
./run.sh --tags git           # Only Git config
./run.sh --tags chezmoi       # Only Chezmoi
./run.sh --tags zsh           # Only Zsh config
./run.sh --tags filesystems   # Only filesystem mounts
./run.sh --check              # Dry-run mode
```

## Project Structure

```
SkogAI/skogansible/
├── playbooks/                # Ansible playbooks
│   ├── default.yml           # Main playbook (6 roles)
│   ├── workstation.yml       # Workstation setup
│   └── ...                   # Additional playbooks
├── bootstrap.sh              # Initial setup script
├── run.sh                    # Playbook execution wrapper
├── roles/
│   ├── packages/             # Package management (pacman + AUR)
│   ├── ssh/                  # SSH configuration
│   ├── git/                  # Git configuration
│   ├── chezmoi/              # Dotfiles management
│   ├── zsh/                  # Zsh shell configuration
│   └── filesystems/          # Filesystem mounts management
├── vars/                     # Role-specific configuration
│   ├── packages.yml          # Package lists
│   ├── ssh.yml               # SSH settings
│   ├── git.yml               # Git settings
│   ├── chezmoi.yml           # Chezmoi settings
│   ├── zsh.yml               # Zsh settings
│   ├── filesystems.yml       # Filesystem mount definitions
│   └── user.yml              # User variables
└── docs/                     # Reference documentation
    ├── README.md             # Documentation index
    ├── primitives/           # Core Ansible patterns
    │   ├── ansible-core.md
    │   └── system-inventory-by-primitives.md
    └── repos/                # Historical repository documentation
        └── CLAUDE.md         # Consolidation reference
```

## Prerequisites

- Arch Linux system
- `uv` (Python package manager)
- `skogcli` (environment variable management via `.envrc`)
- `direnv` (optional, for automatic environment activation)

## Configuration

All role-specific configuration is in `vars/` directory:

- **packages.yml** - Customize package lists (official + AUR)
- **ssh.yml** - Enable/disable SSH features (keys, config, known_hosts)
- **git.yml** - Configure git settings (user, aliases, hooks, signing)
- **chezmoi.yml** - Machine profile settings (type, WM, laptop mode)
- **zsh.yml** - Zsh configuration (deploy config, default shell)
- **filesystems.yml** - Define filesystem mounts (UUID, path, fstype, options)

Each role has comprehensive documentation in its `README.md` file.

## Documentation

- **CLAUDE.md** - Complete project documentation (detailed usage, configuration, all features)
- **roles/*/README.md** - Role-specific documentation with examples
- **docs/README.md** - Documentation index and navigation
- **docs/primitives/** - Core Ansible patterns and system inventory
- **docs/repos/** - Historical ansible repository documentation (7 repos, 1,275+ tasks)

## Historical Context

This is the main active ansible repository for SkogAI. Historical documentation from 7 previous ansible repository iterations (ansible-base, dotfile-ansible, setup, etc.) is preserved in `docs/repos/` for consolidation and pattern reference.

## Repository Identity

- **Active Repository:** SkogAI/skogansible
- **Purpose:** Main ansible automation for Arch Linux system configuration
- **Approach:** Primitives-based role architecture with comprehensive documentation
- **Status:** 6 roles implemented (packages, ssh, git, chezmoi, zsh, filesystems), system expansion roadmap documented

---

For comprehensive documentation, configuration details, and usage examples, see **CLAUDE.md**.
