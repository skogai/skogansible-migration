# HISTORICAL REPOS DOMAIN

## OVERVIEW
`docs/repos/` is a historical consolidation reference. It is useful for mining patterns from earlier repositories and dangerous as a source of current paths or current behavior.

## WHERE TO LOOK
| File | Use | Notes |
|---|---|---|
| `CLAUDE.md` | Consolidation strategy | Read first |
| `ANSIBLE-BASE.md` | Large role inventory | Pattern mining only |
| `SETUP.md` | Historical setup approach | Pattern mining only |
| `SKOGANSIBLE.md` | Older current-repo snapshot | Compare carefully against live tree |
| `DOTFILE-ANSIBLE.md`, `DOT_ANSIBLE.md` | Earlier approaches | Reference only |
| `ANSIBLE-COLLECTION-TOOLS.md` | External collection reference | Do not merge blindly |
| `ARCHIVE-2025-10-05-ANSIBLE.md` | Archived multi-OS config | Historical context |

## RULES
- Use this directory to review, compare, and cherry-pick ideas.
- Treat the live repository tree as authoritative when paths disagree.
- Focus on patterns and decisions, not copy-paste imports.

## DO NOT
- Do not use these files as the source of truth for active paths like `playbooks/`, `primitives/`, or `.semaphore/`.
- Do not create implementation changes solely because a historical repo did something differently.
