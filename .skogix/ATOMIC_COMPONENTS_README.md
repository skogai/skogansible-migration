# Atomic Components - Quick Start

This repository has been analyzed and broken down into atomic components for easy integration into your existing Ansible setup.

---

## 📚 Documentation Overview

Three comprehensive guides have been created:

### 1. **INTEGRATION_GUIDE.md** (Start Here!)
**Purpose:** High-level overview and planning guide

**Contains:**
- Repository structure overview
- Detailed breakdown of all 4 roles
- Variable file explanations
- Integration strategies (3 approaches)
- Critical warnings and gotchas
- Quick reference tables
- Pre-integration checklist

**Best For:** Understanding what's available and planning your integration approach

---

### 2. **COMPONENT_BREAKDOWN.md** (Technical Deep Dive)
**Purpose:** Detailed technical analysis of each component

**Contains:**
- Task flow diagrams for each role
- Individual script breakdowns (17 bash utilities)
- Line-by-line task analysis
- Complexity analysis
- File inventory (45+ files catalogued)
- Security considerations
- Testing commands
- Pre-integration checklist

**Best For:** Technical implementation details and understanding exactly what each component does

---

### 3. **DEPENDENCY_MAP.md** (Visual Guide)
**Purpose:** Visual dependency mapping and quick reference

**Contains:**
- ASCII dependency graphs
- Role-specific dependency trees
- 4 integration path options with risk/effort ratings
- Quick reference cards
- Decision flowchart
- Critical warnings
- Testing strategy
- Success criteria checklists

**Best For:** Quick decision-making and understanding dependencies at a glance

---

## 🎯 Quick Start (Choose Your Path)

### Path 1: Just Copy the Scripts (5 minutes, Zero Risk)
```bash
# No Ansible needed - just copy and use the utilities
cp -r roles/bash/files/bash ~/.config/
echo 'for script in ~/.config/bash/*.sh; do source "$script"; done' >> ~/.bashrc
source ~/.bashrc
```

**You Get:**
- 17 utility scripts (git helpers, neovim shortcuts, etc.)
- No automation overhead
- Keep your existing config

**Read:** DEPENDENCY_MAP.md → Card 1

---

### Path 2: Full Bash Role Automation (30 minutes, Medium Risk)
```bash
# Backup first!
cp ~/.bashrc ~/.bashrc.backup
cp ~/.profile ~/.profile.backup

# Copy role to your Ansible setup
cp -r roles/bash /path/to/your/ansible/roles/

# Add to your playbook
# - role: bash

# Run it
ansible-playbook your-playbook.yml --tags bash
```

**You Get:**
- Automated oh-my-bash installation
- All 17 utility scripts
- Custom theme
- Managed .bashrc and .profile

**⚠️ Warning:** Will overwrite .bashrc and .profile

**Read:** INTEGRATION_GUIDE.md → Section 1 (Bash Role)

---

### Path 3: Multi-Role Integration (1-2 hours, Medium-High Risk)
```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements/common.yml

# Copy roles
cp -r roles/bash /path/to/your/ansible/roles/
cp -r roles/system /path/to/your/ansible/roles/
cp -r roles/nvim /path/to/your/ansible/roles/

# Update variables with your personal info
vim vars/main.yml  # Change git_user_name, email, etc.

# Add to your playbook and run
ansible-playbook your-playbook.yml
```

**You Get:**
- Complete bash environment
- Neovim installation
- System package management
- Full automation

**⚠️ Warning:** Full system modification - test in VM first!

**Read:** COMPONENT_BREAKDOWN.md → Complete Technical Details

---

### Path 4: Complete Merge with SSH Vault (2-4 hours, High Risk)
```bash
# Read the security warnings first!
cat INTEGRATION_GUIDE.md | grep -A 10 "SSH_VAULT"

# Update hardcoded paths in ssh_vault role
sed -i 's|/home/skogix|{{ ansible_user_dir }}|g' roles/ssh_vault/tasks/main.yml

# Follow Path 3, then add ssh_vault role
# Make sure you understand ansible-vault before proceeding!
```

**⚠️ CRITICAL:**
- ssh_vault has hardcoded paths that MUST be updated
- Handles sensitive SSH keys - review security implications
- Requires ansible-vault setup

**Read:** INTEGRATION_GUIDE.md → Section 3 (SSH_VAULT Role) → Full warnings

---

## 🔍 What's in This Repository?

### **4 Custom Roles:**

1. **bash** (★★★★★ Most Valuable)
   - 17 utility scripts (git, neovim, packages, paths, AI, etc.)
   - Oh-my-bash installation
   - Custom theme
   - ~2000+ lines of bash utilities

2. **nvim** (★★☆☆☆ Simple)
   - Neovim nightly installation (Arch Linux)
   - Single task

3. **ssh_vault** (★★★☆☆ Advanced Use Case)
   - SSH key backup and encryption
   - Ansible vault integration
   - ⚠️ Requires path updates

4. **system** (★★☆☆☆ Basic)
   - Package manager updates
   - Installs jq
   - Very basic

### **Variable Files:**
- `vars/main.yml` - General configuration (update personal info!)
- `vars/groups.yml` - Role selection pattern
- `vars/ssh_keys.yml` - Vaulted SSH keys (don't copy as-is!)

### **Imported Roles (24):**
- Located in `roles-import/`
- All currently commented out
- Available for use if needed

---

## ⚡ Most Common Use Case

**Scenario:** You want the bash utilities but already have an Ansible setup

**Solution:**
```bash
# 1. Copy just the bash scripts
cp -r roles/bash/files/bash ~/.config/

# 2. Add this line to your .bashrc
for script in ~/.config/bash/*.sh; do
  [ -f "$script" ] && source "$script"
done

# 3. Done! Reload shell
source ~/.bashrc
```

**Time:** 5 minutes
**Risk:** None (doesn't touch existing config)
**Value:** Immediate access to 17 utility scripts

**Individual Scripts Available:**
- `bat_functions.sh` - Better cat with syntax highlighting
- `git_functions.sh` - Advanced git workflows
- `git_aliases.sh` - Git shortcuts
- `neovim_functions.sh` - Nvim helpers
- `pkg_functions.sh` - Universal package management
- `paths_functions.sh` - PATH management
- `gpt_functions.sh` - AI integration
- `speedtest_functions.sh` - Network testing
- `lsd_aliases.sh` - Modern ls commands
- And 8 more!

---

## ⚠️ Critical Warnings Before Integration

### 1. Hardcoded Paths (ssh_vault role)
The `ssh_vault` role contains hardcoded paths:
- `/home/skogix/.ssh/ansible-vault`
- `/home/skogix/.ssh_backup`

**Must replace with:** `{{ ansible_user_dir }}`

### 2. Personal Information (vars/main.yml)
Contains personal info that must be updated:
- Git username and email
- Dotfiles repository URL
- Other preferences

### 3. SSH Keys (vars/ssh_keys.yml)
Contains vaulted SSH keys - **DO NOT** copy to your repo!
Create your own and vault it properly.

### 4. .bashrc Overwrite (bash role)
The bash role will overwrite:
- `~/.bashrc`
- `~/.profile`

**Backup first!**

---

## 📊 Component Value Assessment

| Component | Value | Risk | Effort | Recommendation |
|-----------|-------|------|--------|----------------|
| **Bash utility scripts** | ★★★★★ | ☆☆☆☆☆ | ☆☆☆☆☆ | **USE THIS** |
| **Bash role (full)** | ★★★★☆ | ★★★☆☆ | ★★☆☆☆ | Good for automation |
| **Role selection pattern** | ★★★☆☆ | ★☆☆☆☆ | ★☆☆☆☆ | Nice organizational pattern |
| **Axin theme** | ★★☆☆☆ | ☆☆☆☆☆ | ☆☆☆☆☆ | Visual enhancement |
| **SSH vault role** | ★★★☆☆ | ★★★★★ | ★★★★☆ | Only if you need it |
| **Nvim role** | ★☆☆☆☆ | ★☆☆☆☆ | ☆☆☆☆☆ | Too simple, likely redundant |
| **System role** | ★☆☆☆☆ | ★☆☆☆☆ | ☆☆☆☆☆ | Too basic |

**Recommendation:** Start with bash utility scripts, expand if needed

---

## 🧪 Safe Testing Approach

### Step 1: Review Documentation (15 minutes)
```bash
# Read the overview
cat INTEGRATION_GUIDE.md | less

# Check dependencies
cat DEPENDENCY_MAP.md | grep -A 20 "Component Dependency Graph"
```

### Step 2: Test Individual Script (5 minutes)
```bash
# Copy one script
cp roles/bash/files/bash/git_functions.sh /tmp/

# Test it
source /tmp/git_functions.sh

# Try a function (check what's available first)
# If it works, proceed to copy all
```

### Step 3: Copy All Scripts (5 minutes)
```bash
# Copy to separate directory first
mkdir -p ~/.config/bash-test
cp roles/bash/files/bash/*.sh ~/.config/bash-test/

# Test source
for script in ~/.config/bash-test/*.sh; do
  source "$script"
done

# If no errors, move to permanent location
mv ~/.config/bash-test ~/.config/bash
```

### Step 4: Make Permanent (2 minutes)
```bash
# Add to .bashrc
echo '# Custom bash utilities from dotfile-ansible' >> ~/.bashrc
echo 'for script in ~/.config/bash/*.sh; do' >> ~/.bashrc
echo '  [ -f "$script" ] && source "$script"' >> ~/.bashrc
echo 'done' >> ~/.bashrc

# Reload
source ~/.bashrc
```

---

## 🎓 Understanding the 17 Bash Utilities

The bash role includes 17 utility scripts organized by function:

**Git Workflow (3 scripts):**
- `git_functions.sh` - Advanced git operations
- `git_aliases.sh` - Quick git shortcuts
- `git_completions.sh` - Tab completion for git commands

**Development Tools (4 scripts):**
- `neovim_functions.sh` - Neovim workflow helpers
- `neovim_aliases.sh` - Nvim shortcuts
- `pkg_functions.sh` - Universal package management
- `gpt_functions.sh` - AI/GPT integration

**File Management (3 scripts):**
- `bat_functions.sh` - Enhanced file viewing
- `lsd_aliases.sh` - Modern ls alternatives
- `paths_functions.sh` - PATH management

**System Utilities (3 scripts):**
- `paths_vars.sh` - Path variables
- `vars.sh` - General environment variables
- `speedtest_functions.sh` - Network testing

**Completions (2 scripts):**
- `dotfiles_completions.sh` - Dotfile command completion
- `git_completions.sh` - Enhanced git completion

**Miscellaneous (2 scripts):**
- `misc_aliases.sh` - General aliases
- Additional utilities

Each can be used independently or together!

---

## 📞 Need Help Deciding?

Answer these questions:

**1. Do you use Ansible?**
- **No** → Use Path 1 (copy scripts manually)
- **Yes** → Continue to Q2

**2. Want full automation or just utilities?**
- **Just utilities** → Use Path 1 (copy scripts)
- **Full automation** → Use Path 2 or 3

**3. Need SSH key management?**
- **No** → Use Path 2 or 3
- **Yes** → Use Path 4 (but read security warnings!)

**4. Are you on Arch Linux?**
- **Yes** → All paths work, nvim role included
- **No** → Skip nvim role or adapt for your distro

**5. What's your risk tolerance?**
- **Conservative** → Path 1 (scripts only)
- **Moderate** → Path 2 (bash role)
- **Aggressive** → Path 3 or 4 (full integration)

---

## ✅ Success Checklist

After integration, verify:

**For Scripts Only (Path 1):**
- [ ] Scripts copied to ~/.config/bash/
- [ ] Scripts sourced in .bashrc
- [ ] Can call functions from scripts
- [ ] No error messages on shell start

**For Bash Role (Path 2):**
- [ ] Oh-my-bash installed at ~/.oh-my-bash
- [ ] Custom theme active (if using)
- [ ] All utilities available
- [ ] .bashrc and .profile updated correctly

**For Multi-Role (Path 3):**
- [ ] All roles executed without errors
- [ ] Packages installed (nvim, jq, etc.)
- [ ] Ansible collections installed
- [ ] Personal info updated in vars

**For Complete Merge (Path 4):**
- [ ] All of Path 3 checks passed
- [ ] SSH vault role paths updated
- [ ] Vault password file configured
- [ ] SSH keys deployed successfully
- [ ] Backup created and encrypted

---

## 📝 Next Steps

1. **Choose your integration path** (see Quick Start section)
2. **Read the appropriate documentation:**
   - Path 1 → DEPENDENCY_MAP.md (Card 1)
   - Path 2 → INTEGRATION_GUIDE.md (Bash Role section)
   - Path 3 → COMPONENT_BREAKDOWN.md (full technical details)
   - Path 4 → All three documents + security review

3. **Test in safe environment** (VM, container, or test directory)
4. **Backup existing configuration** (especially .bashrc, .profile)
5. **Execute integration** (following chosen path)
6. **Verify success** (using checklist above)
7. **Commit to your repository**

---

## 🔗 Documentation Index

| Document | Purpose | Read Time | When to Use |
|----------|---------|-----------|-------------|
| **This File** | Quick start & navigation | 5 min | Start here! |
| **INTEGRATION_GUIDE.md** | Planning & overview | 20 min | Before integrating |
| **COMPONENT_BREAKDOWN.md** | Technical deep dive | 30 min | During implementation |
| **DEPENDENCY_MAP.md** | Visual guide & quick ref | 15 min | For quick decisions |

**Total reading time:** ~70 minutes
**Implementation time:** 5 minutes to 4 hours (depending on path chosen)

---

## 🎯 TL;DR - The Absolute Quickest Start

If you want the most value with the least risk:

```bash
# 1. Copy the 17 bash utility scripts (no Ansible needed)
cp -r roles/bash/files/bash ~/.config/

# 2. Add to your .bashrc
echo 'for f in ~/.config/bash/*.sh; do source "$f"; done' >> ~/.bashrc

# 3. Reload
source ~/.bashrc

# Done! You now have 17 utility scripts available.
```

**Time:** 2 minutes
**Risk:** Zero
**Value:** 17 utility scripts for git, neovim, packages, paths, and more

If you want automation later, you can always come back and integrate the full roles.

---

**Repository:** dotfile-ansible
**Analysis Date:** 2025-11-07
**Total Components:** 4 roles, 17 utility scripts, 3 variable files, 24 imported roles
**Documentation:** 4 comprehensive guides (~12,000 words)
**Ready to integrate!** 🚀
