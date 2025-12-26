# Ansible Documentation

Documentation for the Ansible Arch Linux automation system.

## Quick Links

### Essential Documentation

- **[../CLAUDE.md](../CLAUDE.md)** - Complete project documentation
- **[../README.md](../README.md)** - Project overview and quick start
- **[../FILESTRUCTURE.md](../FILESTRUCTURE.md)** - Complete file structure
- **[../RULES.md](../RULES.md)** - Security rules and development patterns
- **[COMPOSITION.md](COMPOSITION.md)** - Composition layer and profile orchestration
- **[TESTING_PROFILES.md](TESTING_PROFILES.md)** - Testing guide for profile combinations

### Role Documentation

- **[../roles/packages/README.md](../roles/packages/README.md)** - Package management
- **[../roles/ssh/README.md](../roles/ssh/README.md)** - SSH configuration
- **[../roles/git/README.md](../roles/git/README.md)** - Git configuration
- **[../roles/chezmoi/README.md](../roles/chezmoi/README.md)** - Chezmoi dotfiles

## Structure

```
docs/
├── README.md                                       # This file
├── COMPOSITION.md                                  # Composition layer architecture
├── TESTING_PROFILES.md                             # Profile testing guide
├── primitives/
│   ├── ansible-core.md                             # Reference: 7 fundamental patterns
│   └── system-inventory-by-primitives.md           # Roadmap: System organized by primitives
└── repos/
    └── CLAUDE.md                                   # Historical repository documentation
```

## Documents

### COMPOSITION.md

**Purpose:** Architecture documentation for the composition layer that orchestrates roles

**Use cases:**

- Understanding profile-based role selection
- Learning role dependency management
- Designing conditional role inclusion
- Using tag-based execution control

**Content:**

- Four machine profiles (workstation, laptop, server, WSL)
- Role dependency declaration patterns
- Conditional role inclusion with `when` clauses
- Hierarchical tag structure
- Playbook organization by profile
- Role composition patterns
- Best practices and guidelines

### TESTING_PROFILES.md

**Purpose:** Comprehensive testing guide for profile combinations

**Use cases:**

- Validating composition layer changes
- Testing profile-specific playbooks
- Verifying conditional inclusion logic
- Running regression tests

**Content:**

- Syntax validation tests
- Dry-run testing procedures
- Task listing verification
- Tag testing at all hierarchy levels
- Profile-specific test checklists
- Integration testing with containers/VMs
- Troubleshooting common issues
- CI/CD integration examples

### primitives/ansible-core.md

**Purpose:** Reference documentation for the 7 fundamental Ansible primitives

**Use cases:**

- Learning Ansible building blocks through working examples
- Quick syntax lookup when writing new tasks
- Understanding how complex operations decompose into primitives

**Content:**

- Task composition (include_tasks)
- Package management (pacman)
- AUR package management (kewlfft.aur)
- User management
- File content management (lineinfile)
- Path state queries (stat + register)
- Git repository management
- Arbitrary command execution
- Path deletion

All examples are taken directly from this codebase's working roles.

### primitives/system-inventory-by-primitives.md

**Purpose:** Complete system inventory and automation expansion roadmap

**Use cases:**

- Understanding current automation coverage
- Planning future role implementations
- System disaster recovery planning
- Identifying configuration gaps

**Content:**

- Current implementation status (packages, ssh, git, chezmoi roles)
- Expansion roadmap organized by the 7 primitives
- Complete system configuration inventory (477 packages, services, configs)
- Variable data structures for future implementation
- Next steps for achieving complete automation

**Status tracking:**

- ✅ marks implemented features
- → marks planned features

## Role Documentation

For detailed role-specific documentation, see:

- `roles/packages/README.md` - Package management (pacman + AUR)
- `roles/ssh/README.md` - SSH configuration and key deployment
- `roles/git/README.md` - Git configuration and repository management
- `roles/chezmoi/README.md` - Chezmoi dotfiles management
- `CLAUDE.md` - Complete project overview and usage guide

## Contributing

When adding new automation:

1. Use primitives from `primitives/ansible-core.md`
2. Update `primitives/system-inventory-by-primitives.md` to mark features as implemented
3. Document role-specific details in role README files
4. Keep variable organization in role-specific `vars/*.yml` files
5. Follow security rules and development patterns in `../RULES.md`

---

**Last Updated:** 2025-12-26
