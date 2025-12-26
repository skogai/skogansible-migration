# Ansible Composition Layer

This document describes the composition layer that orchestrates primitives into higher-level operations through profile-based role selection, dependency management, and conditional execution.

## Overview

The composition layer sits between individual roles (primitives) and complete system configuration. It provides:

1. **Profile-Based Orchestration** - Different machine profiles get different role combinations
2. **Role Dependency Management** - Explicit declaration of role dependencies
3. **Conditional Role Inclusion** - Roles included based on machine type and feature flags
4. **Tag-Based Execution Control** - Hierarchical tags for granular control

## Machine Profiles

Four machine profiles are supported, defined via `machine_type` variable in `vars/main.yml`:

### workstation

**Description:** Full desktop with GPU, development tools, GUI applications

**Characteristics:**
- GUI environment (X11 with i3 or Wayland with Sway)
- GPU support (NVIDIA/AMD drivers)
- Full development stack
- Multimedia applications
- Cloudflare tunnel for remote access
- Multiple mounted filesystems

**Included Roles:**
- `packages` (all packages including GUI apps)
- `ssh` (full SSH configuration)
- `git` (complete git setup)
- `chezmoi` (dotfiles with GUI configs)
- `zsh` (shell configuration)
- `cloudflared` (tunnel service)
- `filesystems` (mount management)

**Example Use Case:** Primary development machine, desktop workstation

---

### laptop

**Description:** Portable machine with battery management and power optimization

**Characteristics:**
- GUI environment (typically Sway for better battery life)
- Laptop-specific features (battery management, power profiles)
- Lightweight configurations
- WiFi/Bluetooth management
- Automatic display configuration
- Reduced background services

**Included Roles:**
- `packages` (with laptop-specific packages)
- `ssh` (full SSH configuration)
- `git` (complete git setup)
- `chezmoi` (dotfiles with laptop mode enabled)
- `zsh` (shell configuration)

**Example Use Case:** Development laptop, portable workstation

---

### server

**Description:** Headless server environment, no GUI

**Characteristics:**
- No GUI applications
- No window manager
- Service-focused (docker, databases, web servers)
- SSH-only access
- Minimal resource usage
- Automated service management

**Included Roles:**
- `packages` (server packages only, no GUI)
- `ssh` (hardened SSH configuration)
- `git` (minimal git for deployments)
- `cloudflared` (tunnel for remote access)
- `filesystems` (data mount management)

**Example Use Case:** Home server, VPS, container host

---

### wsl

**Description:** Windows Subsystem for Linux environment

**Characteristics:**
- Headless (no GUI)
- No window manager
- No systemd services
- CLI tools only
- Windows integration
- Limited hardware access

**Included Roles:**
- `packages` (CLI tools only)
- `ssh` (basic SSH client configuration)
- `git` (full git setup for Windows integration)
- `chezmoi` (CLI-focused dotfiles)
- `zsh` (shell configuration)

**Example Use Case:** Windows development environment, WSL2 setup

---

## Role Dependencies

Role dependencies are declared in each role's `meta/main.yml` file. Dependencies are automatically resolved by Ansible before executing a role.

### Current Dependencies

```yaml
# roles/chezmoi/meta/main.yml
dependencies:
  - role: git
    tags: [git, vcs]
```

**Rationale:** Chezmoi uses git to manage dotfiles repository, so git must be configured first.

### Planned Dependencies

```yaml
# roles/zsh/meta/main.yml
dependencies:
  - role: packages
    tags: [packages, install]
    vars:
      # Ensure zsh package is installed
      packages_ensure_zsh: true
```

**Rationale:** ZSH configuration role requires zsh package to be installed.

### Dependency Guidelines

**When to add dependencies:**
- Role requires another role's output (e.g., chezmoi needs git)
- Role configures software that must be installed by another role
- Role modifies files created by another role

**When NOT to add dependencies:**
- Roles can work independently (prefer conditional inclusion)
- Dependency would create circular reference
- Dependency is profile-specific (use conditional inclusion instead)

**Best Practices:**
- Keep dependency chains shallow (2 levels max)
- Document why dependency exists in comments
- Use tags to allow selective execution
- Prefer conditional inclusion over hard dependencies

---

## Conditional Role Inclusion

Roles are conditionally included based on machine profile and feature flags using Ansible's `when` clause.

### Profile-Based Inclusion

```yaml
- role: cloudflared
  tags: [cloudflared, tunnel, services]
  when: machine_type in ['workstation', 'server']
```

This includes cloudflared only on workstation and server profiles (not laptop or WSL).

### Feature Flag Inclusion

```yaml
- role: filesystems
  tags: [filesystems, mounts]
  when:
    - filesystems_enabled | default(false)
    - filesystems_mounts is defined
    - filesystems_mounts | length > 0
```

This includes filesystems role only when:
1. Feature is explicitly enabled
2. Filesystem configurations are defined
3. At least one filesystem is configured

### GUI vs Headless

```yaml
# GUI roles only on workstation/laptop
- role: i3
  tags: [i3, wm, gui]
  when:
    - machine_type in ['workstation', 'laptop']
    - not (chezmoi_headless | default(false))
```

This includes i3 window manager only on GUI-capable profiles.

### Example Conditional Patterns

**Simple profile check:**
```yaml
when: machine_type == 'workstation'
```

**Multiple profiles:**
```yaml
when: machine_type in ['workstation', 'laptop']
```

**Profile + feature flag:**
```yaml
when:
  - machine_type != 'wsl'
  - ssh_hardening_enabled | default(false)
```

**Negative conditions:**
```yaml
when: machine_type not in ['server', 'wsl']
```

---

## Tag-Based Execution Control

Tags provide granular control over which roles and tasks execute. Tags are hierarchical and can be combined.

### Tag Hierarchy

```
Profile Tags (broadest)
├── workstation    - All workstation roles
├── laptop         - All laptop roles
├── server         - All server roles
└── wsl            - All WSL roles

Category Tags
├── base           - Base system (packages, ssh)
├── shell          - Shell configuration (zsh)
├── vcs            - Version control (git)
├── dotfiles       - Dotfile management (chezmoi)
├── services       - System services (cloudflared)
└── gui            - GUI applications (future: i3, sway)

Role-Specific Tags
├── packages       - Package management
├── ssh            - SSH configuration
├── git            - Git configuration
├── chezmoi        - Chezmoi dotfiles
├── zsh            - ZSH shell
├── cloudflared    - Cloudflare tunnel
└── filesystems    - Filesystem mounts

Task-Level Tags (most specific)
├── install        - Package installation tasks
├── config         - Configuration tasks
├── update         - Update/maintenance tasks
└── vault          - Vault-encrypted tasks
```

### Tag Usage Examples

**Run complete workstation setup:**
```bash
ansible-playbook playbooks/site.yml --tags workstation
```

**Run only base system configuration:**
```bash
ansible-playbook playbooks/site.yml --tags base
```

**Run only shell configuration:**
```bash
ansible-playbook playbooks/site.yml --tags shell
```

**Run specific role:**
```bash
ansible-playbook playbooks/site.yml --tags git
```

**Run specific tasks within a role:**
```bash
ansible-playbook playbooks/site.yml --tags git,config
```

**Skip specific roles:**
```bash
ansible-playbook playbooks/site.yml --skip-tags gui
```

**Combine tags:**
```bash
ansible-playbook playbooks/site.yml --tags base,shell,vcs
```

---

## Playbook Organization

Playbooks are organized by purpose and profile in the `playbooks/` directory.

### Main Playbooks

**`site.yml`** - Complete system configuration (all profiles)
- Includes all roles
- Uses conditional inclusion for profile-specific roles
- Default playbook for full setup

**`default.yml`** - Basic configuration (all profiles)
- Core roles only (packages, ssh)
- Minimal setup for quick configuration
- Use when only base system needs updating

**`bootstrap.yml`** - Initial system setup
- Packages only
- No configuration changes
- Use on fresh Arch installation

**`maintenance.yml`** - Updates and cleanup
- Package updates only
- No configuration changes
- Use for regular system maintenance

### Profile-Specific Playbooks

**`workstation.yml`** - Full desktop/development environment
- All roles including GUI
- Cloudflared tunnel
- Filesystem mounts
- Development tools

**`laptop.yml`** - Portable development environment
- GUI roles with laptop optimizations
- Battery management
- Power profiles
- Minimal background services

**`server.yml`** - Headless server environment
- No GUI roles
- Service-focused
- Hardened SSH
- Automated service management

**`wsl.yml`** - Windows Subsystem for Linux
- CLI tools only
- No systemd services
- Windows integration
- Git for cross-platform development

### Playbook Selection Guide

| Scenario | Playbook | Command |
|----------|----------|---------|
| Complete fresh setup | `site.yml` | `./run.sh` |
| Workstation setup | `workstation.yml` | `./run.sh -p workstation` |
| Update packages only | `maintenance.yml` | `./run.sh -p maintenance` |
| Configure SSH only | `site.yml --tags ssh` | `./run.sh --tags ssh` |
| Initial package install | `bootstrap.yml` | `./run.sh -p bootstrap` |

---

## Role Composition Patterns

### Pattern 1: Base + Extensions

**Concept:** Core roles run on all profiles, extensions are profile-specific

```yaml
roles:
  # Base (all profiles)
  - role: packages
  - role: ssh

  # Extensions (conditional)
  - role: cloudflared
    when: machine_type in ['workstation', 'server']
```

**Use when:** You have core functionality + optional additions

---

### Pattern 2: Feature Flags

**Concept:** Roles controlled by boolean flags in vars

```yaml
roles:
  - role: cloudflared
    when: cloudflared_enabled | default(false)
```

**Use when:** Feature is optional regardless of profile

---

### Pattern 3: Data-Driven

**Concept:** Role included only if data exists

```yaml
roles:
  - role: filesystems
    when: filesystems_mounts is defined and filesystems_mounts | length > 0
```

**Use when:** Role configures resources that may not exist

---

### Pattern 4: Layered Dependencies

**Concept:** Roles depend on each other in layers

```yaml
# meta/main.yml
dependencies:
  - role: git  # Layer 1: VCS

# playbook.yml
roles:
  - role: chezmoi  # Layer 2: Uses git
```

**Use when:** Clear dependency hierarchy exists

---

## Testing Profile Combinations

### Test Checklist

**Workstation Profile:**
- [ ] All GUI roles execute
- [ ] Cloudflared service configured
- [ ] Filesystems mounted
- [ ] Development tools installed
- [ ] i3/Sway window manager configured

**Laptop Profile:**
- [ ] GUI roles execute with laptop optimizations
- [ ] Battery management configured
- [ ] Power profiles enabled
- [ ] Cloudflared skipped (unless enabled)
- [ ] Lightweight configurations applied

**Server Profile:**
- [ ] No GUI roles execute
- [ ] SSH hardening applied
- [ ] Services configured
- [ ] Cloudflared configured for remote access
- [ ] Minimal resource usage

**WSL Profile:**
- [ ] CLI tools only
- [ ] No systemd services
- [ ] Git configured for Windows integration
- [ ] Shell configured
- [ ] No GUI applications

### Testing Commands

**Test with check mode (dry-run):**
```bash
ansible-playbook playbooks/workstation.yml --check
ansible-playbook playbooks/laptop.yml --check
ansible-playbook playbooks/server.yml --check
ansible-playbook playbooks/wsl.yml --check
```

**Test specific role with profile:**
```bash
ansible-playbook playbooks/site.yml --tags chezmoi --extra-vars "machine_type=laptop"
```

**Test conditional inclusion:**
```bash
ansible-playbook playbooks/site.yml --tags cloudflared --extra-vars "machine_type=wsl"
# Should skip cloudflared on WSL
```

**Verify tag combinations:**
```bash
ansible-playbook playbooks/site.yml --tags base,shell --list-tasks
```

---

## Migration Guide

### Updating Existing Playbooks

**Before (hardcoded roles):**
```yaml
roles:
  - packages
  - ssh
  - git
  - chezmoi
  - cloudflared
```

**After (composition layer):**
```yaml
roles:
  # Base (all profiles)
  - role: packages
    tags: [packages, install, base]

  - role: ssh
    tags: [ssh, config, base]

  - role: git
    tags: [git, vcs]

  - role: chezmoi
    tags: [chezmoi, dotfiles]

  # Conditional (profile-specific)
  - role: cloudflared
    tags: [cloudflared, tunnel, services]
    when: machine_type in ['workstation', 'server']
```

### Adding New Roles

**Step 1:** Create role with meta/main.yml
```yaml
# roles/newrole/meta/main.yml
dependencies:
  - role: required_role
    tags: [required_role]
```

**Step 2:** Add to appropriate playbooks
```yaml
# playbooks/site.yml
- role: newrole
  tags: [newrole, category]
  when: machine_type in ['applicable', 'profiles']
```

**Step 3:** Document in this file
- Add to role list for each profile
- Document any dependencies
- Add tag hierarchy entry
- Create testing checklist

---

## Best Practices

### DO

✅ Use explicit dependencies in meta/main.yml when roles require each other
✅ Document why conditional inclusion exists
✅ Test all profile combinations after changes
✅ Use hierarchical tags for flexibility
✅ Keep profile variables in vars/main.yml
✅ Use feature flags for optional functionality
✅ Document profile-specific behaviors

### DON'T

❌ Create circular dependencies
❌ Hardcode profile checks inside roles (use vars instead)
❌ Mix profile logic with task logic
❌ Add dependencies for profile-specific requirements (use conditionals)
❌ Skip tag hierarchy (always include category + role tags)
❌ Assume all roles run on all profiles

---

## Future Enhancements

### Planned Features

1. **Dynamic Profile Detection**
   - Auto-detect laptop (battery present)
   - Auto-detect WSL (kernel version)
   - Auto-detect server (no GPU)

2. **Role Groups**
   - GUI group (i3, sway, dunst, etc.)
   - Development group (languages, tools)
   - Services group (docker, databases)

3. **Dependency Visualization**
   - Generate dependency graph
   - Show role execution order
   - Identify circular dependencies

4. **Profile Inheritance**
   - laptop extends workstation
   - server extends base
   - wsl extends minimal

---

## Reference

### Related Documentation

- [Ansible Primitives](primitives/ansible-core.md) - Building blocks used by roles
- [System Inventory](primitives/system-inventory-by-primitives.md) - Complete system configuration
- [Role READMEs](../roles/) - Individual role documentation

### External Resources

- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Role Dependencies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#role-dependencies)
- [Conditional Execution](https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html)
- [Tags](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html)

---

**Last Updated:** 2025-12-26
**Maintainer:** SkogAI/skogansible
