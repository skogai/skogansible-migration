# system-services role

manages system-level services and configurations.

## features

- **cloudflared**: secure tunnel token management using ansible-vault

## usage

### cloudflared secure token setup

1. extract your current token:
```bash
sudo grep "token" /etc/systemd/system/cloudflared.service
```

2. create a vault file:
```bash
mkdir -p group_vars/localhost
cat > group_vars/localhost/vault.yml <<EOF
---
cloudflared_token: "your-actual-token-here"
EOF
```

3. encrypt the vault:
```bash
ansible-vault encrypt group_vars/localhost/vault.yml
```

4. run the playbook:
```bash
ansible-playbook playbook.yml --ask-vault-pass --tags cloudflared
```

## security notes

- the cloudflared token is **never** stored in plaintext in git
- token file is owned by root with mode 0600
- token is not logged during ansible runs (no_log: true)
- systemd service references token file, not inline token

## variables

| variable | default | description |
|----------|---------|-------------|
| `cloudflared_enabled` | `true` | enable cloudflared configuration |
| `cloudflared_token` | `""` | tunnel token (should be in vault) |
