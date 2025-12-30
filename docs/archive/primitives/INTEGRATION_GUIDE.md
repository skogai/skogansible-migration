# Ansible Dotfiles Integration Guide

This guide breaks down the atomic components of this repository for merging into your existing Ansible setup.

---

## 📁 Repository Structure Overview

```
dotfile-ansible/
├── roles/              # Custom roles (4 roles)
│   ├── bash/          # Comprehensive bash configuration
│   ├── nvim/          # Neovim installation
│   ├── ssh_vault/     # SSH key encryption/backup
│   └── system/        # System package management
├── roles-import/      # Imported external roles (24 roles)
├── vars/              # Variable definitions
├── requirements/      # Ansible dependencies
├── main.yml          # Main playbook
├── playbook.yml      # Alternative playbook
├── ansible.cfg       # Ansible configuration
└── inventory         # Inventory file
```

---

## 🎯 Atomic Components

### 1. **BASH ROLE** (Most Complex)

**Location:** `roles/bash/`

**Purpose:** Complete bash environment setup with oh-my-bash and extensive custom utilities

**Key Files:**

- `tasks/main.yml` - Main installation tasks
- `handlers/main.yml` - Cleanup handlers
- `files/.bashrc` - Bash configuration
- `files/.profile` - Profile configuration
- `files/bash/` - 17 utility script files:
  - `bat_functions.sh` - Bat utility functions
  - `dotfiles_completions.sh` - Dotfile command completions
  - `git_aliases.sh` - Git aliases
  - `git_completions.sh` - Git completions
  - `git_functions.sh` - Git helper functions
  - `gpt_functions.sh` - GPT/AI helper functions
  - `lsd_aliases.sh` - LSD (ls replacement) aliases
  - `misc_aliases.sh` - Miscellaneous aliases
  - `neovim_aliases.sh` - Neovim aliases
  - `neovim_functions.sh` - Neovim helper functions
  - `paths_functions.sh` - Path management functions
  - `paths_vars.sh` - Path variables
  - `pkg_functions.sh` - Package management functions
  - `speedtest_functions.sh` - Network speed test utilities
  - `vars.sh` - General variables
- `files/themes/axin/` - Custom bash theme

**What It Does:**

1. Installs oh-my-bash framework
2. Copies custom .bashrc and .profile
3. Deploys 17 utility script modules to `~/.config/bash/`
4. Installs custom "axin" theme
5. Supports OS-specific configurations (Ubuntu, Arch, MacOS)

**Dependencies:**

- Oh-my-bash (downloaded during installation)
- No Ansible Galaxy dependencies

**Merge Strategy:**

- **Standalone Role**: Copy entire `roles/bash/` directory
- **Cherry-pick Scripts**: Copy individual scripts from `files/bash/` to your dotfiles
- **Theme Only**: Copy just `files/themes/` if you want the theme

---

### 2. **NVIM ROLE** (Simple)

**Location:** `roles/nvim/`

**Purpose:** Installs Neovim nightly build on Arch Linux

**Key Files:**

- `tasks/main.yml` - Single task file

**What It Does:**

- Installs `neovim-git` package using AUR helper

**Dependencies:**

- Requires: `kewlfft.aur` collection (Arch Linux only)

**Merge Strategy:**

- **Direct Copy**: Copy entire role if you're on Arch
- **Adapt**: Replace with your distro's package manager
- **Skip**: If you already have neovim installation role

---

### 3. **SSH_VAULT ROLE** (Security Focused)

**Location:** `roles/ssh_vault/`

**Purpose:** Backup, encrypt, and manage SSH keys with Ansible Vault

**Key Files:**

- `tasks/main.yml` - Main orchestration
- `decrypt_ssh_keys.yml` - Decryption tasks
- `encrypt_and_upload_ssh_keys.yml` - Encryption tasks
- `tests/test_decryption.yml` - Test suite
- `tests/test_encryption.yml` - Test suite

**What It Does:**

1. Creates backup of `~/.ssh/` directory
2. Archives backup to `.tar.gz`
3. Encrypts archive with ansible-vault
4. Manages vault password file
5. Deploys SSH keys from vaulted variables

**Dependencies:**

- Ansible vault password file at `/home/skogix/.ssh/ansible-vault`
- Variables: `ssh_private_key`, `ssh_public_key` (from `vars/ssh_keys.yml`)

**⚠️ WARNING:**

- Contains hardcoded username: `skogix`
- **MUST UPDATE** paths before using in your setup

**Merge Strategy:**

- **Review & Adapt**: Update all hardcoded paths to use `{{ ansible_user_dir }}`
- **Security Review**: Ensure vault password management fits your workflow
- **Skip If Exists**: Only use if you don't have SSH key management

---

### 4. **SYSTEM ROLE** (Simple)

**Location:** `roles/system/`

**Purpose:** Basic system package management

**Key Files:**

- `tasks/main.yml` - Main tasks (Arch-specific currently)
- `tasks/Archlinux.yml` - Arch Linux tasks
- `tasks/Ubuntu.yml` - Ubuntu tasks
- `tasks/MacOSX.yml` - MacOS tasks

**What It Does:**

- Updates package manager (pacman)
- Installs `jq` package

**Dependencies:**

- Requires: `community.general` collection

**Merge Strategy:**

- **Extend**: Add to your existing system role
- **Replace**: Use as template for multi-OS support structure
- **Skip**: Very basic, likely redundant

---

## 📋 Variable Files

### **vars/main.yml**

**Purpose:** General dotfiles configuration

**Key Variables:**

```yaml
dotfiles_repo_url: "https://github.com/skogix/.dotfiles.git"
dotfiles_install_path: "{{ ansible_user_dir }}/.dotfiles"
git_user_name: "Skogix"
git_user_email: "emil.skogsund@gmail.com"
bash_prompt: "[\\u@\\h \\W]\\$ "
vim_theme: "dracula"
default_shell: "/bin/bash"
```

**Merge Strategy:**

- **Extract Relevant**: Copy only variables you need
- **Rename**: Integrate into your existing var structure
- **⚠️ Update**: Change personal information

---

### **vars/groups.yml**

**Purpose:** Role selection configuration

**Key Variables:**

```yaml
default_roles:
  - bash      # Only bash is enabled
  # 24+ other roles commented out
```

**Merge Strategy:**

- **Reference**: Use as template for role selection pattern
- **Copy Pattern**: Implement similar toggle system in your setup

---

### **vars/ssh_keys.yml**

**Purpose:** Encrypted SSH key storage

**⚠️ SENSITIVE FILE** - Contains vaulted SSH keys

**Merge Strategy:**

- **DO NOT COPY**: This is user-specific encrypted data
- **Reference**: Use as template for your own vault structure

---

## 📦 External Dependencies

### **requirements/common.yml**

```yaml
collections:
  - community.general
  - kubernetes.core
```

### **requirements/arch.yml**

```yaml
collections:
  - kewlfft.aur
```

**Merge Strategy:**

- Add to your `requirements.yml`
- Install with: `ansible-galaxy collection install -r requirements/common.yml`

---

## 🗂️ Imported Roles (roles-import/)

**24 Imported Roles Available:**

- bash, bat, brave, btop, fonts, fzf, gh, git, go, lazygit, lsd, lua
- neovim, npm, nvm, python, rust, starship, system, tldr, tmux
- warp, zoxide, zsh

**Current Status:** All commented out in `vars/groups.yml`

**Merge Strategy:**

- **Evaluate Each**: Check if you need these
- **Source**: These might be from Ansible Galaxy or custom
- **Import**: Copy specific role directories as needed

---

## 🔧 Configuration Files

### **ansible.cfg**

Key settings:

- `roles_path = ./roles`
- `stdout_callback = yaml`
- `become = True`
- SSH multiplexing configured

**Merge Strategy:**

- **Compare**: Review against your ansible.cfg
- **Cherry-pick**: Take useful settings

---

### **inventory**

Simple localhost inventory

**Merge Strategy:**

- **Skip**: Use your existing inventory

---

## 🚀 Integration Steps

### Option 1: Full Integration

1. Copy `roles/bash/` to your roles directory
2. Add Ansible collections to your requirements
3. Copy relevant variables to your vars
4. Add bash role to your playbook
5. Run playbook

### Option 2: Selective Integration (Recommended)

1. **Bash Scripts Only:**

   ```bash
   cp -r roles/bash/files/bash/* your-repo/files/bash/
   ```

   - Integrate individual scripts into your dotfiles

2. **Custom Theme:**

   ```bash
   cp -r roles/bash/files/themes/axin your-repo/themes/
   ```

3. **Variable Patterns:**
   - Copy role selection pattern from `vars/groups.yml`
   - Adapt to your variable structure

### Option 3: Cherry-Pick Components

Individual scripts can be used standalone:

- Copy specific `roles/bash/files/bash/*.sh` files
- Source them in your `.bashrc`
- No Ansible needed for this approach

---

## ⚠️ Important Notes Before Merging

1. **Hardcoded Paths:**
   - `ssh_vault` role has hardcoded `/home/skogix/` paths
   - Must replace with `{{ ansible_user_dir }}` or your username

2. **Personal Information:**
   - Git user name/email in `vars/main.yml`
   - SSH keys in `vars/ssh_keys.yml`
   - Update all personal info

3. **OS Compatibility:**
   - System role is Arch-focused
   - Bash role supports multi-OS but may need testing
   - Nvim role is Arch-only (AUR)

4. **Dependencies:**
   - Install Ansible collections before running
   - Some roles require specific collections

5. **Testing:**
   - Test in safe environment first
   - Bash role will modify `.bashrc` and `.profile`
   - SSH vault role handles sensitive data

---

## 📝 Quick Reference: What to Take

| Component | Priority | Effort | Value |
|-----------|----------|--------|-------|
| **Bash utility scripts** | HIGH | Low | High - 17 useful utilities |
| **Bash role structure** | MEDIUM | Medium | Good Ansible pattern |
| **Axin theme** | LOW | Low | Nice visual enhancement |
| **Role selection pattern** | MEDIUM | Low | Useful organization pattern |
| **SSH vault approach** | MEDIUM | High | Good if you need SSH key mgmt |
| **Nvim role** | LOW | Low | Too simple, likely redundant |
| **System role** | LOW | Low | Too basic |
| **ansible.cfg settings** | LOW | Low | Some useful configs |

---

## 🎯 Recommended Merge Strategy

**For Most Users:**

1. Copy the 17 bash utility scripts individually
2. Source them in your `.bashrc` manually
3. Test each script independently
4. Skip the full Ansible role unless you want oh-my-bash

**For Ansible Power Users:**

1. Copy entire `roles/bash/` directory
2. Update requirements with needed collections
3. Review and test role tasks
4. Integrate into your playbook with proper variables

**For Cherry-Pickers:**

1. Identify specific utilities you need (e.g., git_functions.sh)
2. Copy just those files
3. Source in your shell config
4. No Ansible integration needed

---

## 🔍 Next Steps

1. Review this guide
2. Decide which components you need
3. Test in isolated environment
4. Update personal information
5. Integrate into your setup
6. Commit changes to your repo

**Questions to Consider:**

- Do you already have bash configuration management?
- Do you need all 17 utility scripts or just specific ones?
- Are you using oh-my-bash or different framework?
- Do you need Ansible automation or manual dotfile management?
