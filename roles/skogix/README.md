# Ansible Role: <role>

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

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/<role>.yml`.

### Installation

```yaml
<role>_install: true              # Install the tool
<role>_package_name: "<role>"       # <role> name
```

### Configuration

```yaml
<role>_deploy_config: false       # Deploy configuration file
<role>_config_file: "{{ ansible_facts['env']['HOME'] }}/.<role>rc"
# [@skogix:i like the idea of a role-rc file being able to override/be used but for now i think we should look in the .ansible folder for them until we get to implementing that feature]
```

### Feature Flags

```yaml
<role>_enable_<feature-x>: false    # Enable experimental <feature-x> (CAUTION)
<role>_enable_<feature-y>: true     # Enable <feature-y> (safe)
```

## Dependencies

None (or list role dependencies here)

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - role: <role>
      vars:
        <role>_install: true
```

### Advanced Usage

```yaml
- hosts: localhost
  roles:
    - role: <role>
      vars:
        <role>_install: true
        <role>_deploy_config: true
        <role>_enable_<feature-x>: true
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: <role>
      vars:
        <role>_package_name: "custom-role"
        <role>_config_file: "/path/to/<role>.conf"
```

## Tags

Run specific parts of the role:

```bash
# Run entire role
./run.sh --tags <role>

# Run only installation
./run.sh --tags <role>-install

# Run only configuration
./run.sh --tags <role>-config
```

Available tags:

- `<role>` - Run all tasks
- `<role>-install` - Installation tasks
- `<role>-config` - Configuration tasks

## License

MIT (or whatever license)

## Author Information

Created by [Author] for [Project]
