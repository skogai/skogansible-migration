# Ansible Role: Template

Brief description of what this role does and why it exists.

This role provides:
- Feature 1
- Feature 2
- Feature 3

## Requirements

- Ansible 2.10 or higher
- `community.general` collection (if needed)
- Target system: Arch Linux (or whatever platforms supported)

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/template.yml`.

### Installation

```yaml
template_install: true              # Install the tool
template_package_name: "tool"       # Package name
```

### Configuration

```yaml
template_deploy_config: false       # Deploy configuration file
template_config_file: "{{ ansible_facts['env']['HOME'] }}/.toolrc"
```

### Feature Flags

```yaml
template_enable_feature_x: false    # Enable experimental feature X (CAUTION)
template_enable_feature_y: true     # Enable feature Y (safe)
```

## Dependencies

None (or list role dependencies here)

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: template
      vars:
        template_install: true
```

### Advanced Usage

```yaml
- hosts: localhost
  roles:
    - role: template
      vars:
        template_install: true
        template_deploy_config: true
        template_enable_feature_y: true
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: template
      vars:
        template_package_name: "custom-tool"
        template_config_file: "/etc/tool.conf"
```

## Tags

Run specific parts of the role:

```bash
# Run entire role
./run.sh --tags template

# Run only installation
./run.sh --tags template-install

# Run only configuration
./run.sh --tags template-config
```

Available tags:
- `template` - Run all tasks
- `template-install` - Installation tasks
- `template-config` - Configuration tasks

## Troubleshooting

### Issue: Tool not found after installation

Check that the package name is correct for your distribution:
```bash
pacman -Ss tool-name
```

## License

MIT (or whatever license)

## Author Information

Created by [Author] for [Project]
