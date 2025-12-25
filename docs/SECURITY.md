# Security Guide

**Repository:** SkogAI/skogansible

This document outlines security practices, credential management, and secure usage of the skogansible repository.

---

## Table of Contents

1. [Credential Management](#credential-management)
2. [Ansible Vault](#ansible-vault)
3. [Password Files Setup](#password-files-setup)
4. [SSH Key Security](#ssh-key-security)
5. [Semaphore Security](#semaphore-security)
6. [Best Practices](#best-practices)
7. [Incident Response](#incident-response)

---

## Credential Management

### Overview

The skogansible repository uses multiple layers of credential management:

1. **Ansible Vault** - Encrypts sensitive variables (SSH keys, API tokens)
2. **Password Files** - Local files storing sudo and vault passwords
3. **Environment Variables** - For dynamic configuration (via skogcli)
4. **Git Exclusions** - Prevents accidental commit of secrets

### Credential Hierarchy

```
Repository (Public)
  ├── Ansible Vault Files (Encrypted, in git)
  │   └── vars/ssh_vault.yml
  │
  ├── Password Files (Local only, NOT in git)
  │   ├── ~/.ssh/ansible-vault-password
  │   └── ~/.ssh/ansible-become-password
  │
  └── Environment Files (Local only, NOT in git)
      └── semaphore/.env
```

---

## Ansible Vault

### What is Ansible Vault?

Ansible Vault encrypts sensitive data files using AES256 encryption. The encrypted files can be safely committed to git.

### Using Vault

**Encrypt a file:**
```bash
ansible-vault encrypt vars/ssh_vault.yml
```

**Decrypt a file (view only):**
```bash
ansible-vault view vars/ssh_vault.yml
```

**Edit an encrypted file:**
```bash
ansible-vault edit vars/ssh_vault.yml
```

**Change vault password:**
```bash
ansible-vault rekey vars/ssh_vault.yml
```

### Vault Password Storage

The vault password should be stored in a secure location:

**Default location:** `~/.ssh/ansible-vault-password`

**File permissions:** Must be `600` (read/write owner only)

```bash
# Create and secure the password file
echo "your_secure_vault_password" > ~/.ssh/ansible-vault-password
chmod 600 ~/.ssh/ansible-vault-password
```

**Alternative:** Use `--ask-vault-pass` flag to enter password interactively

---

## Password Files Setup

### Required Password Files

The repository requires two password files for automation:

1. **Vault Password File** - Decrypts Ansible Vault files
2. **Become Password File** - Provides sudo password for privilege escalation

### Setup Instructions

```bash
# Create SSH directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Create vault password file
echo "your_vault_password" > ~/.ssh/ansible-vault-password
chmod 600 ~/.ssh/ansible-vault-password

# Create become (sudo) password file
echo "your_sudo_password" > ~/.ssh/ansible-become-password
chmod 600 ~/.ssh/ansible-become-password
```

### Environment Variables

Override default locations using environment variables (set in `.envrc` or shell):

```bash
export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/vault-password
export ANSIBLE_BECOME_PASSWORD_FILE=/path/to/become-password
```

### Security Considerations

- ⚠️ **Never commit password files to git**
- ✅ Password files are automatically checked and fixed to 600 permissions by `run.sh`
- ✅ The `.gitignore` excludes files matching `*password*` and `*secret*`
- ⚠️ Keep password files in a secure, encrypted location (e.g., `~/.ssh/`)

---

## SSH Key Security

### Key Storage

SSH keys are stored encrypted in Ansible Vault:

**File:** `vars/ssh_vault.yml`

**Contents:**
```yaml
ssh_private_key_ed25519: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  [encrypted key content]
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key_ed25519: "ssh-ed25519 AAAA..."
```

### Key Deployment

Keys are deployed with secure permissions:

- SSH directory: `0700` (rwx------)
- Private keys: `0600` (rw-------)
- Public keys: `0644` (rw-r--r--)
- SSH config: `0600` (rw-------)

### Key Passphrase

When generating new SSH keys, consider using a passphrase:

**Without passphrase:**
- ✅ More convenient (no password prompt)
- ❌ Less secure (key file is all attacker needs)

**With passphrase:**
- ✅ More secure (two-factor: file + passphrase)
- ❌ Less convenient (requires ssh-agent)

**Recommendation:** Use passphrase + ssh-agent for best security/convenience balance

---

## Semaphore Security

### Configuration

Semaphore UI runs via Docker and requires admin credentials.

**NEVER commit credentials to docker-compose.yml**

### Setup Process

1. **Copy the example environment file:**
   ```bash
   cd semaphore
   cp .env.example .env
   ```

2. **Edit `.env` with your secure credentials:**
   ```bash
   SEMAPHORE_ADMIN=your_username
   SEMAPHORE_ADMIN_PASSWORD=your_secure_password
   SEMAPHORE_ADMIN_EMAIL=your@email.com
   ```

3. **Set proper permissions:**
   ```bash
   chmod 600 .env
   ```

4. **Verify .env is in .gitignore:**
   ```bash
   grep "semaphore/.env" .gitignore
   # Should return: semaphore/.env
   ```

### Access Control

- **Local:** `http://localhost:9005`
- **Public:** `https://semaphore.skogai.se` (via Cloudflare tunnel)
- **Authentication:** Username + Password (set in `.env`)
- **API Token:** Stored in skogcli as `SEMAPHORE_API_TOKEN`

### Security Best Practices

1. Use a strong, unique password (20+ characters, mixed case, symbols)
2. Enable 2FA if available in Semaphore Pro
3. Restrict Cloudflare tunnel access by IP if possible
4. Rotate admin password quarterly
5. Audit Semaphore logs regularly

---

## Best Practices

### 1. Secret Scanning

The repository uses `detect-secrets` to scan for accidentally committed secrets.

**Run manually:**
```bash
detect-secrets scan --baseline .secrets.baseline
```

**Pre-commit hooks:**
```bash
# Install pre-commit
pip install pre-commit

# Setup hooks
pre-commit install

# Run manually on all files
pre-commit run --all-files
```

### 2. Vault File Management

**Do:**
- ✅ Always encrypt vault files before committing
- ✅ Use descriptive variable names
- ✅ Test vault decryption before deploying
- ✅ Keep vault password separate from repository

**Don't:**
- ❌ Commit unencrypted vault files
- ❌ Share vault password via insecure channels
- ❌ Store vault password in repository
- ❌ Use weak vault passwords

### 3. Privilege Escalation

**Become (sudo) usage:**
- Only use `become: true` on tasks that require root privileges
- Never set `become: true` at playbook level (too broad)
- Validate all sudoers files with `visudo -cf`
- Use NOPASSWD only for specific commands

**Example (secure):**
```yaml
- name: Install package
  become: true  # Only this task runs as root
  community.general.pacman:
    name: git
    state: present
```

### 4. File Permissions

Always set explicit permissions on sensitive files:

```yaml
- name: Deploy config
  ansible.builtin.copy:
    src: config.yml
    dest: /etc/app/config.yml
    owner: root
    group: root
    mode: '0600'  # Only root can read/write
```

### 5. Logging Sensitive Operations

Use `no_log: true` for tasks that handle sensitive data:

```yaml
- name: Deploy private key
  ansible.builtin.copy:
    content: "{{ ssh_private_key }}"
    dest: ~/.ssh/id_ed25519
  no_log: true  # Prevents key from appearing in logs
```

---

## Incident Response

### If Credentials Are Compromised

#### 1. Vault Password Compromised

**Immediate actions:**
1. Change vault password: `ansible-vault rekey vars/ssh_vault.yml`
2. Update password file: `~/.ssh/ansible-vault-password`
3. Rotate all secrets stored in vault (SSH keys, API tokens)
4. Review git history for unauthorized access
5. Audit all systems with vault access

#### 2. SSH Keys Compromised

**Immediate actions:**
1. Generate new SSH key pair
2. Update authorized_keys on all servers
3. Encrypt new keys in vault: `ansible-vault edit vars/ssh_vault.yml`
4. Remove old key from authorized_keys
5. Review SSH logs for unauthorized access

#### 3. Semaphore Password Compromised

**Immediate actions:**
1. Change password via Semaphore UI
2. Update `semaphore/.env` file
3. Restart Semaphore: `cd semaphore && docker compose restart`
4. Review Semaphore audit logs
5. Check for unauthorized playbook executions

#### 4. Sudo Password Compromised

**Immediate actions:**
1. Change user sudo password: `passwd`
2. Update `~/.ssh/ansible-become-password`
3. Review sudo logs: `sudo journalctl -u sudo`
4. Check for unauthorized privilege escalation

### Security Audit Checklist

Run this checklist quarterly or after any security incident:

```bash
# 1. Verify vault files are encrypted
file vars/*vault*.yml

# 2. Check password file permissions
ls -la ~/.ssh/ansible-*-password

# 3. Scan for secrets
detect-secrets scan --baseline .secrets.baseline

# 4. Review git history for sensitive data
git log -p | grep -i "password\|secret\|key"

# 5. Verify .gitignore is working
git status --ignored

# 6. Check sudoers configuration
sudo cat /etc/sudoers.d/11-install-aur_builder
sudo cat /etc/sudoers.d/12-wheel-to-aur_builder

# 7. Review Semaphore access logs
docker compose -f semaphore/docker-compose.yml logs | grep -i auth

# 8. Audit SSH key usage
journalctl | grep -i "sshd.*Accepted"
```

### Contact

For security issues or questions:

- **Email:** emil@skogsund.se
- **GitHub:** @skogix
- **Urgent:** Create a private security advisory on GitHub

---

## Secrets Rotation Schedule

| Credential Type | Rotation Frequency | Last Rotated | Next Rotation |
|----------------|-------------------|--------------|---------------|
| Vault Password | Annually | - | - |
| SSH Keys | Every 2 years | - | - |
| Semaphore Password | Quarterly | - | - |
| API Tokens | Every 6 months | - | - |
| Sudo Password | As needed | - | - |

**Note:** Update this table when rotating credentials.

---

## Additional Resources

- [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [SSH Key Management Best Practices](https://www.ssh.com/academy/ssh/keygen)
- [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [CIS Ansible Benchmark](https://www.cisecurity.org/)

---

**Last Updated:** 2025-12-25
**Review Frequency:** Quarterly
**Next Review:** 2026-03-25
