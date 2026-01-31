# Ansible Role: zsh

Zsh shell installation and configuration management.

This role provides:

- Zsh installation
- Configuration file deployment
- Default shell setup
- Plugin manager integration (zinit, oh-my-zsh, etc.)

## Requirements

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

## Dependencies

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

## Tags

Run specific parts of the role:

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

Available tags:

- `zsh` - Run all tasks
- `zsh-install` - Installation tasks
- `zsh-config` - Configuration tasks
- `zsh-default-shell` - Default shell tasks
- `zsh-plugins` - Plugin manager tasks

## License

MIT

## Author Information

Created by skogix for SkogAI/skogansible
