# Ansible Role: ZSH

<<<<<<< HEAD
Simple ZSH configuration deployment using modular directory structure.
||||||| parent of 55abd31 (Squash commits from master)
Zsh shell installation and configuration management
=======

Modular zsh configuration deployment with numbered load-order directories.
>>>>>>> 55abd31 (Squash commits from master)

<<<<<<< HEAD

## Features

||||||| parent of 55abd31 (Squash commits from master)
This role provides
=======

## What It Does
>>>>>>>
>>>>>>> 55abd31 (Squash commits from master)

<<<<<<< HEAD

- **Single task deployment** - Copies entire `zsh.d/` directory
- **Modular loader** - Loads numbered directories in sequence (00, 10, 20, etc.)
- **Recursive loading** - Supports nested files with `**/*.zsh` glob
- **File type handling** - `.env` files sourced with `allexport`, others sourced normally
- **Minimal by default** - Start with essentials (PATH, history, options, completions)
||||||| parent of 55abd31 (Squash commits from master)
- Zsh installation
- Configuration file deployment
- Default shell setup
- Plugin manager integration (zinit, oh-my-zsh, etc.)
=======
- Deploys `~/.config/zsh.d/` directory structure with modular configuration
- Creates minimal `.zshrc` (single line: `source ~/.config/zsh.d/loader.zsh`)
- Optionally sets zsh as default shell

>>>>>>> 55abd31 (Squash commits from master)

## Quick Start

<<<<<<< HEAD

```bash
./run.sh --tags zsh
```

## Architecture

### Directory Structure

```
~/.config/zsh.d/
├── loader.zsh          # Recursive loader
├── 00-path/            # PATH configuration (loaded first)
│   └── path.zsh
├── 10-settings/        # Shell options and history
│   ├── history.zsh
│   └── options.zsh
├── 20-functions/       # Custom functions (empty)
├── 30-aliases/         # Aliases (empty)
├── 40-completions/     # Completion system
│   └── completions.zsh
├── 50-secrets/         # API keys (empty)
├── 60-exports/         # Environment exports (empty)
└── 90-skogai/          # SkogAI integration (empty, loaded last)
```

### Loader Behavior

The loader (`loader.zsh`) processes files in this order:

1. **Directories** - Numerical order (00, 10, 20, ...)
2. **File types** - Within each directory:
   - `.zsh`, `.sh`, `.conf` - Sourced normally
   - `.env` - Sourced with `set -o allexport` (auto-export variables)
3. **Recursive** - Finds files in subdirectories using `**/*.ext`

Example:

```zsh
# loader.zsh
local zsh_d="${0:h}"
setopt nullglob

for dir in "$zsh_d"/[0-9]*(/N); do
    for file in "$dir"/**/*.conf "$dir"/**/*.sh "$dir"/**/*.zsh "$dir"/**/*.env; do
        if [[ -r "$file" ]]; then
            if [[ "$file" == *.env ]]; then
                set -o allexport
                source "$file"
                set +o allexport
            else
                source "$file"
            fi
        fi
    done
done

unsetopt nullglob
```

||||||| parent of 55abd31 (Squash commits from master)

- Ansible 2.10 or higher
- Target system: Arch Linux

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/zsh.yml`.

### Installation

```yaml
zsh_install: true              # Install zsh
zsh_package_name: "zsh"        # Package name
```

### Configuration

```yaml
zsh_deploy_config: false       # Deploy configuration file
zsh_config_file: "{{ ansible_facts['env']['HOME'] }}/.zshrc"
```

### Feature Flags

```yaml
zsh_set_default_shell: false   # Set zsh as default shell
zsh_enable_plugin_manager: false  # Enable plugin manager
zsh_plugin_manager: "zinit"    # Plugin manager to use
```

=======

- Ansible 2.10 or higher
- Target system: Arch Linux

## Directory Structure (zsh.d/)

The role deploys a modular zsh configuration organized by numbered directories for deterministic load order:

```
~/.config/zsh.d/
├── loader.zsh           # Main loader that sources everything
├── 00-path/             # PATH exports (loads first)
│   └── path.zsh
├── 10-settings/         # Shell settings (8 files)
│   ├── grc.zsh          # Generic colorizer setup
│   ├── history.zsh      # History configuration
│   ├── keybindings.zsh  # Key bindings (emacs mode)
│   ├── nvm.zsh          # Node Version Manager
│   ├── options.zsh      # Shell options (setopt)
│   ├── prompt.zsh       # Prompt configuration
│   ├── shell-enhancements.zsh  # Enhanced tools (zoxide, etc.)
│   └── zplug.zsh        # Plugin manager
├── 20-functions/        # Shell functions (4 files)
│   ├── docker.zsh       # Docker helper functions
│   ├── git.zsh          # Git helper functions
│   ├── python.zsh       # Python/venv functions
│   └── utils.zsh        # General utilities
├── 30-aliases/          # Aliases (5 files)
│   ├── build.zsh        # Build tool aliases
│   ├── git.zsh          # Git aliases
│   ├── navigation.zsh   # Directory navigation
│   ├── system.zsh       # System management
│   └── tools.zsh        # Tool aliases (eza, bat, etc.)
├── 40-completions/      # Completion config (2 files)
│   ├── argc.zsh         # argc completions
│   └── completions.zsh  # zstyle completion settings
├── 50-secrets/          # API keys (1 file)
│   └── openrouter.zsh   # OpenRouter API key
├── 60-exports/          # Environment exports (2 files)
│   ├── editor.zsh       # EDITOR/VISUAL
│   └── fzf.zsh          # FZF configuration
└── 90-skogai/           # SkogAI tools (5 files)
    ├── ai.zsh           # AI tool wrappers
    ├── aichat.zsh       # aichat configuration
    ├── dev.zsh          # Development helpers
    ├── skogai.zsh       # SkogAI paths
    └── skogcli.zsh      # skogcli integration
```

## loader.zsh Behavior

The loader sources files in directory order (00 → 90) with special handling:

- **`.zsh`, `.sh`, `.conf` files** → Sourced normally
- **`.env` files** → Sourced with `allexport` (auto-exports all variables)

```zsh
# loader.zsh behavior
for dir in "$zsh_d"/[0-9]*(/N); do
    for file in "$dir"/*.(zsh|sh|conf)(N); do
        source "$file"
    done
    for file in "$dir"/*.env(N); do
        set -o allexport
        source "$file"
        set +o allexport
    done
done
```

## Role Variables

All variables defined in `defaults/main.yml` with sensible defaults. Override in `vars/zsh.yml`.

| Variable | Default | Description |
|----------|---------|-------------|
| `zsh_install` | `true` | Install zsh package |
| `zsh_package_name` | `zsh` | Package name to install |
| `zsh_deploy_config` | `true` | Deploy zsh.d structure to ~/.config |
| `zsh_set_default_shell` | `false` | Set zsh as user's default shell |

>>>>>>> 55abd31 (Squash commits from master)

## Configuration

<<<<<<< HEAD

### Role Variables (defaults/main.yml)

||||||| parent of 55abd31 (Squash commits from master)
None

## Example Playbook

### Basic Usage

=======
None

## Example Playbook

### Basic Usage (deploy config only)
>>>>>>>
>>>>>>> 55abd31 (Squash commits from master)

```yaml
<<<<<<< HEAD
zsh_deploy_config: true
zsh_config_dir: "{{ ansible_user_dir }}/.config/zsh.d"
zsh_deploy_zshrc: true
zsh_backup_existing: true
||||||| parent of 55abd31 (Squash commits from master)
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
=======
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
>>>>>>> 55abd31 (Squash commits from master)
```

<<<<<<< HEAD

### Project Configuration (vars/zsh.yml)

||||||| parent of 55abd31 (Squash commits from master)

### Full Setup

=======

### Full Setup (with default shell)
>>>>>>>
>>>>>>> 55abd31 (Squash commits from master)

```yaml
<<<<<<< HEAD
# Deploy to test directory while building
zsh_config_dir: "{{ ansible_user_dir }}/.config/zsh.d.ansible-test"
zsh_deploy_zshrc: false
||||||| parent of 55abd31 (Squash commits from master)
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
        zsh_set_default_shell: true
        zsh_enable_plugin_manager: true
        zsh_plugin_manager: "zinit"
=======
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
        zsh_set_default_shell: true
>>>>>>> 55abd31 (Squash commits from master)
```

Switch to production when ready:

```yaml
zsh_config_dir: "{{ ansible_user_dir }}/.config/zsh.d"
zsh_deploy_zshrc: true
```

## Current Modules

### 00-path (Essential)

**Files:** `path.zsh`

Sets up PATH for:

- User binaries (`~/.local/bin`, `~/bin`)
- Rust (`~/.cargo/bin`)
- Go (`$GOPATH/bin`)
- Node/pnpm (`~/.local/share/pnpm`)
- Custom tools (`~/.opencode/bin`)

### 10-settings (Essential)

**Files:** `history.zsh`, `options.zsh`

**history.zsh:**

- 50,000 command history
- Duplicate filtering
- Timestamp recording
- Shared across sessions

**options.zsh:**

- Auto-cd to directories
- Directory stack management
- Interactive comments
- Disables auto-correct

### 40-completions (Essential)

**Files:** `completions.zsh`

Sets up completion system:

- Adds `~/.config/zsh.d/completions` to fpath
- Initializes compinit
- Configures completion behavior (menu select, case-insensitive, etc.)

Place completion files in `40-completions/` subdirectories.

### Empty Modules

These directories exist but have no files:

- `20-functions/` - Add custom shell functions
- `30-aliases/` - Add command aliases
- `50-secrets/` - Add API keys/tokens (use `.env` files)
- `60-exports/` - Add environment exports
- `90-skogai/` - Add SkogAI integration

## Adding Configuration

### 1. Add File to Module

```bash
# Example: Add editor export
cat > roles/zsh/files/zsh.d/60-exports/editor.zsh << 'EOF'
export EDITOR='nvim'
export VISUAL='nvim'
EOF
```

### 2. Deploy

```bash
./run.sh --tags zsh-config
```

### 3. Test

```bash
zsh -c "source ~/.config/zsh.d/loader.zsh && echo \$EDITOR"
```

## File Type Usage

### .zsh files (standard)

Use for shell scripts that need explicit control:

```zsh
# 60-exports/editor.zsh
export EDITOR='nvim'
export VISUAL='nvim'
```

### .env files (auto-export)

Use for simple KEY=VALUE pairs:

```bash
# 50-secrets/api-keys.env
OPENROUTER_API_KEY=sk-xxxxx
GITHUB_TOKEN=ghp_xxxxx
```

No `export` needed - the loader enables `allexport` automatically.

## Tags

```bash
<<<<<<< HEAD
# Deploy config only
||||||| parent of 55abd31 (Squash commits from master)
# Run entire role
./run.sh --tags zsh

# Run only installation
./run.sh --tags zsh-install

# Run only configuration
=======
# Run entire role
./run.sh --tags zsh

# Only install zsh package
./run.sh --tags zsh-install

# Only deploy zsh.d configuration
>>>>>>> 55abd31 (Squash commits from master)
./run.sh --tags zsh-config

<<<<<<< HEAD
# Deploy .zshrc only
./run.sh --tags zsh-zshrc

# Deploy everything
./run.sh --tags zsh
||||||| parent of 55abd31 (Squash commits from master)
# Set default shell
./run.sh --tags zsh-default-shell

# Setup plugins
./run.sh --tags zsh-plugins
=======
# Only set default shell
./run.sh --tags zsh-default-shell
>>>>>>> 55abd31 (Squash commits from master)
```

## Role Structure

<<<<<<< HEAD

```
roles/zsh/
├── defaults/main.yml       # Default variables (7 lines)
├── tasks/
│   ├── main.yml           # Orchestrator (2 includes)
│   ├── deploy_config.yml  # Single copy task
│   └── deploy_zshrc.yml   # .zshrc deployment
├── files/
│   └── zsh.d/             # Config files
│       ├── loader.zsh
│       ├── 00-path/
│       ├── 10-settings/
│       ├── 20-functions/
│       ├── 30-aliases/
│       ├── 40-completions/
│       ├── 50-secrets/
│       ├── 60-exports/
│       └── 90-skogai/
├── templates/
│   └── zshrc.j2          # .zshrc template
└── README.md             # This file
```

||||||| parent of 55abd31 (Squash commits from master)

- `zsh` - Run all tasks
- `zsh-install` - Installation tasks
- `zsh-config` - Configuration tasks
- `zsh-default-shell` - Default shell tasks
- `zsh-plugins` - Plugin manager tasks
=======
- `zsh` - Run all tasks
- `zsh-install` - Install zsh package
- `zsh-config` - Deploy zsh.d directory and .zshrc
- `zsh-default-shell` - Set zsh as default shell

## Design Decisions

### Why Modular zsh.d?

1. **Maintainability** - Each concern in separate files
2. **Deterministic loading** - Numbered directories ensure correct order
3. **Easy debugging** - Isolate issues to specific files
4. **No plugin manager dependency** - Direct sourcing, no external deps

### Why Minimal .zshrc?

The `.zshrc` contains only: `source ~/.config/zsh.d/loader.zsh`

- **Single source of truth** - All config in zsh.d
- **No conflicts** - Chezmoi doesn't manage zsh config
- **Ansible owns everything** - Clear ownership boundary

### Why .env with allexport?

Files ending in `.env` are sourced with `set -o allexport` which automatically exports all variables. This allows:

- Clean separation of secrets (API keys, tokens)
- Standard `.env` file format
- Automatic export without `export` prefix

## Customization

### Adding New Configuration

1. Choose appropriate directory (00-90 based on load order needs)
2. Create `.zsh` file with your config
3. Run `./run.sh --tags zsh-config` to deploy

### Secrets Management

Place sensitive exports in `50-secrets/` directory. Files here are deployed but should be:

- Not committed to version control (add to .gitignore if needed)
- Deployed from encrypted vault for production

>>>>>>> 55abd31 (Squash commits from master)

## Notes

- **ZSH installation** is handled by packages role, not this role
- **Completions** go in `40-completions/` module, not a separate directory
- **Empty directories** have `.gitkeep` files to preserve structure
- **Test deployment** uses `zsh.d.ansible-test` directory while building

## Troubleshooting

### Loader not sourcing files

Check file permissions - must be readable:

```bash
ls -la ~/.config/zsh.d/10-settings/
```

### Variables not set

Test direct sourcing:

```bash
zsh -c "source ~/.config/zsh.d/10-settings/history.zsh && echo \$HISTSIZE"
```

### Global configs override settings

The loader must be sourced from `.zshrc` LAST so settings take precedence over global configs.
