# Ansible Arch Linux Setup

**Repository:** SkogAI/skogansible (active/canonical ansible repository)

Ansible setup for managing Arch Linux system packages, AUR packages, SSH configuration, Git configuration, and Chezmoi dotfiles management.

**Historical Context:** This is the main active ansible repository. Historical documentation from 7 previous ansible repository iterations is preserved in `docs/repos/` for consolidation and pattern reference.

## Project Structure

**See @FILESTRUCTURE.md for complete file tree and file-by-file documentation.**

The repository follows standard Ansible structure:

- **Core files:** `ansible.cfg`, `.inventory`, `.requirements.yml`
- **Execution script:** `run.sh` (all playbook execution goes through this)
- **Playbooks:** `playbooks/` directory with scenario-specific playbooks
- **Roles:** `roles/` with users/, packages/, ssh/, git/, chezmoi/, zsh/, cloudflared/, filesystems/ (each with tasks/, templates/, defaults/, meta/)
- **Variables:** `vars/` directory with role-specific configuration files
- **Documentation:** `docs/` with primitives reference and historical repos
- **Standards:** `RULES.md` - canonical coding standards for this repo

## Key Details

- **Become method:** `become: true` on individual tasks only (NEVER at playbook/play level)
- **Sudo password:** Set via `$ANSIBLE_BECOME_PASSWORD_FILE` exported by `skogcli` through `.envrc`
- **Vault password:** Set via `$ANSIBLE_VAULT_PASSWORD_FILE` (same source)
- **Python interpreter:** `auto` discovery in `ansible.cfg`
- **Collections path:** `./tmp/collections` (set in `ansible.cfg`)
- **Variable organization:** Role-specific vars files in `vars/` directory
- **AUR support:** Dedicated `aur_builder` user for secure AUR package building
- **Settings decisions:** When uncertain about config values, agents MUST add questions to `docs/SETTINGS_DECISIONS.md` instead of guessing

## Development Standards (RULES.md)

**See @RULES.md for the full canonical standards. Key conventions:**

### Task Naming

All task names MUST use format: `"ROLE | Description"`

```yaml
# Correct
- name: "Packages | Install system packages"

# Wrong
- name: "Install system packages"
```

### Tag Format

- Use **kebab-case** tags in **bracket format**
- ALL tasks MUST have at least the role-level tag

```yaml
# Correct - all tags visible in one line
tags: [packages, packages-install]

# Wrong - underscore format
tags: [packages, packages_install]
```

### Variable Hierarchy (lowest to highest precedence)

1. `roles/<role>/defaults/main.yml` - Sane defaults (safe for anyone)
2. `roles/<role>/vars/main.yml` - Personal standard config (references `vars/main.yml`)
3. `vars/main.yml` - **Shared variables (source of truth)** - cross-role settings
4. `vars/<role>.yml` - Role-specific deployment overrides
5. `vars/<role>_vault.yml` - Encrypted secrets (ansible-vault)

### Feature Flags

- ALL feature flags MUST be defined in `roles/ROLE/defaults/main.yml`
- Dangerous operations MUST be disabled by default
- Every flag MUST have an explanatory comment

```yaml
# Upgrade all system packages (CAUTION: may break system)
packages_upgrade_system: false

# Update package cache (safe - read-only)
packages_update_cache: true
```

### Privilege Escalation

- **ONLY task-level `become: true`** — never at playbook or play level

## Semaphore Ansible UI

Web interface for running and managing Ansible playbooks.

**Access:**

- Local: `http://localhost:9005`
- Public: `https://semaphore.skogai.se` (Cloudflare tunnel)

**Configuration:**

- Docker compose: `semaphore/docker-compose.yml`
- Data volume: `semaphore/data/`
- Admin: skogix / skogsund1

**MCP Integration:**

- MCP server: `~/dev/semaphore-mcp/`
- API token: Stored in `skogcli` as `SEMAPHORE_API_TOKEN`
- Enables programmatic playbook execution via Claude Code

**Setup:**

```bash
cd semaphore && docker compose up -d
```

## Git Worktree Management (Worktrunk)

The repository uses [worktrunk](https://github.com/thought-tracker/worktrunk) for managing git worktrees.

**Why Worktrees:**

- Safe parallel development without branch switching
- Each worktree is fully isolated (no `.venv` or state conflicts)
- Test changes without affecting main development

**Quick Start:**

```bash
# Create and switch to new worktree
wt switch --create --base master feature-name

# List all worktrees
wt list

# Make changes, then commit with AI-generated message
wt step commit

# Merge back to master (squash, commit, remove worktree)
wt merge

# Or remove without merging
wt remove feature-name
```

**Project Hooks** (defined in `.config/wt.toml`):

- `post-create`: `direnv allow` for new worktree
- `pre-commit`: Ansible syntax check (`./run.sh --syntax-check`)
- `pre-merge`: Full dry-run (`./run.sh --check`) + direnv allow

**Config:**

- Global config: `~/.config/worktrunk/config.toml`
- Project hooks: `.config/wt.toml`
- Worktree path: `.worktrees/{{ branch }}/`

## Usage

**Run playbook:**

```bash
# run.sh signature: ./run.sh [playbook.yml] [ansible-playbook args...]
./run.sh                              # default.yml (current: equivalent to site.yml minus cloudflared)
./run.sh site.yml                     # Full setup (all roles in playbooks/site.yml)
./run.sh workstation.yml              # Full desktop setup (includes cloudflared + filesystems)
./run.sh bootstrap.yml                # Minimal fresh-install bootstrap
./run.sh maintenance.yml              # Package updates only
./run.sh site.yml --check             # Dry-run mode
./run.sh site.yml --tags users        # Run only user management
./run.sh site.yml --tags packages     # Run only package management
./run.sh site.yml --tags ssh          # Run only SSH configuration
./run.sh site.yml --tags git          # Run only Git configuration
./run.sh site.yml --tags chezmoi      # Run only Chezmoi configuration
./run.sh site.yml --tags zsh          # Run only Zsh configuration
./run.sh site.yml --tags filesystems  # Run only filesystem mounts
./run.sh site.yml --tags aur          # Run only AUR-related tasks
```

**SSH key deployment (requires vault password):**

```bash
# Enable in vars/ssh.yml first:
# ssh_deploy_from_vault: true

./run.sh site.yml --tags ssh
```

## Playbook Organization

Playbooks live in `playbooks/`. `run.sh` prepends `./playbooks/` automatically.

| Playbook | Purpose | Roles Included |
|----------|---------|----------------|
| `default.yml` | Current default | users, packages, ssh, git, chezmoi, zsh |
| `site.yml` | Same as default (without cloudflared) | users, packages, ssh, git, chezmoi, zsh |
| `workstation.yml` | Full desktop setup | + cloudflared, filesystems |
| `bootstrap.yml` | Fresh install only | packages (no upgrade) |
| `maintenance.yml` | Regular updates | packages (update + upgrade) |

## Current Scope

**Active Roles:**

- ✅ **users** - User and group management with security foundation
- ✅ **packages** - Official Arch repository packages via pacman + AUR packages via paru
- ✅ **ssh** - SSH directory setup, key deployment, config management, known_hosts
- ✅ **git** - Comprehensive Git configuration and repository management
- ✅ **chezmoi** - Dotfiles management via machine-specific configuration templating
- ✅ **zsh** - Modular shell configuration with numbered load-order directories
- ✅ **cloudflared** - Cloudflare Tunnel with secure vault token storage
- ✅ **filesystems** - UUID-based fstab management and mount point creation

## Users Role Configuration

The Users role manages system users and groups. Users are defined in `vars/user.yml`.

**Current users managed:**

- `skogix` - Primary user (wheel, skogai)
- `aldervall` - Secondary user (wheel, skogai)
- `dot`, `amy`, `claude`, `letta`, `goose`, `skogai` - AI agent users (wheel, skogai)

**To customize users and groups:**

1. Edit `vars/user.yml` to add/remove users:

   ```yaml
   users:
     - name: username
       groups_base:
         - wheel       # sudo access
         - skogai      # custom group
       shell: /usr/bin/zsh  # optional
       comment: "User Description"  # optional
   ```

2. Run: `./run.sh --tags users`

**Available Features (configure in `roles/users/defaults/main.yml`):**

- `users_ensure_users: true` - Ensure users exist on system
- `users_ensure_groups: true` - Ensure groups exist on system
- `users_create_home: true` - Create home directories
- `users_default_shell: "/bin/bash"` - Default shell for users
- `users_configure_sudo: false` - Configure sudo (disabled by default)

**System Groups:**

```yaml
users_system_groups:
  - name: skogai
    gid: 1100
    system: false
```

**Granular tag support:**

```bash
./run.sh --tags users          # All user management tasks
./run.sh --tags users-groups   # Only group management
./run.sh --tags users-ensure   # Only user management
```

**See:** `roles/users/README.md` for complete documentation.

## Packages Role Configuration

The Packages role manages system packages from official Arch repositories and AUR.

**To customize package lists:**

1. Edit `vars/packages.yml` to add/remove packages:

   ```yaml
   packages:
     - git
     - vim
     - htop
   aur_packages:
     - google-chrome
   ```

2. Run: `./run.sh --tags packages`

**Available Package Features:**

- `packages_update_cache: true` - Update package database (safe, default on)
- `packages_upgrade_system: false` - Upgrade all packages (CAUTION: default off)
- AUR builder user creation and configuration (dedicated `aur_builder` user)
- Automatic paru installation from source
- AUR package installation via paru

**Security Model:**

- Dedicated `aur_builder` user isolates AUR package building
- User can only run `/usr/bin/pacman` with sudo (no privilege escalation)
- Wheel group can become aur_builder without password

**Granular tag support:**

```bash
./run.sh --tags packages          # All package tasks
./run.sh --tags packages-install  # Only install official packages
./run.sh --tags aur               # AUR tasks (user + helper + packages)
./run.sh --tags aur-user          # Only setup aur_builder user
./run.sh --tags aur-helper        # Only install paru helper
./run.sh --tags aur-packages      # Only install AUR packages
```

**Task Execution Order:**

1. **AUR User Setup** - Creates aur_builder user with secure sudo config
2. **AUR Helper Installation** - Installs paru from AUR source
3. **Official Packages** - Updates cache, installs packages
4. **AUR Packages** - Installs AUR packages as aur_builder user

**See:** `roles/packages/README.md` for complete documentation.

## SSH Role Configuration

The SSH role manages SSH keys, configuration, and related settings with dual-tier deployment: vault variables for critical keys + file-based deployment for complete `.ssh` directory restoration.

**Quick Start - Deploy Entire .ssh Directory:**

1. Enable in `vars/ssh.yml`:

   ```yaml
   ssh_deploy_full_directory: true
   ssh_deploy_from_vault: true  # Also deploy keys from vault variables
   ```

2. Run: `./run.sh --tags ssh`

**Automatic permission management:**

- Private keys: `600`
- Public keys: `644`
- Vault password files: `700` (executable - required by Ansible)
- Directory: `700`

**Common Error - Vault Decryption Failure:**

```
[ERROR]: Decryption failed (no vault secrets were found that could decrypt)
```

Root cause: vault password file is not executable. Fix:

```bash
chmod 700 ~/.ssh/ansible-become-password
chmod 700 ~/.ssh/ansible-vault-password
```

**See:** `roles/ssh/README.md` for complete documentation.

## Git Role Configuration

The Git role provides standardized, reusable task files for all common git operations. All features are **configurable via `vars/git.yml`**.

**Quick Start (Enabled by default):**

- Git installation
- Global `.gitconfig` with user name/email
- Comprehensive git aliases
- Global `.gitignore` patterns
- Credential caching

**To customize:**

1. Edit `vars/git.yml`:

   ```yaml
   git_user_name_override: "Your Name"
   git_user_email_override: "your.email@example.com"
   ```

2. Run: `./run.sh --tags git`

**Standardized Task Files** (`roles/git/tasks/`):

- `install.yml`, `configure_global.yml`, `configure_aliases.yml`
- `configure_credentials.yml`, `install_lfs.yml`, `clone_repositories.yml`
- `deploy_gitignore.yml`, `deploy_hooks.yml`, `configure_signing.yml`
- `configure_repo_specific.yml`, `maintenance.yml`

**Granular tag support:**

```bash
./run.sh --tags git-install      # Only install git
./run.sh --tags git-config       # Only configure gitconfig
./run.sh --tags git-aliases      # Only setup aliases
./run.sh --tags git-clone        # Only clone repositories
./run.sh --tags git-hooks        # Only deploy hooks
```

**See:** `roles/git/README.md` for complete documentation.

## Chezmoi Role Configuration

The Chezmoi role manages dotfiles by templating `.chezmoidata.yaml` with machine-specific configuration.

**To customize machine profile:**

1. Edit `vars/chezmoi.yml`:

   ```yaml
   chezmoi_machine_type: laptop  # workstation, laptop, wsl
   chezmoi_wm: sway              # i3, sway, none
   chezmoi_laptop_mode: true
   chezmoi_headless: false
   ```

2. Run: `./run.sh --tags chezmoi`

**Machine Profile Variables:**

- `chezmoi_machine_type` - workstation, laptop, or wsl
- `chezmoi_wm` - Window manager (i3, sway, none)
- `chezmoi_laptop_mode` - Laptop-specific features
- `chezmoi_headless` - Headless environment (auto-true for WSL)
- `chezmoi_gui` - GUI apps enabled (auto-false for headless)
- `chezmoi_terminal` - Terminal emulator (kitty, alacritty, etc.)

**SkogAI Integration:**

- `chezmoi_agents` - Enable/disable individual AI agents (claude, letta, amy, goose, dot)
- `chezmoi_skogai_home` - Path to SkogAI home directory

**Granular tag support:**

```bash
./run.sh --tags chezmoi-install   # Only verify installation
./run.sh --tags chezmoi-init      # Only check initialization
./run.sh --tags chezmoi-config    # Only template configuration
./run.sh --tags chezmoi-apply     # Only apply dotfiles
```

**See:** `roles/chezmoi/README.md` for complete documentation.

## Cloudflared Role Configuration

The Cloudflared role manages Cloudflare Tunnel with secure token storage using ansible-vault.

**To deploy Cloudflare Tunnel:**

1. Copy and encrypt vault file:

   ```bash
   cp vars/cloudflared_vault.yml.template vars/cloudflared_vault.yml
   # Edit and add your token
   ansible-vault encrypt vars/cloudflared_vault.yml
   ```

2. Run: `./run.sh workstation.yml --tags cloudflared`

**Security Model:**

- Token encrypted with ansible-vault (never committed plaintext)
- Token file restricted to root (0600 permissions)
- Service uses `--token-file` flag (no plaintext in systemd unit)
- `no_log: true` on sensitive tasks prevents token leakage

**Granular tag support:**

```bash
./run.sh --tags cloudflared          # All cloudflared tasks
./run.sh --tags cloudflared-token    # Only deploy token
./run.sh --tags cloudflared-service  # Only deploy service
./run.sh --tags cloudflared-vault    # Vault-related tasks
```

**See:** `roles/cloudflared/README.md` and `docs/CLOUDFLARED_SETUP.md` for complete documentation.

## Filesystems Role Configuration

The Filesystems role manages UUID-based filesystem mounts via `/etc/fstab`.

**To configure mounts:**

1. Edit `vars/filesystems.yml`:

   ```yaml
   data_mounts:
     - path: /mnt/data
       uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  # from `blkid`
       fstype: ext4
       opts: defaults
       state: mounted  # mounted, present, absent, unmounted
       dump: 0
       passno: 2
   ```

   **Warning:** UUIDs are machine-specific. Run `sudo blkid` to find yours.

2. Run: `./run.sh workstation.yml --tags filesystems`

**Available Features (`roles/filesystems/defaults/main.yml`):**

- `filesystems_manage_mounts: true` - Manage fstab entries
- `filesystems_create_mount_points: true` - Create mount directories
- `filesystems_backup_fstab: true` - Backup fstab before changes

**Granular tag support:**

```bash
./run.sh --tags filesystems             # All filesystem tasks
./run.sh --tags filesystems-validate    # Only validate UUIDs
./run.sh --tags filesystems-mount-points  # Only create directories
./run.sh --tags filesystems-mount       # Only manage fstab/mounts
```

**See:** `roles/filesystems/README.md` for complete documentation.

## Zsh Role Configuration

The Zsh role deploys modular shell configuration with numbered load-order directories.

**Default behavior:**

- Deploys entire `zsh.d/` directory to `~/.config/zsh.d/`
- Creates minimal `.zshrc` that sources the loader

**To customize zsh configuration:**

1. Add files to `roles/zsh/files/zsh.d/[module]/`:

   ```bash
   # Example: Add editor export
   cat > roles/zsh/files/zsh.d/60-exports/editor.zsh << 'EOF'
   export EDITOR='nvim'
   export VISUAL='nvim'
   EOF
   ```

2. Run: `./run.sh --tags zsh-config`

**Directory Structure (`~/.config/zsh.d/`):**

```
├── loader.zsh           # Sources all config files in order
├── 00-path/             # PATH exports (loads first)
├── 10-settings/         # Shell settings
├── 20-functions/        # Shell functions
├── 30-aliases/          # Aliases
├── 40-completions/      # Completion config
├── 60-exports/          # Environment exports
└── 90-skogai/           # SkogAI tools (loads last)
```

**loader.zsh Behavior:**

- `.zsh`, `.sh`, `.conf` files — sourced normally
- `.env` files — sourced with `allexport` (auto-exports all variables)

**Available Zsh Features (`vars/zsh.yml`):**

- `zsh_deploy_config: true` - Deploy zsh.d structure to `~/.config`
- `zsh_deploy_zshrc: false` - Deploy `.zshrc` (currently disabled in vars)
- `zsh_backup_existing: true` - Backup existing config

**Design Decisions:**

- **Minimal .zshrc** - Single line: `source ~/.config/zsh.d/loader.zsh`
- **Ansible owns everything** - Chezmoi doesn't manage zsh config
- **Numbered directories** - Deterministic load order (00 → 90)
- **No plugin manager dependency** - Direct sourcing, no external deps

**Granular tag support:**

```bash
./run.sh --tags zsh              # All zsh tasks
./run.sh --tags zsh-config       # Only deploy zsh.d directory
./run.sh --tags zsh-zshrc        # Only deploy .zshrc
```

**See:** `roles/zsh/README.md` for complete documentation.

## Security Rules

### Vault Files

- All `vars/*vault*.yml` files MUST be encrypted with ansible-vault
- Verify: `file vars/*vault*.yml` should show `Ansible Vault, version 1.1, encryption AES256`

### Password File Permissions

- Vault password file: `~/.ssh/ansible-vault-password` — **700 (executable)**
- Become password file: `~/.ssh/ansible-become-password` — **700 (executable)**
- WHY: Ansible reads password files by executing them as scripts

### Pre-commit Security Checks

The repo uses `.pre-commit-config.yaml` with:

- Trailing whitespace checks
- Shell script linting (shellcheck)
- Python formatting (black, flake8)
- Markdown linting
- Secret scanning (detect-secrets baseline in `.secrets.baseline`)

```bash
# Run manually
pre-commit run --all-files

# Verify vault files are encrypted
file vars/*vault*.yml
```

### Settings Decisions

**When uncertain about config values:**

- ❌ NEVER guess or assume values
- ✅ ADD questions to `docs/SETTINGS_DECISIONS.md`
- ✅ Reference confirmed decisions when they exist

## Reference

### Essential Reading

- @FILESTRUCTURE.md - Complete file structure overview
- @RULES.md - Coding standards and conventions (read this first)
- @docs/README.md - Documentation navigation
- @docs/primitives/ansible-core.md - 7 fundamental Ansible primitives

### Role Documentation

- @roles/users/README.md - Users role documentation
- @roles/packages/README.md - Packages role documentation
- @roles/chezmoi/README.md - Chezmoi role documentation
- @roles/ssh/README.md - SSH role documentation
- @roles/git/README.md - Git role documentation
- @roles/cloudflared/README.md - Cloudflared role documentation
- @roles/zsh/README.md - Zsh role documentation
- @roles/filesystems/README.md - Filesystems role documentation
- @roles/_template/README.md - Template for new roles

### Playbooks

- @playbooks/README.md - Playbook reference and usage guide
- `playbooks/default.yml` - Default playbook
- `playbooks/site.yml` - Full setup
- `playbooks/workstation.yml` - Full workstation (+ cloudflared, filesystems)
- `playbooks/bootstrap.yml` - Fresh install only
- `playbooks/maintenance.yml` - Updates only

### System Expansion

- @docs/primitives/system-inventory-by-primitives.md - Complete automation roadmap

### Configuration Decisions

- @docs/SETTINGS_DECISIONS.md - When uncertain, ADD questions here instead of guessing

### Historical Context

- @docs/repos/CLAUDE.md - Consolidation reference for 7 previous repos
