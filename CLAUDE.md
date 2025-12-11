# Ansible Arch Linux Setup

Minimal Ansible setup for managing Arch Linux system packages and AUR packages.

## Project Structure

```
.
├── @ansible.cfg              # Ansible configuration
├── @.inventory               # Localhost target
├── @playbook.yml             # Main playbook
├── @.requirements.yml        # Ansible Galaxy collections
├── @vars/main.yml           # Package lists (single source of truth)
├── @roles/packages/         # Package management role
│   ├── tasks/
│   │   ├── main.yml         # Orchestrates all package tasks
│   │   ├── aur_user.yml     # Creates aur_builder user
│   │   ├── aur_helper.yml   # Installs yay AUR helper
│   │   └── aur_packages.yml # Installs AUR packages
│   ├── defaults/main.yml
│   ├── handlers/main.yml
│   └── meta/main.yml
├── @setup.sh                # Bootstrap script (creates venv, installs ansible)
├── @run.sh                  # Execution script (runs playbook)
├── @.envrc                  # direnv environment setup
└── @docs/                   # Reference documentation
    ├── ansible-core.md
    └── system-inventory-by-primitives.md  # Full system expansion plan
```

## Key Details

- **Become method:** `become: true` on individual tasks (not playbook level)
- **Sudo password:** Set via `$ANSIBLE_BECOME_PASSWORD_FILE` exported by `skogcli` through `.envrc`
- **Python interpreter:** Hardcoded venv path in `ansible.cfg`: `/home/skogix/.ansible/.venv/bin/python`
- **Single source of truth:** `vars/main.yml` contains all package lists
- **AUR support:** Dedicated `aur_builder` user for secure AUR package building

## Usage

**Initial setup:**
```bash
./setup.sh                    # Creates venv, installs Ansible + collections
```

**Run playbook:**
```bash
./run.sh                      # Applies all package management
./run.sh --check             # Dry-run mode
./run.sh --tags aur          # Run only AUR-related tasks
```

## Current Scope

This is a **basic** setup focused on package management:
- ✅ Official Arch repository packages via pacman
- ✅ AUR packages via yay
- ✅ AUR builder user setup with secure sudo config
- ⏸️  System configuration (see `docs/system-inventory-by-primitives.md` for expansion plan)

## Reference

- **docs/ansible-core.md** - Ansible reference documentation
- **docs/system-inventory-by-primitives.md** - Complete system automation roadmap (future expansion)
