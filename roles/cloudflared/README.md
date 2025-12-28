# Ansible Role: Cloudflared

Cloudflare Tunnel management role with secure token storage using ansible-vault.

This role provides automated Cloudflare Tunnel deployment including:

- Secure token storage in ansible-vault encrypted files
- Token file deployment with restricted permissions (0600)
- Systemd service configuration using token-file (no plaintext tokens in service files)
- Service enablement and management

## Role Variables

All role variables are defined in `defaults/main.yml` with sensible defaults. Override them in your playbook, inventory, or `vars/cloudflared.yml`.

### Configuration Directory

```yaml
cloudflared_config_dir: "/etc/cloudflared"      # Configuration directory
cloudflared_config_dir_mode: "0700"             # Directory permissions
```

### Token Management

```yaml
cloudflared_deploy_token: true                  # Deploy token from vault
cloudflared_token_file: "/etc/cloudflared/token" # Token file location
cloudflared_token_mode: "0600"                  # Token file permissions (read-only for root)
cloudflared_token: "{{ cloudflared_tunnel_token | default('') }}"  # Token from vault
```

### Service Configuration

```yaml
cloudflared_deploy_service: true                # Deploy systemd service
cloudflared_service_template: "cloudflared.service.j2"  # Service template
cloudflared_enable_service: true                # Enable and start service
cloudflared_extra_args: ""                      # Additional cloudflared arguments
```

## Setup Instructions

### 1. Obtain Your Tunnel Token

Get your tunnel token from the Cloudflare Zero Trust dashboard:

1. Go to https://one.dash.cloudflare.com/
2. Navigate to Networks → Tunnels
3. Create or select your tunnel
4. Copy the tunnel token (long alphanumeric string)

### 2. Create and Encrypt Vault File

```bash
# Copy the template
cp vars/cloudflared_vault.yml.template vars/cloudflared_vault.yml

# Edit and add your token
nano vars/cloudflared_vault.yml
# Replace YOUR_CLOUDFLARE_TUNNEL_TOKEN_HERE with your actual token

# Encrypt the file with ansible-vault
ansible-vault encrypt vars/cloudflared_vault.yml

# Enter a strong vault password when prompted
```

### 3. Update Playbook

Add the cloudflared role to your playbook:

```yaml
---
- name: Configure cloudflared tunnel
  hosts: localhost
  connection: local

  vars_files:
    - vars/cloudflared_vault.yml  # Encrypted token
    - vars/cloudflared.yml        # Configuration

  roles:
    - cloudflared

  tags:
    - cloudflared
```

### 4. Run the Playbook

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
        cloudflared_extra_args: "--metrics localhost:8080"
        cloudflared_enable_service: true
```

### Deploy Token Only (No Service)

```yaml
- hosts: localhost
  vars_files:
    - vars/cloudflared_vault.yml

  roles:
    - role: cloudflared
      vars:
        cloudflared_deploy_token: true
        cloudflared_deploy_service: false
```

## Role Tasks

The role executes tasks in this order:

### 1. Configuration Directory Creation

Creates `/etc/cloudflared` directory with restricted permissions (0700, root-owned).

### 2. Token Deployment

- Deploys tunnel token from vault to `/etc/cloudflared/token`
- Sets permissions to 0600 (read-only for root)
- Uses `no_log: true` to prevent token exposure in logs

### 3. Systemd Service Deployment

- Deploys cloudflared.service to `/etc/systemd/system/`
- Service uses `--token-file` flag (no plaintext token in service file)
- Enables and starts the service

## Tags

The role supports granular execution via tags:

- `cloudflared` - All cloudflared tasks
- `cloudflared-config` - Configuration directory setup
- `cloudflared-token` - Token deployment only
- `cloudflared-vault` - Vault-related tasks
- `cloudflared-service` - Service deployment and enablement

### Tag Usage Examples

```bash
# Deploy token only
ansible-playbook playbook.yml --tags cloudflared-token --ask-vault-pass

# Deploy service only (assumes token already exists)
ansible-playbook playbook.yml --tags cloudflared-service

# Full deployment
ansible-playbook playbook.yml --tags cloudflared --ask-vault-pass
```

## Security Considerations

### Token Storage

1. **Never commit unencrypted tokens** to version control
2. **Always use ansible-vault** to encrypt `vars/cloudflared_vault.yml`
3. **Use strong vault passwords** (consider using a password manager)
4. **Store vault password securely** (e.g., in `~/.vault_pass` with 0600 permissions)

### File Permissions

Default permissions follow security best practices:

- `/etc/cloudflared/` directory: `0700` (rwx------)
- `/etc/cloudflared/token` file: `0600` (rw-------)
- Both owned by root:root

### Service Configuration

- Uses `--token-file` flag instead of inline token
- Service file contains no secrets
- Runs as root (required by cloudflared for network operations)

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

## Troubleshooting

### Service Fails to Start

Check the token file exists and has correct permissions:

```bash
sudo ls -la /etc/cloudflared/token
# Should show: -rw------- 1 root root ... /etc/cloudflared/token

# Check service status
sudo systemctl status cloudflared

# Check service logs
sudo journalctl -u cloudflared -f
```

### Token File Not Created

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

### Permission Denied Errors

The role requires `become: true` (sudo) for system-level operations:

- Creating `/etc/cloudflared/` directory
- Writing token file
- Installing systemd service
- Managing service state

These operations are automatically elevated with `become: true` in the tasks.

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
