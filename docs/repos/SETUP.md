# Ansible Task Inventory

Generated task catalog for `/home/skogix/skogai/ansible/setup`

## Overview

- **Total Roles**: 38
- **Base/Numbered Roles**: 12
- **Tool/Utility Roles**: 26
- **Play Files**: 1
- **Total Tasks**: 325

---

## Core Roles (Numbered: 00-10)

Core infrastructure and foundational setup roles executed in sequence.


### 00-locale

- `Ensure locale.gen is configured`
- `Set system locale`

### 00-secrets

- `Check if .ssh exists`
- `Ensure .secrets directory exists`
- `Clone secrets repo`
- `Ensure secrets directory has correct permissions`
- `Ensure SSH directory exists`
- `Copy SSH keys if they exist`
- `Set SSH key permissions`

### 01-base

- `Update package cache`
- `Upgrade all packages`
- `Install base packages`
- `Install utility packages`
- `Set timezone`
- `Set hostname`
- `Enable sshd service`
- `Configure pacman parallel downloads`
- `Enable color in pacman`

### 02-users

- `Install shell package if needed`
- `Ensure primary user exists`
- `Create additional users`
- `Configure sudo for wheel group`
- `Ensure .ssh directory exists for primary user`
- `Add SSH authorized keys`

### 03-dotfiles

- `Ensure .config directories exist`
- `Install stow if needed`
- `Clone dotfiles repository`
- `Build stow command arguments`
- `Apply stow packages`
- `Deploy templated zsh configs for users`
- `Create manual symlinks`
- `Ensure zsh completions directory exists`
- `Symlink zsh completions for users`
- `Symlink fish config for users`
- `Symlink fish_plugins for users`
- `Symlink kitty config for users`
- `Symlink sway configs for users`
- `Ensure sway config.d exists`
- `Symlink sway config.d files for users`
- `Symlink sway backup configs for users`
- `Check if Claude Code is installed`
- `Install Claude Code`
- `Ensure systemd user directory exists`
- `Symlink systemd user services`
- `Ensure .claude directory exists`
- `Symlink Claude CLAUDE.md for users`
- `Symlink Claude settings.json for users`
- `Ensure Claude skills directory exists`
- `Symlink individual Claude skills for users`
- `Ensure btop config directory exists`
- `Symlink btop config for users`
- `Ensure picom config directory exists`
- `Symlink picom config for users`
- `Ensure pipewire config directory exists`
- `Symlink pipewire config for users`
- `Ensure rclone config directory exists`
- `Symlink rclone config for users`
- `Symlink byobu configs for users`
- `Deploy i3 config from template (content varies by wm_type)`
- `Symlink i3 scripts for users`
- `Symlink i3 backup config for users`
- `Symlink i3 wallpaper for users`
- `Symlink mods config for users`
- `Symlink Zed config files for users`
- `Symlink aichat config for users`
- `Symlink xinitrc for users`
- `Remove existing aichat agent directories if they exist`
- `Symlink aichat agent directories for users`
- `Symlink gh config files for users`
- `Symlink gh config files for users`
- `Symlink xinitrc to home directory for users`
- `Symlink .inputrc for users (readline config - Issue #52)`
- `Symlink .editorconfig for users (cross-editor consistency - Issue #53)`
- `Symlink .dircolors for users (custom ls colors - Issue #54)`
- `Symlink .profile for users (login shell environment - Issue #56)`
- `Deploy .bashrc template for users (bash shell config - Issue #57)`

### 04-aur-user

- `Verify nologin shell exists (security check)`
- `Create AUR build user`
- `Create build directory for AUR packages`
- `Configure passwordless sudo for AUR user`
- `Install dependencies for AUR building`
- `Set AUR helper repository URL`
- `Check if AUR helper is already installed`
- `Check AUR helper remote origin`
- `Clone AUR helper repository`
- `Build and install AUR helper`

### 05-nvm

- `Check if NVM is already installed`
- `Download NVM installer`
- `Install NVM`
- `Remove NVM installer script`
- `Install default Node.js version`
- `Install additional Node.js versions`
- `Set default Node.js version`
- `Install global npm packages`

### 06-skogcli

- `Install dependencies`
- `Ensure bin directory exists`
- `Clone SkogCLI repository`
- `Add bin path to shell profiles`

### 07-argc

- `Check if argc is already installed`
- `Install argc via cargo`
- `Install argc from binary release`
- `Ensure completions directory exists`
- `Generate shell completions`

### 08-graphics

- `Install NVIDIA drivers`
- `Install AMD drivers`
- `Install Intel drivers`
- `Install CUDA toolkit`
- `Install Ollama via script`
- `Install Ollama via pacman`
- `Enable Ollama service`
- `Pull Ollama models`

### 09-uv-tools

- `Check currently installed tools` _(from install.yml)_
- `Install Python CLI tools via uv` _(from install.yml)_
- `Check if uv is already installed`
- `Fail if uv not installed and install method is skip`
- `Install uv via official installer script`
- `Install uv from system package manager`
- `Install Python via uv`
- `Install Python CLI tools via uv`
- `Remove unwanted tools`
- `Install and upgrade tools`
- `Verify tool installation`
- `Remove unwanted Python CLI tools` _(from remove.yml)_
- `Verify installed tools are accessible` _(from verify.yml)_

### 10-gptme

- `Install gptme via uv`
- `Install gptme via pip`
- `Install gptme via pipx`
- `Ensure gptme config directory exists`
- `Create gptme configuration file`

---

## Tool & Utility Roles

Optional roles for installing specific tools and applications.

### bash

- `Bash | Detect oh-my-bash`
- `Bash | Register oh-my-bash state`
- `Bash | Debug ohmybash_is_installed`
- `Bash | Install oh-my-bash`
- `Bash | Copy .bashrc`
- `Bash | Copy .profile`
- `Bash | Copy custom bash config`
- `Bash | Copy custom bash theme`
- `Bash | {{ ansible_distribution }} | Identify distribution config`
- `Bash | {{ ansible_os_family }} | Identify os family config`
- `Bash | Calculate os config src`
- `Bash | Copy custom bash config for os: {{ bash_os_config.stat.path | basename }}`

### bat

- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### brave

- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### btop

- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `BTOP | Ensure btop directory structure exists`
- `BTOP | Copy btop config`

### fonts

- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### fzf

- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### gh

- `GH | MacOSX | Install gh` _(from MacOSX.yml)_
- `Install GitHub CLI tool` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### git

- `Git | {{ ansible_distribution }} | Install git` _(from Archlinux.yml)_
- `Git | MacOSX | Install git` _(from MacOSX.yml)_
- `Git | {{ ansible_distribution }} | Install git` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `Git | Set diff.colorMoved`
- `Git | Set fetch.prune`
- `Git | Set user.name`
- `Git | Set user.email`
- `Git | Set commit signing key`
- `Git | Set GPG format to SSH`
- `Git | Set SSH program`
- `Git | Enable commit signing`
- `Git | Add GitHub SSH config`

### go

- `Go | MacOSX | Install Go` _(from MacOSX.yml)_
- `Go-Lang | Install dependencies` _(from Ubuntu.yml)_
- `Go-Lang | Define GOARCH` _(from Ubuntu.yml)_
- `Go-Lang | Define GOOS` _(from Ubuntu.yml)_
- `Go-Lang | GOARCH Value` _(from Ubuntu.yml)_
- `Go-Lang | GOOS Value` _(from Ubuntu.yml)_
- `Go-Lang | Getting version information` _(from Ubuntu.yml)_
- `Go-Lang | Querying Latest Version JSON` _(from Ubuntu.yml)_
- `Go-Lang | Registering go Latest Version` _(from Ubuntu.yml)_
- `Go-Lang | Registering go Latest Release` _(from Ubuntu.yml)_
- `Go-Lang | Define go_file` _(from Ubuntu.yml)_
- `Go-Lang | Show current_go_version debug` _(from Ubuntu.yml)_
- `Go-Lang | Show go_latest_release debug` _(from Ubuntu.yml)_
- `Go-Lang | Install` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `Install Packages`
- `Go-Lang | Install GoLang Packages` _(from packages.yml)_

### lazygit

- `Lazygit | MacOSX | Install lazygit` _(from MacOSX.yml)_
- `LAZYGIT | Download Latest Version JSON` _(from Ubuntu.yml)_
- `LAZYGIT | Registering lazygit Latest Release` _(from Ubuntu.yml)_
- `LAZYGIT | Registering lazygit Latest Version` _(from Ubuntu.yml)_
- `LAZYGIT | Getting version information` _(from Ubuntu.yml)_
- `LAZYGIT | Show current_lazygit_version debug` _(from Ubuntu.yml)_
- `LAZYGIT | Show lazygit_latest_release debug` _(from Ubuntu.yml)_
- `LAZYGIT | Install` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### lsd

- `LSD | MacOSX | Install lsd` _(from MacOSX.yml)_
- `LSD | Download Latest Version JSON` _(from Ubuntu.yml)_
- `LSD | Registering LSD Latest Release` _(from Ubuntu.yml)_
- `LSD | Registering LSD Latest Version` _(from Ubuntu.yml)_
- `LSD | Getting version information` _(from Ubuntu.yml)_
- `LSD | Edit current_lsd_version` _(from Ubuntu.yml)_
- `LSD | Show current_lsd_version debug` _(from Ubuntu.yml)_
- `LSD | Show lsd_latest_release debug` _(from Ubuntu.yml)_
- `LSD | Install` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### lua

- `Lua | MacOSX | Install lua` _(from MacOSX.yml)_
- `Lua | Update APT cache` _(from Ubuntu.yml)_
- `Lua | Install Lua` _(from Ubuntu.yml)_
- `Lua | Gather installed lua rocks` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### neovim

- `Neovim | {{ ansible_distribution }} | Install Neovim Nightly` _(from Archlinux.yml)_
- `Neovim | MacOSX | Dependencies` _(from MacOSX.yml)_
- `Neovim | MacOSX | Install` _(from MacOSX.yml)_
- `Neovim | {{ ansible_distribution }} | Dependencies` _(from Ubuntu.yml)_
- `Neovim | {{ ansible_distribution }} | Install` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `Neovim | Debug Ansible_user_dir`
- `Neovim | Config folder`
- `Neovim | Create symlink to role files directory`

### npm

- `NPM | MacOSX | Install npm` _(from MacOSX.yml)_
- `NPM | Get latest STABLE NodeJS version` _(from Ubuntu.yml)_
- `NPM | Check if NodeJS is installed` _(from Ubuntu.yml)_
- `NPM | Check if NodeJS is up to date` _(from Ubuntu.yml)_
- `NPM | Show NodeJS version` _(from Ubuntu.yml)_
- `NPM | Show NodeJS latest version` _(from Ubuntu.yml)_
- `NPM | Register update needed` _(from Ubuntu.yml)_
- `NPM | Install NodeJS` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### nvim

- `Neovim | Install Neovim Nightly`

### nvm

- `NVM | Download Latest Version JSON`
- `NVM | Registering NVM Latest Release`
- `NVM | Registering NVM Latest Version`
- `NVM | Show nvm_latest_release debug`
- `Install nvm`
- `Ensure NVM is added to PATH`

### python

- `Python | Install` _(from Ubuntu.yml)_
- `Python | Install pip packages` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### rust

- `Rust | {{ ansible_distribution }} | Install rustup` _(from Archlinux.yml)_
- `Rust | Install packages` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### skogai-ssh

- `SSH | Ensure .ssh directory exists`
- `SSH | Deploy SSH keys from vault`
- `SSH | Generate SSH key pair`
- `SSH | Deploy SSH config`
- `SSH | Manage known hosts`
- `SSH | Manage authorized_keys`
- `SSH | Backup SSH directory`

### starship

- `Starship | MacOSX | Install Starship` _(from MacOSX.yml)_
- `Starship | {{ ansible_distribution }} | Install Starship` _(from Ubuntu.yml)_
- `Starship | {{ ansible_distribution }} | Install Starship` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `{{ role_name }} | Ensure .config directory exists`
- `{{ role_name }} | Copy custom starship config`

### system

- `System | {{ ansible_distribution }} | Update pacman` _(from Archlinux.yml)_
- `System | {{ ansible_distribution }} | Install` _(from Archlinux.yml)_
- `System | MacOSX | Update Homebrew` _(from MacOSX.yml)_
- `System | MacOSX | Install Homebrew Packages` _(from MacOSX.yml)_
- `System | MacOSX | Enable Passwordless Sudo` _(from MacOSX.yml)_
- `System | {{ ansible_distribution }} | Update APT Repos and Upgrade APT Packages` _(from Ubuntu.yml)_
- `System | {{ ansible_distribution }} | Install` _(from Ubuntu.yml)_
- `System | Detecting win32yank` _(from Ubuntu.yml)_
- `System | Install win32yank.exe` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `System | Set hosts`

### tldr

- `TLDR | MacOSX | Install TLDR` _(from MacOSX.yml)_
- `Tldr | Download Latest Version JSON` _(from Ubuntu.yml)_
- `Tldr | Registering Tldr Latest Release` _(from Ubuntu.yml)_
- `Tldr | Registering Tldr Latest Version` _(from Ubuntu.yml)_
- `Tldr | Getting version information` _(from Ubuntu.yml)_
- `Tldr | Show current_tldr_version debug` _(from Ubuntu.yml)_
- `Tldr | Show tldr_latest_release debug` _(from Ubuntu.yml)_
- `Tldr | Install` _(from Ubuntu.yml)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`

### tmux

- `Tmux | {{ ansible_distribution }} | Install tmux` _(from Archlinux.yml)_
- `TMUX | MacOSX | Install tmux` _(from MacOSX.yml)_
- `Tmux | {{ ansible_distribution }} | Install tmux` _(from Ubuntu.yml)_
- `Tmux | Checking for Distribution Config: {{ ansible_distribution }}`
- `Tmux | Run Tasks: {{ ansible_distribution }}`
- `Tmux | Install TPM`
- `Tmux | Configure tmux`

### warp

- `WARP | MacOSX | Install warp` _(from MacOSX.yml)_
- `Warp | Add APT Key` _(from Ubuntu.yml)_
- `Warp | Add APT Repository` _(from Ubuntu.yml)_
- `Warp | Install Warp` _(from Ubuntu.yml)_
- `Warp | Checking for Distribution Config: {{ ansible_distribution }}` _(from main.yaml)_
- `Warp | Run Tasks: {{ ansible_distribution }}` _(from main.yaml)_

### zoxide

- `Zoxide | {{ ansible_distribution }} | Install Zoxide` _(from Archlinux.yml)_
- `Zoxide | MacOSX | Install Zoxide` _(from MacOSX.yml)_
- `Zoxide | {{ ansible_distribution }} | Install Zoxide` _(from Ubuntu.yml)_
- `Zoxide | Checking for Distribution Config: {{ ansible_distribution }}`
- `Zoxide | Run Tasks: {{ ansible_distribution }}`

### zsh

- `Zsh | MacOSX | Install` _(from MacOSX.yml)_
- `Zsh | Set default terminal` _(from MacOSX.yml)_
- `Zsh | Set default terminal` _(from Ubuntu.yml)_
- `Determine user home directory`
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}`
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}`
- `ZSH | Install zsh`
- `ZSH | Detect oh-my-zsh`
- `ZSH | Register oh-my-zsh state`
- `ZSH | Debug ohmyzsh_is_installed`
- `ZSH | Debug home directory exists`
- `ZSH | Install oh-my-zsh`
- `ZSH | Install Custom Plugins`
- `ZSH | Copy .zshrc`
- `ZSH | Copy custom zsh config`
- `ZSH | {{ ansible_distribution }} | Identify distribution config`
- `ZSH | {{ ansible_os_family }} | Identify os family config`
- `ZSH | Calculate os config src`
- `ZSH | Copy custom zsh config for os: {{ zsh_os_config.stat.path | basename }}`

---

## Play Files

Standalone playbooks in the plays directory.

### deploy-ssh.yml

- `Deploy SSH keys`

---

## Complete Task Index (Alphabetical)

- `BTOP | Copy btop config` _(role: btop)_
- `BTOP | Ensure btop directory structure exists` _(role: btop)_
- `Bash | Calculate os config src` _(role: bash)_
- `Bash | Copy .bashrc` _(role: bash)_
- `Bash | Copy .profile` _(role: bash)_
- `Bash | Copy custom bash config for os: {{ bash_os_config.stat.path | basename }}` _(role: bash)_
- `Bash | Copy custom bash config` _(role: bash)_
- `Bash | Copy custom bash theme` _(role: bash)_
- `Bash | Debug ohmybash_is_installed` _(role: bash)_
- `Bash | Detect oh-my-bash` _(role: bash)_
- `Bash | Install oh-my-bash` _(role: bash)_
- `Bash | Register oh-my-bash state` _(role: bash)_
- `Bash | {{ ansible_distribution }} | Identify distribution config` _(role: bash)_
- `Bash | {{ ansible_os_family }} | Identify os family config` _(role: bash)_
- `Determine user home directory` _(role: zsh)_
- `GH | MacOSX | Install gh` _(role: gh)_
- `Git | Add GitHub SSH config` _(role: git)_
- `Git | Enable commit signing` _(role: git)_
- `Git | MacOSX | Install git` _(role: git)_
- `Git | Set GPG format to SSH` _(role: git)_
- `Git | Set SSH program` _(role: git)_
- `Git | Set commit signing key` _(role: git)_
- `Git | Set diff.colorMoved` _(role: git)_
- `Git | Set fetch.prune` _(role: git)_
- `Git | Set user.email` _(role: git)_
- `Git | Set user.name` _(role: git)_
- `Git | {{ ansible_distribution }} | Install git` _(role: git)_
- `Git | {{ ansible_distribution }} | Install git` _(role: git)_
- `Go | MacOSX | Install Go` _(role: go)_
- `Go-Lang | Define GOARCH` _(role: go)_
- `Go-Lang | Define GOOS` _(role: go)_
- `Go-Lang | Define go_file` _(role: go)_
- `Go-Lang | GOARCH Value` _(role: go)_
- `Go-Lang | GOOS Value` _(role: go)_
- `Go-Lang | Getting version information` _(role: go)_
- `Go-Lang | Install dependencies` _(role: go)_
- `Go-Lang | Install` _(role: go)_
- `Go-Lang | Querying Latest Version JSON` _(role: go)_
- `Go-Lang | Registering go Latest Release` _(role: go)_
- `Go-Lang | Registering go Latest Version` _(role: go)_
- `Go-Lang | Show current_go_version debug` _(role: go)_
- `Go-Lang | Show go_latest_release debug` _(role: go)_
- `LAZYGIT | Download Latest Version JSON` _(role: lazygit)_
- `LAZYGIT | Getting version information` _(role: lazygit)_
- `LAZYGIT | Install` _(role: lazygit)_
- `LAZYGIT | Registering lazygit Latest Release` _(role: lazygit)_
- `LAZYGIT | Registering lazygit Latest Version` _(role: lazygit)_
- `LAZYGIT | Show current_lazygit_version debug` _(role: lazygit)_
- `LAZYGIT | Show lazygit_latest_release debug` _(role: lazygit)_
- `LSD | Download Latest Version JSON` _(role: lsd)_
- `LSD | Edit current_lsd_version` _(role: lsd)_
- `LSD | Getting version information` _(role: lsd)_
- `LSD | Install` _(role: lsd)_
- `LSD | MacOSX | Install lsd` _(role: lsd)_
- `LSD | Registering LSD Latest Release` _(role: lsd)_
- `LSD | Registering LSD Latest Version` _(role: lsd)_
- `LSD | Show current_lsd_version debug` _(role: lsd)_
- `LSD | Show lsd_latest_release debug` _(role: lsd)_
- `Lazygit | MacOSX | Install lazygit` _(role: lazygit)_
- `Lua | MacOSX | Install lua` _(role: lua)_
- `NPM | Check if NodeJS is installed` _(role: npm)_
- `NPM | Check if NodeJS is up to date` _(role: npm)_
- `NPM | Get latest STABLE NodeJS version` _(role: npm)_
- `NPM | Install NodeJS` _(role: npm)_
- `NPM | MacOSX | Install npm` _(role: npm)_
- `NPM | Register update needed` _(role: npm)_
- `NPM | Show NodeJS latest version` _(role: npm)_
- `NPM | Show NodeJS version` _(role: npm)_
- `NVM | Download Latest Version JSON` _(role: nvm)_
- `NVM | Registering NVM Latest Release` _(role: nvm)_
- `NVM | Registering NVM Latest Version` _(role: nvm)_
- `Neovim | Config folder` _(role: neovim)_
- `Neovim | Create symlink to role files directory` _(role: neovim)_
- `Neovim | Debug Ansible_user_dir` _(role: neovim)_
- `Neovim | Install Neovim Nightly` _(role: nvim)_
- `Neovim | MacOSX | Dependencies` _(role: neovim)_
- `Neovim | MacOSX | Install` _(role: neovim)_
- `Neovim | {{ ansible_distribution }} | Dependencies` _(role: neovim)_
- `Neovim | {{ ansible_distribution }} | Install Neovim Nightly` _(role: neovim)_
- `Neovim | {{ ansible_distribution }} | Install` _(role: neovim)_
- `Python | Install pip packages` _(role: python)_
- `Python | Install` _(role: python)_
- `Rust | {{ ansible_distribution }} | Install rustup` _(role: rust)_
- `SSH | Backup SSH directory` _(role: skogai-ssh)_
- `SSH | Deploy SSH config` _(role: skogai-ssh)_
- `SSH | Deploy SSH keys from vault` _(role: skogai-ssh)_
- `SSH | Ensure .ssh directory exists` _(role: skogai-ssh)_
- `SSH | Generate SSH key pair` _(role: skogai-ssh)_
- `SSH | Manage authorized_keys` _(role: skogai-ssh)_
- `SSH | Manage known hosts` _(role: skogai-ssh)_
- `Starship | MacOSX | Install Starship` _(role: starship)_
- `Starship | {{ ansible_distribution }} | Install Starship` _(role: starship)_
- `Starship | {{ ansible_distribution }} | Install Starship` _(role: starship)_
- `System | Install win32yank.exe` _(role: system)_
- `System | MacOSX | Enable Passwordless Sudo` _(role: system)_
- `System | MacOSX | Install Homebrew Packages` _(role: system)_
- `System | MacOSX | Update Homebrew` _(role: system)_
- `System | Set hosts` _(role: system)_
- `System | {{ ansible_distribution }} | Install` _(role: system)_
- `System | {{ ansible_distribution }} | Install` _(role: system)_
- `System | {{ ansible_distribution }} | Update APT Repos and Upgrade APT Packages` _(role: system)_
- `System | {{ ansible_distribution }} | Update pacman` _(role: system)_
- `TLDR | MacOSX | Install TLDR` _(role: tldr)_
- `TMUX | MacOSX | Install tmux` _(role: tmux)_
- `Tldr | Download Latest Version JSON` _(role: tldr)_
- `Tldr | Getting version information` _(role: tldr)_
- `Tldr | Install` _(role: tldr)_
- `Tldr | Registering Tldr Latest Release` _(role: tldr)_
- `Tldr | Registering Tldr Latest Version` _(role: tldr)_
- `Tldr | Show current_tldr_version debug` _(role: tldr)_
- `Tldr | Show tldr_latest_release debug` _(role: tldr)_
- `Tmux | Checking for Distribution Config: {{ ansible_distribution }}` _(role: tmux)_
- `Tmux | Configure tmux` _(role: tmux)_
- `Tmux | Install TPM` _(role: tmux)_
- `Tmux | Run Tasks: {{ ansible_distribution }}` _(role: tmux)_
- `Tmux | {{ ansible_distribution }} | Install tmux` _(role: tmux)_
- `Tmux | {{ ansible_distribution }} | Install tmux` _(role: tmux)_
- `WARP | MacOSX | Install warp` _(role: warp)_
- `Warp | Add APT Key` _(role: warp)_
- `Warp | Add APT Repository` _(role: warp)_
- `Warp | Checking for Distribution Config: {{ ansible_distribution }}` _(role: warp)_
- `Warp | Install Warp` _(role: warp)_
- `Warp | Run Tasks: {{ ansible_distribution }}` _(role: warp)_
- `ZSH | Calculate os config src` _(role: zsh)_
- `ZSH | Copy .zshrc` _(role: zsh)_
- `ZSH | Copy custom zsh config for os: {{ zsh_os_config.stat.path | basename }}` _(role: zsh)_
- `ZSH | Copy custom zsh config` _(role: zsh)_
- `ZSH | Debug home directory exists` _(role: zsh)_
- `ZSH | Debug ohmyzsh_is_installed` _(role: zsh)_
- `ZSH | Detect oh-my-zsh` _(role: zsh)_
- `ZSH | Install Custom Plugins` _(role: zsh)_
- `ZSH | Install oh-my-zsh` _(role: zsh)_
- `ZSH | Install zsh` _(role: zsh)_
- `ZSH | Register oh-my-zsh state` _(role: zsh)_
- `ZSH | {{ ansible_distribution }} | Identify distribution config` _(role: zsh)_
- `ZSH | {{ ansible_os_family }} | Identify os family config` _(role: zsh)_
- `Zoxide | Checking for Distribution Config: {{ ansible_distribution }}` _(role: zoxide)_
- `Zoxide | MacOSX | Install Zoxide` _(role: zoxide)_
- `Zoxide | Run Tasks: {{ ansible_distribution }}` _(role: zoxide)_
- `Zoxide | {{ ansible_distribution }} | Install Zoxide` _(role: zoxide)_
- `Zoxide | {{ ansible_distribution }} | Install Zoxide` _(role: zoxide)_
- `Zsh | MacOSX | Install` _(role: zsh)_
- `Zsh | Set default terminal` _(role: zsh)_
- `Zsh | Set default terminal` _(role: zsh)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: bat)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: brave)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: btop)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: fonts)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: fzf)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: gh)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: git)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: go)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: lazygit)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: lsd)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: lua)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: neovim)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: npm)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: python)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: rust)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: starship)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: system)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: tldr)_
- `{{ role_name }} | Checking for Distribution Config: {{ ansible_distribution }}` _(role: zsh)_
- `{{ role_name }} | Copy custom starship config` _(role: starship)_
- `{{ role_name }} | Ensure .config directory exists` _(role: starship)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: bat)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: brave)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: btop)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: fonts)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: fzf)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: gh)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: git)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: go)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: lazygit)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: lsd)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: lua)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: neovim)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: npm)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: python)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: rust)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: starship)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: system)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: tldr)_
- `{{ role_name }} | Run Tasks: {{ ansible_distribution }}` _(role: zsh)_
- `Add SSH authorized keys` _(role: 02-users)_
- `Add bin path to shell profiles` _(role: 06-skogcli)_
- `Apply stow packages` _(role: 03-dotfiles)_
- `Build and install AUR helper` _(role: 04-aur-user)_
- `Build stow command arguments` _(role: 03-dotfiles)_
- `Check AUR helper remote origin` _(role: 04-aur-user)_
- `Check currently installed tools` _(role: 09-uv-tools)_
- `Check if .ssh exists` _(role: 00-secrets)_
- `Check if AUR helper is already installed` _(role: 04-aur-user)_
- `Check if Claude Code is installed` _(role: 03-dotfiles)_
- `Check if NVM is already installed` _(role: 05-nvm)_
- `Check if argc is already installed` _(role: 07-argc)_
- `Check if uv is already installed` _(role: 09-uv-tools)_
- `Clone AUR helper repository` _(role: 04-aur-user)_
- `Clone SkogCLI repository` _(role: 06-skogcli)_
- `Clone dotfiles repository` _(role: 03-dotfiles)_
- `Clone secrets repo` _(role: 00-secrets)_
- `Configure pacman parallel downloads` _(role: 01-base)_
- `Configure passwordless sudo for AUR user` _(role: 04-aur-user)_
- `Configure sudo for wheel group` _(role: 02-users)_
- `Copy SSH keys if they exist` _(role: 00-secrets)_
- `Create AUR build user` _(role: 04-aur-user)_
- `Create additional users` _(role: 02-users)_
- `Create build directory for AUR packages` _(role: 04-aur-user)_
- `Create gptme configuration file` _(role: 10-gptme)_
- `Create manual symlinks` _(role: 03-dotfiles)_
- `Deploy .bashrc template for users (bash shell config - Issue #57)` _(role: 03-dotfiles)_
- `Deploy i3 config from template (content varies by wm_type)` _(role: 03-dotfiles)_
- `Deploy templated zsh configs for users` _(role: 03-dotfiles)_
- `Download NVM installer` _(role: 05-nvm)_
- `Enable Ollama service` _(role: 08-graphics)_
- `Enable color in pacman` _(role: 01-base)_
- `Enable sshd service` _(role: 01-base)_
- `Ensure .claude directory exists` _(role: 03-dotfiles)_
- `Ensure .config directories exist` _(role: 03-dotfiles)_
- `Ensure .secrets directory exists` _(role: 00-secrets)_
- `Ensure .ssh directory exists for primary user` _(role: 02-users)_
- `Ensure Claude skills directory exists` _(role: 03-dotfiles)_
- `Ensure NVM is added to PATH` _(role: nvm)_
- `Ensure SSH directory exists` _(role: 00-secrets)_
- `Ensure bin directory exists` _(role: 06-skogcli)_
- `Ensure btop config directory exists` _(role: 03-dotfiles)_
- `Ensure completions directory exists` _(role: 07-argc)_
- `Ensure gptme config directory exists` _(role: 10-gptme)_
- `Ensure locale.gen is configured` _(role: 00-locale)_
- `Ensure picom config directory exists` _(role: 03-dotfiles)_
- `Ensure pipewire config directory exists` _(role: 03-dotfiles)_
- `Ensure primary user exists` _(role: 02-users)_
- `Ensure rclone config directory exists` _(role: 03-dotfiles)_
- `Ensure secrets directory has correct permissions` _(role: 00-secrets)_
- `Ensure sway config.d exists` _(role: 03-dotfiles)_
- `Ensure systemd user directory exists` _(role: 03-dotfiles)_
- `Ensure zsh completions directory exists` _(role: 03-dotfiles)_
- `Fail if uv not installed and install method is skip` _(role: 09-uv-tools)_
- `Generate shell completions` _(role: 07-argc)_
- `Go-Lang | Install GoLang Packages` _(role: go)_
- `Install AMD drivers` _(role: 08-graphics)_
- `Install CUDA toolkit` _(role: 08-graphics)_
- `Install Claude Code` _(role: 03-dotfiles)_
- `Install GitHub CLI tool` _(role: gh)_
- `Install Intel drivers` _(role: 08-graphics)_
- `Install NVIDIA drivers` _(role: 08-graphics)_
- `Install NVM` _(role: 05-nvm)_
- `Install Ollama via pacman` _(role: 08-graphics)_
- `Install Ollama via script` _(role: 08-graphics)_
- `Install Packages` _(role: go)_
- `Install Python CLI tools via uv` _(role: 09-uv-tools)_
- `Install Python CLI tools via uv` _(role: 09-uv-tools)_
- `Install Python via uv` _(role: 09-uv-tools)_
- `Install additional Node.js versions` _(role: 05-nvm)_
- `Install and upgrade tools` _(role: 09-uv-tools)_
- `Install argc from binary release` _(role: 07-argc)_
- `Install argc via cargo` _(role: 07-argc)_
- `Install base packages` _(role: 01-base)_
- `Install default Node.js version` _(role: 05-nvm)_
- `Install dependencies` _(role: 06-skogcli)_
- `Install dependencies for AUR building` _(role: 04-aur-user)_
- `Install global npm packages` _(role: 05-nvm)_
- `Install gptme via pip` _(role: 10-gptme)_
- `Install gptme via pipx` _(role: 10-gptme)_
- `Install gptme via uv` _(role: 10-gptme)_
- `Install nvm` _(role: nvm)_
- `Install shell package if needed` _(role: 02-users)_
- `Install stow if needed` _(role: 03-dotfiles)_
- `Install utility packages` _(role: 01-base)_
- `Install uv from system package manager` _(role: 09-uv-tools)_
- `Install uv via official installer script` _(role: 09-uv-tools)_
- `Lua | Gather installed lua rocks` _(role: lua)_
- `Lua | Install Lua` _(role: lua)_
- `Lua | Update APT cache` _(role: lua)_
- `NVM | Show nvm_latest_release debug` _(role: nvm)_
- `Pull Ollama models` _(role: 08-graphics)_
- `Remove NVM installer script` _(role: 05-nvm)_
- `Remove existing aichat agent directories if they exist` _(role: 03-dotfiles)_
- `Remove unwanted Python CLI tools` _(role: 09-uv-tools)_
- `Remove unwanted tools` _(role: 09-uv-tools)_
- `Rust | Install packages` _(role: rust)_
- `Set AUR helper repository URL` _(role: 04-aur-user)_
- `Set SSH key permissions` _(role: 00-secrets)_
- `Set default Node.js version` _(role: 05-nvm)_
- `Set hostname` _(role: 01-base)_
- `Set system locale` _(role: 00-locale)_
- `Set timezone` _(role: 01-base)_
- `Symlink .dircolors for users (custom ls colors - Issue #54)` _(role: 03-dotfiles)_
- `Symlink .editorconfig for users (cross-editor consistency - Issue #53)` _(role: 03-dotfiles)_
- `Symlink .inputrc for users (readline config - Issue #52)` _(role: 03-dotfiles)_
- `Symlink .profile for users (login shell environment - Issue #56)` _(role: 03-dotfiles)_
- `Symlink Claude CLAUDE.md for users` _(role: 03-dotfiles)_
- `Symlink Claude settings.json for users` _(role: 03-dotfiles)_
- `Symlink Zed config files for users` _(role: 03-dotfiles)_
- `Symlink aichat agent directories for users` _(role: 03-dotfiles)_
- `Symlink aichat config for users` _(role: 03-dotfiles)_
- `Symlink btop config for users` _(role: 03-dotfiles)_
- `Symlink byobu configs for users` _(role: 03-dotfiles)_
- `Symlink fish config for users` _(role: 03-dotfiles)_
- `Symlink fish_plugins for users` _(role: 03-dotfiles)_
- `Symlink gh config files for users` _(role: 03-dotfiles)_
- `Symlink gh config files for users` _(role: 03-dotfiles)_
- `Symlink i3 backup config for users` _(role: 03-dotfiles)_
- `Symlink i3 scripts for users` _(role: 03-dotfiles)_
- `Symlink i3 wallpaper for users` _(role: 03-dotfiles)_
- `Symlink individual Claude skills for users` _(role: 03-dotfiles)_
- `Symlink kitty config for users` _(role: 03-dotfiles)_
- `Symlink mods config for users` _(role: 03-dotfiles)_
- `Symlink picom config for users` _(role: 03-dotfiles)_
- `Symlink pipewire config for users` _(role: 03-dotfiles)_
- `Symlink rclone config for users` _(role: 03-dotfiles)_
- `Symlink sway backup configs for users` _(role: 03-dotfiles)_
- `Symlink sway config.d files for users` _(role: 03-dotfiles)_
- `Symlink sway configs for users` _(role: 03-dotfiles)_
- `Symlink systemd user services` _(role: 03-dotfiles)_
- `Symlink xinitrc for users` _(role: 03-dotfiles)_
- `Symlink xinitrc to home directory for users` _(role: 03-dotfiles)_
- `Symlink zsh completions for users` _(role: 03-dotfiles)_
- `System | Detecting win32yank` _(role: system)_
- `Update package cache` _(role: 01-base)_
- `Upgrade all packages` _(role: 01-base)_
- `Verify installed tools are accessible` _(role: 09-uv-tools)_
- `Verify nologin shell exists (security check)` _(role: 04-aur-user)_
- `Verify tool installation` _(role: 09-uv-tools)_
