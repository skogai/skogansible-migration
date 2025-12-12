# Ansible Arch Linux Setup

Ansible setup for managing Arch Linux system packages, AUR packages, and SSH configuration.

## Project Structure

```
.
├── @ansible.cfg              # Ansible configuration
├── @.inventory               # Localhost target
├── @playbook.yml             # Main playbook (2 roles)
├── @.requirements.yml        # Ansible Galaxy collections (3 collections)
├── @vars/                    # Configuration variables (organized by role)
│   ├── main.yml              # Shared variables
│   ├── packages.yml          # Package lists (61 official + 7 AUR)
│   ├── ssh.yml               # SSH role configuration
│   ├── ssh_vault.yml         # Encrypted SSH keys
│   └── user.yml              # User-specific variables
├── @roles/packages/          # Package management role
│   ├── tasks/
│   │   ├── main.yml          # Orchestrates all package tasks
│   │   ├── aur_user.yml      # Creates aur_builder user
│   │   ├── aur_helper.yml    # Installs yay AUR helper
│   │   └── aur_packages.yml  # Installs AUR packages
│   ├── defaults/main.yml
│   ├── handlers/main.yml
│   └── meta/main.yml
├── @roles/ssh/               # SSH management role
│   ├── tasks/main.yml        # SSH key, config, known_hosts management
│   ├── templates/
│   │   └── ssh_config.j2     # SSH config template
│   ├── defaults/main.yml
│   ├── handlers/main.yml
│   ├── meta/main.yml
│   └── README.md             # Full SSH role documentation
├── @setup.sh                 # Bootstrap script (creates venv, installs ansible)
├── @run.sh                   # Execution script (runs playbook)
├── @.envrc                   # direnv environment setup
└── @docs/                    # Reference documentation
    ├── ansible-core.md
    └── system-inventory-by-primitives.md  # Full system expansion plan
```

## Key Details

- **Become method:** `become: true` on individual tasks (not playbook level)
- **Sudo password:** Set via `$ANSIBLE_BECOME_PASSWORD_FILE` exported by `skogcli` through `.envrc`
- **Python interpreter:** Hardcoded venv path in `ansible.cfg`: `/home/skogix/.ansible/.venv/bin/python`
- **Variable organization:** Role-specific vars files (packages.yml, ssh.yml, user.yml)
- **AUR support:** Dedicated `aur_builder` user for secure AUR package building
- **Collections:** community.general, kewlfft.aur, ansible.posix

## Usage

**Initial setup:**
```bash
./setup.sh                    # Creates venv, installs Ansible + collections
```

**Run playbook:**
```bash
./run.sh                      # Run all roles (packages + ssh)
./run.sh --check             # Dry-run mode
./run.sh --tags packages     # Run only package management
./run.sh --tags ssh          # Run only SSH configuration
./run.sh --tags aur          # Run only AUR-related tasks
```

**SSH key deployment (requires vault password):**
```bash
# Enable in vars/ssh.yml first:
# ssh_deploy_from_vault: true

ansible-playbook playbook.yml --tags ssh --ask-vault-pass
```

## Current Scope

**Active Roles:**
- ✅ **packages** - Official Arch repository packages via pacman (61 packages)
- ✅ **packages** - AUR packages via yay (7 packages)
- ✅ **ssh** - SSH directory setup, key deployment, config management, known_hosts

**Features:**
- ✅ AUR builder user setup with secure sudo config
- ✅ SSH key deployment from encrypted vault
- ✅ SSH config template with connection multiplexing
- ✅ Known hosts management
- ✅ Authorized keys management
- ✅ SSH directory backup functionality
- ⏸️  Additional system configuration (see `docs/system-inventory-by-primitives.md`)

## SSH Role Configuration

The SSH role manages SSH keys, configuration, and related settings. All features are **disabled by default** for safety.

**To deploy SSH keys from vault:**
1. Edit `vars/ssh.yml` and set `ssh_deploy_from_vault: true`
2. Ensure `vars/ssh_vault.yml` contains your encrypted keys with variables:
   - `ssh_private_key` - Your private key content
   - `ssh_public_key` - Your public key content
3. Run: `ansible-playbook playbook.yml --tags ssh --ask-vault-pass`

**Other SSH features (configure in vars/ssh.yml):**
- `ssh_generate_key: true` - Generate new SSH key pair
- `ssh_deploy_config: true` - Deploy custom SSH config from template
- `ssh_manage_known_hosts: true` - Manage known_hosts entries
- `ssh_manage_authorized_keys: true` - Manage authorized_keys
- `ssh_enable_backup: true` - Backup SSH directory

**See:** `roles/ssh/README.md` for complete documentation and examples.

## Reference

- **roles/ssh/README.md** - Complete SSH role documentation with examples
- **docs/ansible-core.md** - Ansible reference documentation
- **docs/system-inventory-by-primitives.md** - Complete system automation roadmap (future expansion)
