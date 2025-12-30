# Ansible Arch Linux Setup

**Repository:** SkogAI/skogansible (active/canonical ansible repository)

Ansible setup for managing Arch Linux system packages, AUR packages, SSH configuration, Git configuration, and Chezmoi dotfiles management.

**Historical Context:** This is the main active ansible repository. Historical documentation from 7 previous ansible repository iterations is preserved in `docs/repos/` for consolidation and pattern reference.

## Project Structure

**See @FILESTRUCTURE.md for complete file tree and file-by-file documentation.**

The repository follows standard Ansible structure:

- **Core files:** ansible.cfg, playbook.yml, .inventory, .requirements.yml
- **Execution scripts:** bootstrap.sh (setup), run.sh (execution)
- **Roles:** packages/, ssh/, git/, chezmoi/, zsh/, cloudflared/ (each with tasks/, templates/, defaults/, meta/)
- **Variables:** vars/ directory with role-specific configuration files
- **Documentation:** docs/ with primitives reference and historical repos
- **Collections:** Installed Ansible Galaxy collections (community.general, kewlfft.aur, ansible.posix)

## Key Details

- **Become method:** `become: true` on individual tasks (not playbook level)
- **Sudo password:** Set via `$ANSIBLE_BECOME_PASSWORD_FILE` exported by `skogcli` through `.envrc`
- **Python interpreter:** Hardcoded venv path in `ansible.cfg`: `/home/skogix/.ansible/.venv/bin/python`
- **Variable organization:** Role-specific vars files (packages.yml, ssh.yml, git.yml, chezmoi.yml, zsh.yml, user.yml)
- **AUR support:** Dedicated `aur_builder` user for secure AUR package building
- **Git automation:** Standardized, reusable task files for all common git operations
- **Chezmoi integration:** Templates `.chezmoidata.yaml` for machine-specific dotfiles configuration
- **Collections:** community.general, kewlfft.aur, ansible.posix
- **Semaphore UI:** Web-based Ansible playbook management (Docker on port 9005)
- **Settings decisions:** When uncertain about config values, agents MUST add questions to `docs/SETTINGS_DECISIONS.md` instead of guessing

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

The repository uses [worktrunk](https://github.com/thought-tracker/worktrunk) for managing git worktrees - isolated working directories for parallel development.

**Why Worktrees:**

- Safe parallel development without branch switching
- Each worktree is fully isolated (no `.venv` or state conflicts)
- Test changes without affecting main development
- Easy context switching between features

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

**Project Configuration:**

- Global config: `~/.config/worktrunk/config.toml`
- Project hooks: `.config/wt.toml` (in repo root)
- Worktree path: `.worktrees/{{ branch }}/`
- AI commits: `aichat -m claude:claude-haiku-4.5`

**Workflow:**

1. `wt switch --create --base master issue-123-feature` - Create isolated workspace
2. Make changes, test with `./run.sh --check`
3. `wt step commit` - Commit with AI-generated message
4. `wt merge` - Squash merge back to master, cleanup worktree

**Project Hooks:**

- `post-create`: Allow direnv for new worktree
- `pre-commit`: Validate Ansible syntax
- `pre-merge`: Full dry-run validation
- `post-start`: Show helpful reminder

## Usage

**Initial setup:**

```bash
./bootstrap.sh                # System setup (locale, keyring) + venv + Ansible + collections
```

**Run playbook:**

```bash
./run.sh                      # Run all roles (packages + ssh + git + chezmoi + zsh)
./run.sh --check             # Dry-run mode
./run.sh --tags packages     # Run only package management
./run.sh --tags ssh          # Run only SSH configuration
./run.sh --tags git          # Run only Git configuration
./run.sh --tags chezmoi      # Run only Chezmoi configuration
./run.sh --tags zsh          # Run only Zsh configuration
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
- ✅ **zsh** - Modular shell configuration with numbered load-order directories
- ✅ **cloudflared** - Cloudflare Tunnel with secure vault token storage
- ✅ **zsh** - Modular ZSH configuration with recursive loader

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
- ✅ Cloudflare Tunnel token deployment from encrypted vault
- ✅ Systemd service configuration with token-file (no plaintext secrets)
- ✅ Cloudflared service enablement and management
- ✅ Modular zsh configuration (29 files in numbered directories)
- ✅ Minimal .zshrc with loader pattern
- ✅ Deterministic load order (00-path through 90-skogai)
- ✅ Auto-export for .env files
- ⏸️ Additional system configuration (see `docs/system-inventory-by-primitives.md`)

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

The SSH role manages SSH keys, configuration, and related settings with dual-tier deployment: vault variables for critical keys + file-based deployment for complete .ssh directory restoration.

**Quick Start - Deploy Entire .ssh Directory (Recommended):**

1. Enable full directory deployment in `vars/ssh.yml`:

   ```yaml
   ssh_deploy_full_directory: true
   ssh_deploy_from_vault: true  # Also deploy keys from vault variables
   ```

2. Run: `./run.sh --tags ssh`

**What gets deployed:**

- **From `roles/ssh/files/ssh/`** (11 vault-encrypted files):
  - `.env`, `allowed_signers`, `authorized_keys`
  - `ansible-become-password`, `ansible-vault-password` (executable, 700)
  - Cloudflare Access certificates and keys
  - `openrouter` API credentials

- **From `vars/ssh_vault.yml`** (vault variables):
  - All 3 SSH key types: ED25519, RSA, ECDSA
  - Variable names: `ssh_private_key_ed25519`, `ssh_public_key_ed25519` (etc.)

**Automatic permission management:**

- Private keys: `600`
- Public keys: `644`
- Vault password files: `700` (executable - required by Ansible)
- Directory: `700`

**Other SSH features (configure in vars/ssh.yml):**

- `ssh_generate_key: true` - Generate new SSH key pair
- `ssh_deploy_config: true` - Deploy custom SSH config from template
- `ssh_manage_known_hosts: true` - Manage known_hosts entries
- `ssh_manage_authorized_keys: true` - Manage authorized_keys
- `ssh_enable_backup: true` - Backup SSH directory

**Common Error - Vault Password File Permissions:**

If you see this error:

```
[ERROR]: Decryption failed (no vault secrets were found that could decrypt)
```

**Root cause:** The vault password file (`ansible-become-password` or `ansible-vault-password`) is not executable.

**Solution:** Ansible requires vault password files to have executable permissions (chmod 700). The SSH role automatically sets this when deploying via `ssh_deploy_full_directory: true`, but if deploying manually, ensure:

```bash
chmod 700 ~/.ssh/ansible-become-password
chmod 700 ~/.ssh/ansible-vault-password
```

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
   chezmoi_machine_type: laptop # workstation, laptop, wsl
   chezmoi_wm: sway # i3, sway, none
   chezmoi_laptop_mode: true # Enable laptop features
   chezmoi_headless: false # WSL environments
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

## Cloudflared Role Configuration

The Cloudflared role manages Cloudflare Tunnel with secure token storage using ansible-vault. All features are **enabled by default**.

**Quick Start (Default behavior):**

- Deploys tunnel token from encrypted vault
- Creates systemd service using token-file (no plaintext secrets)
- Enables and starts cloudflared service
- Validates token is defined before deployment

**To deploy Cloudflare Tunnel:**

1. Get your tunnel token from Cloudflare Zero Trust dashboard:
   - Go to https://one.dash.cloudflare.com/
   - Navigate to Networks → Tunnels
   - Create or select your tunnel
   - Copy the tunnel token

2. Create and encrypt vault file:

   ```bash
   cp vars/cloudflared_vault.yml.template vars/cloudflared_vault.yml
   # Edit and add your token
   nano vars/cloudflared_vault.yml
   # Encrypt with ansible-vault
   ansible-vault encrypt vars/cloudflared_vault.yml
   ```

3. Run: `./run.sh --tags cloudflared --ask-vault-pass`

**Available Cloudflared Features (configure in vars/cloudflared.yml):**

- `cloudflared_deploy_token: true` - Deploy token from vault
- `cloudflared_deploy_service: true` - Deploy systemd service
- `cloudflared_enable_service: true` - Enable and start service
- `cloudflared_extra_args: ""` - Additional cloudflared arguments

**Security Model:**

- Token encrypted with ansible-vault (never committed plaintext)
- Token file restricted to root (0600 permissions)
- Service uses `--token-file` flag (no plaintext in systemd unit)
- `no_log: true` on sensitive tasks prevents token leakage
- Configuration directory restricted (0700 permissions)

**Granular tag support:**

```bash
./run.sh --tags cloudflared          # All cloudflared tasks
./run.sh --tags cloudflared-token    # Only deploy token
./run.sh --tags cloudflared-service  # Only deploy service
./run.sh --tags cloudflared-vault    # Vault-related tasks
```

**How it works:**

1. Validates tunnel token is defined in vault
2. Creates `/etc/cloudflared/` directory with restricted permissions
3. Deploys token to `/etc/cloudflared/token` (0600, root-owned)
4. Templates systemd service with `--token-file` flag
5. Enables and starts service (restarts if token changed)

**See:** `roles/cloudflared/README.md` for complete documentation and troubleshooting.

**See also:** `docs/CLOUDFLARED_SETUP.md` for comprehensive setup guide.

<<<<<<< HEAD

## ZSH Role Configuration

The ZSH role deploys modular shell configuration using numbered directories and a recursive loader.

**Quick Start (Default behavior):**

- Deploys entire `zsh.d/` directory structure
- Minimal configuration (PATH, history, options, completions)
- Recursive loader handles `.zsh`, `.sh`, `.conf`, and `.env` files

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

**Available Modules:**

- `00-path/` - PATH configuration (loaded first)
- `10-settings/` - Shell options and history
- `20-functions/` - Custom shell functions
- `30-aliases/` - Command aliases
- `40-completions/` - Completion system
- `50-secrets/` - API keys (use `.env` files)
- `60-exports/` - Environment exports
- `90-skogai/` - SkogAI integration (loaded last)

**File Type Handling:**

- `.zsh`, `.sh`, `.conf` - Sourced normally
- `.env` - Sourced with `set -o allexport` (auto-exports variables)

**Granular tag support:**

```bash
./run.sh --tags zsh-config    # Deploy config only
./run.sh --tags zsh-zshrc     # Deploy .zshrc only
./run.sh --tags zsh           # Deploy everything
```

**Current Configuration:**

The role currently deploys:

- Loader with recursive loading and `.env` support
- PATH setup for user binaries and toolchains
- 50,000 command history with smart filtering
- Shell options (auto-cd, directory stack, etc.)
- Completion system initialization

**See:** `roles/zsh/README.md` for complete documentation.

||||||| parent of 55abd31 (Squash commits from master)
=======

## Zsh Role Configuration

The Zsh role deploys modular shell configuration with numbered load-order directories. All features are **configurable via vars/zsh.yml**.

**Quick Start (Default behavior):**

- Installs zsh package
- Deploys `~/.config/zsh.d/` directory structure (29 files)
- Creates minimal `.zshrc` that sources the loader

**To customize zsh configuration:**

1. Edit files in `roles/zsh/files/zsh.d/` directories
2. Run: `./run.sh --tags zsh`

**Directory Structure (zsh.d/):**

```
~/.config/zsh.d/
├── loader.zsh           # Sources all config files
├── 00-path/             # PATH exports (loads first)
├── 10-settings/         # Shell settings (8 files)
├── 20-functions/        # Shell functions (4 files)
├── 30-aliases/          # Aliases (5 files)
├── 40-completions/      # Completion config (2 files)
├── 50-secrets/          # API keys (1 file)
├── 60-exports/          # Environment exports (2 files)
└── 90-skogai/           # SkogAI tools (5 files)
```

**loader.zsh Behavior:**

- Sources `.zsh`, `.sh`, `.conf` files normally
- Sources `.env` files with `allexport` (auto-exports all variables)

**Available Zsh Features (configure in vars/zsh.yml):**

- `zsh_install: true` - Install zsh package
- `zsh_deploy_config: true` - Deploy zsh.d structure to ~/.config
- `zsh_set_default_shell: false` - Set zsh as default shell

**Granular tag support:**

```bash
./run.sh --tags zsh              # All zsh tasks
./run.sh --tags zsh-install      # Only install zsh
./run.sh --tags zsh-config       # Only deploy configuration
./run.sh --tags zsh-default-shell # Only set default shell
```

**Design Decisions:**

- **Minimal .zshrc** - Single line: `source ~/.config/zsh.d/loader.zsh`
- **Ansible owns everything** - Chezmoi doesn't manage zsh config
- **Numbered directories** - Deterministic load order (00 → 90)
- **No plugin manager dependency** - Direct sourcing, no external deps

**See:** `roles/zsh/README.md` for complete documentation.

>>>>>>> 55abd31 (Squash commits from master)
>>>>>>>
## Reference

### Essential Reading

- @FILESTRUCTURE.md - Complete file structure overview
- @docs/README.md - Documentation navigation
- @docs/primitives/ansible-core.md - 7 fundamental Ansible primitives

### Role Documentation

- @roles/packages/README.md - Packages role documentation
- @roles/chezmoi/README.md - Chezmoi role documentation
- @roles/ssh/README.md - SSH role documentation
- @roles/git/README.md - Git role documentation
- @roles/cloudflared/README.md - Cloudflared role documentation
<<<<<<< HEAD
- @roles/zsh/README.md - ZSH role documentation
||||||| parent of 55abd31 (Squash commits from master)
=======
- @roles/zsh/README.md - Zsh role documentation

>>>>>>> 55abd31 (Squash commits from master)

### System Expansion

- @docs/primitives/system-inventory-by-primitives.md - Complete automation roadmap

### Configuration Decisions

- @docs/SETTINGS_DECISIONS.md - When uncertain, ADD questions here instead of guessing

### Historical Context

- @docs/repos/CLAUDE.md - Consolidation reference for 7 previous repos
