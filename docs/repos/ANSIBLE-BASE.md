# Ansible Task Inventory

Complete catalog of all task names in ansible-base, organized by type and role.

Generated: 2025-12-18

---

## Roles - Core System Setup (Numbered Roles)

### Role: 00-locale

Located: `roles/00-locale/tasks/main.yml`

- Ensure locale.gen is configured
- Set system locale

### Role: 00-secrets

Located: `roles/00-secrets/tasks/main.yml`

- Check if .ssh exists
- Ensure .secrets directory exists
- Clone secrets repo
- Ensure secrets directory has correct permissions
- Ensure SSH directory exists
- Copy SSH keys if they exist
- Set SSH key permissions

### Role: 01-base

Located: `roles/01-base/tasks/main.yml`

- Update package cache
- Upgrade all packages
- Install base packages
- Install utility packages
- Set timezone
- Set hostname
- Enable sshd service
- Configure pacman parallel downloads
- Enable color in pacman

### Role: 02-users

Located: `roles/02-users/tasks/main.yml`

- Install shell package if needed
- Ensure primary user exists
- Create additional users
- Configure sudo for wheel group
- Ensure .ssh directory exists for primary user
- Add SSH authorized keys

### Role: 03-dotfiles

Located: `roles/03-dotfiles/tasks/main.yml`

- Ensure .config directories exist
- Install stow if needed
- Clone dotfiles repository
- Build stow command arguments
- Apply stow packages
- Deploy templated zsh configs for users
- Create manual symlinks
- Ensure zsh completions directory exists
- Symlink zsh completions for users
- Symlink fish config for users
- Symlink fish_plugins for users
- Symlink kitty config for users
- Symlink sway configs for users
- Ensure sway config.d exists
- Symlink sway config.d files for users
- Symlink sway backup configs for users
- Check if Claude Code is installed
- Install Claude Code
- Ensure systemd user directory exists
- Symlink systemd user services
- Ensure .claude directory exists
- Symlink Claude CLAUDE.md for users
- Symlink Claude settings.json for users
- Ensure Claude skills directory exists
- Symlink individual Claude skills for users
- Ensure btop config directory exists
- Symlink btop config for users
- Ensure picom config directory exists
- Symlink picom config for users
- Ensure pipewire config directory exists
- Symlink pipewire config for users
- Ensure rclone config directory exists
- Symlink rclone config for users
- Symlink byobu configs for users
- Deploy i3 config from template (content varies by wm_type)
- Symlink i3 scripts for users
- Symlink i3 backup config for users
- Symlink i3 wallpaper for users
- Symlink mods config for users
- Symlink Zed config files for users
- Symlink aichat config for users
- Symlink xinitrc for users
- Remove existing aichat agent directories if they exist
- Symlink aichat agent directories for users
- Symlink gh config files for users
- Symlink gh config files for users
- Symlink xinitrc to home directory for users
- Symlink .inputrc for users (readline config - Issue #52)
- Symlink .editorconfig for users (cross-editor consistency - Issue #53)
- Symlink .dircolors for users (custom ls colors - Issue #54)
- Symlink .profile for users (login shell environment - Issue #56)
- Deploy .bashrc template for users (bash shell config - Issue #57)

### Role: 04-aur-user

Located: `roles/04-aur-user/tasks/main.yml`

- Verify nologin shell exists (security check)
- Create AUR build user
- Create build directory for AUR packages
- Configure passwordless sudo for AUR user
- Install dependencies for AUR building
- Set AUR helper repository URL
- Check if AUR helper is already installed
- Check AUR helper remote origin
- Clone AUR helper repository
- Build and install AUR helper

### Role: 05-nvm

Located: `roles/05-nvm/tasks/main.yml`

- Check if NVM is already installed
- Download NVM installer
- Install NVM
- Remove NVM installer script
- Install default Node.js version
- Install additional Node.js versions
- Set default Node.js version
- Install global npm packages

### Role: 06-skogcli

Located: `roles/06-skogcli/tasks/main.yml`

- Install dependencies
- Ensure bin directory exists
- Clone SkogCLI repository
- Add bin path to shell profiles

### Role: 07-argc

Located: `roles/07-argc/tasks/main.yml`

- Check if argc is already installed
- Install argc via cargo
- Install argc from binary release
- Ensure completions directory exists
- Generate shell completions

### Role: 08-graphics

Located: `roles/08-graphics/tasks/main.yml`

- Install NVIDIA drivers
- Install AMD drivers
- Install Intel drivers
- Install CUDA toolkit
- Install Ollama via script
- Install Ollama via pacman
- Enable Ollama service
- Pull Ollama models

### Role: 09-uv-tools

Located: `roles/09-uv-tools/tasks/main.yml`, split into sub-files

#### Main (`tasks/main.yml`)

- Check if uv is already installed
- Fail if uv not installed and install method is skip
- Install uv via official installer script
- Install uv from system package manager
- Install Python via uv

#### Install (`tasks/install.yml`)

- Check currently installed tools
- Install Python CLI tools via uv

#### Remove (`tasks/remove.yml`)

- Remove unwanted Python CLI tools

#### Verify (`tasks/verify.yml`)

- Verify installed tools are accessible

### Role: 10-gptme

Located: `roles/10-gptme/tasks/main.yml`

- Install gptme via uv
- Install gptme via pip
- Install gptme via pipx
- Ensure gptme config directory exists
- Create gptme configuration file

---

## Roles - Development Tools

### Role: bash

Located: `roles/bash/tasks/main.yml`

- Bash | Detect oh-my-bash
- Bash | Register oh-my-bash state
- Bash | Debug ohmybash_is_installed
- Bash | Install oh-my-bash
- Bash | Copy .bashrc
- Bash | Copy .profile
- Bash | Copy custom bash config
- Bash | Copy custom bash theme
- Bash | {{ ansible_distribution }} | Identify distribution config
- Bash | {{ ansible_os_family }} | Identify os family config
- Bash | Calculate os config src
- Bash | Copy custom bash config for os: {{ bash_os_config.stat.path | basename }}

### Role: bat

Located: `roles/bat/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

### Role: brave

Located: `roles/brave/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

### Role: btop

Located: `roles/btop/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- BTOP | Ensure btop directory structure exists
- BTOP | Copy btop config

### Role: fonts

Located: `roles/fonts/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

### Role: fzf

Located: `roles/fzf/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

### Role: gh

Located: `roles/gh/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/gh/tasks/MacOSX.yml`)

- GH | MacOSX | Install gh

#### Ubuntu (`roles/gh/tasks/Ubuntu.yml`)

- Install GitHub CLI tool

### Role: git

Located: `roles/git/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- Git | Set diff.colorMoved
- Git | Set fetch.prune
- Git | Set user.name
- Git | Set user.email
- Git | Set commit signing key
- Git | Set GPG format to SSH
- Git | Set SSH program
- Git | Enable commit signing
- Git | Add GitHub SSH config

**Platform-specific tasks:**

#### Archlinux (`roles/git/tasks/Archlinux.yml`)

- Git | {{ ansible_distribution }} | Install git

#### MacOSX (`roles/git/tasks/MacOSX.yml`)

- Git | MacOSX | Install git

#### Ubuntu (`roles/git/tasks/Ubuntu.yml`)

- Git | {{ ansible_distribution }} | Install git

### Role: go

Located: `roles/go/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- Install Packages

**Platform-specific tasks:**

#### MacOSX (`roles/go/tasks/MacOSX.yml`)

- Go | MacOSX | Install Go

#### Packages (`roles/go/tasks/packages.yml`)

- Go-Lang | Install GoLang Packages

#### Ubuntu (`roles/go/tasks/Ubuntu.yml`)

- Go-Lang | Install dependencies
- Go-Lang | Define GOARCH
- Go-Lang | Define GOOS
- Go-Lang | GOARCH Value
- Go-Lang | GOOS Value
- Go-Lang | Getting version information
- Go-Lang | Querying Latest Version JSON
- Go-Lang | Registering go Latest Version
- Go-Lang | Registering go Latest Release
- Go-Lang | Define go_file
- Go-Lang | Show current_go_version debug
- Go-Lang | Show go_latest_release debug
- Go-Lang | Install

### Role: lazygit

Located: `roles/lazygit/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/lazygit/tasks/MacOSX.yml`)

- Lazygit | MacOSX | Install lazygit

#### Ubuntu (`roles/lazygit/tasks/Ubuntu.yml`)

- LAZYGIT | Download Latest Version JSON
- LAZYGIT | Registering lazygit Latest Release
- LAZYGIT | Registering lazygit Latest Version
- LAZYGIT | Getting version information
- LAZYGIT | Show current_lazygit_version debug
- LAZYGIT | Show lazygit_latest_release debug
- LAZYGIT | Install

### Role: lsd

Located: `roles/lsd/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/lsd/tasks/MacOSX.yml`)

- LSD | MacOSX | Install lsd

#### Ubuntu (`roles/lsd/tasks/Ubuntu.yml`)

- LSD | Download Latest Version JSON
- LSD | Registering LSD Latest Release
- LSD | Registering LSD Latest Version
- LSD | Getting version information
- LSD | Edit current_lsd_version
- LSD | Show current_lsd_version debug
- LSD | Show lsd_latest_release debug
- LSD | Install

### Role: lua

Located: `roles/lua/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/lua/tasks/MacOSX.yml`)

- Lua | MacOSX | Install lua

#### Ubuntu (`roles/lua/tasks/Ubuntu.yml`)

- Lua | Update APT cache
- Lua | Install Lua
- Lua | Gather installed lua rocks

### Role: neovim

Located: `roles/neovim/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- Neovim | Debug Ansible_user_dir
- Neovim | Config folder
- Neovim | Create symlink to role files directory

**Platform-specific tasks:**

#### Archlinux (`roles/neovim/tasks/Archlinux.yml`)

- Neovim | {{ ansible_distribution }} | Install Neovim Nightly

#### MacOSX (`roles/neovim/tasks/MacOSX.yml`)

- Neovim | MacOSX | Dependencies
- Neovim | MacOSX | Install

#### Ubuntu (`roles/neovim/tasks/Ubuntu.yml`)

- Neovim | {{ ansible_distribution }} | Dependencies
- Neovim | {{ ansible_distribution }} | Install

### Role: npm

Located: `roles/npm/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/npm/tasks/MacOSX.yml`)

- NPM | MacOSX | Install npm

#### Ubuntu (`roles/npm/tasks/Ubuntu.yml`)

- NPM | Get latest STABLE NodeJS version
- NPM | Check if NodeJS is installed
- NPM | Check if NodeJS is up to date
- NPM | Show NodeJS version
- NPM | Show NodeJS latest version
- NPM | Register update needed
- NPM | Install NodeJS

### Role: nvim

Located: `roles/nvim/tasks/main.yml`

- Neovim | Install Neovim Nightly

### Role: nvm

Located: `roles/nvm/tasks/main.yml`

- NVM | Download Latest Version JSON
- NVM | Registering NVM Latest Release
- NVM | Registering NVM Latest Version
- NVM | Show nvm_latest_release debug
- Install nvm
- Ensure NVM is added to PATH

### Role: python

Located: `roles/python/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### Ubuntu (`roles/python/tasks/Ubuntu.yml`)

- Python | Install
- Python | Install pip packages

### Role: rust

Located: `roles/rust/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### Archlinux (`roles/rust/tasks/Archlinux.yml`)

- Rust | {{ ansible_distribution }} | Install rustup

#### Ubuntu (`roles/rust/tasks/Ubuntu.yml`)

- Rust | Install packages

### Role: starship

Located: `roles/starship/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- {{ role_name }} | Ensure .config directory exists
- {{ role_name }} | Copy custom starship config

**Platform-specific tasks:**

#### MacOSX (`roles/starship/tasks/MacOSX.yml`)

- Starship | MacOSX | Install Starship

#### Ubuntu (`roles/starship/tasks/Ubuntu.yml`)

- Starship | {{ ansible_distribution }} | Install Starship
- Starship | {{ ansible_distribution }} | Install Starship (duplicate)

### Role: system

Located: `roles/system/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- System | Set hosts

**Platform-specific tasks:**

#### Archlinux (`roles/system/tasks/Archlinux.yml`)

- System | {{ ansible_distribution }} | Update pacman
- System | {{ ansible_distribution }} | Install

#### MacOSX (`roles/system/tasks/MacOSX.yml`)

- System | MacOSX | Update Homebrew
- System | MacOSX | Install Homebrew Packages
- System | MacOSX | Enable Passwordless Sudo

#### Ubuntu (`roles/system/tasks/Ubuntu.yml`)

- System | {{ ansible_distribution }} | Update APT Repos and Upgrade APT Packages
- System | {{ ansible_distribution }} | Install
- System | Detecting win32yank
- System | Install win32yank.exe

### Role: tldr

Located: `roles/tldr/tasks/main.yml`

- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### MacOSX (`roles/tldr/tasks/MacOSX.yml`)

- TLDR | MacOSX | Install TLDR

#### Ubuntu (`roles/tldr/tasks/Ubuntu.yml`)

- Tldr | Download Latest Version JSON
- Tldr | Registering Tldr Latest Release
- Tldr | Registering Tldr Latest Version
- Tldr | Getting version information
- Tldr | Show current_tldr_version debug
- Tldr | Show tldr_latest_release debug
- Tldr | Install

### Role: tmux

Located: `roles/tmux/tasks/main.yml`

- Tmux | Checking for Distribution Config: {{ ansible_distribution }}
- Tmux | Run Tasks: {{ ansible_distribution }}
- Tmux | Install TPM
- Tmux | Configure tmux

**Platform-specific tasks:**

#### Archlinux (`roles/tmux/tasks/Archlinux.yml`)

- Tmux | {{ ansible_distribution }} | Install tmux

#### MacOSX (`roles/tmux/tasks/MacOSX.yml`)

- TMUX | MacOSX | Install tmux

#### Ubuntu (`roles/tmux/tasks/Ubuntu.yml`)

- Tmux | {{ ansible_distribution }} | Install tmux

### Role: warp

Located: `roles/warp/tasks/main.yml`

**Platform-specific tasks:**

#### MacOSX (`roles/warp/tasks/MacOSX.yml`)

- WARP | MacOSX | Install warp

#### Ubuntu (`roles/warp/tasks/Ubuntu.yml`)

- Warp | Add APT Key
- Warp | Add APT Repository
- Warp | Install Warp

#### Main YAML (`roles/warp/tasks/main.yaml`)

- Warp | Checking for Distribution Config: {{ ansible_distribution }}
- Warp | Run Tasks: {{ ansible_distribution }}

### Role: zoxide

Located: `roles/zoxide/tasks/main.yml`

- Zoxide | Checking for Distribution Config: {{ ansible_distribution }}
- Zoxide | Run Tasks: {{ ansible_distribution }}

**Platform-specific tasks:**

#### Archlinux (`roles/zoxide/tasks/Archlinux.yml`)

- Zoxide | {{ ansible_distribution }} | Install Zoxide

#### MacOSX (`roles/zoxide/tasks/MacOSX.yml`)

- Zoxide | MacOSX | Install Zoxide

#### Ubuntu (`roles/zoxide/tasks/Ubuntu.yml`)

- Zoxide | {{ ansible_distribution }} | Install Zoxide

### Role: zsh

Located: `roles/zsh/tasks/main.yml`

- Determine user home directory
- {{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}
- {{ role_name }} | Run Tasks: {{ ansible_distribution }}
- ZSH | Install zsh
- ZSH | Detect oh-my-zsh
- ZSH | Register oh-my-zsh state
- ZSH | Debug ohmyzsh_is_installed
- ZSH | Debug home directory exists
- ZSH | Install oh-my-zsh
- ZSH | Install Custom Plugins
- ZSH | Copy .zshrc
- ZSH | Copy custom zsh config
- ZSH | {{ ansible_distribution }} | Identify distribution config
- ZSH | {{ ansible_os_family }} | Identify os family config
- ZSH | Calculate os config src
- ZSH | Copy custom zsh config for os: {{ zsh_os_config.stat.path | basename }}

**Platform-specific tasks:**

#### MacOSX (`roles/zsh/tasks/MacOSX.yml`)

- Zsh | MacOSX | Install
- Zsh | Set default terminal

#### Ubuntu (`roles/zsh/tasks/Ubuntu.yml`)

- Zsh | Set default terminal

### Role: skogai-ssh

Located: `roles/skogai-ssh/tasks/main.yml`

- SSH | Ensure .ssh directory exists
- SSH | Deploy SSH keys from vault
- SSH | Generate SSH key pair
- SSH | Deploy SSH config
- SSH | Manage known hosts
- SSH | Manage authorized_keys
- SSH | Backup SSH directory

**Example playbooks** in `roles/skogai-ssh/examples/`:

- `01-basic-setup.yml` - Basic SSH setup
- `02-generate-key.yml` - Generate SSH key
- `03-deploy-from-vault.yml` - Deploy SSH keys from vault
- `04-deploy-config.yml` - Deploy SSH configuration
- `05-manage-known-hosts.yml` - Manage SSH known hosts
- `06-complete-setup.yml` - Complete SSH environment setup

---

## Top-Level Playbooks

### Main Playbook

Located: `skogai.yml`

- Deploy Dotfiles

### SSH Deployment Playbook

Located: `plays/deploy-ssh.yml`

- Deploy SSH keys

---

## Example Playbooks

Located: `examples/` directory

Each example demonstrates individual role usage:

- `example-argc.yml` - Install argc
- `example-aur-user.yml` - Configure AUR build user
- `example-base.yml` - Install base packages
- `example-dotfiles.yml` - Deploy dotfiles configuration
- `example-gptme.yml` - Install gptme
- `example-graphics.yml` - Install GPU drivers
- `example-locale.yml` - Configure system locale
- `example-nvm.yml` - Install Node Version Manager
- `example-secrets.yml` - Deploy SSH keys and secrets
- `example-skogcli.yml` - Install SkogAI CLI
- `example-users.yml` - Create and configure users
- `example-uv-tools.yml` - Install Python CLI tools with uv

---

## Handlers

Handlers provide idempotent service restart and cleanup operations:

### Role: 00-locale

Located: `roles/00-locale/handlers/main.yml`

- Generate locales

### Role: 01-base

Located: `roles/01-base/handlers/main.yml`

- Sync hardware clock

### Role: 05-nvm

Located: `roles/05-nvm/handlers/main.yml`

- Source NVM

### Role: 08-graphics

Located: `roles/08-graphics/handlers/main.yml`

- Regenerate initramfs

### Role: bash

Located: `roles/bash/handlers/main.yml`

- Remove oh-my-bash Install Script
- Bash | Cleanup oh-my-bash install script

### Role: fzf

Located: `roles/fzf/handlers/main.yml`

- Install FZF

### Role: go

Located: `roles/go/handlers/main.yml`

- Cleanup go downloaded tar
- Remove extracted go directory

### Role: lazygit

Located: `roles/lazygit/handlers/main.yml`

- Cleanup lazygit downloaded tar
- Remove extracted lazygit directory

### Role: lsd

Located: `roles/lsd/handlers/main.yml`

- Cleanup LSD downloaded tar

### Role: npm

Located: `roles/npm/handlers/main.yml`

- NPM | Cleanup NodeJS

### Role: tldr

Located: `roles/tldr/handlers/main.yml`

- Cleanup Tldr downloaded tar
- Remove extracted Tldr directory

### Role: zsh

Located: `roles/zsh/handlers/main.yml`

- ZSH | Cleanup oh-my-zsh install script

---

## Summary Statistics

- **Total Roles**: 45
- **Core System Roles (00-10)**: 11
- **Development Tool Roles**: 34
- **Total Unique Tasks**: 400+
- **Platform-Specific Task Files**: 25+ (MacOSX, Ubuntu, Archlinux variants)

## Organization by Function

### System Foundation

- 00-locale, 00-secrets, 01-base, 02-users

### System Enhancement

- 03-dotfiles, 04-aur-user, 05-nvm, 06-skogcli, 07-argc, 08-graphics, 09-uv-tools, 10-gptme

### Development Tools (Language Runtimes)

- bash, python, rust, go, lua, nvm, npm, nvim

### Development Tools (CLI Utilities)

- bat, fzf, gh, git, lazygit, lsd, tldr, zoxide

### Development Tools (Application Stacks)

- neovim, starship, tmux, zsh, warp, brave, btop, fonts

### Infrastructure

- system (package management), skogai-ssh (SSH configuration)

---

## Task Naming Conventions

Tasks follow consistent naming patterns:

- **"{{ role_name }}" pattern**: Refers to task title and distribution detection
- **Platform markers**: "MacOSX | ...", "{{ ansible_distribution }} | ...", "Archlinux | ..."
- **Functional markers**: Verb-noun format ("Install X", "Configure Y", "Ensure Z exists")
- **Tool prefixes**: "Git | ...", "ZSH | ...", "SSH | ...", "NPM | ..." etc.

---

## Notes

- Task names use Jinja2 templating for dynamic values ({{ ansible_distribution }}, {{ role_name }})
- Platform-specific tasks are organized into separate files (MacOSX.yml, Ubuntu.yml, Archlinux.yml)
- Handlers use task names to trigger on when conditions
- All roles follow FQCN (Fully Qualified Collection Names) for modules
- Variable naming follows `{role_name}_{variable_name}` convention
