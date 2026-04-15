# ROLES DOMAIN

## OVERVIEW
`roles/` contains the active implementation surface: one directory per role, each with its own defaults, tasks, handlers, templates, and README.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Repo role pattern | `roles/_template/` | Use as structure reference |
| Shared role rules | `../RULES.md` | Naming, tags, defaults, privilege escalation |
| Current roles | `users/`, `packages/`, `ssh/`, `git/`, `chezmoi/`, `zsh/`, `cloudflared/`, `filesystems/` | `_template/` is reference only |
| Heavily specialized roles | `ssh/`, `zsh/` | Each has its own child `AGENTS.md` |

## ROLE RULES
- Every role needs `README.md`.
- Feature flags live in `defaults/main.yml`, not scattered through tasks.
- `tasks/main.yml` is the orchestrator; prefer `include_tasks` to keep units small.
- Role tags are mandatory on every task; feature tags are additive.
- Keep secrets in `vars/*_vault.yml` or vaulted files, never plaintext role files.
- Shared values should flow from `vars/main.yml` through role vars/defaults instead of being duplicated per role.

## WHAT BELONGS HERE
- Role layout rules common to all roles.
- When to add a new role versus extend an existing one.
- README, defaults, tag, and task-orchestration conventions.

## WHAT DOES NOT
- Do not create `AGENTS.md` under `tasks/`, `defaults/`, `templates/`, `handlers/`, or `meta/`.
- Do not repeat repo-wide law already covered by `../AGENTS.md` unless a role subtree has an explicit exception.

## LOCAL EXCEPTIONS
- `ssh/` has unusual security, vault, backup, and hardening behavior.
- `zsh/` has unusual file-payload and loader behavior.
- Other roles are covered by this file plus their README/defaults/tasks.
