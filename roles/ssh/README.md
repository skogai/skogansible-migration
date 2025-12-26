# Ansible Role: SSH

A flexible Ansible role for managing SSH keys, configuration, and backups with ansible-vault support.

## Features

- ✅ Deploy entire .ssh directory from vault-encrypted files (disaster recovery)
- ✅ Deploy SSH keys from ansible-vault encrypted variables (all 3 key types: ED25519, RSA, ECDSA)
- ✅ Generate new SSH key pairs (RSA, ED25519, ECDSA)
- ✅ Deploy custom SSH configuration from template
- ✅ Manage known_hosts entries
- ✅ Manage authorized_keys
- ✅ Automatic permission management (vault password files set to 700, private keys to 600, public keys to 644)
- ✅ Backup SSH directory with optional encryption
- ✅ No hardcoded paths - fully configurable
- ✅ Safe defaults with commented optional features

## Quick Start

### Installation

Copy this role to your Ansible roles directory:

```bash
cp -r components/ssh-role /path/to/your/ansible/roles/ssh
```

### Basic Usage - Deploy Keys from Vault

**Step 1:** Create a vaulted variables file with your SSH keys:

```bash
cat > vars/ssh_vault.yml <<'EOF'
---
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  (paste your private key here)
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key: "ssh-ed25519 AAAA... your@email.com"
EOF

# Encrypt it
ansible-vault encrypt vars/ssh_vault.yml
```

**Step 2:** Create a playbook:

```yaml
---
- name: Deploy SSH keys
  hosts: localhost
  connection: local

  vars_files:
    - vars/ssh_vault.yml

  vars:
    ssh_deploy_from_vault: true
    ssh_private_key_content: "{{ ssh_private_key }}"
    ssh_public_key_content: "{{ ssh_public_key }}"

  roles:
    - ssh
```

**Step 3:** Run it:

```bash
ansible-playbook deploy-ssh.yml --ask-vault-pass
```

## Usage Scenarios

### Scenario 0: Deploy Entire .ssh Directory (Disaster Recovery)

**Recommended approach** - Deploy your complete .ssh directory from vault-encrypted files stored in `roles/ssh/files/ssh/`.

**Setup:**

1. Copy your .ssh files to `roles/ssh/files/ssh/`:

   ```bash
   cp ~/.ssh/id_ed25519 roles/ssh/files/ssh/
   cp ~/.ssh/id_rsa roles/ssh/files/ssh/
   cp ~/.ssh/authorized_keys roles/ssh/files/ssh/
   # ... etc
   ```

2. Encrypt all files with ansible-vault:

   ```bash
   for file in roles/ssh/files/ssh/*; do
     ansible-vault encrypt "$file"
   done
   ```

3. Enable full directory deployment in `vars/ssh.yml`:

   ```yaml
   ssh_deploy_full_directory: true
   ```

4. Run the playbook:

   ```bash
   ./run.sh --tags ssh
   ```

**What gets deployed:**

All files from `roles/ssh/files/ssh/` are synced to `~/.ssh/` with automatic permission management:

- Private keys (id_*): `600`
- Public keys (*.pub): `644`
- Vault password files (ansible-become-password, ansible-vault-password): `700` (executable)
- Other files: preserved mode from source

**Current files in this implementation (11 files):**

- `.env` - Environment variables
- `allowed_signers` - SSH commit signing configuration
- `ansible-become-password` - Ansible vault password (executable)
- `ansible-vault-password` - Ansible vault password (executable)
- `authorized_keys` - SSH authorized keys for incoming connections
- `CF-ACCESS-CLIENT-ID.pub` - Cloudflare Access SSH certificate
- `CF-ACCESS-CLIENT-SECRET.access` - Cloudflare Access secret
- `cloudflare-access-ssh-infrastructure.pub` - Cloudflare SSH infrastructure key
- `open-ssh-ca.clroudflareaccess.org` - Cloudflare CA certificate
- `open-ssh-ca.clroudflareaccess.pub` - Cloudflare CA public key
- `openrouter` - OpenRouter API credentials

**Additional vault variables for SSH keys:**

In `vars/ssh_vault.yml`, define all three key types:

```yaml
ssh_private_key_ed25519: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  (your ed25519 private key)
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key_ed25519: "ssh-ed25519 AAAA... user@host"

ssh_private_key_rsa: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  (your rsa private key)
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key_rsa: "ssh-rsa AAAA... user@host"

ssh_private_key_ecdsa: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  (your ecdsa private key)
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key_ecdsa: "ecdsa-sha2-nistp256 AAAA... user@host"
```

Enable vault key deployment in `vars/ssh.yml`:

```yaml
ssh_deploy_from_vault: true
```

This dual approach provides:

- **Vault variables** for critical SSH keys (ed25519, rsa, ecdsa)
- **File deployment** for drop-and-forget files (configs, certs, authorized_keys)

### Scenario 1: Just Ensure SSH Directory Exists

Minimal usage - just creates `~/.ssh` with correct permissions:

```yaml
- hosts: localhost
  roles:
    - ssh
```

### Scenario 2: Generate New SSH Key

Generate a new ED25519 key pair:

```yaml
- hosts: localhost
  vars:
    ssh_generate_key: true
    ssh_key_type: "ed25519"
    ssh_key_comment: "myuser@myhost"
  roles:
    - ssh
```

Generate RSA key with specific size:

```yaml
- hosts: localhost
  vars:
    ssh_generate_key: true
    ssh_key_type: "rsa"
    ssh_key_size: 4096
    ssh_key_comment: "myuser@myhost"
  roles:
    - ssh
```

### Scenario 3: Deploy SSH Config

Deploy a custom SSH configuration:

```yaml
- hosts: localhost
  vars:
    ssh_deploy_config: true
    ssh_config_template: "ssh_config.j2"

    # Optional: Define custom hosts in config
    ssh_custom_hosts:
      - name: github
        hostname: github.com
        user: git
        identity_file: ~/.ssh/id_ed25519

      - name: myserver
        hostname: server.example.com
        user: myuser
        port: 2222
        forward_agent: yes

  roles:
    - ssh
```

### Scenario 4: Manage Known Hosts

Add specific hosts to known_hosts:

```yaml
- hosts: localhost
  vars:
    ssh_manage_known_hosts: true
    ssh_known_hosts:
      - github.com
      - gitlab.com
      - bitbucket.org

  roles:
    - ssh
```

### Scenario 5: Manage Authorized Keys

Add public keys to authorized_keys (for allowing SSH access TO this machine):

```yaml
- hosts: localhost
  vars:
    ssh_manage_authorized_keys: true
    ssh_authorized_keys:
      - "ssh-ed25519 AAAAC3... admin@laptop"
      - "ssh-rsa AAAAB3... admin@desktop"

  roles:
    - ssh
```

### Scenario 6: Backup SSH Directory

Create a backup of your SSH directory:

```yaml
- hosts: localhost
  vars:
    ssh_enable_backup: true

  roles:
    - ssh
```

This creates:

- `~/.ssh_backup/` (copy of .ssh directory)
- `~/.ssh_backup.tar.gz` (compressed archive)

### Scenario 7: Complete Setup

Full featured deployment with keys, config, and known hosts:

```yaml
---
- name: Complete SSH setup
  hosts: localhost
  connection: local

  vars_files:
    - vars/ssh_vault.yml

  vars:
    # Deploy keys from vault
    ssh_deploy_from_vault: true
    ssh_private_key_content: "{{ ssh_private_key }}"
    ssh_public_key_content: "{{ ssh_public_key }}"

    # Deploy custom config
    ssh_deploy_config: true
    ssh_config_template: "ssh_config.j2"

    # Manage known hosts
    ssh_manage_known_hosts: true
    ssh_known_hosts:
      - github.com
      - gitlab.com

    # Create backup
    ssh_enable_backup: true

  roles:
    - ssh
```

## Configuration Variables

### SSH Directory Deployment

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_deploy_full_directory` | `false` | Deploy entire .ssh directory from `roles/ssh/files/ssh/` |

### SSH Key Management

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_key_type` | `ed25519` | SSH key type (rsa, ed25519, ecdsa) |
| `ssh_key_size` | `4096` | Key size (RSA only) |
| `ssh_deploy_from_vault` | `false` | Deploy keys from vaulted variables |
| `ssh_generate_key` | `false` | Generate new SSH key pair |
| `ssh_key_passphrase` | `""` | Passphrase for generated key |
| `ssh_key_comment` | (undefined) | Comment for generated key |

**Vault variable names for multiple key types:**

- ED25519: `ssh_private_key_ed25519`, `ssh_public_key_ed25519`
- RSA: `ssh_private_key_rsa`, `ssh_public_key_rsa`
- ECDSA: `ssh_private_key_ecdsa`, `ssh_public_key_ecdsa`

### SSH Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_deploy_config` | `false` | Deploy custom SSH config |
| `ssh_config_template` | (undefined) | Template file for SSH config |
| `ssh_config_file` | `~/.ssh/config` | SSH config file location |

### File Permissions

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_dir` | `~/.ssh` | SSH directory location |
| `ssh_dir_mode` | `0700` | SSH directory permissions |
| `ssh_private_key_mode` | `0600` | Private key permissions |
| `ssh_public_key_mode` | `0644` | Public key permissions |
| `ssh_config_mode` | `0600` | Config file permissions |

### Backup & Vault

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_enable_backup` | `false` | Create SSH directory backup |
| `ssh_backup_dir` | `~/.ssh_backup` | Backup directory location |
| `ssh_backup_archive` | `~/.ssh_backup.tar.gz` | Backup archive location |
| `ssh_encrypt_backup` | `false` | Encrypt backup with ansible-vault |

### Known Hosts & Authorized Keys

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_manage_known_hosts` | `false` | Manage known_hosts file |
| `ssh_known_hosts` | `[]` | List of hosts to add |
| `ssh_manage_authorized_keys` | `false` | Manage authorized_keys |
| `ssh_authorized_keys` | `[]` | List of public keys to add |

## Advanced Features (Commented Out)

Some advanced features are commented out in the tasks file. Review and uncomment if needed:

### SSH Agent Configuration

Automatically start SSH agent in shell profile. **Review before enabling:**

- Uncomment the "SSH Agent Configuration" section in `tasks/main.yml`
- Set `ssh_configure_agent: true`
- Define `ssh_agent_socket` location

### Backup Encryption

Encrypt SSH backups with ansible-vault. **Review before enabling:**

- Uncomment the "SSH Backup Encryption" section in `tasks/main.yml`
- Set `ssh_encrypt_backup: true`
- Define `ssh_vault_password_file` location
- Ensure vault password file exists and is accessible

## Security Considerations

### Private Keys in Vault

When using `ssh_deploy_from_vault`:

1. Always encrypt vars files containing private keys:

   ```bash
   ansible-vault encrypt vars/ssh_vault.yml
   ```

2. Use strong vault passwords

3. Consider using `no_log: true` (already included in tasks)

### File Permissions

Default permissions follow SSH security best practices:

- `.ssh/` directory: `0700` (rwx------)
- Private keys: `0600` (rw-------)
- Public keys: `0644` (rw-r--r--)
- Config file: `0600` (rw-------)
- Vault password files: `0700` (rwx------) - **Must be executable for Ansible to read them**

The role automatically sets these permissions when using `ssh_deploy_full_directory: true`

### Passphrases

If using `ssh_key_passphrase`:

1. Store in a vaulted variable
2. Use `no_log: true` (already included)
3. Consider using SSH agent instead

## Troubleshooting

### Vault Decryption Failed Error

**Error message:**

```
[ERROR]: Decryption failed (no vault secrets were found that could decrypt)
```

**Root cause:** The vault password file (`ansible-become-password` or `ansible-vault-password` in `~/.ssh/`) is not executable.

**Solution:**

Ansible requires vault password files to have executable permissions (chmod 700). The SSH role automatically sets this when deploying via `ssh_deploy_full_directory: true`, but if you deployed manually or permissions were changed:

```bash
chmod 700 ~/.ssh/ansible-become-password
chmod 700 ~/.ssh/ansible-vault-password
```

**Why:** Ansible reads vault password files by executing them as scripts, so they must have the executable bit set.

### Keys not deploying from vault

Check:

1. `ssh_deploy_from_vault` is set to `true`
2. Variables are defined in `vars/ssh_vault.yml`:
   - `ssh_private_key_ed25519`, `ssh_public_key_ed25519`
   - `ssh_private_key_rsa`, `ssh_public_key_rsa`
   - `ssh_private_key_ecdsa`, `ssh_public_key_ecdsa`
3. Vault file is properly encrypted and decryptable
4. Running playbook with `--ask-vault-pass` or vault password file configured

### Permission denied errors

Check:

1. SSH directory has correct permissions (`0700`)
2. Private key has correct permissions (`0600`)
3. Files owned by correct user

### Key generation fails

Check:

1. `ssh_generate_key` is set to `true`
2. `ssh_deploy_from_vault` is set to `false` (they're mutually exclusive)
3. Key doesn't already exist (role won't overwrite)

### Config not deploying

Check:

1. `ssh_deploy_config` is set to `true`
2. `ssh_config_template` points to valid template file
3. Template file exists in `templates/` directory

## Examples Directory Structure

Recommended project structure:

```
your-ansible-project/
├── ansible.cfg
├── inventory
├── roles/
│   └── ssh/              # This role
│       ├── defaults/
│       ├── tasks/
│       ├── templates/
│       ├── vars/
│       └── meta/
├── vars/
│   └── ssh_vault.yml     # Your vaulted SSH keys (encrypted)
└── playbooks/
    ├── setup-ssh.yml     # Your playbook
    └── backup-ssh.yml    # Backup playbook
```

## Migration from Original ssh_vault Role

If migrating from the original `roles/ssh_vault`:

### Key Changes

1. **No hardcoded paths** - Uses `{{ ansible_user_dir }}` variables
2. **Everything is optional** - Enable only what you need
3. **Vault encryption commented out** - Review before enabling
4. **No user-specific paths** - Works for any user

### Migration Steps

1. Copy vaulted SSH keys from `vars/ssh_keys.yml` to new structure
2. Update playbook to use new variables
3. Review and uncomment advanced features if needed
4. Test on non-production system first

## SSH Hardening

The role includes comprehensive SSH hardening capabilities based on security best practices. Hardening is **disabled by default** for safety.

### Hardening Features

#### Client-Side Hardening (`~/.ssh/config`)
- Modern cryptographic algorithms only (no weak ciphers/MACs/KEX)
- Strict host key checking
- Ed25519 and RSA-SHA2 key types preferred
- Connection multiplexing for performance
- Disabled X11/agent forwarding by default
- Automatic permission fixing for SSH directory and keys

#### Server-Side Hardening (`/etc/ssh/sshd_config`)
- Modern cryptographic algorithms enforced
- Root login restricted (prohibit-password by default)
- Public key authentication preferred
- Weak key algorithms removed (DSA, optionally ECDSA)
- Connection rate limiting
- Failed login attempt restrictions
- Disabled risky features (TCP forwarding, tunneling)
- Verbose logging for security auditing

#### Security Policies
- Fail2Ban integration for SSH brute-force protection
- PAM configuration for enhanced authentication
- Systemd socket rate limiting
- Security banner support
- Configuration validation and auditing

### Quick Start: Enable Hardening

#### Client-Side Only (Safe for Development)

```yaml
---
- hosts: localhost
  vars:
    ssh_hardening_enabled: true
    ssh_hardening_client_enabled: true
    ssh_hardening_audit_enabled: true
  roles:
    - ssh
```

This hardens your `~/.ssh/config` with modern crypto algorithms and secure defaults.

#### Full Hardening (Client + Server)

**⚠️ WARNING:** Server-side hardening requires sudo and restarts SSH daemon. Test carefully!

```yaml
---
- hosts: localhost
  vars:
    ssh_hardening_enabled: true
    ssh_hardening_client_enabled: true
    ssh_hardening_server_enabled: true
    ssh_hardening_remove_weak_keys: true
    ssh_hardening_audit_enabled: true
  roles:
    - ssh
```

#### Advanced: Full Hardening with Security Policies

```yaml
---
- hosts: localhost
  vars:
    # Enable hardening
    ssh_hardening_enabled: true
    ssh_hardening_client_enabled: true
    ssh_hardening_server_enabled: true
    
    # Remove weak algorithms
    ssh_hardening_remove_weak_keys: true
    ssh_hardening_remove_dsa: true
    ssh_hardening_remove_ecdsa: false  # Optional: remove ECDSA too
    
    # Security policies
    ssh_hardening_policies_enabled: true
    ssh_hardening_configure_fail2ban: true
    ssh_hardening_connection_limits: true
    
    # Security banner
    ssh_hardening_enable_banner: true
    ssh_hardening_banner_content: |
      ******************************************************************
      *                      AUTHORIZED ACCESS ONLY                    *
      *            All activity is monitored and logged                *
      ******************************************************************
    
    # Audit configuration
    ssh_hardening_audit_enabled: true
    
    # Server restrictions
    ssh_hardening_permit_root_login: "no"
    ssh_hardening_server_password_auth: "no"  # Keys only!
    ssh_hardening_max_auth_tries: 3
    
  roles:
    - ssh
```

### Hardening Configuration Variables

#### Main Controls

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_enabled` | `false` | Master switch for all hardening |
| `ssh_hardening_client_enabled` | `false` | Enable client-side hardening |
| `ssh_hardening_server_enabled` | `false` | Enable server-side hardening |
| `ssh_hardening_audit_enabled` | `false` | Validate configuration after applying |

#### Cryptographic Algorithms (Client & Server)

Modern, secure algorithms are enforced by default:

```yaml
# Key Exchange Algorithms
ssh_hardening_kex_algorithms: "curve25519-sha256,curve25519-sha256@libssh.org,..."

# Ciphers
ssh_hardening_ciphers: "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,..."

# MACs
ssh_hardening_macs: "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,..."

# Public Key Types
ssh_hardening_pubkey_types: "ssh-ed25519,rsa-sha2-512,rsa-sha2-256,..."
```

#### Authentication Settings (Server)

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_permit_root_login` | `prohibit-password` | Root login mode (yes/no/prohibit-password/forced-commands-only) |
| `ssh_hardening_server_password_auth` | `yes` | Allow password authentication |
| `ssh_hardening_pubkey_authentication` | `yes` | Allow public key authentication |
| `ssh_hardening_max_auth_tries` | `3` | Max authentication attempts |
| `ssh_hardening_login_grace_time` | `60` | Seconds to authenticate |

#### Security Features (Server)

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_x11_forwarding` | `no` | Allow X11 forwarding |
| `ssh_hardening_allow_tcp_forwarding` | `no` | Allow TCP forwarding |
| `ssh_hardening_allow_agent_forwarding` | `no` | Allow agent forwarding |
| `ssh_hardening_permit_tunnel` | `no` | Allow tunnel device forwarding |
| `ssh_hardening_gateway_ports` | `no` | Allow gateway ports |

#### Weak Key Removal

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_remove_weak_keys` | `false` | Remove weak host key algorithms |
| `ssh_hardening_remove_dsa` | `true` | Remove DSA keys (recommended) |
| `ssh_hardening_remove_ecdsa` | `false` | Remove ECDSA keys (optional) |
| `ssh_hardening_ensure_ed25519` | `true` | Ensure ED25519 key exists |
| `ssh_hardening_ensure_rsa` | `true` | Ensure RSA key exists |

#### Security Policies

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_policies_enabled` | `false` | Enable security policies |
| `ssh_hardening_configure_fail2ban` | `false` | Configure Fail2Ban for SSH |
| `ssh_hardening_configure_pam` | `false` | Configure PAM for SSH |
| `ssh_hardening_connection_limits` | `false` | Enable systemd connection limits |

#### Fail2Ban Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `ssh_hardening_fail2ban_enabled` | `true` | Enable SSH jail in Fail2Ban |
| `ssh_hardening_fail2ban_maxretry` | `3` | Failed attempts before ban |
| `ssh_hardening_fail2ban_findtime` | `600` | Time window for counting failures (seconds) |
| `ssh_hardening_fail2ban_bantime` | `3600` | Ban duration (seconds) |

### Hardening Workflow

1. **Test client-side first** (safe, no sudo required):
   ```yaml
   ssh_hardening_enabled: true
   ssh_hardening_client_enabled: true
   ssh_hardening_audit_enabled: true
   ```

2. **Verify client config**:
   ```bash
   ssh -G localhost  # Test client config
   cat ~/.ssh/config  # Review changes
   ```

3. **Enable server-side** (requires sudo, test on non-production first):
   ```yaml
   ssh_hardening_server_enabled: true
   ```

4. **CRITICAL: Test SSH access before closing current session**:
   ```bash
   # In a NEW terminal window:
   ssh localhost  # Test connection works
   ssh user@yourserver  # Test remote access
   ```

5. **Add security policies** (after testing basic hardening):
   ```yaml
   ssh_hardening_policies_enabled: true
   ssh_hardening_configure_fail2ban: true
   ```

### Security Considerations

#### Before Enabling Server Hardening

⚠️ **CRITICAL WARNINGS:**

1. **Always test in a non-production environment first**
2. **Keep existing SSH session open while testing**
3. **Test new SSH connections in a separate terminal**
4. **Have console/physical access as backup**
5. **Review generated config before applying**: `sshd -T -f /etc/ssh/sshd_config`
6. **Backup is automatic**: Original config saved as `.backup.<timestamp>`

#### Firewall Considerations

If changing SSH port:
```yaml
ssh_hardening_port: 2222
```

Remember to update firewall rules:
```bash
# UFW
sudo ufw allow 2222/tcp

# firewalld
sudo firewall-cmd --add-port=2222/tcp --permanent
sudo firewall-cmd --reload
```

#### Key-Only Authentication

To require keys only (no passwords):
```yaml
ssh_hardening_server_password_auth: "no"
ssh_hardening_permit_empty_passwords: "no"
ssh_hardening_kbd_interactive: "no"
```

**⚠️ Ensure you have working key-based access BEFORE disabling password auth!**

#### Access Control

Restrict SSH access to specific users/groups:
```yaml
ssh_hardening_allow_users:
  - alice
  - bob
ssh_hardening_allow_groups:
  - sshusers
  - admins
```

### Troubleshooting Hardening

#### SSH client connection fails after hardening

Check algorithm mismatch:
```bash
ssh -v user@host 2>&1 | grep -i "algorithm"
```

Temporarily use legacy algorithms:
```bash
ssh -oKexAlgorithms=+diffie-hellman-group14-sha1 user@host
```

#### Locked out of server

1. Use console/physical access
2. Restore backup: `sudo cp /etc/ssh/sshd_config.backup.<timestamp> /etc/ssh/sshd_config`
3. Restart SSH: `sudo systemctl restart sshd`

#### Configuration validation fails

Check syntax:
```bash
# Client
ssh -G localhost

# Server (requires sudo)
sudo sshd -t -f /etc/ssh/sshd_config
```

#### Fail2Ban not working

Check status:
```bash
sudo fail2ban-client status sshd
sudo fail2ban-client get sshd bantime
```

View logs:
```bash
sudo journalctl -u fail2ban -f
```

### Testing Hardening

Run with audit enabled to validate configuration:
```bash
ansible-playbook playbook.yml --tags ssh -e "ssh_hardening_audit_enabled=true"
```

The audit will:
- Validate client config with `ssh -G localhost`
- Validate server config with `sshd -T` (if server hardening enabled)
- Report any configuration errors

### Further Reading

- [Mozilla SSH Guidelines](https://infosec.mozilla.org/guidelines/openssh)
- [SSH Best Practices](https://www.ssh.com/academy/ssh/security)
- [OpenSSH Security Advisories](https://www.openssh.com/security.html)
- [NIST SSH Security](https://nvlpubs.nist.gov/nistpubs/ir/2015/NIST.IR.7966.pdf)

## License

MIT

## Author

Created from dotfile-ansible repository
Refactored for general use with configurable paths and safe defaults
SSH hardening added for enhanced security
