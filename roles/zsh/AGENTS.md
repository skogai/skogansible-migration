# ZSH ROLE DOMAIN

## OVERVIEW
`roles/zsh/` manages a numbered `zsh.d` tree plus a minimal `.zshrc`. Most of the complexity is in file payload layout, load order, and ownership boundaries.

## WHERE TO LOOK
| Task | Location | Notes |
|---|---|---|
| Orchestrator | `tasks/main.yml` | Thin include wrapper |
| Payload tree | `files/zsh.d/` | Main content surface |
| Loader contract | `files/zsh.d/loader.zsh`, `README.md` | Numbered ordering + `.env` export behavior |
| `.zshrc` deployment | `tasks/deploy_zshrc.yml`, `templates/zshrc.j2` | Keep thin |
| Defaults | `defaults/main.yml`, `../../vars/zsh.yml` | Deployment toggles |

## LOCAL RULES
- Preserve numbered directory ordering (`00-` through `90-`).
- Keep `.zshrc` minimal; the real source of truth is `~/.config/zsh.d/loader.zsh`.
- `.env` payloads are special: they are sourced with `allexport`.
- Package installation belongs to the packages role; this role owns config deployment behavior.

## LOW-SIGNAL AREAS
- `files/zsh.d/completions/` contains bulky completion payloads; treat them as data, not as the main design surface.

## DO NOT
- Do not spread zsh config ownership back into Chezmoi.
- Do not add a second configuration entrypoint that competes with `loader.zsh`.
- Do not over-document individual completion payloads in future child guides.
