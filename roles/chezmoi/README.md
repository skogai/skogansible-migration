# Ansible Role: Chezmoi

Chezmoi dotfiles management role with machine-specific configuration templating.

This role provides automated dotfiles management including:

- Chezmoi installation verification
- Source directory initialization
- Machine-specific `.chezmoidata.yaml` templating
- Profile-based configuration (workstation, laptop, WSL)
- SkogAI agent integration
- Automatic dotfiles application with change detection

## Requirements

- Ansible 2.10 or higher
- Target system: Arch Linux (adaptable to other distros)
- Chezmoi must be installed (verified by role, install via packages role)
- Chezmoi source directory at `~/.local/share/chezmoi`

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/chezmoi.yml`.

### Installation & Setup

```yaml
chezmoi_ensure_installed: true                           # Verify chezmoi is installed
chezmoi_init_source: true                                # Check source directory exists
chezmoi_source_dir: "{{ ansible_user_dir }}/.local/share/chezmoi"  # Source directory
```

### Configuration Deployment

```yaml
chezmoi_deploy_config: true                              # Template .chezmoidata.yaml
chezmoi_apply_on_change: true                            # Auto-apply after config changes
```

### Machine Profile

```yaml
chezmoi_machine_type: workstation                        # workstation, laptop, or wsl
chezmoi_hostname: "{{ inventory_hostname }}"             # Machine hostname
```

### User Information

```yaml
chezmoi_user_name: "{{ users[0].name }}"                 # User name
chezmoi_user_email: "{{ users[0].git_email }}"           # Email address
chezmoi_github_user: "{{ users[0].git_name }}"           # GitHub username
```

### Environment Flags

```yaml
chezmoi_personal: true                                   # Personal machine
chezmoi_work: false                                      # Work machine
chezmoi_headless: false                                  # Headless environment (auto-true for WSL)
chezmoi_gui: true                                        # GUI enabled (auto-false for headless)
```

### Desktop Environment

```yaml
chezmoi_wm: i3                                           # Window manager (i3, sway, none)
chezmoi_laptop_mode: false                               # Laptop-specific features
chezmoi_terminal: kitty                                  # Terminal emulator
```

### Feature Flags

```yaml
chezmoi_ai_tools: true                                   # AI tools integration
chezmoi_development: true                                # Development tools

# GUI applications (auto-disabled if headless)
chezmoi_gui_apps_enabled: "{{ chezmoi_gui }}"
chezmoi_dunst_enabled: "{{ chezmoi_gui }}"
chezmoi_kitty_enabled: "{{ chezmoi_gui }}"

# Dev tools
chezmoi_direnv_enabled: true
chezmoi_gh_enabled: true
chezmoi_gita_enabled: true
```

### SkogAI Integration

```yaml
# Enable/disable individual agents
chezmoi_agents:
  claude: true
  letta: true
  amy: true
  goose: true
  dot: true

# SkogAI directory paths
chezmoi_skogai_home: "{{ ansible_user_dir }}/skogai"
chezmoi_skogai_docs: "{{ ansible_user_dir }}/skogai/docs"
chezmoi_skogai_tools: "{{ ansible_user_dir }}/skogai/tools"
```

### Debug Mode

```yaml
chezmoi_debug: true                                      # Enable debug output
```

## Dependencies

- Chezmoi must be installed (can be installed via packages role)
- Chezmoi source directory must exist at `~/.local/share/chezmoi`

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: chezmoi
      vars:
        chezmoi_machine_type: workstation
        chezmoi_wm: i3
```

### Laptop Configuration

```yaml
- hosts: laptop
  roles:
    - role: chezmoi
      vars:
        chezmoi_machine_type: laptop
        chezmoi_laptop_mode: true
        chezmoi_wm: sway
        chezmoi_terminal: alacritty
```

### WSL Configuration

```yaml
- hosts: wsl
  roles:
    - role: chezmoi
      vars:
        chezmoi_machine_type: wsl
        chezmoi_headless: true
        chezmoi_gui: false
        chezmoi_wm: none
```

### With SkogAI Integration

```yaml
- hosts: localhost
  vars_files:
    - vars/chezmoi.yml
  roles:
    - chezmoi
  tags:
    - chezmoi
```

## Role Tasks

The role executes tasks in this order:

### 1. Installation Verification (`install.yml`)

Verifies chezmoi is installed:

- Checks for chezmoi binary in PATH
- Fails with helpful message if not found
- Recommends installing via packages role

### 2. Source Directory Initialization (`init.yml`)

Checks source directory exists:

- Verifies `~/.local/share/chezmoi` directory exists
- Fails with helpful message if not initialized
- Provides instructions for `chezmoi init`

### 3. Configuration Templating (`configure.yml`)

Templates `.chezmoidata.yaml`:

- Generates machine-specific configuration from template
- Includes machine profile (type, hostname, WM)
- Includes user information
- Includes environment flags
- Includes SkogAI agent configuration
- Registers configuration changes

### 4. Dotfiles Application (`apply.yml`)

Applies dotfiles if configuration changed:

- Runs `chezmoi apply` only when `.chezmoidata.yaml` changes
- Uses change detection to avoid unnecessary applications
- Provides verbose output in debug mode

## Tags

The role supports granular execution via tags:

- `chezmoi` - All chezmoi tasks
- `chezmoi-install` - Verify installation only
- `chezmoi-init` - Check initialization only
- `chezmoi-config` - Template configuration only
- `chezmoi-apply` - Apply dotfiles only

### Tag Usage Examples

```bash
# Verify chezmoi is installed
ansible-playbook playbook.yml --tags chezmoi-install

# Template configuration only (no apply)
ansible-playbook playbook.yml --tags chezmoi-config

# Apply dotfiles only (if config changed)
ansible-playbook playbook.yml --tags chezmoi-apply

# Full chezmoi management
ansible-playbook playbook.yml --tags chezmoi
```

## Variables File Example

Create `vars/chezmoi.yml`:

```yaml
---
# Machine profile
chezmoi_machine_type: workstation
chezmoi_hostname: archbox
chezmoi_wm: i3
chezmoi_laptop_mode: false
chezmoi_terminal: kitty

# Environment
chezmoi_personal: true
chezmoi_work: false
chezmoi_headless: false
chezmoi_gui: true

# Features
chezmoi_ai_tools: true
chezmoi_development: true

# SkogAI agents
chezmoi_agents:
  claude: true
  letta: true
  amy: false
  goose: true
  dot: true

# SkogAI paths
chezmoi_skogai_home: "{{ ansible_user_dir }}/skogai"
```

## Configuration Template

The role templates `.chezmoidata.yaml` in your chezmoi source directory:

```yaml
# Machine Profile
machine:
  type: workstation
  hostname: archbox

# User Information
user:
  name: skogix
  email: user@example.com
  github: skogix

# Environment
environment:
  personal: true
  work: false
  headless: false
  gui: true

# Desktop
desktop:
  wm: i3
  laptop_mode: false
  terminal: kitty

# Features
features:
  ai_tools: true
  development: true
  gui_apps: true
  dunst: true
  kitty: true
  direnv: true
  gh: true
  gita: true

# SkogAI
skogai:
  agents:
    claude: true
    letta: true
    amy: true
    goose: true
    dot: true
  paths:
    home: /home/skogix/skogai
    docs: /home/skogix/skogai/docs
    tools: /home/skogix/skogai/tools
```

## Integration with Chezmoi

This role complements your chezmoi dotfiles setup:

1. **Ansible manages machine profile** - Templates `.chezmoidata.yaml` with machine-specific settings
2. **Chezmoi manages dotfiles** - Uses `.chezmoidata.yaml` for conditional deployment
3. **Profile-based filtering** - `.chezmoiignore` patterns filter files by machine type

### Example `.chezmoiignore` patterns

```
# Workstation only
{{ if ne .machine.type "workstation" }}
.config/i3/
.config/dunst/
{{ end }}

# Laptop only
{{ if ne .machine.type "laptop" }}
.config/battery/
{{ end }}

# GUI environments only
{{ if not .environment.gui }}
.config/kitty/
.config/i3/
{{ end }}

# SkogAI agents
{{ if not .skogai.agents.claude }}
.config/claude/
{{ end }}
```

## Machine Types

The role supports three machine types:

### workstation

- Full GUI environment
- Desktop window manager (i3/sway)
- All development tools
- SkogAI integration
- No laptop-specific features

### laptop

- Full GUI environment
- Laptop window manager (often sway)
- Battery management tools
- Power optimization
- Laptop-specific keybindings

### wsl

- Headless environment (auto-configured)
- No GUI applications (auto-disabled)
- No window manager
- CLI tools only
- WSL-specific configurations

## Troubleshooting

### Chezmoi Not Installed

If the role fails with "chezmoi binary not found":

```bash
# Install via packages role
ansible-playbook playbook.yml --tags packages

# Or install manually
pacman -S chezmoi
```

### Source Directory Not Initialized

If the role fails with "chezmoi source directory not found":

```bash
# Initialize chezmoi
chezmoi init

# Or initialize with a dotfiles repo
chezmoi init https://github.com/yourusername/dotfiles.git
```

### Configuration Not Applied

If `.chezmoidata.yaml` is templated but dotfiles not applied:

1. Check that `chezmoi_apply_on_change: true` in vars
2. Verify the configuration actually changed (Ansible shows "changed" status)
3. Run manual apply: `chezmoi apply -v`

### SkogAI Paths Not Found

If SkogAI paths are incorrect:

1. Update `chezmoi_skogai_home` in `vars/chezmoi.yml`
2. Ensure SkogAI directory structure exists
3. Re-run: `ansible-playbook playbook.yml --tags chezmoi-config,chezmoi-apply`

## Testing

Test the role in check mode (dry-run):

```bash
ansible-playbook playbook.yml --tags chezmoi --check
```

Test specific components:

```bash
# Test installation check
ansible-playbook playbook.yml --tags chezmoi-install --check

# Test configuration templating
ansible-playbook playbook.yml --tags chezmoi-config --check

# Test dotfiles application
ansible-playbook playbook.yml --tags chezmoi-apply --check
```

## Role Structure

```
roles/chezmoi/
├── tasks/
│   ├── main.yml           # Orchestrates all tasks
│   ├── install.yml        # Verify chezmoi installation
│   ├── init.yml           # Check source directory
│   ├── configure.yml      # Template .chezmoidata.yaml
│   └── apply.yml          # Apply dotfiles
├── templates/
│   └── chezmoidata.yaml.j2  # Machine configuration template
├── defaults/main.yml      # Default variables
├── handlers/main.yml      # Handlers
├── meta/main.yml          # Role metadata
└── README.md              # This file
```

## Further Reading

- **Chezmoi Documentation:** <https://www.chezmoi.io/>
- **Ansible Integration Guide:** `~/.local/share/chezmoi/examples/ANSIBLE-INTEGRATION.md`
- **SkogAI Documentation:** `~/skogai/docs/`

## License

MIT

## Author

SkogAI (skogansible repository)
