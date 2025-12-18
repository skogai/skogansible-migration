# Repository History Documentation

This directory contains historical documentation from 7 different ansible repositories developed over the past year. These documents are now part of the main/active ansible repository at `/home/skogix/.ansible/`.

## Purpose

This documentation serves as a **consolidation reference** for future work:

1. **Review** - Understand what was built across different ansible iterations
2. **Cherry-pick** - Identify valuable roles, tasks, and patterns worth preserving
3. **Merge** - Integrate the best parts into the current active repository
4. **Remove** - Deprecate and remove old repositories once consolidated

## Historical Repositories

### Active Development (Now Consolidated Here)

**skogansible** (SkogAI/skogansible)
- Primary ansible repository
- Contains: SSH, Git, Chezmoi, Packages roles

**dotfile-ansible** (Skogix/dotfile-ansible)
- Dotfile management via ansible
- Architecture: Primitives-based approach

**setup** (SkogAI/setup)
- System setup and configuration
- Focus: Initial system provisioning

### Supporting Infrastructure

**ansible-base** (SkogAI/ansible-base)
- Base ansible configuration and roles
- Contains: 45 roles (12 core + 34 tools)

**ansible-collection-tools** (den-is/ansible-collection-tools)
- External dependency (den-is)
- Contains: 41 roles (shell, dev, k8s, crypto)
- Note: Upstream maintained, reference only

### Archived/Maintenance

**archive-2025-10-05-ansible** (SkogAI/archive-2025-10-05-ansible)
- Archived multi-OS configuration
- Contains: 30+ roles

**dot_ansible** (Skogix/.ansible)
- Legacy .ansible configuration (11 months old)
- Contains: Backup, file structure, encryption tasks

## Task Inventory Reference

Comprehensive task documentation extracted from all repositories:

| File | Size | Tasks | Description |
|------|------|-------|-------------|
| **ANSIBLE-BASE.md** | 22K | 400+ | Core system setup, 45 roles (12 numbered core + 34 tools) |
| **ANSIBLE-COLLECTION-TOOLS.md** | 26K | 120+ | External tools collection (41 roles: shell, dev, k8s, crypto) |
| **SETUP.md** | 36K | 325 | System setup (12 core numbered + 26 tool/utility roles) |
| **SKOGANSIBLE.md** | 6.2K | 147 | Primary ansible (SSH, Git, Chezmoi, Packages - 4 roles) |
| **DOTFILE-ANSIBLE.md** | 6.8K | 36 | Primitives-based dotfile management architecture |
| **ARCHIVE-2025-10-05-ANSIBLE.md** | 11K | 211 | Archived multi-OS config (30+ roles) |
| **DOT_ANSIBLE.md** | 4.0K | 36 | Legacy .ansible tasks (backup, file structure, encryption) |

**Total**: ~110K documentation covering 1,275+ ansible tasks across all historical repositories.

Task names extracted via `grep "^- name:" --include="*.yml"` pattern.

## Consolidation Strategy

1. **Current State**: All documentation moved to `/home/skogix/.ansible/docs/repos/`
2. **Review Phase**: Read through each .md file to identify useful patterns
3. **Integration Phase**: Cherry-pick valuable roles/tasks into active repo
4. **Cleanup Phase**: Remove old repositories once consolidated
5. **Verification Phase**: Ensure no functionality lost during consolidation

## What to Look For

When reviewing these documents for consolidation:

- **Roles** worth preserving (especially from ansible-base's 45 roles)
- **Task patterns** that could improve current implementation
- **Configuration approaches** that solved specific problems
- **Documentation patterns** worth adopting
- **Primitives-based architecture** from dotfile-ansible
- **Multi-OS support** from archive-2025-10-05-ansible
- **Tooling roles** from ansible-collection-tools (external, reference only)

## Notes

- Multiple overlapping repositories reflect evolution of infrastructure management approach
- This consolidation effort aims to preserve best-of-breed while reducing maintenance burden
- ansible-collection-tools is external (den-is) - reference only, do not merge
- Focus on patterns and approaches, not just copy-paste of roles
- Current active repo is intentionally minimal - expand thoughtfully

---

*Historical snapshot: 2025-12-18*
*Consolidated into: /home/skogix/.ansible/*
*Purpose: Reference for future merge/cherry-pick operations*
