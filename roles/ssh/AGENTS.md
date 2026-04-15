# SSH ROLE DOMAIN

## OVERVIEW
`roles/ssh/` is a security-heavy role with full-directory restore, vaulted key deployment, optional backups, and optional hardening.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Main orchestrator | `tasks/main.yml` | Bulk deploy, key deploy, config, backup, hardening hook-in |
| Full-directory restore | `tasks/deploy_ssh_directory.yml`, `files/ssh/` | Vaulted file payloads |
| Hardening | `tasks/hardening.yml`, `README.md` | Disabled by default; test carefully |
| Examples | `examples/` | Scenario samples, not core logic |
| Defaults + vars | `defaults/main.yml`, `vars/main.yml`, `../../vars/ssh.yml` | Live config split |

## LOCAL RULES
- Keep secret-bearing tasks under `no_log: true`.
- Respect permission rules: SSH dir `0700`, private keys `0600`, public keys `0644`, vault password files `0700`.
- Treat `ssh_deploy_full_directory` as a bulk-restore feature; review payloads before expanding it.
- Treat hardening as opt-in and potentially disruptive. Keep existing SSH access open while testing server-side changes.

## GOTCHAS
- Vault password files must be executable or Ansible decryption fails.
- This role mixes two secret models: vaulted variables and vaulted file payloads.
- `setup_with_primitives.yml` is reference/alternate composition, not the only active path.

## DO NOT
- Do not weaken file permissions for convenience.
- Do not enable server hardening casually or without test instructions.
- Do not move generic repo-wide vault guidance here; this file should stay SSH-specific.
