# Primitives Documentation

All documentation related to Ansible primitives, organized for easy navigation.

## Directory Structure

```
docs/
├── active/              # Current active documentation
│   ├── ansible-core.md                      # Reference: 7 fundamental primitives
│   └── system-inventory-by-primitives.md    # Current automation + roadmap
├── archive/             # Historical conceptual documentation
│   ├── PRIMITIVES_README.md                 # Architecture patterns (13KB)
│   ├── ATOMIC_COMPONENTS_README.md          # Component integration (13KB)
│   ├── COMPONENT_BREAKDOWN.md               # Technical deep-dive (16KB)
│   ├── DEPENDENCY_MAP.md                    # Visual dependencies (26KB)
│   ├── INTEGRATION_GUIDE.md                 # Integration planning (11KB)
│   └── CLAUDE.md                            # AI agent guidance (8.5KB)
└── planning/            # Planning and analysis documents
    ├── consolidate-primitives-documentation.md  # Master consolidation plan
    ├── PRIMITIVES_CONSOLIDATION_SUMMARY.md      # Executive summary
    ├── PRIMITIVES_CONSOLIDATION_INDEX.md        # Navigation hub
    ├── PRIMITIVES_CONSOLIDATION_SPECFLOW.md     # SpecFlow analysis
    └── ANALYSIS_COMPLETE.md                     # Complete findings
```

## Quick Links

### For Learning

- **Start here:** [ansible-core.md](active/ansible-core.md) - 7 fundamental primitives with examples
- **System roadmap:** [system-inventory-by-primitives.md](active/system-inventory-by-primitives.md)

### For Planning

- **Consolidation plan:** [planning/consolidate-primitives-documentation.md](planning/consolidate-primitives-documentation.md)
- **Executive summary:** [planning/PRIMITIVES_CONSOLIDATION_SUMMARY.md](planning/PRIMITIVES_CONSOLIDATION_SUMMARY.md)

### For Historical Context

- **Original architecture:** [archive/PRIMITIVES_README.md](archive/PRIMITIVES_README.md)
- **Component patterns:** [archive/ATOMIC_COMPONENTS_README.md](archive/ATOMIC_COMPONENTS_README.md)

## Documentation Status

| Type | Location | Lines | Status |
|------|----------|-------|--------|
| Active reference | active/ | 904 lines | ✅ Current |
| Archive docs | archive/ | 3,014 lines | 📚 Reference |
| Planning | planning/ | 1,600+ lines | 📋 Complete |

**Total:** 5,518+ lines of documentation

## Moving to New Home

This directory is self-contained and can be moved as a unit to its new home (e.g., separate repository, skill directory, or documentation site).

**Suggested locations:**

- `~/dev/ansible-primitives/` - Standalone project
- `~/.claude/skills/ansible-primitives/docs/` - Claude Code skill
- `~/skogai/primitives/` - SkogAI ecosystem

**Related directories:**

- `../` (primitives implementation) - Working YAML primitives (1,131 lines)
- `../examples/` - Example playbooks demonstrating usage

---

**Last Updated:** 2025-12-30
**Consolidated From:** 3 separate locations (docs/primitives, docs/archive/primitives, root planning docs)
