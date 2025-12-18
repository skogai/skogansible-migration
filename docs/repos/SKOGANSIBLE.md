# SkogAnsible Tasks Inventory

This document provides a complete inventory of all Ansible tasks defined in the skogansible playbook, organized by role and task file.

## Playbook Entry Point

### playbook.yml

- Configure Arch Linux system

---

## Role: SSH

SSH configuration and key management tasks.

### roles/ssh/tasks/main.yml

- SSH | Deploy entire .ssh directory from backup
- SSH | Ensure .ssh directory exists
- SSH | Deploy SSH keys from vault
- SSH | Generate SSH key pair
- SSH | Ensure socket directory exists for ControlPath
- SSH | Deploy SSH config
- SSH | Manage known hosts
- SSH | Manage authorized_keys
- SSH | Backup SSH directory

### roles/ssh/tasks/deploy_ssh_directory.yml

- SSH | Deploy entire .ssh directory from files

### SSH Examples

#### roles/ssh/examples/01-basic-setup.yml

- Basic SSH setup

#### roles/ssh/examples/02-generate-key.yml

- Generate SSH key

#### roles/ssh/examples/03-deploy-from-vault.yml

- Deploy SSH keys from vault

#### roles/ssh/examples/04-deploy-config.yml

- Deploy SSH configuration

#### roles/ssh/examples/05-manage-known-hosts.yml

- Manage SSH known hosts

#### roles/ssh/examples/06-complete-setup.yml

- Complete SSH environment setup

---

## Role: Chezmoi

Chezmoi dotfile management tasks.

### roles/chezmoi/tasks/main.yml

- Include install tasks
- Include init tasks
- Include configure tasks
- Include apply tasks

### roles/chezmoi/tasks/install.yml

- Check if chezmoi is installed
- Ensure chezmoi is installed
- Verify chezmoi installation
- Display chezmoi version

### roles/chezmoi/tasks/init.yml

- Check if chezmoi source directory exists
- Display chezmoi source directory status
- Warn if chezmoi not initialized
- Check if .chezmoidata.yaml exists
- Display chezmoidata status

### roles/chezmoi/tasks/apply.yml

- Check what chezmoi would change (dry-run)
- Display pending chezmoi changes
- Apply chezmoi configuration
- Display chezmoi apply result
- Verify chezmoi state
- Display chezmoi status

### roles/chezmoi/tasks/configure.yml

- Ensure chezmoi source directory exists
- Template .chezmoidata.yaml configuration
- Display configuration status
- Verify chezmoi data
- Display chezmoi machine profile

### roles/chezmoi/handlers/main.yml

- Apply chezmoi

---

## Role: Packages

Package management tasks for Arch Linux (pacman and AUR).

### roles/packages/tasks/main.yml

- Setup AUR builder user
- Install yay AUR helper
- Update pacman package database
- Upgrade all packages
- Install packages from list
- Install AUR packages

### roles/packages/tasks/aur_user.yml

- Create the aur_builder user
- Allow the aur_builder user to run sudo pacman without a password
- Allow wheel group users to become aur_builder without a password

### roles/packages/tasks/aur_helper.yml

- Ensure base-devel and git are installed (required for building AUR packages)
- Check if yay is already installed
- Clone yay repository from AUR
- Build and install yay
- Clean up yay build directory

### roles/packages/tasks/aur_packages.yml

- Install AUR packages using yay

---

## Role: Git

Git configuration, installation, and repository management tasks.

### roles/git/tasks/main.yml

- Git | Install git package
- Git | Configure global git settings
- Git | Configure git aliases
- Git | Configure credential helper
- Git | Deploy global .gitignore
- Git | Install and configure Git LFS
- Git | Clone repositories
- Git | Deploy git hooks
- Git | Configure commit and tag signing
- Git | Configure repository-specific settings
- Git | Run git maintenance

### roles/git/tasks/install.yml

- Git | Check if git is installed
- Git | Install git package
- Git | Verify git installation
- Git | Display git version

### roles/git/tasks/configure_global.yml

- Git | Deploy .gitconfig from template
- Git | Configure user name
- Git | Configure user email
- Git | Configure default editor
- Git | Configure default branch name
- Git | Configure core settings
- Git | Configure color UI
- Git | Configure push settings
- Git | Configure pull settings
- Git | Configure merge settings
- Git | Configure diff settings
- Git | Configure rebase settings
- Git | Configure fetch settings
- Git | Configure rerere settings
- Git | Configure submodule recursion
- Git | Configure pack optimization

### roles/git/tasks/configure_aliases.yml

- Git | Configure git aliases

### roles/git/tasks/configure_credentials.yml

- Git | Configure credential helper
- Git | Configure credential cache timeout
- Git | Configure credential store file
- Git | Warning about credential store security

### roles/git/tasks/configure_signing.yml

- Git | Configure GPG commit signing
- Git | Configure GPG tag signing
- Git | Configure SSH commit signing
- Git | Configure SSH tag signing

### roles/git/tasks/clone_repositories.yml

- Git | Ensure parent directories exist for repositories
- Git | Clone or update repositories
- Git | Set ownership on cloned repositories

### roles/git/tasks/deploy_gitignore.yml

- Git | Deploy global .gitignore from template
- Git | Configure global gitignore in git config

### roles/git/tasks/install_lfs.yml

- Git LFS | Install git-lfs package
- Git LFS | Initialize git-lfs for user
- Git LFS | Display git-lfs version
- Git LFS | Show version info

### roles/git/tasks/deploy_hooks.yml

- Git | Ensure git template directory exists
- Git | Configure git template directory
- Git | Deploy git hook templates
- Git | Info about applying hooks to existing repos

### roles/git/tasks/configure_repo_specific.yml

- Git | Configure repository-specific settings
- Git | Display configured repository settings

### roles/git/tasks/maintenance.yml

- Git | Run git maintenance on repositories
- Git | Display maintenance results

### roles/git/handlers/main.yml

- reload git config
- git garbage collection
- refresh git credential cache

---

## Summary Statistics

- **Total Roles**: 4 (SSH, Chezmoi, Packages, Git)
- **Total Task Files**: 26
- **Total Named Tasks**: 147
- **Handler Tasks**: 4

### Tasks by Role

- SSH: 16 tasks (+ 6 example playbooks)
- Chezmoi: 18 tasks
- Packages: 9 tasks
- Git: 98 tasks

---

## Generated: 2025-12-18

This inventory was automatically generated from YAML task definitions across the skogansible directory structure.
