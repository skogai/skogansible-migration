# Ansible Role: zsh

Modular zsh configuration deployment with numbered load-order directories.

## What It Does

- Deploys `~/.config/zsh.d/` directory structure with modular configuration
- Creates minimal `.zshrc` (single line: `source ~/.config/zsh.d/loader.zsh`)
- Optionally sets zsh as default shell

## Requirements

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

## Dependencies

None

## Example Playbook

### Basic Usage (deploy config only)

```yaml
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
```

### Full Setup (with default shell)

```yaml
- hosts: localhost
  roles:
    - role: zsh
      vars:
        zsh_install: true
        zsh_deploy_config: true
        zsh_set_default_shell: true
```

## Tags

Run specific parts of the role:

```bash
# Run entire role
./run.sh --tags zsh

# Only install zsh package
./run.sh --tags zsh-install

# Only deploy zsh.d configuration
./run.sh --tags zsh-config

# Only set default shell
./run.sh --tags zsh-default-shell
```

Available tags:

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

## License

MIT

## Author Information

Created by skogix for SkogAI/skogansible
