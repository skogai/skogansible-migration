# Ansible Documentation

Documentation for the Ansible Arch Linux automation system.

## Quick Links

### Essential Documentation
- **[../CLAUDE.md](../CLAUDE.md)** - Complete project documentation
- **[../README.md](../README.md)** - Project overview and quick start
- **[../FILESTRUCTURE.md](../FILESTRUCTURE.md)** - Complete file structure

### Security Documentation 🔒
- **[SECURITY.md](SECURITY.md)** - Security best practices and credential management
- **[SECURITY_ASSESSMENT.md](SECURITY_ASSESSMENT.md)** - Security audit report (2025-12-25)
- **[SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)** - Quick security validation checklist

### Role Documentation
- **[../roles/packages/README.md](../roles/packages/README.md)** - Package management
- **[../roles/ssh/README.md](../roles/ssh/README.md)** - SSH configuration
- **[../roles/git/README.md](../roles/git/README.md)** - Git configuration
- **[../roles/chezmoi/README.md](../roles/chezmoi/README.md)** - Chezmoi dotfiles

## Structure

```
docs/
├── README.md                                       # This file
├── SECURITY.md                                     # Security best practices guide
├── SECURITY_ASSESSMENT.md                          # Security audit report
├── SECURITY_CHECKLIST.md                           # Security validation checklist
├── primitives/
│   ├── ansible-core.md                             # Reference: 7 fundamental patterns
│   └── system-inventory-by-primitives.md           # Roadmap: System organized by primitives
└── repos/
    └── CLAUDE.md                                   # Historical repository documentation
```

## Documents

### Security Documentation 🔒

#### SECURITY.md
Comprehensive security guide covering:
- Credential management (vault, passwords, keys)
- Ansible Vault usage and best practices
- Password file setup and permissions
- SSH key security and deployment
- Semaphore UI security configuration
- Security best practices
- Incident response procedures
- Secrets rotation schedule

#### SECURITY_ASSESSMENT.md
Detailed security audit report (2025-12-25) with:
- Executive summary of security posture
- Critical, high, medium, and low priority findings
- Security best practices already implemented
- Recommended fixes and improvements
- Compliance and standards alignment
- Action items organized by priority
- Testing and validation procedures

#### SECURITY_CHECKLIST.md
Quick reference checklist for:
- Pre-deployment security checks
- Post-change validation
- Monthly security audits
- Quarterly and annual security tasks
- Quick command references
- Red flags to watch for
- Incident response procedures

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
5. **Follow security best practices from `SECURITY.md`**
6. **Run security checklist from `SECURITY_CHECKLIST.md` before committing**

## Security Best Practices

Before making any changes:
1. Review [SECURITY.md](SECURITY.md) for credential handling
2. Check [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) for validation steps
3. Never commit unencrypted secrets or password files
4. Always use `no_log: true` for sensitive operations
5. Verify vault files are encrypted before committing

---

**Last Updated:** 2025-12-25
**Review Frequency:** Monthly
**Next Review:** 2026-01-25
