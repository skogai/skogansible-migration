# Ansible Arch Linux Setup

**Repository:** SkogAI/skogansible (active/canonical ansible repository)

Ansible setup for managing Arch Linux system packages, AUR packages, SSH configuration, Git configuration, and Chezmoi dotfiles management.

**Historical Context:** This is the main active ansible repository. Historical documentation from 7 previous ansible repository iterations is preserved in `docs/repos/` for consolidation and pattern reference.

## Project Structure

**See @FILESTRUCTURE.md for complete file tree and file-by-file documentation.**

The repository follows standard Ansible structure:

- **Core files:** ansible.cfg, playbook.yml, .inventory, .requirements.yml
- **Execution scripts:** bootstrap.sh (setup), run.sh (execution)
- **Roles:** packages/, ssh/, git/, chezmoi/ (each with tasks/, templates/, defaults/, meta/)
- **Variables:** vars/ directory with role-specific configuration files
- **Documentation:** docs/ with primitives reference and historical repos
- **Collections:** Installed Ansible Galaxy collections (community.general, kewlfft.aur, ansible.posix)

## Key Details

- **Become method:** `become: true` on individual tasks (not playbook level)
- **Sudo password:** Set via `$ANSIBLE_BECOME_PASSWORD_FILE` exported by `skogcli` through `.envrc`
- **Python interpreter:** Hardcoded venv path in `ansible.cfg`: `/home/skogix/.ansible/.venv/bin/python`
- **Variable organization:** Role-specific vars files (packages.yml, ssh.yml, git.yml, chezmoi.yml, user.yml)
- **AUR support:** Dedicated `aur_builder` user for secure AUR package building
- **Git automation:** Standardized, reusable task files for all common git operations
- **Chezmoi integration:** Templates `.chezmoidata.yaml` for machine-specific dotfiles configuration
- **Collections:** community.general, kewlfft.aur, ansible.posix

## Usage

**Initial setup:**

```bash
./bootstrap.sh                # System setup (locale, keyring) + venv + Ansible + collections
```

**Run playbook:**

```bash
./run.sh                      # Run all roles (packages + ssh + git + chezmoi)
./run.sh --check             # Dry-run mode
./run.sh --tags packages     # Run only package management
./run.sh --tags ssh          # Run only SSH configuration
./run.sh --tags git          # Run only Git configuration
./run.sh --tags chezmoi      # Run only Chezmoi configuration
./run.sh --tags aur          # Run only AUR-related tasks
```

**SSH key deployment (requires vault password):**

```bash
# Enable in vars/ssh.yml first:
# ssh_deploy_from_vault: true

ansible-playbook playbook.yml --tags ssh --ask-vault-pass
```

## Current Scope

**Active Roles:**

- ✅ **packages** - Official Arch repository packages via pacman (61 packages)
- ✅ **packages** - AUR packages via yay (7 packages)
- ✅ **ssh** - SSH directory setup, key deployment, config management, known_hosts
- ✅ **git** - Comprehensive Git configuration and repository management
- ✅ **chezmoi** - Dotfiles management via machine-specific configuration templating

**Features:**

- ✅ AUR builder user setup with secure sudo config
- ✅ SSH key deployment from encrypted vault
- ✅ SSH config template with connection multiplexing
- ✅ Known hosts management
- ✅ Authorized keys management
- ✅ SSH directory backup functionality
- ✅ Git installation and global configuration
- ✅ Git aliases and credential helper management
- ✅ Global .gitignore patterns
- ✅ Repository cloning and management
- ✅ Git hooks deployment
- ✅ GPG/SSH commit signing
- ✅ Git LFS support
- ✅ Repository-specific configurations
- ✅ Chezmoi installation and verification
- ✅ Machine profile templating (.chezmoidata.yaml)
- ✅ Dotfiles application with change detection
- ✅ Support for multiple machine types (workstation, laptop, WSL)
- ⏸️  Additional system configuration (see `docs/system-inventory-by-primitives.md`)

## Packages Role Configuration

The Packages role manages system packages from official Arch repositories and AUR with secure package building infrastructure.

**Quick Start (Default behavior):**

- Updates pacman package database
- Upgrades all installed packages
- Installs packages from `vars/packages.yml`
- Creates dedicated aur_builder user for security
- Installs yay AUR helper from source
- Installs AUR packages securely

**To customize package lists:**

1. Edit `vars/packages.yml` to add/remove packages:

   ```yaml
   packages:
     - git
     - vim
     - htop
   aur_packages:
     - google-chrome
     - yay
   ```

2. Run: `./run.sh --tags packages`

**Available Package Features (all enabled by default):**

- `pacman_update_cache: true` - Update package database
- `pacman_upgrade_system: true` - Upgrade all packages before installing
- Package installation from official repos
- AUR builder user creation and configuration
- Automatic yay installation from source
- AUR package installation via yay

**Security Model:**

- Dedicated `aur_builder` user isolates AUR package building
- User can only run `/usr/bin/pacman` with sudo (no privilege escalation)
- Wheel group can become aur_builder without password
- Build artifacts isolated in `/home/aur_builder`

**Granular tag support:**

```bash
./run.sh --tags packages      # All package tasks
./run.sh --tags install       # Only install packages
./run.sh --tags aur           # AUR tasks (user + helper + packages)
./run.sh --tags aur_user      # Only setup aur_builder user
./run.sh --tags yay           # Only install yay helper
```

**Task Execution Order:**

1. **AUR User Setup** - Creates aur_builder user with secure sudo config
2. **AUR Helper Installation** - Installs yay from AUR source
3. **Official Packages** - Updates cache, upgrades system, installs packages
4. **AUR Packages** - Installs AUR packages as aur_builder user

**See:** `roles/packages/README.md` for complete documentation and troubleshooting.

## SSH Role Configuration

The SSH role manages SSH keys, configuration, and related settings. All features are **disabled by default** for safety.

**To deploy SSH keys from vault:**

1. Edit `vars/ssh.yml` and set `ssh_deploy_from_vault: true`
2. Ensure `vars/ssh_vault.yml` contains your encrypted keys with variables:
   - `ssh_private_key` - Your private key content
   - `ssh_public_key` - Your public key content
3. Run: `ansible-playbook playbook.yml --tags ssh --ask-vault-pass`

**Other SSH features (configure in vars/ssh.yml):**

- `ssh_generate_key: true` - Generate new SSH key pair
- `ssh_deploy_config: true` - Deploy custom SSH config from template
- `ssh_manage_known_hosts: true` - Manage known_hosts entries
- `ssh_manage_authorized_keys: true` - Manage authorized_keys
- `ssh_enable_backup: true` - Backup SSH directory

**See:** `roles/ssh/README.md` for complete documentation and examples.

## Git Role Configuration

The Git role provides standardized, reusable functions for all common git operations. All features are **configurable via vars/git.yml**.

**Quick Start (Enabled by default in vars/git.yml):**

- Git installation
- Global .gitconfig with user name/email
- Comprehensive git aliases
- Global .gitignore patterns
- Credential caching (2 hours)

**To customize git configuration:**

1. Edit `vars/git.yml` and set your user information:

   ```yaml
   git_user_name_override: "Your Name"
   git_user_email_override: "your.email@example.com"
   ```

2. Run: `./run.sh --tags git`

**Available Git Features (configure in vars/git.yml):**

- `git_install: true` - Install git package
- `git_deploy_config: true` - Deploy complete .gitconfig from template
- `git_deploy_aliases: true` - Enable git aliases (with sensible defaults)
- `git_configure_credentials: true` - Setup credential helper (cache/store)
- `git_deploy_global_gitignore: true` - Deploy global gitignore patterns
- `git_clone_repos: true` - Clone specified repositories
- `git_deploy_hooks: true` - Deploy git hooks (pre-commit, commit-msg)
- `git_lfs_install: true` - Install and configure Git LFS
- `git_gpg_sign_commits: true` - Enable GPG commit signing
- `git_ssh_sign_commits: true` - Enable SSH commit signing (Git 2.34+)
- `git_deploy_repo_configs: true` - Set repository-specific configurations
- `git_run_maintenance: true` - Run git maintenance on repositories

**Granular tag support:**

```bash
./run.sh --tags git-install      # Only install git
./run.sh --tags git-config       # Only configure gitconfig
./run.sh --tags git-aliases      # Only setup aliases
./run.sh --tags git-clone        # Only clone repositories
./run.sh --tags git-hooks        # Only deploy hooks
```

**Standardized Task Files:**
Each git operation has its own reusable task file in `roles/git/tasks/`:

- `install.yml` - Git installation
- `configure_global.yml` - Global gitconfig settings
- `configure_aliases.yml` - Git aliases
- `configure_credentials.yml` - Credential helper
- `install_lfs.yml` - Git LFS
- `clone_repositories.yml` - Repository cloning
- `deploy_gitignore.yml` - Global gitignore
- `deploy_hooks.yml` - Git hooks
- `configure_signing.yml` - GPG/SSH signing
- `configure_repo_specific.yml` - Repo-specific configs
- `maintenance.yml` - Git maintenance

**See:** `roles/git/README.md` for complete documentation and examples.

## Chezmoi Role Configuration

The Chezmoi role manages dotfiles by templating `.chezmoidata.yaml` with machine-specific configuration. All features are **enabled by default**.

**Quick Start (Default behavior):**

- Verifies chezmoi is installed
- Templates `.chezmoidata.yaml` with machine profile
- Applies dotfiles configuration automatically

**To customize machine profile:**

1. Edit `vars/chezmoi.yml` and set machine-specific values:

   ```yaml
   chezmoi_machine_type: laptop        # workstation, laptop, wsl
   chezmoi_wm: sway                    # i3, sway, none
   chezmoi_laptop_mode: true           # Enable laptop features
   chezmoi_headless: false             # WSL environments
   ```

2. Run: `./run.sh --tags chezmoi`

**Available Chezmoi Features (configure in vars/chezmoi.yml):**

- `chezmoi_ensure_installed: true` - Verify chezmoi installation
- `chezmoi_init_source: true` - Check source directory exists
- `chezmoi_deploy_config: true` - Template .chezmoidata.yaml
- `chezmoi_apply_on_change: true` - Auto-apply after config changes

**Machine Profile Variables:**

- `chezmoi_machine_type` - Machine type (workstation, laptop, wsl)
- `chezmoi_hostname` - Hostname for this machine
- `chezmoi_wm` - Window manager (i3, sway, none)
- `chezmoi_laptop_mode` - Enable laptop-specific features
- `chezmoi_headless` - Headless environment (auto-true for WSL)
- `chezmoi_gui` - GUI applications enabled (auto-false for headless)
- `chezmoi_terminal` - Terminal emulator (kitty, alacritty, etc.)

**SkogAI Integration:**

- `chezmoi_agents` - Enable/disable individual AI agents (claude, letta, amy, goose, dot)
- `chezmoi_skogai_home` - Path to SkogAI home directory
- `chezmoi_ai_tools` - Enable AI tools integration
- `chezmoi_development` - Enable development tools

**Granular tag support:**

```bash
./run.sh --tags chezmoi-install   # Only verify installation
./run.sh --tags chezmoi-init      # Only check initialization
./run.sh --tags chezmoi-config    # Only template configuration
./run.sh --tags chezmoi-apply     # Only apply dotfiles
```

**How it works:**

1. Ansible templates `.chezmoidata.yaml` in chezmoi source directory
2. Chezmoi uses this file to conditionally deploy dotfiles
3. Profile-based `.chezmoiignore` patterns filter files automatically
4. Changes are applied with proper change detection

**Integration with Chezmoi:**
This role complements the chezmoi setup at `~/.local/share/chezmoi`. See the integration guide:

- **~/.local/share/chezmoi/examples/ANSIBLE-INTEGRATION.md** - Full integration documentation

## Reference

### Essential Reading

- @FILESTRUCTURE.md - Complete file structure overview
- @docs/README.md - Documentation navigation
- @docs/primitives/ansible-core.md - 7 fundamental Ansible primitives

### Role Documentation

- roles/packages/README.md - Packages role documentation
- roles/chezmoi/README.md - Chezmoi role documentation
- roles/ssh/README.md - SSH role documentation
- roles/git/README.md - Git role documentation

### System Expansion

- docs/primitives/system-inventory-by-primitives.md - Complete automation roadmap

### Historical Context

- docs/repos/CLAUDE.md - Consolidation reference for 7 previous repos
