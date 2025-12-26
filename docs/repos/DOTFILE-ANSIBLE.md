# Ansible Task Inventory

Complete inventory of all Ansible task names extracted from the dotfile-ansible repository.
Tasks are organized by category: Playbooks, Components, Primitives, and Roles.

**Generated:** 2025-12-18
**Total Tasks Found:** 33

---

## Playbooks

Main orchestration playbooks that define top-level execution flows.

### skogix.yml

- **Skogix Playbook** - Main entry point for skogix user configuration

### skogai.yml

- **Deploy Dotfiles** - Deploy system dotfiles configuration

### playbooks/disaster_recovery.yml

- **Complete System Recovery** - Full system disaster recovery workflow

---

## Components

Feature bundles that compose primitives together. Components represent complete, reusable functionality.

### components/ssh-role/tasks/main.yml

SSH management component providing complete SSH key and configuration management.

- **SSH | Ensure .ssh directory exists** - Create .ssh directory with correct permissions
- **SSH | Deploy SSH keys from vault** - Deploy encrypted SSH keys from vault storage
- **SSH | Generate SSH key pair** - Generate new SSH key pair (ED25519 by default)
- **SSH | Deploy SSH config** - Deploy SSH client configuration
- **SSH | Manage known hosts** - Manage SSH known_hosts file entries
- **SSH | Manage authorized_keys** - Manage SSH authorized_keys file
- **SSH | Backup SSH directory** - Create backup of SSH directory before modifications

---

## Primitives

Core reusable operations extracted into 7 categories. Primitives are the atomic building blocks that all components use.

### Compose Operations (High-level compositions)

#### primitives/compose/aur_setup.yml

Composite operations for AUR (Arch User Repository) setup and management.

- **Composition | Create AUR builder user** - Create dedicated unprivileged user for AUR operations
- **Composition | Allow AUR builder to run pacman without password** - Configure sudoers for AUR builder pacman access
- **Composition | Check if {{ aur_helper | default('yay') }} exists** - Check if AUR helper tool is installed
- **Composition | Install {{ aur_helper | default('yay') }}** - Install AUR helper (yay or paru)
- **Composition | Install AUR packages** - Install packages from AUR repository

### Ensure Content (File content management)

#### primitives/ensure_content/file_copy.yml

Primitive for copying files to target destinations.

- **Primitive | Copy file to {{ file_dest }}** - Copy file from source to destination with permissions

#### primitives/ensure_content/line_in_file.yml

Primitive for managing individual lines in files.

- **Primitive | Ensure line in {{ line_path }}** - Ensure specific line exists in file (create/modify)

### Ensure State (Resource existence management)

#### primitives/ensure_state/package.yml

Primitive for managing package installation state across package managers.

- **Primitive | Ensure package {{ package_state }}:
  {{ package_names if package_names is string else package_names | join(', ') }}** -
  Install/remove packages with cache management

#### primitives/ensure_state/user.yml

Primitive for managing system users.

- **Primitive | Ensure user {{ user_state | default('present') }}: {{ user_name }}** - Create/modify/remove system user

#### primitives/ensure_state/service.yml

Primitive for managing systemd services.

- **Primitive | Reload systemd daemon** - Reload systemd daemon after service file changes
- **Primitive | Ensure service {{ service_name }} is
  {{ service_enabled | default(true) | ternary('enabled', 'disabled') }} and
  {{ service_state | default('started') }}** -
  Manage service state (started/stopped) and enabled state

---

## Roles

Legacy and reference role implementations. These are deprecated in favor of the primitives-based architecture.

### roles/old-ssh-vault-implementation-for-reference/tasks/main.yml

Legacy SSH implementation using vault encryption (kept for reference).

- **Include decryption tasks** - Include task file for decryption operations
- **Include encryption tasks** - Include task file for encryption operations
- **Ensure .ssh_backup directory exists** - Create backup directory for SSH files
- **Copy .ssh directory** - Copy SSH directory to backup location
- **Debug vault password file path** - Debug output for vault password file location
- **Verify vault password file is not encrypted** - Check vault password file encryption status
- **Decrypt vault password file if encrypted** - Decrypt password file if encrypted
- **Set decrypt_result to default if not defined** - Provide default value for decrypt result
- **Fail if decryption failed** - Stop playbook if decryption operation failed
- **Archive .ssh_backup directory** - Create tar archive of SSH backup directory
- **Encrypt .ssh_backup.tar.gz** - Encrypt SSH backup archive
- **Fail if encryption failed** - Stop playbook if encryption operation failed
- **Remove decrypted vault password file** - Clean up decrypted password file
- **Ensure SSH directory exists** - Create SSH directory with correct permissions
- **Deploy SSH private key** - Deploy private key to SSH directory
- **Deploy SSH public key** - Deploy public key to SSH directory

---

## Task Statistics

| Category | Count |
|----------|-------|
| Playbooks | 3 |
| Components (ssh-role) | 7 |
| Primitives (compose) | 5 |
| Primitives (ensure_content) | 2 |
| Primitives (ensure_state) | 3 |
| Roles (legacy reference) | 16 |
| **Total** | **36** |

---

## Architecture Notes

### Primitives-Based Design

The repository uses a primitives-based architecture where:

1. **7 Core Primitives** (`primitives/`) provide atomic operations
2. **Components** (`components/`) compose primitives together
3. **Playbooks** (`*.yml` in root) orchestrate components
4. **Roles** (legacy) are deprecated in favor of primitives

### Key Principles

- **Primitives are reusable**: Any component can compose any primitive
- **Variable isolation**: Primitives use prefixed variables (e.g., `package_names`, `user_name`)
- **Data/Logic separation**: Data in `data/*.yml`, logic in `primitives/*/`
- **Scale target**: Designed for hundreds of components across 5-10 machines

### Primitive Categories

1. **ensure_state/** - Resource existence (packages, users, services)
2. **ensure_content/** - File content (copy, templates, line-in-file)
3. **query_state/** - State checking before decisions
4. **sync/** - Remote synchronization (git, archives)
5. **execute/** - Command execution (command, shell, script)
6. **compose/** - High-level compositions
7. **update_cache/** - Package database operations

---

## References

- See `PRIMITIVES_README.md` for detailed primitives documentation
- See `COMPONENT_BREAKDOWN.md` for component details
- See `components/ssh-role/examples/` for usage patterns
- See `README.md` for setup instructions
