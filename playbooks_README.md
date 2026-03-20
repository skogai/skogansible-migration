# Playbooks

Organized playbooks for different deployment scenarios.

## Available Playbooks

### default.yml

**Default playbook** - Runs when no playbook specified.

Current default configuration (modify as needed).

```bash
./run.sh                # Uses default.yml
./run.sh default.yml    # Explicit
```

### site.yml

**Main playbook** - Complete system configuration with all roles.

Use this for full system setup or comprehensive updates.

```bash
./run.sh site.yml
```

### workstation.yml

**Workstation setup** - Full desktop/development environment configuration.

Includes all packages, SSH, git, and dotfiles management.

```bash
./run.sh workstation.yml
```

### bootstrap.yml

**Initial bootstrap** - Minimal setup for fresh Arch installation.

Only installs essential packages, skips configuration and updates.

```bash
./run.sh bootstrap.yml
```

### maintenance.yml

**Regular maintenance** - System updates and cleanup only.

Updates package cache and upgrades system without changing configuration.

```bash
./run.sh maintenance.yml
```

## Usage Patterns

**Run entire playbook:**

```bash
./run.sh site.yml
```

**Dry-run (check mode):**

```bash
./run.sh site.yml --check
```

**Run specific tags:**

```bash
./run.sh site.yml --tags packages
./run.sh site.yml --tags git,ssh
```

**Skip specific tags:**

```bash
./run.sh site.yml --skip-tags packages
```

## Playbook Structure

All playbooks follow the same pattern:

- Located at project root (Ansible best practice)
- Define target hosts (`all` for localhost)
- Variables are auto-loaded from `group_vars/all/` (no manual `vars_files:` needed)
- Apply roles with appropriate tags
- Can override role variables for specific scenarios
