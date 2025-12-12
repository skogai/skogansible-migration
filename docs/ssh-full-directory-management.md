# Complete .ssh Directory Management

Two approaches for managing your entire `.ssh` folder with Ansible.

## 🎯 Approach 1: Bulk Deploy (Simple - Everything at Once)

### Step 1: Backup Your Current .ssh Folder

```bash
cd ~/.ansible

# Create files directory for SSH backup
mkdir -p files/ssh

# Copy your entire .ssh folder (excluding sockets)
rsync -av --exclude='*.sock' --exclude='sockets/' ~/.ssh/ files/ssh/

# Review what was backed up
ls -la files/ssh/
```

### Step 2: Secure Sensitive Files (Optional)

**Option A: Encrypt entire directory**
```bash
# Create tarball and encrypt it
tar czf files/ssh.tar.gz files/ssh/
ansible-vault encrypt files/ssh.tar.gz

# Update deployment task to extract from tarball
```

**Option B: Keep in files/ and add to .gitignore**
```bash
echo "files/ssh/*_rsa" >> .gitignore
echo "files/ssh/*_ed25519" >> .gitignore
echo "files/ssh/*_ecdsa" >> .gitignore
```

**Option C: Only commit config, keep keys in vault**
```bash
# Keep only non-sensitive files in files/ssh/
rm files/ssh/id_*  # Remove keys
# Keys stay in vars/ssh_vault.yml
```

### Step 3: Enable Bulk Deployment

In `vars/ssh.yml`:
```yaml
# Enable bulk directory deployment
ssh_deploy_full_directory: true

# Disable individual features (bulk deploy handles everything)
ssh_deploy_from_vault: false
ssh_deploy_config: false
```

### Step 4: Deploy

```bash
# Deploy everything
ansible-playbook playbook.yml --tags ssh

# Or if using encrypted tarball:
ansible-playbook playbook.yml --tags ssh --ask-vault-pass
```

---

## 🎯 Approach 2: Granular Control (Recommended - Piece by Piece)

Manage each part of `.ssh` separately for better control.

### What Goes Where:

```
~/.ssh/
├── id_ed25519           → vars/ssh_vault.yml (encrypted)
├── id_ed25519.pub       → vars/ssh_vault.yml (encrypted)
├── config               → roles/ssh/templates/ssh_config.j2
├── known_hosts          → vars/ssh.yml (ssh_known_hosts list)
├── authorized_keys      → vars/ssh.yml (ssh_authorized_keys list)
└── other_keys/          → vars/ssh_vault.yml or separate vault file
```

### Configuration in vars/ssh.yml:

```yaml
---
# Deploy keys from vault
ssh_deploy_from_vault: true

# Deploy SSH config
ssh_deploy_config: true
ssh_config_template: "ssh_config.j2"

# Manage known hosts
ssh_manage_known_hosts: true
ssh_known_hosts:
  - github.com
  - gitlab.com
  - bitbucket.org

# Manage authorized keys (if needed)
ssh_manage_authorized_keys: false
# ssh_authorized_keys:
#   - "ssh-ed25519 AAAA... user@laptop"

# Enable backup (creates ~/.ssh_backup/)
ssh_enable_backup: false
```

### For Multiple Keys:

If you have multiple SSH keys, extend `vars/ssh_vault.yml`:

```yaml
---
# Primary key
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...primary key...
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key: "ssh-ed25519 AAAA... primary@host"

# Additional keys
ssh_additional_keys:
  work:
    private: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      ...work key...
      -----END OPENSSH PRIVATE KEY-----
    public: "ssh-ed25519 AAAA... work@host"
    name: "id_ed25519_work"

  personal:
    private: |
      -----BEGIN OPENSSH PRIVATE KEY-----
      ...personal key...
      -----END OPENSSH PRIVATE KEY-----
    public: "ssh-rsa AAAA... personal@host"
    name: "id_rsa_personal"
```

Then add a task to deploy them:

```yaml
# In roles/ssh/tasks/main.yml (add after main key deployment)

- name: "SSH | Deploy additional SSH keys"
  when: ssh_additional_keys is defined
  block:
    - name: "SSH | Deploy additional private keys"
      ansible.builtin.copy:
        content: "{{ item.value.private }}"
        dest: "{{ ansible_facts['env']['HOME'] }}/.ssh/{{ item.value.name }}"
        mode: "0600"
        owner: "{{ ansible_facts['user_id'] }}"
        group: "{{ ansible_facts['user_id'] }}"
      loop: "{{ ssh_additional_keys | dict2items }}"
      no_log: true

    - name: "SSH | Deploy additional public keys"
      ansible.builtin.copy:
        content: "{{ item.value.public }}"
        dest: "{{ ansible_facts['env']['HOME'] }}/.ssh/{{ item.value.name }}.pub"
        mode: "0644"
        owner: "{{ ansible_facts['user_id'] }}"
        group: "{{ ansible_facts['user_id'] }}"
      loop: "{{ ssh_additional_keys | dict2items }}"
```

---

## 🔒 Security Best Practices

### Always Encrypt:
- ✅ Private keys (`id_*` without `.pub`)
- ✅ Passphrases
- ⚠️  Consider encrypting: `authorized_keys`, `known_hosts` (may contain sensitive info)
- ℹ️  Config files: Usually OK unencrypted unless they contain sensitive data

### File Permissions (automatically set):
- `.ssh/` directory: `0700`
- Private keys: `0600`
- Public keys: `0644`
- Config file: `0600`

### .gitignore Recommendations:
```gitignore
# If using files/ssh/ approach
files/ssh/id_*
!files/ssh/*.pub

# Never commit
*.pem
*.key
*_rsa
*_dsa
*_ecdsa
*_ed25519
!*.pub
```

---

## 🚀 Quick Start Commands

**Backup current .ssh:**
```bash
cd ~/.ansible
mkdir -p files/ssh
rsync -av --exclude='*.sock' --exclude='sockets/' ~/.ssh/ files/ssh/
```

**Test deployment (dry-run):**
```bash
ansible-playbook playbook.yml --tags ssh --check
```

**Deploy for real:**
```bash
ansible-playbook playbook.yml --tags ssh
```

**With vault password:**
```bash
ansible-playbook playbook.yml --tags ssh --ask-vault-pass
```

---

## 📊 Comparison

| Feature | Bulk Deploy | Granular |
|---------|-------------|----------|
| Setup complexity | Low | Medium |
| Control | Low | High |
| Vault usage | Optional | Required |
| Rollback | Full only | Per-item |
| Debugging | Harder | Easier |
| Best for | Simple setups | Complex setups |

**Recommendation:** Start with **Granular** if you have < 5 keys, use **Bulk** if you want to just "copy everything over" and don't need fine control.
