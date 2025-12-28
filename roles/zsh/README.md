# Ansible Role: ZSH

Zsh shell installation and configuration management.

This role provides:

- Zsh installation
- Configuration file deployment
- Default shell setup
- Plugin manager integration (zinit, oh-my-zsh, etc.)

## Quick Start

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

## Configuration

None

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
```

### Full Setup

```yaml
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
        zsh_set_default_shell: true
        zsh_enable_plugin_manager: true
        zsh_plugin_manager: "zinit"
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
# Run entire role
./run.sh --tags zsh

# Run only installation
./run.sh --tags zsh-install

# Run only configuration
./run.sh --tags zsh-config

# Set default shell
./run.sh --tags zsh-default-shell

# Setup plugins
./run.sh --tags zsh-plugins
```

## Role Structure

- `zsh` - Run all tasks
- `zsh-install` - Installation tasks
- `zsh-config` - Configuration tasks
- `zsh-default-shell` - Default shell tasks
- `zsh-plugins` - Plugin manager tasks

## License

MIT

## Author

skogix (SkogAI)
