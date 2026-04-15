# PROJECT KNOWLEDGE BASE

**Generated:** 2026-04-15T17:58:01+02:00
**Commit:** f5a84a5
**Branch:** master

## OVERVIEW
Arch Linux workstation automation via Ansible. Live entrypoint is `./run.sh`; active domains are roles, primitives, playbooks, vars, and Semaphore config.

## READ ORDER
1. Read this file for repo-wide rules.
2. Then read the nearest child `AGENTS.md` in the area you are editing.
3. Prefer the live tree over older docs when they disagree.

## STRUCTURE
```text
./
├── roles/        # Active role implementations; main change surface
├── primitives/   # Reusable atomic task building blocks
├── playbooks/    # Deployment scenarios and role composition
├── vars/         # Shared + role-specific configuration, including vaults
├── .semaphore/   # Semaphore UI config; security-sensitive
└── docs/repos/   # Historical repo docs; reference only
```

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Run automation | `run.sh`, `playbooks/*.yml` | `run.sh` prepends `playbooks/` and injects password files |
| Repo-wide standards | `RULES.md` | Canonical naming, tags, defaults, vault rules |
| Project context | `CLAUDE.md` | Broad repo behavior and operational notes |
| Shared settings | `vars/main.yml` | Source of truth for cross-role values |
| Unresolved config | `docs/SETTINGS_DECISIONS.md` | Add questions here; do not guess |
| Validation workflow | `.config/wt.toml`, `.pre-commit-config.yaml` | Worktrunk hooks + pre-commit checks |
| Historical patterns | `docs/repos/` | Reference only; not authoritative for live paths |

## GLOBAL RULES
- Use `./run.sh`; do not invent alternate repo-local execution wrappers.
- `become: true` is task-level only. Never add play-level or playbook-level `become`.
- Task names use `"ROLE | Description"`.
- Tags use kebab-case, bracket format, and every task gets at least the role tag.
- Feature flags live in `roles/<role>/defaults/main.yml` with explanatory comments.
- Shared cross-role values belong in `vars/main.yml`.
- If a config value is unclear, add a question to `docs/SETTINGS_DECISIONS.md` instead of guessing.
- Treat `vars/*vault*.yml` as encrypted-only. Sensitive tasks should use `no_log: true`.

## ACTIVE DOMAINS
- `roles/` — active implementation work; read `roles/AGENTS.md` first.
- `primitives/` — shared atomic building blocks; read `primitives/AGENTS.md` first.
- `playbooks/` — scenario composition; read `playbooks/AGENTS.md` first.
- `vars/` — live config surface; read `vars/AGENTS.md` first.
- `.semaphore/` — standalone operational surface with secrets; read `.semaphore/AGENTS.md` first.

## REFERENCE-ONLY DOMAIN
- `docs/repos/` is historical consolidation material. Useful for pattern mining, dangerous as current truth.

## VALIDATION COMMANDS
```bash
./run.sh --syntax-check
./run.sh --check
pre-commit run --all-files
file vars/*vault*.yml
```

## IGNORE OR DOWN-WEIGHT
- `.claude/skills/*/references/` — large reference payloads, not active repo logic.
- `tmp/`, `.direnv/`, `.git/`, `.worktrees/`, collection caches — runtime/generated/vendor.
- `roles/zsh/files/zsh.d/completions/` — low-signal completion payloads.
- `docs/archive/` — archive, not active implementation guidance.

## NOTES
- Some overview docs drift from the live tree. Example: prefer `primitives/docs/` over stale `docs/primitives/` references.
- `.semaphore/` is the live path; do not write guidance against nonexistent `semaphore/`.
- Children should add only local rules, entrypoints, and ignore-zones. If guidance applies to siblings, it belongs higher in the tree.
