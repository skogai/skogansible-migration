# SEMAPHORE DOMAIN

## OVERVIEW
`.semaphore/` is a small but security-sensitive operational surface for the Semaphore UI.

## WHERE TO LOOK
| File | Purpose | Notes |
|---|---|---|
| `README.md` | Setup + security warnings | Read first |
| `docker-compose.yml` | Runtime definition | Uses `.env`, `config.json`, and `./data` volume |
| `.env.example` | Template only | Copy to `.env`, then change credentials |
| `config.json` | Semaphore config payload | Mounted into the container |

## RULES
- Never commit `.env`.
- Never reuse the old admin password noted in `README.md`; generate a new one.
- Keep `.env` at `0600`.
- Treat `./data/` as persistent state even though it is not committed.

## OPERATIONS
- Start with `docker compose up -d` from this directory.
- Ports are defined here (`9005:3000` in the current compose file).
- Public access assumptions belong here, not in unrelated roles.

## DO NOT
- Do not spread Semaphore-specific rules into `vars/` or unrelated roles.
- Do not document this path as `semaphore/`; the live path is `.semaphore/`.
