# SkogAnsible

Centralized Ansible configuration directory for Arch Linux system management and configuration.

## Overview

This repository provides a comprehensive Ansible setup for managing an Arch Linux system, including:

- **Numbered roles** (01-07) for sequential system setup and configuration
- **Named roles** for specific tools and services (cloud, docker, git, ssh, etc.)
- **Multiple playbooks** for different use cases (full setup, updates, specific configurations)
- **Testing infrastructure** with ansible-lint, yamllint, and Molecule support
- **Pre-commit hooks** for automated validation

## Quick Start

### Prerequisites

```bash
# Install Ansible and testing tools
pip install ansible ansible-lint yamllint

# Install required Ansible collections
ansible-galaxy collection install -r requirements.yml
```

### Running Playbooks

**Always use the `run.sh` script** (never run `ansible-playbook` directly):

```bash
# Run the main playbook (numbered roles 01-07)
bash run.sh

# Run specific playbooks
bash run.sh playbooks/site.yml      # All roles
bash run.sh playbooks/skogai.yml    # Comprehensive Arch setup
bash run.sh playbooks/update.yml    # Quick system updates
```

### Testing Changes

Before pushing any changes, run the test script:

```bash
# Run static analysis tests (required)
./test.sh

# Optional: Run with check mode (dry-run)
./test.sh --check

# Optional: Run Molecule tests
./test.sh --molecule
```

## Repository Structure

```
skogansible/
├── ansible.cfg          # Ansible configuration
├── .envrc              # direnv environment setup
├── .env                # Environment variables (contains secrets)
├── .hosts              # Inventory file (localhost)
├── run.sh              # Playbook execution script
├── test.sh             # Local testing script
├── requirements.yml    # Ansible collections
├── playbooks/          # Ansible playbooks
│   ├── all.yml         # Numbered roles (01-07)
│   ├── site.yml        # Unified playbook
│   ├── skogai.yml      # Comprehensive Arch setup
│   └── update.yml      # Quick maintenance
├── roles/              # Ansible roles
│   ├── 01_host_info/   # System info and checks
│   ├── 02_package_managers/  # pacman + AUR
│   ├── 03_dotfiles/    # Dotfile management
│   ├── 04_shell_config/# Shell configuration
│   ├── 05_systemd_services/# Service management
│   ├── 06_ai_tools/    # AI tools setup
│   └── ...             # Additional named roles
├── vars/               # Variable files
│   ├── packages.yml    # Package lists
│   └── user.yml        # User configuration
└── tasks/              # Reusable task files
```

## Key Roles

### Numbered Roles (Sequential Setup)

1. **01_host_info** - System information gathering and sudo checks
2. **02_package_managers** - Package installation via pacman and AUR
3. **03_dotfiles** - Dotfile management and deployment
4. **04_shell_config** - Shell configuration (zsh, bash)
5. **05_systemd_services** - System service management
6. **06_ai_tools** - AI development tools setup
7. **07_development** - Development environment configuration

### Named Roles (Specific Configurations)

- **cloud** - Cloud CLI tools (aws, gcloud, azure)
- **docker** - Docker and container configuration
- **fonts** - Font installation and management
- **git** - Git configuration and repository management
- **ssh** - SSH configuration and hardening
- **tmux** - Terminal multiplexer configuration
- **vim** - Vim/Neovim editor setup
- **zsh** - Zsh shell customization

## Configuration

### Ansible Configuration (`ansible.cfg`)

- Collections: `~/.ansible/.collections`
- Fact caching: `~/.ansible/.cache`
- Inventory: `.hosts` (localhost)
- Roles: `roles/` directory
- Working directories: `/tmp/.ansible`

### Environment Setup

The repository uses `direnv` for environment management:

1. `.envrc` - Environment loader
2. `.env` - Protected variables (contains secrets, not committed)

### Package Management

Package lists are defined in `vars/packages.yml`:

- `packages` - Official Arch packages (pacman)
- `aur_packages` - AUR packages (via yay/paru)

## Development Workflow

### 1. Make Changes

Edit playbooks, roles, or variable files as needed.

### 2. Test Locally

```bash
./test.sh
```

This runs:
- Ansible syntax check
- yamllint (YAML formatting)
- ansible-lint (best practices)

### 3. Optional: Test with Check Mode

```bash
./test.sh --check
```

Runs a dry-run to verify changes would work.

### 4. Optional: Molecule Testing

```bash
./test.sh --molecule
```

Runs role tests in isolated Docker containers (see [MOLECULE.md](MOLECULE.md)).

### 5. Commit Changes

Pre-commit hooks automatically run tests before each commit:

```bash
# Install pre-commit (one-time setup)
pip install pre-commit
pre-commit install

# Commits now run hooks automatically
git add .
git commit -m "Description of changes"
```

### 6. Push Changes

```bash
git push
```

GitHub Actions CI will run the same tests automatically.

## Testing

### Static Analysis (Required)

The `test.sh` script runs static analysis tests that match the CI pipeline:

```bash
./test.sh
```

**Tests performed:**
- ✓ Ansible syntax validation
- ✓ YAML linting (yamllint)
- ✓ Ansible best practices (ansible-lint)

### Check Mode (Optional)

Dry-run the playbook to verify it would work:

```bash
./test.sh --check
```

**Note:** Requires proper environment setup (`.env` and `.envrc`)

### Molecule Testing (Optional)

Test roles in isolated Docker containers:

```bash
./test.sh --molecule
```

See [MOLECULE.md](MOLECULE.md) for detailed molecule testing documentation.

## Ansible Best Practices

### Code Style

- **FQCNs**: Use fully qualified collection names (`ansible.builtin.`, `community.general.`)
- **YAML**: Follow `.yamllint` rules for consistent formatting
- **Linting**: Follow `.ansible-lint` rules for best practices

### Common Patterns

- **Force handlers**: Enabled globally - handlers run even when tasks fail
- **Diff mode**: Always on - shows file changes before applying
- **Color output**: Forced on for better readability

### Security

- Never commit secrets to `.env` file
- Use ansible-vault for sensitive data
- Follow SSH hardening practices (see `roles/ssh`)

## AUR Package Installation

AUR packages require special handling because `makepkg` refuses to run as root:

**Setup:**
1. The `aur_builder` user is created by `02_package_managers` role
2. User has passwordless sudo for `/usr/bin/pacman` only
3. Builds packages without sudo, installs with sudo

**Example:**
```yaml
- name: Install AUR packages
  become: true
  become_user: aur_builder
  kewlfft.aur.aur:
    name: "{{ aur_packages }}"
    use: auto
    state: present
```

## Troubleshooting

### Privilege Escalation Fails

If tasks requiring sudo fail:

1. Check you're in the correct directory (for `.envrc` loading)
2. Verify `.env` or `.envrc` files are sourced
3. Confirm sudo access is configured

### Test Failures

```bash
# Check which test failed
./test.sh

# For detailed output
./test.sh --verbose

# Check specific linters
yamllint .
ansible-lint playbooks/ roles/
ansible-playbook playbooks/all.yml --syntax-check
```

### Molecule Issues

See [MOLECULE.md](MOLECULE.md) troubleshooting section for:
- Docker daemon issues
- Permission problems
- Network connectivity
- Container configuration

## GitHub Actions CI

The repository includes automated testing via GitHub Actions:

- **ansible-test.yml** - Runs on every push/PR
  - Syntax checking
  - yamllint
  - ansible-lint

- **molecule-test.yml** - Optional molecule testing
  - Tests roles in Docker containers
  - Validates idempotence

## Additional Documentation

- [CLAUDE.md](CLAUDE.md) - Detailed guide for Claude Code assistant
- [MOLECULE.md](MOLECULE.md) - Comprehensive Molecule testing guide
- [.github/copilot-instructions.md](.github/copilot-instructions.md) - GitHub Copilot configuration

## Contributing

When working on this repository:

1. **Read the docs**: Review this README and documentation files
2. **Test locally**: Always run `./test.sh` before pushing
3. **Follow patterns**: Use existing code style and conventions
4. **Use tools**: Prefer ecosystem tools over manual changes
5. **Keep it minimal**: Make the smallest changes necessary

## Requirements

### System Requirements

- **OS**: Arch Linux (primary target)
- **Python**: 3.x
- **Ansible**: Latest stable version
- **direnv**: For environment management (optional but recommended)

### Python Packages

```bash
pip install ansible ansible-lint yamllint
pip install pre-commit  # Optional, for git hooks
pip install molecule molecule-plugins[docker]  # Optional, for testing
```

### Ansible Collections

```bash
ansible-galaxy collection install -r requirements.yml
```

**Required collections:**
- community.general
- kewlfft.aur
- ansible.posix

## License

This is a personal configuration repository. Use at your own risk.

## Support

For issues or questions:
1. Check documentation files (README, CLAUDE.md, MOLECULE.md)
2. Review existing playbooks and roles for examples
3. Check GitHub Issues in the repository
