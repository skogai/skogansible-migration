# Ansible Tasks Inventory

This document is an auto-generated inventory of all Ansible task names found in the archive. Tasks are organized by their directory structure and file location.

## Summary

- **Total YAML files with tasks**: 61
- **Total task definitions**: 211
- **Organization**: By directory structure (playbooks, roles, tasks, tests)

---

## Playbooks

### playbooks/site.yml
- Run all the things

### playbooks/arch-base.yml
- Arch Linux Base System Configuration

### playbooks/arch-maintenance.yml
- Arch Linux System Maintenance

### playbooks/wsl-base.yml
- WSL Arch Linux Base Configuration

### playbooks/test-02.yml
- Test 02_basics role

### playbooks/install_requirements.yml
- Install and update Ansible Galaxy requirements

---

## Root-Level Tasks (Direct task files)

### tasks/bootstrap.yml
- Update package database
- Install essential packages
- Ensure ansible dependencies are installed
- Check system information

### tasks/maintenance.yml
- Update package database
- Upgrade all packages
- Clean package cache (keep last 3 versions)
- Remove orphan packages
- Update AUR packages (if yay is installed)

### tasks/skogai-core.yml
- Update arch
- Install core packages
- Disable need for password for yay
- Git clone yay-repo in to /tmp
- Install yay using makepkg
- Re-enable need for password for pacman
- Set yay options to cleanafter package installation
- Pacman - enable color
- Pacman - enable ParallelDownloads = 5
- Makepkg - disable compression
- Makepkg - enable parallel compilation MAKEFLAGS="-j$(nproc)"
- Fstab change relatime to noatime
- Change number of failed logins that triger 10min lockout
- Enable members of wheel group to sudo
- Add the user to the root group, to be able to enter directories
- Disable need for sudo password for the current user
- Install ssh
- Enable and start ssh service
- Install plocate
- Enable and start ~12h updatedb timer
- Archlinux-keyring - enable weekly update
- Install util-linux
- Enable and start weekly ssd disks trim using fstrim timer
- install trash-cli
- Create trash-empty.service file
- Create trash-empty.timer file
- Enable and start trash-empty.timer
- Install pacman-contrib
- Enable and start weekly cache cleanup paccache timer
- Install reflector
- Write reflector configuration file
- Enable and start reflector timer
- Do initial run of reflector.service

---

## Tests

### tests/test_arch_detection.yml
- Test arch detection functionality

### tests/test_systemd_services.yml
- Test systemd services configuration

### tests/test_claude_workflow.yml
- Claude Workflow Integration Test

### tests/test_role_dependencies.yml
- Test role dependencies and execution order

### tests/test_package_lists.yml
- Test package management variables

### test_arch_detection.yml (root level)
- Test arch detection functionality

### test_systemd_services.yml (root level)
- Test systemd services configuration

### test_claude_workflow.yml (root level)
- Claude Workflow Integration Test

### test_role_dependencies.yml (root level)
- Test role dependencies and execution order

### test_package_lists.yml (root level)
- Test package management variables

---

## Roles

### roles/01_host_info/tasks/main.yml
- Check distribution is supported

### roles/02_basics/tasks/main.yml
- Start systemd service - systemd-timesyncd
- Start systemd service - paccache.timer
- Update reflector configuration file
- Enable reflector timer for automatic mirror updates
- Check if systemd-boot is used
- Start systemd-boot-update.service if systemd-boot is used
- Upgrade system

### roles/02_basics/handlers/main.yml
- run reflector

### roles/03_display_server/tasks/main.yml
- 03_display_server placeholder

### roles/03_gui_backup/tasks/main.yml
- GUI placeholder

### roles/04_desktop/tasks/main.yml
- Install window manager

### roles/05_packages/tasks/main.yml
- Install packages
- Install Sunshine
- Install font packages
- Start systemd service - systemd-modules-load.service

### roles/05_packages/tasks/fonts.yml
- Install fonts

### roles/05_packages/tasks/aur.yml
- Installing AUR helper
- Install AUR packages

### roles/06_microcode/tasks/main.yml
- Placeholder task for 06_microcode role

### roles/07_users/tasks/main.yml
- Create user
- Git config user.name
- Git config user.email
- Git config credential.helper
- Git config pull.rebase
- Git config diff.colorMoved
- Install VS Code extensions
- Get dotfiles
- Update makepkg configuration file
- Mask systemd services - lvm
- Mask systemd services - systemd homed

### roles/08_hardware/tasks/main.yml
- Placeholder task for 08_hardware role

### roles/09_bluetooth/tasks/main.yml
- Placeholder task for 09_bluetooth role

### roles/10_laptop/tasks/main.yml
- Placeholder task for 10_laptop role

### roles/git/tasks/main.yml
- Template gitconfig
- Ensure gitconfig.d directory exists
- Register SSH key with Github
- Import authorized keys tasks
- Import repo cloning tasks
- Import signing key tasks

### roles/git/tasks/clone_repos.yml
- Start ssh-agent
- Add key to ssh-agent
- Create repository directories
- Clone repositories

### roles/git/tasks/get_authorized_keys.yml
- Get list of existing Github SSH keys
- Add matching public keys to `authorized_keys`

### roles/git/tasks/manage_signing_key.yml
- Create allowed signers file
- Get list of existing Github SSH signing keys
- Register SSH signing key with Github

### roles/git/handlers/main.yml
- Stop ssh-agent

### roles/ssh/tasks/main.yml
- Ensure SSH directory is present
- Set proper permissions on ~/.ssh/authorized_keys
- Create SSH key
- Create SSH config
- Create host keys
- Load SSH hardening tasks

### roles/ssh/tasks/hardening.yml
- Load SSH hardening vars
- Set SSH hardening vars for LMDE
- Secure SSH settings

### roles/dotfiles/tasks/main.yml
- Create directories
- Install dotfiles
- Render dotfile templates
- Post-processing

### roles/fonts/tasks/main.yml
- fonts placeholder

### roles/dock/tasks/main.yml
- dock placeholder

### roles/logi/tasks/main.yml
- logi placeholder

### roles/vim/tasks/main.yml
- vim placeholder

### roles/zsh/tasks/main.yml
- zsh placeholder

### roles/tmux/tasks/main.yml
- Install tmux (via OS package manager)
- Install tmux (via Homebrew)
- Ensure tmux config path exists
- Template tmux config
- Install tmux plugins

### roles/cloud/tasks/main.yml
- cloud placeholder

### roles/packages/tasks/main.yml
- Stop packagekit
- Include distro-specific package managers
- Install Homebrew packages for Linux
- Install Mac App Store apps
- Include Flakpak packages
- Install pipx packages
- Ensure binary install path exists
- Download binaries

### roles/packages/tasks/pkg_mgr/apt.yml
- Install gpg keys
- Install repositories
- Update apt cache
- Install cli packages
- Install gui packages
- Install Desktop Environment or Window Manager packages

### roles/packages/tasks/pkg_mgr/dnf.yml
- Install gpg keys
- Install repositories
- Update dnf cache
- Install cli packages
- Install gui packages
- Install Desktop Environment or Window Manager packages

### roles/packages/tasks/pkg_mgr/flatpak.yml
- Install flatpak
- Install flatpak remotes
- Install flatpak packages

### roles/packages/tasks/pkg_mgr/homebrew.yml
- Install Homebrew taps
- Install Homebrew formulas
- Install Homebrew casks

### roles/packages/tasks/pkg_mgr/mas.yml
- Install mas formula
- Install apps via mas

### roles/packages/handlers/main.yml
- Start packagekit

### roles/system/tasks/main.yml
- Set hostname
- Include system-specific tasks

### roles/system/tasks/Darwin.yml
- Set macOS default settings
- Set launchd services
- Put display to sleep after X minutes
- Put computer to sleep after X minutes
- Set firewall state
- Set Gatekeeper state
- Set ~/Library hidden state
- Set /Volumes hidden state

### roles/system/tasks/Linux.yml
- Load per-system package definitions
- Add DNS fallback
- Apply dconf settings
- Apply Dracut settings

### roles/system/tasks/dconf.yml
- Apply dconf settings

### roles/system/handlers/main.yml
- Restart macOS dock
- Regenerate Dracut

---

## Statistics by Category

### Playbooks: 6 playbooks
- 1 main site playbook
- 3 system configuration playbooks (arch-base, arch-maintenance, wsl-base)
- 1 test playbook
- 1 requirements installation playbook

### Direct Tasks: 3 task files
- bootstrap.yml: 4 tasks
- maintenance.yml: 5 tasks
- skogai-core.yml: 35 tasks

### Tests: 10 test files
- 5 in /tests/ subdirectory
- 5 duplicates at root level
- 1 unique test per file (some duplicated at root)

### Roles: 61+ task files across 30+ roles

#### Core Infrastructure Roles:
- **01_host_info**: Distribution checking (1 task)
- **02_basics**: System services & mirrors (7 tasks + 1 handler)
- **03_display_server**: Display server setup (placeholder)
- **04_desktop**: Window manager installation
- **05_packages**: Package installation & fonts (7 tasks total)
- **06_microcode**: Microcode updates (placeholder)
- **07_users**: User creation & configuration (11 tasks)
- **08_hardware**: Hardware configuration (placeholder)
- **09_bluetooth**: Bluetooth setup (placeholder)
- **10_laptop**: Laptop-specific config (placeholder)

#### Package Management Roles:
- **packages**: Multi-platform package management (8 main tasks)
  - pkg_mgr/apt: Debian/Ubuntu (6 tasks)
  - pkg_mgr/dnf: Fedora/RHEL (6 tasks)
  - pkg_mgr/flatpak: Flatpak packages (3 tasks)
  - pkg_mgr/homebrew: macOS/Homebrew (3 tasks)
  - pkg_mgr/mas: Mac App Store (2 tasks)
- handlers: PackageKit management (1 handler)

#### Development & Tools Roles:
- **git**: Git configuration & SSH (7 main tasks)
  - get_authorized_keys: GitHub SSH key management (2 tasks)
  - clone_repos: Repository cloning (4 tasks)
  - manage_signing_key: GPG signing keys (3 tasks)
  - handlers: SSH agent management (1 handler)
- **ssh**: SSH configuration & hardening (6 tasks)
- **dotfiles**: Configuration file management (4 tasks)
- **tmux**: Terminal multiplexer setup (5 tasks)

#### Application/Configuration Roles:
- **vim**: Vi/Vim setup (placeholder)
- **zsh**: Zsh shell setup (placeholder)
- **fonts**: Font installation (placeholder)
- **cloud**: Cloud services (placeholder)
- **logi**: Logitech devices (placeholder)
- **dock**: Dock configuration (placeholder)

#### System Configuration Roles:
- **system**: Cross-platform system settings
  - main.yml: Hostname & OS dispatch (2 tasks)
  - Darwin.yml: macOS settings (8 tasks)
  - Linux.yml: Linux-specific settings (4 tasks)
  - dconf.yml: GNOME dconf settings (1 task)
  - handlers: System change notifications (2 handlers)

---

## Key Observations

1. **Multi-OS Support**: Architecture includes Darwin (macOS), Linux variants (Arch, Debian, Fedora)
2. **Package Management**: Extensive support for multiple package managers (apt, dnf, pacman, homebrew, mas, flatpak)
3. **Placeholder Tasks**: Many roles have placeholder implementations waiting for actual configuration
4. **Archlinux Focus**: Core tasks heavily focused on Arch Linux optimization and configuration
5. **Testing Framework**: Comprehensive test playbooks for arch detection, services, dependencies, and workflows
6. **Development Integration**: Strong emphasis on Git, SSH, and development environment setup
7. **System Optimization**: Tasks for performance tuning (fstab, makepkg, pacman optimization)
8. **Service Management**: Extensive use of systemd timers and services for automated maintenance

---

*Generated from archive-2025-10-05-ansible directory*
*Archive Date: 2025-10-05*
*Last Updated: 2025-12-18*
