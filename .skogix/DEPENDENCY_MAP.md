# Dependency Map & Quick Reference

Visual guide to component dependencies and integration paths.

---

## 🗺️ Component Dependency Graph

```
┌─────────────────────────────────────────────────────────────┐
│                    EXTERNAL DEPENDENCIES                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Ansible Collections:                                        │
│    ├─ community.general (required for system role)          │
│    ├─ kewlfft.aur (required for nvim role, Arch only)       │
│    └─ kubernetes.core (imported, not actively used)         │
│                                                               │
│  System Packages (Optional):                                 │
│    ├─ bat (for bat_functions.sh)                            │
│    ├─ lsd (for lsd_aliases.sh)                              │
│    ├─ speedtest-cli (for speedtest_functions.sh)            │
│    └─ bash-completion (for completion scripts)              │
│                                                               │
│  External Downloads:                                         │
│    └─ oh-my-bash (downloaded during bash role execution)    │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                                  │
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────┐
│                        ANSIBLE LAYER                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ansible.cfg                                                 │
│    └─ roles_path = ./roles                                   │
│    └─ Configures Ansible behavior                           │
│                                                               │
│  inventory                                                   │
│    └─ Defines localhost target                              │
│                                                               │
│  main.yml (Main Playbook)                                    │
│    ├─ Imports: vars/main.yml                                │
│    ├─ Imports: vars/groups.yml                              │
│    ├─ Imports: vars/ssh_keys.yml                            │
│    └─ Executes selected roles dynamically                   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                                  │
                                  │
                ┌─────────────────┴─────────────────┬──────────┐
                │                                   │          │
                ▼                                   ▼          ▼
┌──────────────────────────┐    ┌──────────────────────────┐  │
│      VARIABLES LAYER     │    │     ROLES LAYER          │  │
├──────────────────────────┤    ├──────────────────────────┤  │
│                          │    │                          │  │
│  vars/main.yml           │───▶│  roles/bash/             │  │
│    ├─ dotfiles_repo_url  │    │    ├─ tasks/main.yml    │  │
│    ├─ git_user_*         │    │    ├─ handlers/main.yml │  │
│    └─ General settings   │    │    ├─ files/.bashrc     │  │
│                          │    │    ├─ files/.profile    │  │
│  vars/groups.yml         │    │    └─ files/bash/*.sh   │  │
│    └─ default_roles []   │    │         (17 scripts)    │  │
│                          │    │                          │  │
│  vars/ssh_keys.yml       │    └──────────────────────────┘  │
│    ├─ ssh_private_key    │                 │                │
│    └─ ssh_public_key     │─────┐           │                │
│         (VAULTED!)       │     │           │                │
│                          │     │           │                │
└──────────────────────────┘     │           │                │
                                 │           │                │
                                 ▼           ▼                ▼
                    ┌──────────────────────────────────────────────┐
                    │         INDEPENDENT ROLES                    │
                    ├──────────────────────────────────────────────┤
                    │                                              │
                    │  roles/ssh_vault/      roles/system/        │
                    │    ├─ Depends on:       ├─ tasks/main.yml  │
                    │    │  ssh_keys.yml       └─ Needs:         │
                    │    ├─ Encrypts SSH           community.     │
                    │    │  keys                   general        │
                    │    └─ ⚠️  Hardcoded                          │
                    │        paths!                               │
                    │                                              │
                    │  roles/nvim/                                │
                    │    ├─ tasks/main.yml                        │
                    │    └─ Needs: kewlfft.aur (Arch only)        │
                    │                                              │
                    └──────────────────────────────────────────────┘
                                         │
                                         │
                                         ▼
                    ┌──────────────────────────────────────────────┐
                    │            TARGET SYSTEM                     │
                    ├──────────────────────────────────────────────┤
                    │                                              │
                    │  ~/.bashrc                                   │
                    │  ~/.profile                                  │
                    │  ~/.oh-my-bash/                              │
                    │  ~/.config/bash/*.sh                         │
                    │  ~/.ssh/                                     │
                    │  System packages (neovim, jq, etc.)          │
                    │                                              │
                    └──────────────────────────────────────────────┘
```

---

## 🔗 Role-Specific Dependency Trees

### BASH Role
```
bash role
│
├─ Runtime Dependencies
│   └─ oh-my-bash (auto-installed via script)
│
├─ Optional Package Dependencies
│   ├─ bat (for bat_functions.sh)
│   ├─ lsd (for lsd_aliases.sh)
│   ├─ neovim (for neovim scripts)
│   ├─ git (for git scripts)
│   ├─ speedtest-cli (for speedtest_functions.sh)
│   └─ bash-completion (for completions)
│
├─ File Dependencies
│   ├─ files/.bashrc
│   ├─ files/.profile
│   ├─ files/bash/*.sh (17 files)
│   └─ files/themes/axin/axin.theme.sh
│
├─ Variable Dependencies
│   ├─ ansible_user_dir (Ansible built-in)
│   ├─ role_path (Ansible built-in)
│   ├─ ansible_distribution (Ansible fact)
│   └─ ansible_os_family (Ansible fact)
│
└─ Ansible Dependencies
    └─ None (no collections required)
```

### NVIM Role
```
nvim role
│
├─ Runtime Dependencies
│   └─ AUR helper (yay, paru, etc.) - Arch Linux only
│
├─ Package Dependencies
│   └─ neovim-git (from AUR)
│
├─ Variable Dependencies
│   └─ None
│
└─ Ansible Dependencies
    └─ kewlfft.aur collection (Arch Linux only)
```

### SSH_VAULT Role
```
ssh_vault role
│
├─ Runtime Dependencies
│   ├─ ansible-vault (Ansible built-in)
│   └─ Vault password file (/home/skogix/.ssh/ansible-vault)
│       ⚠️  HARDCODED PATH - MUST UPDATE!
│
├─ Package Dependencies
│   └─ tar/gzip (system utilities)
│
├─ File Dependencies
│   └─ decrypt_ssh_keys.yml
│   └─ encrypt_and_upload_ssh_keys.yml
│
├─ Variable Dependencies (CRITICAL!)
│   ├─ ssh_private_key (from vars/ssh_keys.yml - VAULTED)
│   └─ ssh_public_key (from vars/ssh_keys.yml - VAULTED)
│
└─ Ansible Dependencies
    └─ None (uses Ansible built-ins)
```

### SYSTEM Role
```
system role
│
├─ Runtime Dependencies
│   └─ pacman (Arch Linux package manager)
│
├─ Package Dependencies
│   └─ jq
│
├─ Variable Dependencies
│   └─ None
│
└─ Ansible Dependencies
    └─ community.general collection
```

---

## 🎯 Integration Paths

### Path 1: Zero Ansible (Manual Script Integration)
```
Source Files                    Target Location
────────────────               ────────────────
roles/bash/files/bash/*.sh  →  ~/.config/bash/*.sh
roles/bash/files/.bashrc    →  Review and merge
roles/bash/files/.profile   →  Review and merge

Dependencies:
  ✅ None - just copy and source

Risk: ▮▯▯▯▯ (Very Low)
Effort: ▮▯▯▯▯ (5-10 minutes)
Value: ▮▮▮▮▮ (High - immediate utilities)
```

### Path 2: Bash Role Only (Ansible)
```
Source                          Target
───────                        ────────
roles/bash/             →      your-ansible/roles/bash/
requirements/common.yml →      Review (no collections needed)

Playbook Addition:
  - role: bash

Dependencies:
  ✅ oh-my-bash (auto-installed)
  ⚠️  Will overwrite .bashrc

Risk: ▮▮▮▯▯ (Medium - config overwrite)
Effort: ▮▮▯▯▯ (20-30 minutes)
Value: ▮▮▮▮▯ (High - full automation)
```

### Path 3: Multi-Role Integration
```
Source                          Target
───────                        ────────
roles/bash/             →      your-ansible/roles/bash/
roles/system/           →      your-ansible/roles/system/
roles/nvim/             →      your-ansible/roles/nvim/
vars/main.yml           →      Merge into your vars/
vars/groups.yml         →      Adapt pattern to your setup
requirements/*.yml      →      Merge with your requirements

Playbook Addition:
  - role: system
  - role: bash
  - role: nvim

Dependencies:
  ✅ community.general collection
  ✅ kewlfft.aur collection (Arch only)
  ⚠️  Update personal info in vars

Risk: ▮▮▮▮▯ (Medium-High)
Effort: ▮▮▮▯▯ (1-2 hours)
Value: ▮▮▮▮▯ (High - multiple roles)
```

### Path 4: Complete Merge (Including SSH Vault)
```
Source                          Target
───────                        ────────
ALL roles/              →      your-ansible/roles/
ALL vars/               →      your-ansible/vars/ (UPDATE PATHS!)
requirements/*.yml      →      your-ansible/requirements/
ansible.cfg             →      Review and merge settings

Playbook Addition:
  - role: system
  - role: bash
  - role: nvim
  - role: ssh_vault

Dependencies:
  ✅ All collections
  ✅ Vault password file setup
  ⚠️  CRITICAL: Update ssh_vault hardcoded paths!
  ⚠️  CRITICAL: Vault your SSH keys
  ⚠️  CRITICAL: Update personal information

Risk: ▮▮▮▮▮ (High - full system modification)
Effort: ▮▮▮▮▯ (2-4 hours)
Value: ▮▮▮▮▮ (Complete automation)
```

---

## 📋 Quick Reference Cards

### Card 1: Bash Scripts Only
```
╔═══════════════════════════════════════════════════════════╗
║              BASH SCRIPTS ONLY INTEGRATION                ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║ What You Get:                                             ║
║   • 17 utility scripts (git, neovim, pkg mgmt, etc.)     ║
║   • No automation - manual management                     ║
║                                                           ║
║ Commands:                                                 ║
║   cp -r roles/bash/files/bash ~/.config/                 ║
║   echo 'for f in ~/.config/bash/*.sh; do                 ║
║         source "$f"; done' >> ~/.bashrc                   ║
║                                                           ║
║ Dependencies: NONE                                        ║
║ Risk: NONE (doesn't touch existing config)               ║
║ Time: 5 minutes                                           ║
║                                                           ║
║ Perfect For:                                              ║
║   • Quick utility additions                               ║
║   • Testing individual scripts                            ║
║   • Non-Ansible users                                     ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

### Card 2: Full Bash Role
```
╔═══════════════════════════════════════════════════════════╗
║               FULL BASH ROLE INTEGRATION                  ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║ What You Get:                                             ║
║   • Automated oh-my-bash installation                     ║
║   • All 17 utility scripts                                ║
║   • Custom theme (axin)                                   ║
║   • Managed .bashrc and .profile                          ║
║                                                           ║
║ Commands:                                                 ║
║   cp -r roles/bash your-ansible/roles/                   ║
║   ansible-playbook your-playbook.yml --tags bash         ║
║                                                           ║
║ Dependencies:                                             ║
║   • Ansible installed                                     ║
║   • wget/curl (for oh-my-bash download)                  ║
║                                                           ║
║ ⚠️  WARNING: Overwrites .bashrc and .profile             ║
║    Backup first: cp ~/.bashrc ~/.bashrc.backup           ║
║                                                           ║
║ Risk: MEDIUM (config overwrite)                           ║
║ Time: 30 minutes                                          ║
║                                                           ║
║ Perfect For:                                              ║
║   • Full bash environment automation                      ║
║   • Multi-machine deployments                             ║
║   • Ansible users                                         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

### Card 3: Multi-Role Setup
```
╔═══════════════════════════════════════════════════════════╗
║             MULTI-ROLE INTEGRATION                        ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║ What You Get:                                             ║
║   • Bash environment (oh-my-bash + scripts)              ║
║   • Neovim nightly (Arch) or stable (others)             ║
║   • System packages (jq)                                  ║
║   • Optional: SSH key management                          ║
║                                                           ║
║ Commands:                                                 ║
║   ansible-galaxy collection install \                     ║
║     -r requirements/common.yml                            ║
║   cp -r roles/* your-ansible/roles/                      ║
║   # Update vars/main.yml with your info                  ║
║   ansible-playbook your-playbook.yml                     ║
║                                                           ║
║ Dependencies:                                             ║
║   • community.general collection                          ║
║   • kewlfft.aur (Arch only)                              ║
║   • Update personal info in vars/                        ║
║                                                           ║
║ ⚠️  WARNING: Full system modification                    ║
║    Test in VM first!                                      ║
║                                                           ║
║ Risk: MEDIUM-HIGH                                         ║
║ Time: 1-2 hours                                           ║
║                                                           ║
║ Perfect For:                                              ║
║   • Complete dotfiles automation                          ║
║   • Infrastructure as code                                ║
║   • Experienced Ansible users                             ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 🚨 Critical Warnings & Gotchas

### ⚠️ Hardcoded Paths (ssh_vault role)
```
Location: roles/ssh_vault/tasks/main.yml

Current:  /home/skogix/.ssh/ansible-vault
Must Be:  {{ ansible_user_dir }}/.ssh/ansible-vault

Current:  /home/skogix/.ssh_backup
Must Be:  {{ ansible_user_dir }}/.ssh_backup

⚠️  CRITICAL: Update before running or it will fail!
```

### ⚠️ Personal Information (vars/main.yml)
```
Update these before running:
  git_user_name: "Skogix"          → Your name
  git_user_email: "email@..."      → Your email
  dotfiles_repo_url: "..."         → Your repo
```

### ⚠️ Vaulted Variables (vars/ssh_keys.yml)
```
This file contains encrypted SSH keys!

DO NOT copy as-is to your repository!

Instead:
1. Create your own vars/ssh_keys.yml
2. Add your SSH key content
3. Encrypt: ansible-vault encrypt vars/ssh_keys.yml
```

### ⚠️ .bashrc Overwrite (bash role)
```
The bash role WILL overwrite:
  - ~/.bashrc
  - ~/.profile

Before running:
  cp ~/.bashrc ~/.bashrc.backup
  cp ~/.profile ~/.profile.backup

Or review roles/bash/files/.bashrc first and merge manually.
```

---

## 🧪 Testing Strategy

### Test Level 1: Scripts Only (Safe)
```bash
# Create test directory
mkdir -p ~/test-dotfiles/bash
cp roles/bash/files/bash/* ~/test-dotfiles/bash/

# Source single script
source ~/test-dotfiles/bash/git_functions.sh

# Test function
# (try a function from the script)

# If works, add to .bashrc
```

### Test Level 2: Role in Container (Medium)
```bash
# Use Docker
docker run -it --rm -v $(pwd):/ansible ubuntu:22.04 bash

# Inside container:
apt update && apt install -y ansible git
cd /ansible
ansible-playbook main.yml --tags bash

# Check result
cat ~/.bashrc
ls ~/.config/bash/
```

### Test Level 3: Full Integration in VM (Safe)
```bash
# Use Vagrant or VirtualBox
vagrant init ubuntu/jammy64
vagrant up
vagrant ssh

# Inside VM:
cd /vagrant
ansible-playbook main.yml

# Test all roles
# If satisfied, apply to real system
```

---

## 📊 Dependency Matrix Table

| Component | Ansible Collections | System Packages | Ansible Variables | File Dependencies |
|-----------|---------------------|-----------------|-------------------|-------------------|
| **bash role** | None | oh-my-bash (auto) | ansible_user_dir | 19 files (scripts/configs) |
| **nvim role** | kewlfft.aur | neovim-git | None | None |
| **ssh_vault** | None | tar, gzip | ssh_private_key, ssh_public_key | 2 task includes |
| **system** | community.general | jq | None | None |
| **vars/** | None | None | Various | None |

---

## 🎓 Learning Path (For New Ansible Users)

If you're new to Ansible, follow this progression:

**Week 1: Manual Integration**
- Copy bash scripts manually
- Learn what each script does
- Source them in .bashrc
- Get comfortable with the utilities

**Week 2: Single Role**
- Learn Ansible basics
- Run bash role in test environment
- Understand task flow
- Test on VM

**Week 3: Multi-Role**
- Add system and nvim roles
- Learn about collections
- Manage variables
- Deploy to test machine

**Week 4: Complete Setup**
- Add ssh_vault (if needed)
- Implement role selection pattern
- Deploy to production
- Document your setup

---

## 📞 Quick Decision Flowchart

```
START: Want to integrate this repository?
  │
  ├─ Do you use Ansible?
  │   │
  │   ├─ NO → Use "Path 1: Zero Ansible"
  │   │        Copy scripts manually
  │   │        [END: 5 minutes, Low risk]
  │   │
  │   └─ YES → Continue
  │             │
  │             ├─ Just want bash utilities?
  │             │   │
  │             │   └─ YES → Use "Path 2: Bash Role Only"
  │             │             [END: 30 min, Medium risk]
  │             │
  │             ├─ Want multiple roles?
  │             │   │
  │             │   └─ YES → Use "Path 3: Multi-Role"
  │             │             [END: 1-2 hrs, Medium-High risk]
  │             │
  │             └─ Need SSH key automation too?
  │                 │
  │                 └─ YES → Use "Path 4: Complete Merge"
  │                           ⚠️  Update hardcoded paths first!
  │                           [END: 2-4 hrs, High risk]
```

---

## 🎯 Success Criteria

After integration, you should have:

**✅ For Scripts Only:**
- [ ] All 17 scripts in ~/.config/bash/
- [ ] Scripts sourced in .bashrc
- [ ] Functions work when called

**✅ For Bash Role:**
- [ ] oh-my-bash installed
- [ ] Custom theme active
- [ ] All utilities available
- [ ] .bashrc and .profile updated

**✅ For Multi-Role:**
- [ ] All selected roles executed successfully
- [ ] Packages installed (neovim, jq, etc.)
- [ ] No Ansible errors
- [ ] System configured as expected

**✅ For Complete Merge:**
- [ ] All roles working
- [ ] SSH keys deployed (if using ssh_vault)
- [ ] All personal info updated
- [ ] No hardcoded paths remaining
- [ ] Vault properly configured

---

## 📚 Additional Resources

**Created Documentation:**
- `INTEGRATION_GUIDE.md` - High-level overview and planning
- `COMPONENT_BREAKDOWN.md` - Technical details and analysis
- `DEPENDENCY_MAP.md` - This file - visual dependencies

**External Resources:**
- Ansible Documentation: https://docs.ansible.com/
- Oh-My-Bash: https://github.com/ohmybash/oh-my-bash
- Ansible Vault: https://docs.ansible.com/ansible/latest/user_guide/vault.html

---

**Last Updated:** 2025-11-07
**Repository:** dotfile-ansible
**Purpose:** Integration planning for merging into existing Ansible setup
