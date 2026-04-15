# PLAYBOOKS DOMAIN

## OVERVIEW
`playbooks/` defines deployment scenarios. These files compose roles, load vars, and set scenario-specific overrides.

## WHERE TO LOOK
| Playbook | Purpose | Notes |
|---|---|---|
| `default.yml` | Current default entrypoint target | Used by `./run.sh` with no args |
| `site.yml` | Full core setup | Main all-in-one scenario |
| `workstation.yml` | Desktop/workstation variant | Includes filesystems; some roles are commented out |
| `bootstrap.yml` | Fresh install bootstrap | Minimal initial setup |
| `maintenance.yml` | Updates only | Overrides package upgrade behavior |
| `example_primitives.yml` | Primitive examples | Reference/example surface |
| `test_users.yml` | Focused role test playbook | Small validation surface |

## RULES
- Use `./run.sh`; it resolves `playbooks/` paths and password-file handling.
- Keep playbooks scenario-oriented. Shared logic belongs in roles or primitives.
- Load `../vars/main.yml` first, then scenario-relevant role vars/vault vars.
- Prefer role composition and small scenario overrides to duplicated task logic.

## GOTCHAS
- Live playbooks are the authority. Some docs summarize them loosely or drift over time.
- Commented-out roles are deliberate; do not assume they should be enabled.
- `maintenance.yml` is the place for maintenance-only overrides like `packages_upgrade_system: true`.

## DO NOT
- Do not add play-level `become`.
- Do not move role-specific defaults into playbooks unless the value is truly scenario-specific.
