---
name: ansible-setup
description: Use when working with the SkogAI Ansible repository - roles, playbooks, configuration, and primitives-based architecture for Arch Linux automation
---

# Ansible Setup Skill

Knowledge of the SkogAI Ansible repository at `/home/skogix/.ansible/` - structure, roles, primitives, and configuration.

## When to Use

Trigger when:

- Working with files in `~/.ansible/` directory
- Questions about the repository structure or specific roles
- Creating or modifying Ansible roles in this repository
- Understanding the primitives-based architecture
- Questions about packages, ssh, git, chezmoi, cloudflared, or other implemented roles
- Working with vars files, vault encryption, or role configuration
- Using git worktrees with worktrunk for development

## Repository Location

**Path**: `/home/skogix/.ansible/`
**Repository**: SkogAI/skogansible

## Core Documentation Files

All comprehensive documentation is in the repository:

- **@/home/skogix/.ansible/CLAUDE.md** - Complete project documentation, all features, usage patterns
- **@/home/skogix/.ansible/FILESTRUCTURE.md** - Complete file structure with descriptions
- **@/home/skogix/.ansible/docs/primitives/ansible-core.md** - 7 fundamental primitives reference
- **@/home/skogix/.ansible/docs/primitives/system-inventory-by-primitives.md** - Complete system roadmap

## Role Documentation

Each role has comprehensive README:

- **@/home/skogix/.ansible/roles/packages/README.md** - Package management (pacman + AUR)
- **@/home/skogix/.ansible/roles/ssh/README.md** - SSH configuration and hardening
- **@/home/skogix/.ansible/roles/git/README.md** - Git configuration
- **@/home/skogix/.ansible/roles/chezmoi/README.md** - Dotfiles management
- **@/home/skogix/.ansible/roles/cloudflared/README.md** - Cloudflare Tunnel

## 7 Fundamental Primitives

All automation breaks down into these patterns (see @docs/primitives/ansible-core.md for examples):

1. **Task Composition** - `include_tasks` for modularity
2. **Package State** - `pacman` module for official packages
3. **AUR Packages** - `kewlfft.aur` module with yay
4. **User Management** - `user` module for creating users
5. **File Content** - `lineinfile` for ensuring file contents
6. **Path Queries** - `stat` + `register` for checking existence
7. **Git Repos** - `git` module for cloning/syncing

## Variable Organization

All role configuration in `vars/` directory:

- `vars/packages.yml` - Package lists
- `vars/ssh.yml`, `vars/ssh_vault.yml` - SSH config (vault encrypted)
- `vars/git.yml` - Git configuration
- `vars/chezmoi.yml` - Chezmoi machine profile
- `vars/cloudflared.yml`, `vars/cloudflared_vault.yml` - Cloudflared config
- `vars/main.yml` - Shared variables

## Essential Commands

```bash
./bootstrap.sh              # Initial setup (venv + ansible)
./run.sh                    # Run all roles
./run.sh --check            # Dry-run
./run.sh --tags ROLE        # Run specific role
./run.sh --tags ROLE --ask-vault-pass  # With vault password

wt switch --create --base master NAME  # Create git worktree
wt step commit              # Commit with AI message
wt merge                    # Merge and cleanup worktree
```

## Key Points

- **Primitives-based**: All tasks use the 7 fundamental patterns
- **Vault encryption**: Secrets in `*_vault.yml` files
- **Git worktrees**: Use worktrunk for isolated development
- **Documentation**: Everything documented in role READMEs and docs/
- **Target**: Arch Linux (adaptable to other distros)

For detailed information on any topic, refer to the documentation files listed above.
