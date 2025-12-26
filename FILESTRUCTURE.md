# File Structure

**Repository:** SkogAI/skogansible

Complete file structure with descriptions for all files in the active ansible repository.

## Tree Structure

```
SkogAI/skogansible/
├── ansible.cfg                          # Ansible configuration (interpreter, inventory, collections path)
├── .inventory                           # Ansible inventory file (defines localhost target)
├── playbook.yml                         # Main playbook orchestrating 4 roles
├── .requirements.yml                    # Ansible Galaxy collections (community.general, kewlfft.aur, ansible.posix)
├── bootstrap.sh                         # Bootstrap script (creates venv, installs Ansible + collections)
├── run.sh                               # Playbook execution wrapper script
├── .envrc                               # direnv configuration (loads environment from skogcli)
├── .gitignore                           # Git ignore patterns
├── README.md                            # Project overview and quick start guide
├── CLAUDE.md                            # Complete project documentation (detailed usage, all features)
├── FILESTRUCTURE.md                     # This file - complete file structure reference
│
├── .config/                             # Project-specific configuration
│   └── wt.toml                          # Worktrunk hooks configuration (post-create, pre-merge, etc.)
│
├── .worktrees/                          # Git worktrees directory (isolated development)
│   └── .gitkeep                         # Keeps directory in git (worktrees are gitignored)
│
├── roles/                               # Ansible roles directory
│   ├── packages/                        # Package management role (pacman + AUR)
│   │   ├── tasks/
│   │   │   ├── main.yml                 # Main package tasks (orchestrates all tasks)
│   │   │   ├── aur_user.yml             # Creates aur_builder user for secure AUR building
│   │   │   ├── aur_helper.yml           # Installs yay AUR helper from source
│   │   │   └── aur_packages.yml         # Installs AUR packages via yay
│   │   ├── defaults/main.yml            # Default variables for packages role
│   │   ├── handlers/main.yml            # Handlers for packages role
│   │   └── meta/main.yml                # Role metadata and dependencies
│   │
│   ├── ssh/                             # SSH configuration role
│   │   ├── tasks/
│   │   │   └── main.yml                 # SSH tasks (keys, config, known_hosts, authorized_keys)
│   │   ├── templates/
│   │   │   └── ssh_config.j2            # SSH config template (connection multiplexing, aliases)
│   │   ├── examples/                    # Example configurations
│   │   ├── vars/                        # Role-specific variables
│   │   ├── defaults/main.yml            # Default variables for SSH role
│   │   ├── handlers/main.yml            # Handlers for SSH role (restart ssh-agent)
│   │   ├── meta/main.yml                # Role metadata
│   │   └── README.md                    # Complete SSH role documentation
│   │
│   ├── git/                             # Git configuration role
│   │   ├── tasks/
│   │   │   ├── main.yml                 # Git tasks orchestration
│   │   │   ├── install.yml              # Git package installation
│   │   │   ├── configure_global.yml     # Global gitconfig settings
│   │   │   ├── configure_aliases.yml    # Git aliases configuration
│   │   │   ├── configure_credentials.yml # Credential helper setup
│   │   │   ├── install_lfs.yml          # Git LFS installation
│   │   │   ├── clone_repositories.yml   # Repository cloning
│   │   │   ├── deploy_gitignore.yml     # Global gitignore deployment
│   │   │   ├── deploy_hooks.yml         # Git hooks deployment
│   │   │   ├── configure_signing.yml    # GPG/SSH commit signing
│   │   │   ├── configure_repo_specific.yml # Repository-specific configs
│   │   │   └── maintenance.yml          # Git maintenance tasks
│   │   ├── templates/
│   │   │   ├── gitconfig.j2             # .gitconfig template
│   │   │   ├── gitignore_global.j2      # Global gitignore patterns
│   │   │   └── hooks/                   # Git hook templates
│   │   │       ├── pre-commit.j2        # Pre-commit hook template
│   │   │       └── commit-msg.j2        # Commit message hook template
│   │   ├── defaults/main.yml            # Default variables for git role
│   │   ├── handlers/main.yml            # Handlers for git role
│   │   ├── meta/main.yml                # Role metadata
│   │   └── README.md                    # Complete Git role documentation
│   │
│   ├── chezmoi/                         # Chezmoi dotfiles management role
│   │   ├── tasks/
│   │   │   ├── main.yml                 # Chezmoi tasks orchestration
│   │   │   ├── install.yml              # Chezmoi installation verification
│   │   │   ├── init.yml                 # Source directory initialization check
│   │   │   ├── configure.yml            # Template .chezmoidata.yaml
│   │   │   └── apply.yml                # Apply dotfiles configuration
│   │   ├── templates/
│   │   │   └── chezmoidata.yaml.j2      # Machine-specific chezmoi configuration template
│   │   ├── defaults/main.yml            # Default variables for chezmoi role
│   │   ├── handlers/main.yml            # Handlers for chezmoi role
│   │   └── meta/main.yml                # Role metadata
│   │
│   ├── cloudflared/                     # Cloudflare Tunnel management role
│   │   ├── tasks/
│   │   │   └── main.yml                 # Cloudflared tasks (token deployment, service management)
│   │   ├── templates/
│   │   │   └── cloudflared.service.j2   # Systemd service template (uses --token-file)
│   │   ├── defaults/main.yml            # Default variables for cloudflared role
│   │   ├── handlers/main.yml            # Handlers for cloudflared role (daemon-reload, restart)
│   │   ├── meta/main.yml                # Role metadata
│   │   └── README.md                    # Complete Cloudflared role documentation
│   │
│   └── graphics/                        # GPU drivers and Ollama management role
│       ├── tasks/
│       │   ├── main.yml                 # Graphics tasks orchestration
│       │   ├── drivers.yml              # GPU driver installation (NVIDIA/AMD/Intel)
│       │   ├── cuda.yml                 # CUDA toolkit installation
│       │   └── ollama.yml               # Ollama installation and model management
│       ├── defaults/main.yml            # Default variables for graphics role
│       ├── handlers/main.yml            # Handlers for graphics role (initramfs regeneration)
│       ├── meta/main.yml                # Role metadata
│       └── README.md                    # Complete Graphics role documentation
│
├── vars/                                # Variable files (role-specific configuration)
│   ├── main.yml                         # Shared variables across roles
│   ├── packages.yml                     # Package lists (61 official + 7 AUR packages)
│   ├── ssh.yml                          # SSH role configuration (features, paths, permissions)
│   ├── ssh_vault.yml                    # Encrypted SSH keys (ansible-vault)
│   ├── git.yml                          # Git configuration (user, aliases, repos, hooks)
│   ├── chezmoi.yml                      # Chezmoi configuration (machine profile, agents)
│   ├── cloudflared.yml                  # Cloudflared configuration (deployment flags, extra args)
│   ├── cloudflared_vault.yml            # Encrypted Cloudflare tunnel token (ansible-vault)
│   ├── cloudflared_vault.yml.template   # Template for creating vault file
│   ├── graphics.yml                     # Graphics configuration (GPU driver, CUDA, Ollama models)
│   └── user.yml                         # User-specific variables (username, groups, shell)
│
├── docs/                                # Documentation directory
│   ├── README.md                        # Documentation index and navigation guide
│   ├── CLOUDFLARED_SETUP.md             # Cloudflared setup guide (comprehensive setup instructions)
│   ├── primitives/                      # Core Ansible patterns and system inventory
│   │   ├── ansible-core.md              # Reference: 7 fundamental Ansible primitives
│   │   └── system-inventory-by-primitives.md # Roadmap: complete system organized by primitives
│   └── repos/                           # Historical repository documentation
│       ├── CLAUDE.md                    # Consolidation guide for 7 historical ansible repos
│       ├── ANSIBLE-BASE.md              # Documentation from ansible-base (45 roles, 400+ tasks)
│       ├── SETUP.md                     # Documentation from setup repo (325 tasks)
│       ├── SKOGANSIBLE.md               # Documentation from skogansible repo (147 tasks)
│       ├── DOTFILE-ANSIBLE.md           # Documentation from dotfile-ansible (36 tasks)
│       ├── ARCHIVE-2025-10-05-ANSIBLE.md # Documentation from archived multi-OS config (211 tasks)
│       ├── DOT_ANSIBLE.md               # Documentation from legacy .ansible (36 tasks)
│       └── ANSIBLE-COLLECTION-TOOLS.md  # Documentation from external collection (120+ tasks)
│
├── collections/                         # Ansible Galaxy collections (installed)
│   └── ansible_collections/
│       ├── community/                   # community.general collection
│       ├── kewlfft/                     # kewlfft.aur collection (AUR support)
│       └── ansible/                     # ansible.posix collection
│
├── .claude/                             # Claude Code configuration directory
│   ├── settings.json                    # Claude Code settings
│   ├── settings.local.json              # Local overrides for Claude settings
│   ├── agents/                          # Custom agent configurations
│   │   ├── code-review.md               # Code review agent configuration
│   │   ├── context-gathering.md         # Context gathering agent configuration
│   │   ├── context-refinement.md        # Context refinement agent configuration
│   │   ├── logging.md                   # Logging agent configuration
│   │   └── service-documentation.md     # Service documentation agent configuration
│   ├── commands/                        # Custom slash commands
│   │   └── sessions.md                  # Sessions command definition
│   └── skills/                          # Project-specific skills
│       └── ansible-core/                # Ansible core primitives skill
│
└── .ansible/                            # Local Ansible directory (runtime)
    ├── ansible.cfg                      # Local Ansible configuration
    ├── collections/                     # Collections cache
    ├── galaxy_cache/                    # Galaxy API cache
    └── galaxy_token                     # Galaxy authentication token
```

## Key Files

### Core Configuration

- **ansible.cfg** - Ansible configuration defining Python interpreter, inventory location, and collections path
- **.inventory** - Defines localhost as the managed host for all playbook runs
- **.requirements.yml** - Lists required Ansible Galaxy collections (community.general, kewlfft.aur, ansible.posix)
- **.envrc** - direnv configuration that loads environment variables from skogcli (sudo password file, paths)
- **./tmp/ENV** - Output from bootstrap.sh which dumps the current environment variables (!`ansible-config dump --type all`)

### Execution Scripts

- **bootstrap.sh** - Initial setup script that creates Python venv, installs Ansible and collections
- **run.sh** - Wrapper script to activate venv and execute ansible-playbook with provided arguments

### Playbooks

- **playbook.yml** - Main playbook that orchestrates all roles (packages, ssh, git, chezmoi, cloudflared, graphics) with proper variable loading

### Documentation

- **README.md** - Project overview with quick start guide and repository identity
- **CLAUDE.md** - Comprehensive project documentation covering all features, configuration, and usage patterns
- **FILESTRUCTURE.md** - This file, complete file structure reference with descriptions
- **docs/README.md** - Documentation navigation index
- **docs/primitives/ansible-core.md** - Reference guide for 7 fundamental Ansible primitives with examples
- **docs/primitives/system-inventory-by-primitives.md** - Complete system automation roadmap organized by primitives
- **docs/repos/CLAUDE.md** - Historical documentation consolidation guide for 7 previous ansible repositories

### Roles

Each role follows standard Ansible structure with tasks/, templates/, defaults/, handlers/, and meta/ directories.

#### packages/

Manages system packages from official Arch repositories (pacman) and AUR (yay). Creates secure aur_builder user for AUR package building.

#### ssh/

Manages SSH configuration including key deployment from vault, config templating, known_hosts management, and authorized_keys.

#### git/

Comprehensive Git configuration with modular tasks for installation, global config, aliases, credential management, LFS, hooks, signing, and repository-specific settings.

#### chezmoi/

Manages dotfiles by templating machine-specific .chezmoidata.yaml configuration and applying dotfiles automatically.

#### cloudflared/

Manages Cloudflare Tunnel with secure token storage using ansible-vault. Deploys tunnel token from encrypted vault, configures systemd service with --token-file flag (no plaintext secrets), and manages service enablement.

#### graphics/

Manages GPU drivers and Ollama AI model infrastructure. Installs NVIDIA/AMD/Intel drivers, optional CUDA toolkit, Ollama service, and pulls AI models. Automatically regenerates initramfs after driver changes.

### Variables

All role-specific configuration stored in `vars/` directory:

- **packages.yml** - Lists of official and AUR packages to install
- **ssh.yml** - SSH role feature flags and configuration
- **ssh_vault.yml** - Encrypted SSH keys (use ansible-vault to edit)
- **git.yml** - Git user configuration, aliases, repositories, and features
- **chezmoi.yml** - Machine profile settings (type, WM, agents, tools)
- **cloudflared.yml** - Cloudflared configuration (deployment flags, extra args)
- **cloudflared_vault.yml** - Encrypted Cloudflare tunnel token (use ansible-vault to edit)
- **cloudflared_vault.yml.template** - Template for creating vault file
- **graphics.yml** - Graphics configuration (GPU driver selection, CUDA, Ollama models)
- **user.yml** - User-specific variables (username, groups, shell)
- **main.yml** - Shared variables across all roles

### Collections

Installed Ansible Galaxy collections in `collections/ansible_collections/`:

- **community.general** - Community-maintained modules (pacman, etc.)
- **kewlfft.aur** - AUR package management module
- **ansible.posix** - POSIX-specific modules

### Claude Code Integration

The `.claude/` directory contains Claude Code configuration:

- Custom agents for code review, context gathering, logging, and documentation
- Custom slash commands for session management
- Project-specific skills (ansible-core primitives skill)

## Ignored Paths

The following directories are excluded from version control (see .gitignore):

- `.venv/` - Python virtual environment
- `*.retry` - Ansible retry files
- `.ansible/collections/` - Downloaded collections cache
- `__pycache__/`, `*.pyc` - Python bytecode
- `tmp/` - Temporary ansible files
- `backup/` - Backup files and archives

## File Counts

- **6 roles** - packages, ssh, git, chezmoi, cloudflared, graphics
- **11 variable files** - Role-specific configuration
- **17+ task files** - Modular task definitions
- **7+ templates** - Jinja2 templates for configs and hooks
- **13+ documentation files** - Reference and historical docs
- **3 collections** - Ansible Galaxy collections installed

---

This file structure supports the primitives-based architecture documented in `docs/primitives/ansible-core.md` and the system expansion roadmap in `docs/primitives/system-inventory-by-primitives.md`.
