# Cloudflared Setup Guide

This guide explains how to set up Cloudflare Tunnel with secure token storage using ansible-vault.

## Overview

The cloudflared role manages Cloudflare Tunnel deployment with:

- **Secure token storage**: Token encrypted with ansible-vault
- **Token-file deployment**: Service uses `--token-file` flag (no plaintext secrets in service files)
- **Restricted permissions**: Token file is 0600, owned by root
- **Service management**: Systemd service enabled and started automatically

## Prerequisites

1. **Cloudflared package installed**: Already included in `vars/packages.yml`
2. **Cloudflare Tunnel created**: Create tunnel in Cloudflare Zero Trust dashboard
3. **Tunnel token obtained**: Copy the token from Cloudflare dashboard

## Quick Start

### 1. Get Your Tunnel Token

1. Go to https://one.dash.cloudflare.com/
2. Navigate to **Networks** → **Tunnels**
3. Create a new tunnel or select an existing one
4. Copy the tunnel token (long alphanumeric string)

### 2. Create Vault File

```bash
# Navigate to ansible directory
cd ~/.ansible

# Copy the template
cp vars/cloudflared_vault.yml.template vars/cloudflared_vault.yml

# Edit and add your token
nano vars/cloudflared_vault.yml
# Replace YOUR_CLOUDFLARE_TUNNEL_TOKEN_HERE with your actual token

# Encrypt the file
ansible-vault encrypt vars/cloudflared_vault.yml
# Enter a strong vault password when prompted
```

### 3. Run the Playbook

```bash
# Run workstation playbook with cloudflared role
./run.sh --tags cloudflared --ask-vault-pass

# Or run full workstation setup
./run.sh --ask-vault-pass
```

## Detailed Setup

### Creating the Vault File

The vault file should contain your tunnel token:

```yaml
---
# vars/cloudflared_vault.yml (before encryption)
cloudflared_tunnel_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

After creating this file, **immediately encrypt it**:

```bash
ansible-vault encrypt vars/cloudflared_vault.yml
```

**Never commit the unencrypted file to git!** The `.gitignore` file already excludes `vars/*_vault.yml` files.

### Vault Password Management

Choose one of these methods:

#### Option 1: Interactive Prompt (Recommended for manual runs)

```bash
./run.sh --tags cloudflared --ask-vault-pass
```

#### Option 2: Vault Password File (Recommended for automation)

```bash
# Create password file
echo "your-strong-vault-password" > ~/.vault_pass
chmod 600 ~/.vault_pass

# Configure ansible to use it
echo "vault_password_file = ~/.vault_pass" >> ansible.cfg

# Now run without --ask-vault-pass
./run.sh --tags cloudflared
```

#### Option 3: Environment Variable

```bash
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass
./run.sh --tags cloudflared
```

### Editing Encrypted Vault File

```bash
# Edit the encrypted file
ansible-vault edit vars/cloudflared_vault.yml

# View without editing
ansible-vault view vars/cloudflared_vault.yml

# Change vault password
ansible-vault rekey vars/cloudflared_vault.yml
```

## Configuration

### Role Variables

Configure in `vars/cloudflared.yml`:

```yaml
# Enable/disable token deployment
cloudflared_deploy_token: true

# Enable/disable service deployment
cloudflared_deploy_service: true
cloudflared_enable_service: true

# Additional arguments
cloudflared_extra_args: ""
```

### Advanced Configuration

For metrics, logging, or other features:

```yaml
# vars/cloudflared.yml
cloudflared_extra_args: "--metrics localhost:8080 --loglevel debug"
```

## Verification

### Check Service Status

```bash
# Check if service is running
sudo systemctl status cloudflared

# View service logs
sudo journalctl -u cloudflared -f

# Check if service is enabled
sudo systemctl is-enabled cloudflared
```

### Check Token File

```bash
# Verify token file exists with correct permissions
sudo ls -la /etc/cloudflared/token
# Should show: -rw------- 1 root root ... /etc/cloudflared/token

# Verify token content (be careful, this shows the token!)
sudo cat /etc/cloudflared/token
```

### Check Service Configuration

```bash
# View service file
sudo systemctl cat cloudflared

# Should show:
# ExecStart=/usr/bin/cloudflared tunnel --no-autoupdate run --token-file /etc/cloudflared/token
# No plaintext token should be visible!
```

## Troubleshooting

### Service Fails to Start

```bash
# Check detailed service status
sudo systemctl status cloudflared -l

# Check logs
sudo journalctl -u cloudflared -n 50 --no-pager

# Common issues:
# 1. Token file doesn't exist: Run playbook with --tags cloudflared-token
# 2. Invalid token: Check token in vault file
# 3. Network issues: Check firewall and network connectivity
```

### Token Not Deployed

```bash
# Check if vault file is encrypted
head -1 vars/cloudflared_vault.yml
# Should show: $ANSIBLE_VAULT;1.1;AES256

# Test vault decryption
ansible-vault view vars/cloudflared_vault.yml

# Run with verbose output
./run.sh --tags cloudflared --ask-vault-pass -vvv
```

### Permission Issues

The role requires sudo for:
- Creating `/etc/cloudflared/` directory
- Writing token file
- Installing systemd service
- Managing service state

Ensure your user has sudo privileges.

## Security Best Practices

1. **Never commit unencrypted tokens** to version control
2. **Use strong vault passwords** (minimum 20 characters, mix of characters)
3. **Rotate tokens regularly** (create new tunnel, update vault file)
4. **Restrict vault password file** permissions (0600)
5. **Use different vault passwords** for different environments (dev/prod)
6. **Audit service configuration** to ensure no plaintext secrets

## Integration with Existing Setup

The cloudflared role integrates with the existing workstation playbook:

```yaml
# playbooks/workstation.yml
vars_files:
  - ../vars/cloudflared_vault.yml  # Encrypted token
  - ../vars/cloudflared.yml        # Configuration

roles:
  - cloudflared                    # After packages, before or after other roles
```

## Updating the Token

To change or rotate your tunnel token:

```bash
# Edit encrypted vault file
ansible-vault edit vars/cloudflared_vault.yml

# Update the token value
cloudflared_tunnel_token: "new-token-here"

# Save and exit

# Re-run the playbook
./run.sh --tags cloudflared --ask-vault-pass

# Service will be restarted with new token
```

## Removing Cloudflared

To remove cloudflared from your system:

```bash
# Stop and disable service
sudo systemctl stop cloudflared
sudo systemctl disable cloudflared

# Remove service file
sudo rm /etc/systemd/system/cloudflared.service
sudo systemctl daemon-reload

# Remove token and config
sudo rm -rf /etc/cloudflared

# Remove package (if desired)
sudo pacman -R cloudflared
```

## Reference

- **Role README**: `roles/cloudflared/README.md`
- **Cloudflare Docs**: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
- **Ansible Vault**: https://docs.ansible.com/ansible/latest/vault_guide/index.html

## Support

For issues or questions:
1. Check this guide and the role README
2. Review service logs: `sudo journalctl -u cloudflared -f`
3. Test vault decryption: `ansible-vault view vars/cloudflared_vault.yml`
4. Run playbook with verbose output: `./run.sh --tags cloudflared -vvv --ask-vault-pass`
