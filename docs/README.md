# Ansible Documentation

Documentation for the Ansible Arch Linux automation system.

## Structure

```
docs/
├── README.md                                       # This file
└── primitives/
    ├── ansible-core.md                             # Reference: 7 fundamental patterns
    └── system-inventory-by-primitives.md           # Roadmap: System organized by primitives
```

## Documents

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

- `roles/ssh/README.md` - Complete SSH role documentation
- `roles/git/README.md` - Complete Git role documentation
- `CLAUDE.md` - Project overview and usage guide

## Contributing

When adding new automation:

1. Use primitives from `primitives/ansible-core.md`
2. Update `primitives/system-inventory-by-primitives.md` to mark features as implemented
3. Document role-specific details in role README files
4. Keep variable organization in role-specific `vars/*.yml` files
