# Ansible Role: ZSH

Simple ZSH configuration deployment using modular directory structure.

## Features

- **Single task deployment** - Copies entire `zsh.d/` directory
- **Modular loader** - Loads numbered directories in sequence (00, 10, 20, etc.)
- **Recursive loading** - Supports nested files with `**/*.zsh` glob
- **File type handling** - `.env` files sourced with `allexport`, others sourced normally
- **Minimal by default** - Start with essentials (PATH, history, options, completions)

## Quick Start

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

## Configuration

### Role Variables (defaults/main.yml)

```yaml
zsh_deploy_config: true
zsh_config_dir: "{{ ansible_user_dir }}/.config/zsh.d"
zsh_deploy_zshrc: true
zsh_backup_existing: true
```

### Project Configuration (vars/zsh.yml)

```yaml
# Deploy to test directory while building
zsh_config_dir: "{{ ansible_user_dir }}/.config/zsh.d.ansible-test"
zsh_deploy_zshrc: false
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
# Deploy config only
./run.sh --tags zsh-config

# Deploy .zshrc only
./run.sh --tags zsh-zshrc

# Deploy everything
./run.sh --tags zsh
```

## Role Structure

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

## License

MIT

## Author

skogix (SkogAI)
