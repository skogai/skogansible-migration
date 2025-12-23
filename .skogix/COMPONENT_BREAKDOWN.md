# Component Breakdown - Technical Details

This document provides detailed technical breakdowns of each atomic component for integration.

---

## 🔧 Role: BASH

### Task Flow (`roles/bash/tasks/main.yml`)

```yaml
Task Sequence:
1. Detect oh-my-bash installation (stat check)
2. Register installation state (set_fact)
3. Debug state
4. Conditional block (if not installed):
   a. Download install script
   b. Run install script
   c. Copy .bashrc
   d. Copy .profile
   e. Copy custom bash configs to ~/.config/
   f. Copy custom theme to ~/.oh-my-bash/custom/
   g. Copy OS-specific configs (conditional)
   h. Copy OS-family configs (conditional)
```

**Handlers:**
- `Bash | Cleanup oh-my-bash install script` - Removes temp install script

**Files Deployed:**
```
Target: ~/.config/bash/
├── bat_functions.sh          # Bat (cat replacement) helpers
├── dotfiles_completions.sh   # Custom completions
├── git_aliases.sh            # Git shortcuts
├── git_completions.sh        # Git tab completion
├── git_functions.sh          # Advanced git helpers
├── gpt_functions.sh          # AI/GPT integration
├── lsd_aliases.sh            # LSD (ls deluxe) aliases
├── misc_aliases.sh           # General aliases
├── neovim_aliases.sh         # Nvim shortcuts
├── neovim_functions.sh       # Nvim helpers
├── paths_functions.sh        # PATH management
├── paths_vars.sh             # PATH variables
├── pkg_functions.sh          # Package manager wrappers
├── speedtest_functions.sh    # Network speed testing
└── vars.sh                   # General variables

Target: ~/.oh-my-bash/custom/themes/
└── axin/
    └── axin.theme.sh         # Custom prompt theme

Target: ~/
├── .bashrc                   # Main bash config
└── .profile                  # Shell profile
```

**Variables Used:**
- `ansible_user_dir` - User home directory
- `role_path` - Current role path
- `ansible_distribution` - OS distribution (Ubuntu, Archlinux, etc.)
- `ansible_os_family` - OS family (Debian, RedHat, etc.)

**External Dependencies:**
- None (oh-my-bash downloaded at runtime)

**OS Support:**
- ✅ All Linux distributions
- ✅ MacOS
- 🔍 Windows/WSL (untested)

### Individual Script Breakdown

#### 1. **bat_functions.sh**
- **Purpose:** Enhanced `cat` command alternatives using `bat`
- **Dependencies:** Requires `bat` package
- **Merge Impact:** Low - Can be used standalone
- **Example Functions:** Syntax-highlighted file viewing

#### 2. **git_functions.sh**
- **Purpose:** Advanced git workflows
- **Dependencies:** Git
- **Merge Impact:** Medium - May conflict with existing git helpers
- **Example Functions:** Likely includes branch management, commit helpers

#### 3. **git_aliases.sh**
- **Purpose:** Git command shortcuts
- **Dependencies:** Git
- **Merge Impact:** Medium - May conflict with existing aliases
- **Example Aliases:** Common git operations (gst, gco, etc.)

#### 4. **neovim_functions.sh** & **neovim_aliases.sh**
- **Purpose:** Neovim workflow enhancements
- **Dependencies:** Neovim
- **Merge Impact:** Low - Only affects nvim users
- **Example Functions:** Project management, config switching

#### 5. **pkg_functions.sh**
- **Purpose:** Package manager wrapper functions
- **Dependencies:** System package manager (pacman, apt, brew, etc.)
- **Merge Impact:** High - May conflict with existing package helpers
- **Example Functions:** Universal install/update/search commands

#### 6. **paths_functions.sh** & **paths_vars.sh**
- **Purpose:** PATH and directory navigation management
- **Dependencies:** None
- **Merge Impact:** Medium - Modifies PATH
- **Example Functions:** Add/remove from PATH, directory bookmarks

#### 7. **gpt_functions.sh**
- **Purpose:** AI/GPT integration for shell
- **Dependencies:** API keys, curl/wget
- **Merge Impact:** Low - Optional enhancement
- **Example Functions:** Command-line AI queries

#### 8. **speedtest_functions.sh**
- **Purpose:** Network performance testing
- **Dependencies:** speedtest-cli or similar
- **Merge Impact:** Low - Standalone utility
- **Example Functions:** Quick speed tests, logging

#### 9. **lsd_aliases.sh**
- **Purpose:** Aliases for `lsd` (LSDeluxe - modern ls)
- **Dependencies:** `lsd` package
- **Merge Impact:** Low - Only affects ls commands
- **Example Aliases:** ls, ll, la, tree alternatives

#### 10. **dotfiles_completions.sh** & **git_completions.sh**
- **Purpose:** Tab completion for custom commands
- **Dependencies:** bash-completion
- **Merge Impact:** Low - Enhancements only
- **Example:** Auto-complete for dotfile commands

#### 11. **vars.sh**
- **Purpose:** General shell variables
- **Dependencies:** None
- **Merge Impact:** Medium - Sets environment variables
- **Example Vars:** Editor, locale, history settings

#### 12. **misc_aliases.sh**
- **Purpose:** General utility aliases
- **Dependencies:** Various (cd, mkdir, etc.)
- **Merge Impact:** Medium - May overlap with existing aliases
- **Example Aliases:** ll, la, ..., mkdir -p

---

## 🔧 Role: NVIM

### Task Flow (`roles/nvim/tasks/main.yml`)

```yaml
Task Sequence:
1. Install neovim-git from AUR (Arch Linux)
```

**Simple Role - Single Task**

**Variables Used:**
- None

**External Dependencies:**
- `kewlfft.aur` collection (Ansible Galaxy)
- AUR helper (yay, paru, etc.)

**OS Support:**
- ✅ Arch Linux only
- ❌ Other distributions need adaptation

**Merge Strategy:**
- Replace with your distro's neovim package
- Example alternatives:
  ```yaml
  # Ubuntu/Debian
  - apt: name=neovim state=present

  # Fedora
  - dnf: name=neovim state=present

  # MacOS
  - homebrew: name=neovim state=present
  ```

---

## 🔧 Role: SSH_VAULT

### Task Flow (`roles/ssh_vault/tasks/main.yml`)

```yaml
Task Sequence:
1. Include decrypt tasks (decrypt_ssh_keys.yml)
2. Include encrypt tasks (encrypt_and_upload_ssh_keys.yml)
3. Ensure ~/.ssh_backup directory exists
4. Copy ~/.ssh to ~/.ssh_backup
5. Debug vault password file path
6. Verify vault password file is not encrypted (head check)
7. Decrypt vault password file if encrypted
8. Set default decrypt_result if not defined
9. Fail if decryption failed
10. Archive .ssh_backup to .tar.gz
11. Encrypt .tar.gz with ansible-vault
12. Fail if encryption failed
13. Remove decrypted vault password file
14. Ensure ~/.ssh directory exists
15. Deploy SSH private key from variable
16. Deploy SSH public key from variable
```

**⚠️ Critical Path Issues:**
- Hardcoded path: `/home/skogix/.ssh/ansible-vault`
- Hardcoded path: `/home/skogix/.ssh_backup`

**Variables Required:**
- `ssh_private_key` - Content of private key (vaulted)
- `ssh_public_key` - Content of public key (vaulted)

**External Dependencies:**
- ansible-vault
- Vault password file at specified location

**Files Modified:**
```
Created:
- ~/.ssh_backup/
- ~/.ssh_backup.tar.gz (encrypted)
- ~/.ssh/id_rsa (from variable)
- ~/.ssh/id_rsa.pub (from variable)

Temporary:
- ~/.ssh/ansible-vault-decrypted (removed after use)
```

**Security Considerations:**
1. Private key stored in vault
2. Vault password file must be pre-existing
3. Backup created before deployment
4. Encrypted backup saved
5. Temporary decrypted password file cleaned up

**Merge Requirements:**
1. Update all `/home/skogix/` references to `{{ ansible_user_dir }}`
2. Ensure vars/ssh_keys.yml is vaulted
3. Set up vault password file location
4. Test decryption/encryption cycle

---

## 🔧 Role: SYSTEM

### Task Flow (`roles/system/tasks/main.yml`)

```yaml
Task Sequence (Arch Linux):
1. Update pacman cache and upgrade packages
2. Install jq package
```

**Additional Task Files:**
- `Archlinux.yml` - Arch-specific tasks
- `Ubuntu.yml` - Ubuntu-specific tasks (likely empty or unused)
- `MacOSX.yml` - MacOS-specific tasks (likely empty or unused)

**Variables Used:**
- None

**External Dependencies:**
- `community.general` collection

**OS Support:**
- ✅ Arch Linux (implemented)
- ⚠️ Ubuntu, MacOS (task files exist but may be empty)

**Merge Strategy:**
- Very basic - likely redundant
- Consider merging into existing system/package management role
- Add OS-specific tasks to existing multi-OS role structure

---

## 📦 Dependency Matrix

### Ansible Collections Required

| Collection | Used By | Purpose | Priority |
|------------|---------|---------|----------|
| `community.general` | system | Package management (pacman) | HIGH |
| `kewlfft.aur` | nvim | AUR package installation | MEDIUM |
| `kubernetes.core` | none (imported) | Kubernetes management | LOW |

### System Package Dependencies

| Package | Used By | Required | Optional |
|---------|---------|----------|----------|
| oh-my-bash | bash role | ✅ Yes | - |
| bat | bat_functions.sh | - | ✅ Yes |
| lsd | lsd_aliases.sh | - | ✅ Yes |
| neovim | neovim scripts | - | ✅ Yes |
| git | git scripts | ✅ Yes | - |
| jq | system role | ✅ Yes | - |
| speedtest-cli | speedtest_functions.sh | - | ✅ Yes |
| bash-completion | completion scripts | - | ✅ Yes |

### Inter-Role Dependencies

```
system role
  └─> (independent)

bash role
  └─> (independent)
  └─> oh-my-bash (external, auto-installed)

nvim role
  └─> (independent)

ssh_vault role
  └─> (independent)
  └─> ansible-vault (Ansible built-in)
  └─> vars/ssh_keys.yml (data dependency)
```

**No cross-role dependencies** - All roles are independent!

---

## 🎯 Integration Dependency Map

### Minimal Integration (Bash Scripts Only)

**Dependencies:**
```
None - Scripts can be sourced independently
```

**Steps:**
1. Copy `roles/bash/files/bash/*.sh` to your dotfiles
2. Source in `.bashrc`: `for script in ~/.config/bash/*.sh; do source "$script"; done`

**Risk:** Low
**Effort:** 5 minutes
**Value:** High (17 utility scripts)

---

### Full Bash Role Integration

**Dependencies:**
```
Ansible → None (oh-my-bash downloaded at runtime)
System → bash, wget/curl (for oh-my-bash install)
```

**Steps:**
1. Copy `roles/bash/` to your roles directory
2. Run role in playbook
3. Oh-my-bash auto-installs

**Risk:** Medium (overwrites .bashrc)
**Effort:** 15 minutes
**Value:** High (full automation)

---

### Complete Repository Integration

**Dependencies:**
```
Ansible Collections:
  - community.general (system role)
  - kewlfft.aur (nvim role, Arch only)

Variables:
  - vars/main.yml (update personal info)
  - vars/ssh_keys.yml (vault your SSH keys)

External:
  - oh-my-bash (auto-installed)
  - Ansible Vault password file (for ssh_vault)
```

**Steps:**
1. Install collections: `ansible-galaxy collection install -r requirements/common.yml`
2. Update all personal information in vars/
3. Copy all roles to your repository
4. Update ssh_vault hardcoded paths
5. Test each role independently
6. Integrate into main playbook

**Risk:** High (full system modification)
**Effort:** 2-3 hours
**Value:** Complete dotfiles automation

---

## 🔍 File Inventory

### Files by Category

#### **Executable/Scripts (22 files)**
```
roles/bash/files/bash/*.sh (17 files)
roles/bash/files/themes/axin/axin.theme.sh (1 file)
```

#### **Configuration (4 files)**
```
roles/bash/files/.bashrc
roles/bash/files/.profile
ansible.cfg
inventory
```

#### **Ansible Playbooks (2 files)**
```
main.yml
playbook.yml
```

#### **Ansible Tasks (12 files)**
```
roles/bash/tasks/main.yml
roles/bash/handlers/main.yml
roles/nvim/tasks/main.yml
roles/ssh_vault/tasks/main.yml
roles/ssh_vault/decrypt_ssh_keys.yml
roles/ssh_vault/encrypt_and_upload_ssh_keys.yml
roles/ssh_vault/tests/test_decryption.yml
roles/ssh_vault/tests/test_encryption.yml
roles/system/tasks/main.yml
roles/system/tasks/Archlinux.yml
roles/system/tasks/Ubuntu.yml
roles/system/tasks/MacOSX.yml
```

#### **Variables (3 files)**
```
vars/main.yml
vars/groups.yml
vars/ssh_keys.yml (vaulted)
```

#### **Requirements (2 files)**
```
requirements/common.yml
requirements/arch.yml
```

#### **Imported Roles (24 directories)**
```
roles-import/*/ (not analyzed in detail)
```

**Total Files to Review:** ~45 files
**Critical Files:** 8 files (main roles + vars)
**Optional Files:** 37 files (individual scripts, imported roles)

---

## 📊 Complexity Analysis

| Component | Lines of YAML | Lines of Bash | Complexity | Merge Risk |
|-----------|--------------|---------------|------------|------------|
| bash role | ~75 | ~2000+ | HIGH | MEDIUM |
| nvim role | ~6 | 0 | LOW | LOW |
| ssh_vault role | ~88 | 0 | MEDIUM | HIGH |
| system role | ~15 | 0 | LOW | LOW |
| Variables | ~60 | 0 | LOW | MEDIUM |
| Total | ~244 | ~2000+ | - | - |

**Most Complex:** Bash role (17 utility scripts)
**Highest Risk:** SSH_vault (handles sensitive data, hardcoded paths)
**Easiest:** Nvim role (single task)
**Best Value:** Bash scripts (high utility, low risk if copied standalone)

---

## 🚦 Integration Priority Ranking

### Priority 1: HIGH VALUE, LOW RISK
1. **Bash utility scripts** (standalone copy)
   - Impact: Immediate productivity boost
   - Risk: None (doesn't affect existing config)
   - Time: 10 minutes

### Priority 2: MEDIUM VALUE, MEDIUM RISK
2. **Bash role** (full Ansible integration)
   - Impact: Automated bash environment
   - Risk: Overwrites .bashrc (backup first!)
   - Time: 30 minutes

3. **Role selection pattern** (from vars/groups.yml)
   - Impact: Better role organization
   - Risk: Requires playbook refactoring
   - Time: 20 minutes

### Priority 3: LOW VALUE or HIGH RISK
4. **SSH vault role** (after security review)
   - Impact: Automated SSH key management
   - Risk: High (sensitive data, needs path updates)
   - Time: 1-2 hours

5. **System/Nvim roles**
   - Impact: Minimal (likely redundant)
   - Risk: Low
   - Time: 15 minutes

---

## 📝 Pre-Integration Checklist

- [ ] Backup existing .bashrc, .profile, .bash_aliases
- [ ] Review all bash scripts for conflicts with existing aliases/functions
- [ ] Update personal information in vars/main.yml
- [ ] Update or remove hardcoded paths in ssh_vault role
- [ ] Install required Ansible collections
- [ ] Test in VM or container first
- [ ] Verify oh-my-bash compatibility with existing setup
- [ ] Check for conflicting aliases (especially git aliases)
- [ ] Review security implications of ssh_vault role
- [ ] Document which components you're integrating

---

## 🎬 Quick Start Commands

### Install Dependencies
```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements/common.yml
ansible-galaxy collection install -r requirements/arch.yml  # Arch only
```

### Test Single Role
```bash
# Test bash role only
ansible-playbook main.yml --tags bash

# Test with specific variables
ansible-playbook main.yml -e "run_roles=[bash]"
```

### Copy Scripts Only (No Ansible)
```bash
# Copy to your dotfiles
cp -r roles/bash/files/bash ~/.config/

# Source in .bashrc
echo 'for script in ~/.config/bash/*.sh; do source "$script"; done' >> ~/.bashrc
```

### Integration Test Environment
```bash
# Create test user/container
docker run -it ubuntu:22.04 bash

# Or use Vagrant
vagrant init ubuntu/jammy64
vagrant up
vagrant ssh
```

---

## 🔗 Related Files Reference

- **Main Integration Guide:** `INTEGRATION_GUIDE.md` (high-level overview)
- **This Document:** `COMPONENT_BREAKDOWN.md` (technical details)
- **Source Repository:** Current directory
- **Target Repository:** Your existing Ansible setup

---

## 📮 Questions for Planning Integration

Before proceeding, answer these:

1. **What's your current shell setup?**
   - [ ] Plain bash
   - [ ] oh-my-bash
   - [ ] bash-it
   - [ ] Other: ___________

2. **What do you need most?**
   - [ ] Bash utility scripts
   - [ ] Full role automation
   - [ ] SSH key management
   - [ ] All of the above

3. **OS targets?**
   - [ ] Arch Linux
   - [ ] Ubuntu/Debian
   - [ ] MacOS
   - [ ] Multiple

4. **Integration style?**
   - [ ] Copy scripts manually (no Ansible)
   - [ ] Copy roles to existing playbook
   - [ ] Merge repo completely

5. **Risk tolerance?**
   - [ ] Conservative (manual, tested)
   - [ ] Balanced (role-by-role)
   - [ ] Aggressive (full merge)

Your answers will determine the best integration path!
