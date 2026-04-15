# PRIMITIVES DOMAIN

## OVERVIEW
`primitives/` is the reusable building-block layer. Keep primitives atomic, composable, and safe to call from multiple roles.

## STRUCTURE
```text
primitives/
├── ensure_state/
├── ensure_content/
├── query_state/
├── sync/
├── execute/
├── compose/
└── docs/
```

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Philosophy + examples | `README.md` | Canonical primitive usage guide |
| Active reference docs | `docs/active/` | Current reference material |
| Planning docs | `docs/planning/` | Roadmap, consolidation work |
| Archived docs | `docs/archive/` | Historical only |
| Example composition | `compose/aur_setup.yml` | Shows primitive-on-primitive composition |

## RULES
- Prefer primitives for repeated low-level operations across roles.
- Use prefixed variables (`package_*`, `file_*`, `query_*`, `exec_*`) to avoid collisions.
- Prefer idempotent modules over manual imperative checks.
- New primitives should be narrow and reusable, not role-specific business logic.
- If an existing primitive can be extended safely, extend it instead of cloning behavior.

## DOC BOUNDARIES
- `docs/active/` is current reference.
- `docs/planning/` is design work, not implementation truth.
- `docs/archive/` is historical context only.

## DO NOT
- Do not turn `primitives/` into a second `roles/` tree.
- Do not encode personal machine assumptions directly into generic primitives.
- Do not create child `AGENTS.md` files under primitive category leaves unless this subtree grows much larger.
