# Ansible Role: Cloudflared

Cloudflare Tunnel management role with proper credential deployment using ansible-vault.

This role provides automated Cloudflare Tunnel deployment including:

- Origin certificate (`cert.pem`) deployment from ansible-vault encrypted files
- Tunnel credentials generation using `cloudflared tunnel token` command
- Proper credential file naming (`{tunnel-id}.json`) for automatic discovery
- Systemd service configuration using `--origincert` and `--cred-file` flags
- Service enablement and management

## Requirements

- Ansible 2.10 or higher
- Target system: Arch Linux (adaptable to other distros)
- Cloudflared package must be installed (included in packages role)
- Cloudflare account with tunnel already created

## Understanding Cloudflare Tunnel Credentials

Cloudflare tunnels require **two** credential files:

### 1. Origin Certificate (`cert.pem`)

- **What it is:** Account-level authentication certificate
- **How to obtain:** Run `cloudflared login` (opens browser, authenticates, saves cert)
- **Location:** `~/.cloudflared/cert.pem`
- **Purpose:** Proves you own the Cloudflare account
- **Security:** Should be vault-encrypted (can manage tunnels, not super-critical but good practice)

### 2. Tunnel Credentials (`{tunnel-id}.json`)

- **What it is:** Specific tunnel's cryptographic credentials
- **How to obtain:** Generated using `cloudflared tunnel token --cred-file` command
- **Location:** `~/.cloudflared/{tunnel-id}.json` (e.g., `ae7fd63a-935f-42b2-b1d0-a53cca0f2798.json`)
- **Purpose:** Contains TunnelSecret, TunnelID, AccountTag
- **Security:** Generated at runtime by this role (not stored in vault)
- **Filename:** Must be `{tunnel-id}.json` for Cloudflare's automatic discovery

**Note:** This role deploys the origin certificate from vault and **generates** the tunnel credentials automatically.

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/cloudflared.yml`.

### User Directory

```yaml
cloudflared_user_dir: "{{ ansible_user_dir }}/.cloudflared"  # User cloudflared directory
cloudflared_user_dir_mode: "0700"                            # Directory permissions
```

### Origin Certificate Management

```yaml
cloudflared_deploy_cert: true                                # Deploy cert.pem from vault
cloudflared_cert_file: "{{ cloudflared_user_dir }}/cert.pem" # Certificate location
cloudflared_cert_mode: "0600"                                # Certificate permissions
```

### Tunnel Credentials

```yaml
cloudflared_generate_creds: true                             # Generate credentials using cloudflared command
cloudflared_force_regenerate_creds: false                    # Force regeneration if file exists
cloudflared_tunnel_name: "skogix"                            # Tunnel name (human-readable)
cloudflared_tunnel_id: ""                                    # Tunnel ID (UUID - set in vars/cloudflared.yml)
cloudflared_creds_file: "{{ cloudflared_user_dir }}/{{ cloudflared_tunnel_id }}.json"  # Credentials file
cloudflared_creds_mode: "0600"                               # Credentials permissions
```

### Service Configuration

```yaml
cloudflared_deploy_service: true                             # Deploy systemd service
cloudflared_service_template: "cloudflared.service.j2"       # Service template
cloudflared_enable_service: true                             # Enable and start service
cloudflared_extra_args: ""                                   # Additional cloudflared arguments
```

## Dependencies

- Cloudflared package (install via packages role or manually)

## Setup Instructions

### 1. Obtain Your Origin Certificate

If you haven't already authenticated with Cloudflare:

```bash
cloudflared login
```

This opens a browser, authenticates you, and saves `~/.cloudflared/cert.pem`.

### 2. Get Your Tunnel ID

Find your tunnel ID from the Cloudflare dashboard:

1. Go to https://one.dash.cloudflare.com/
2. Navigate to Networks → Tunnels
3. Select your tunnel
4. Copy the Tunnel ID (UUID format, e.g., `ae7fd63a-935f-42b2-b1d0-a53cca0f2798`)

Or list tunnels from CLI:

```bash
cloudflared tunnel list
```

### 3. Create and Encrypt Vault File

```bash
# Copy the template
cp vars/cloudflared_vault.yml.template vars/cloudflared_vault.yml

# Edit and add your origin certificate
nano vars/cloudflared_vault.yml

# Copy the content from ~/.cloudflared/cert.pem
cat ~/.cloudflared/cert.pem

# Paste into cloudflared_vault.yml under cloudflared_origin_cert_content

# Encrypt the file with ansible-vault
ansible-vault encrypt vars/cloudflared_vault.yml

# Enter a strong vault password when prompted
```

### 4. Configure Tunnel Settings

Edit `vars/cloudflared.yml`:

```yaml
---
# Tunnel name (human-readable)
cloudflared_tunnel_name: "skogix"

# Tunnel ID (UUID from Cloudflare dashboard)
cloudflared_tunnel_id: "ae7fd63a-935f-42b2-b1d0-a53cca0f2798"
```

### 5. Update Playbook

Add the cloudflared role to your playbook:

```yaml
---
- name: Configure cloudflared tunnel
  hosts: localhost
  connection: local

  vars_files:
    - vars/cloudflared_vault.yml  # Encrypted origin certificate
    - vars/cloudflared.yml        # Tunnel configuration

  roles:
    - cloudflared

  tags:
    - cloudflared
```

### 6. Run the Playbook

```bash
# Run with vault password prompt
ansible-playbook playbook.yml --tags cloudflared --ask-vault-pass

# Or use a vault password file
ansible-playbook playbook.yml --tags cloudflared --vault-password-file ~/.vault_pass
```

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  vars_files:
    - vars/cloudflared_vault.yml
    - vars/cloudflared.yml

  roles:
    - role: cloudflared
```

### Custom Configuration

```yaml
- hosts: localhost
  vars_files:
    - vars/cloudflared_vault.yml

  roles:
    - role: cloudflared
      vars:
        cloudflared_tunnel_name: "my-tunnel"
        cloudflared_tunnel_id: "12345678-1234-1234-1234-123456789abc"
        cloudflared_extra_args: "--metrics localhost:8080"
        cloudflared_enable_service: true
```

### Deploy Certificate Only (No Service)

```yaml
- hosts: localhost
  vars_files:
    - vars/cloudflared_vault.yml

  roles:
    - role: cloudflared
      vars:
        cloudflared_deploy_cert: true
        cloudflared_generate_creds: false
        cloudflared_deploy_service: false
```

## Role Tasks

The role executes tasks in this order:

### 1. User Directory Creation

Creates `~/.cloudflared` directory with restricted permissions (0700, user-owned).

### 2. Origin Certificate Deployment

- Deploys origin certificate from vault to `~/.cloudflared/cert.pem`
- Sets permissions to 0600 (read-only for user)
- Uses `no_log: true` to prevent certificate exposure in logs

### 3. Tunnel Credentials Generation

- Checks if credentials file exists
- Generates credentials using: `cloudflared tunnel token --cred-file ~/.cloudflared/{tunnel-id}.json {tunnel-name}`
- Uses `TUNNEL_ORIGIN_CERT` environment variable to reference cert.pem
- Sets permissions to 0600
- Skips if file exists (unless `cloudflared_force_regenerate_creds: true`)

### 4. Systemd Service Deployment

- Deploys cloudflared.service to `/etc/systemd/system/`
- Service uses `--origincert` and `--cred-file` flags
- Runs as user (not root)
- Enables and starts the service
- Restarts if certificate or credentials changed

## Tags

The role supports granular execution via tags:

- `cloudflared` - All cloudflared tasks
- `cloudflared-config` - Directory creation only
- `cloudflared-cert` - Certificate deployment only
- `cloudflared-vault` - Vault-related tasks
- `cloudflared-creds` - Credential generation only
- `cloudflared-service` - Service deployment and enablement

### Tag Usage Examples

```bash
# Deploy certificate only
ansible-playbook playbook.yml --tags cloudflared-cert --ask-vault-pass

# Generate credentials only (assumes cert already exists)
ansible-playbook playbook.yml --tags cloudflared-creds

# Deploy service only (assumes cert and creds already exist)
ansible-playbook playbook.yml --tags cloudflared-service

# Full deployment
ansible-playbook playbook.yml --tags cloudflared --ask-vault-pass
```

## Security Considerations

### What Gets Encrypted

**Origin Certificate (`cert.pem`):**

- Stored in `vars/cloudflared_vault.yml` (ansible-vault encrypted)
- Can manage tunnels for your account
- Not super-critical (can't access account settings) but good practice to encrypt

**Tunnel Credentials:**

- NOT stored in vault (generated at runtime)
- Lives at `~/.cloudflared/{tunnel-id}.json` in plaintext
- This is **intentional** - Cloudflare expects this file to be readable by the daemon
- Limited blast radius: compromised credentials only affect this one tunnel
- Easy to rotate: just delete file and regenerate

### File Permissions

Default permissions follow security best practices:

- `~/.cloudflared/` directory: `0700` (rwx------)
- `~/.cloudflared/cert.pem`: `0600` (rw-------)
- `~/.cloudflared/{tunnel-id}.json`: `0600` (rw-------)
- All owned by user (not root)

### Why Not Run as Root?

Previous implementations ran cloudflared as root. This role runs as user because:

- Cloudflared doesn't require root privileges
- Reduces attack surface
- Credentials stored in user's home directory
- Follows principle of least privilege

## Troubleshooting

### Service Fails to Start

Check credentials exist and have correct permissions:

```bash
ls -la ~/.cloudflared/
# Should show:
# -rw------- 1 user user ... cert.pem
# -rw------- 1 user user ... {tunnel-id}.json

# Check service status
systemctl --user status cloudflared

# Check service logs
journalctl --user -u cloudflared -f
```

### Certificate Not Deployed

Ensure vault file is properly encrypted and loaded:

```bash
# Verify vault file is encrypted
head -1 vars/cloudflared_vault.yml
# Should show: $ANSIBLE_VAULT;1.1;AES256

# Test vault decryption
ansible-vault view vars/cloudflared_vault.yml

# Run playbook with increased verbosity
ansible-playbook playbook.yml --tags cloudflared --ask-vault-pass -vvv
```

### Credentials Not Generated

Check cloudflared command works manually:

```bash
# Ensure cert.pem exists
ls -la ~/.cloudflared/cert.pem

# Try generating manually
cloudflared tunnel token --cred-file ~/.cloudflared/test.json your-tunnel-name

# Check tunnel exists
cloudflared tunnel list
```

### Wrong Credentials Filename

If credentials file has wrong name (e.g., `skogix.pem` instead of `{tunnel-id}.json`):

1. Update `cloudflared_tunnel_id` in `vars/cloudflared.yml` with correct UUID
2. Delete old credentials file
3. Re-run playbook: `./run.sh --tags cloudflared-creds`

### Permission Denied Errors

The role uses `become: true` for systemd service management only:

- Creating `~/.cloudflared/` - user permissions (no sudo)
- Writing cert.pem - user permissions (no sudo)
- Generating credentials - user permissions (no sudo)
- Installing systemd service - requires sudo
- Managing service state - requires sudo

If you get permission errors, check your user can use sudo:

```bash
sudo -v
```

## Vault Management

### Editing Encrypted Vault File

```bash
# Edit existing encrypted file
ansible-vault edit vars/cloudflared_vault.yml

# View encrypted file content
ansible-vault view vars/cloudflared_vault.yml

# Change vault password
ansible-vault rekey vars/cloudflared_vault.yml
```

### Using Vault Password File

```bash
# Create vault password file
echo "your-vault-password" > ~/.vault_pass
chmod 600 ~/.vault_pass

# Use in playbook runs
ansible-playbook playbook.yml --vault-password-file ~/.vault_pass

# Or set in ansible.cfg
# [defaults]
# vault_password_file = ~/.vault_pass
```

## File Structure

```
roles/cloudflared/
├── defaults/
│   └── main.yml              # Default variables
├── tasks/
│   └── main.yml              # Main task file
├── templates/
│   └── cloudflared.service.j2 # Systemd service template
├── handlers/
│   └── main.yml              # Service restart handler
├── meta/
│   └── main.yml              # Role metadata
└── README.md                 # This file
```

## Integration with Playbook

Add cloudflared role to your main playbook:

```yaml
---
- name: System configuration
  hosts: localhost
  connection: local

  vars_files:
    - vars/main.yml
    - vars/packages.yml
    - vars/ssh_vault.yml
    - vars/ssh.yml
    - vars/git.yml
    - vars/chezmoi.yml
    - vars/cloudflared_vault.yml  # Add this
    - vars/cloudflared.yml        # Add this

  roles:
    - packages
    - ssh
    - git
    - chezmoi
    - cloudflared  # Add this

  tags:
    - all
```

## Further Reading

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [Cloudflared CLI Reference](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/tunnel-guide/)
- [Ansible Vault Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

## License

MIT

## Author

SkogAI (skogansible repository)
