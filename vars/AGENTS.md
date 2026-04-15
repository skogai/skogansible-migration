# VARS DOMAIN

## OVERVIEW
`vars/` is the live configuration surface. `main.yml` holds shared cross-role values; per-role files tune behavior; `*_vault.yml` stores encrypted secrets.

## WHERE TO LOOK
| File | Purpose | Notes |
|---|---|---|
| `main.yml` | Shared source of truth | User identity, common paths, machine type |
| `<role>.yml` | Role-specific live config | Examples: `packages.yml`, `ssh.yml`, `git.yml` |
| `<role>_vault.yml` | Encrypted secrets | Must stay vaulted |
| `cloudflared_vault.yml.template` | Template only | Use to create encrypted real file |
| `semaphore.sqlite` | Local artifact | Do not treat as source-of-truth config |

## RULES
- Keep cross-role values in `main.yml`.
- Keep role-specific toggles and lists in the role file, not in `main.yml`.
- Vault files must stay encrypted with ansible-vault.
- If a value is uncertain, update `../docs/SETTINGS_DECISIONS.md` instead of guessing.

## COMMON CASES
- `ssh.yml` is large and security-sensitive; treat it as live operational config, not example prose.
- `packages.yml` is the package selection surface, including commented candidates and AUR lists.
- `user.yml`, `chezmoi.yml`, `git.yml`, `zsh.yml`, `filesystems.yml`, `cloudflared.yml` are deployment inputs, not generated outputs.

## DO NOT
- Do not commit plaintext secrets or replace vault files with templates.
- Do not treat `semaphore.sqlite` as something to hand-edit.
