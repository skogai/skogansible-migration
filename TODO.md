# Ansible Repository TODO

This document tracks implementation status for all roles in the consolidated Ansible repository.

## Legend
- ✅ Complete and working
- 🚧 Partially implemented
- ⏳ TODO (placeholder only)
- 📝 Needs implementation

---

## Numbered Roles (Sequential Setup)

### ✅ 00_bootstrap
- [x] Install ssh
- [x] Install core packages
- [x] Set yay options

### ✅ 01_host_info
- [x] Display current user
- [x] Check sudo configuration
- [x] Save ansible facts to file
- [x] Display system information

### ✅ 02_package_managers
- [x] Ensure yay is installed
- [x] Create aur_builder user
- [x] Configure passwordless sudo for pacman
- [x] Load package lists from vars/packages.yml
- [x] Install pacman packages
- [x] Install AUR packages

### 🚧 03_dotfiles
- [x] Clone dotfiles repository from git@github.com:SkogAI/.dotfiles.git
- [x] Copy rcrc configuration to home directory
- [x] Run rcup to symlink dotfiles
- [ ] Verify critical dotfiles are properly symlinked (optional enhancement)

### ✅ 04_shell_config
- [x] Display shell configuration status
- [x] Ensure zsh is installed
- [x] Check if oh-my-zsh is already installed
- [x] Link oh-my-zsh from AUR installation
- [x] Install zsh-autosuggestions plugin
- [x] Install zsh-syntax-highlighting plugin
- [x] Check current shell
- [x] Set zsh as default shell
- [x] Display completion message

### 📝 05_systemd_services
- [ ] Enable cockpit service (cockpit.socket)
- [ ] Symlink services from ~/.dotfiles/config/systemd/user/ to ~/.config/systemd/user/
- [ ] Enable AI tool services (skogai-ttyd, skogai-gptme, skogai-claude-webui, etc.)
- [ ] Run systemctl --user daemon-reload
- [ ] Verify service status and report failures

### 📝 06_ai_tools
- [ ] Setup Claude Code configuration (symlink configs, API keys)
- [ ] Configure aider-chat (aider.conf.yml, venv setup)
- [ ] Setup fabric-ai (initialize fabric, configure patterns/models)
- [ ] Configure gptme (symlink config.toml, API keys)
- [ ] Setup opencode-ai (symlink configs, configure agents)
- [ ] Configure aichat-ng (symlink config, setup models)
- [ ] Setup mods configuration (symlink mods.yml, configure API endpoints)

### 📝 07_development
- [ ] Setup .NET SDK environment (DOTNET_ROOT, PATH)
- [ ] Setup Bun environment (BUN_INSTALL, PATH)
- [ ] Initialize Google Cloud CLI (gcloud init, authentication)
- [ ] Configure Supabase CLI (setup, link projects)
- [ ] Setup pgvector extension (PostgreSQL configuration)
- [ ] Setup Virtualbox (add user to vboxusers, load kernel modules)
- [ ] Configure git-flow (setup defaults for repositories)

---

## Named Roles (Modular Components)

### ⏳ cloud
- [ ] Implement cloud role
- [ ] Likely includes: AWS CLI, Azure CLI, GCP CLI configuration
- [ ] Cloud provider authentication setup

### ⏳ dock
- [ ] Implement dock role
- [ ] Likely includes: Docker installation and configuration
- [ ] Docker Compose setup
- [ ] Container runtime configuration

### ✅ dotfiles (named version - different from 03_dotfiles)
- [x] Create directories from dotfiles_folders variable
- [x] Synchronize files from dotfiles_files_source
- [x] Render dotfile templates
- [x] Run post-processing commands
- Note: This is a more generic dotfiles role using synchronize instead of rcup

### ⏳ fonts
- [ ] Implement fonts role
- [ ] Likely includes: Nerd Fonts installation
- [ ] Font cache updates

### ✅ git
- [x] Template gitconfig
- [x] Ensure gitconfig.d directory exists
- [x] Register SSH key with Github
- [x] Import authorized keys tasks
- [x] Import repo cloning tasks
- [x] Import signing key tasks

### ✅ packages (cross-platform package manager)
- [x] Stop packagekit service
- [x] Include distro-specific package managers
- [x] Install Homebrew packages for Linux
- [x] Install Mac App Store apps (macOS only)
- [x] Include Flatpak packages
- [x] Install pipx packages
- [x] Ensure binary install path exists
- [x] Download binaries

### ✅ ssh
- [x] Ensure SSH directory is present
- [x] Set proper permissions on authorized_keys
- [x] Create SSH keys (configurable types)
- [x] Create SSH config
- [x] Create host keys
- [x] Load SSH hardening tasks

### ✅ system
- [x] Set hostname
- [x] Include system-specific tasks (Linux/Darwin)

### ✅ tmux
- [x] Install tmux (via OS package manager or Homebrew)
- [x] Ensure tmux config path exists
- [x] Template tmux config
- [x] Install tmux plugins

### ⏳ vim
- [ ] Implement vim role
- [ ] Likely includes: Vim/Neovim installation
- [ ] Plugin manager setup
- [ ] Configuration symlinks

### ⏳ zsh (named version - different from 04_shell_config)
- [ ] Implement zsh role
- [ ] Likely includes: Zsh installation and configuration
- [ ] Oh-my-zsh or similar framework setup
- [ ] Theme and plugin configuration

---

## Priority Implementation Order

### High Priority (Core Functionality)
1. **05_systemd_services** - Critical for enabling services that should auto-start
2. **06_ai_tools** - Core SkogAI AI tool configurations
3. **fonts** - Visual quality and terminal rendering

### Medium Priority (Development Tools)
4. **07_development** - Development environment setup
5. **dock** - Docker and containerization
6. **cloud** - Cloud CLI tools

### Low Priority (Already covered by numbered roles or optional)
7. **vim** - May be redundant with dotfiles
8. **zsh** - Already covered by 04_shell_config

---

## Variables to Review

Check these variable files for configuration:
- `vars/packages.yml` - Package lists (packages, aur_packages)
- `vars/user.yml` - User configuration
- Individual role `defaults/main.yml` files

---

## Testing Checklist

Before marking a role as complete:
- [ ] Run `./test.sh` for syntax and linting
- [ ] Run `./run.sh` to execute the playbook
- [ ] Verify role tasks complete without errors
- [ ] Test idempotency (run twice, second run should show no changes)
- [ ] Document any special requirements or dependencies

---

## Notes

- **Vault password**: `/home/skogix/.ssh/ansible-vault-password`
- **Become password**: `/home/skogix/.ssh/ansible-become-password` (vault-encrypted)
- **Collections path**: `~/.ansible/.collections`
- **Always use run.sh**: Never run ansible-playbook directly
- **Pre-commit hooks**: Use `./setup-precommit.sh` for automated testing

---

## Recent Progress

### 2025-10-20
- ✅ Fixed 03_dotfiles git clone task with ignore_errors
- ✅ Implemented rcup functionality (copy rcrc, run rcup)
- 📝 Created this TODO.md for tracking remaining work
