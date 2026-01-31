# Plan: Consolidate Primitives Documentation

## Overview

Consolidate scattered primitives documentation across 3 locations (active docs, archived docs, implementation) into a unified, discoverable reference system that serves both learning and implementation needs.

**Type:** Documentation Enhancement
**Complexity:** Medium (documentation organization + content migration)
**Estimated Effort:** 65-90 hours over 5 weeks
**Success Probability:** 90%

## Problem Statement

**Current Pain Points:**

Users must search **3 separate locations** to understand primitives:

- `/docs/primitives/` - Active reference docs (23KB, 2 files)
- `/docs/archive/primitives/` - Conceptual architecture (88KB, 6 files)
- `/primitives/` - Implementation + inline docs (22KB README + 23 YAML files)

**Consequences:**

- **40-60% documentation duplication** across locations
- **2-5 minute reference lookups** (should be < 30 seconds)
- **Scattered learning path** (2-3 hours to understand basics)
- **High maintenance burden** (update 3 places for each change)
- **Poor discoverability** (users don't know what exists)

## Proposed Solution

Create a **unified primitives documentation system** organized by use case:

```
docs/primitives/
├── README.md                          # Navigation hub (NEW)
├── reference/
│   ├── quick-reference.md            # Fast syntax lookup (NEW)
│   ├── ansible-core.md               # Enhanced 7 primitives guide (EXISTING)
│   └── parameters.md                 # Complete parameter reference (NEW)
├── learning/
│   ├── getting-started.md            # Zero to first primitive (NEW)
│   ├── concepts.md                   # Architecture & philosophy (MIGRATED)
│   └── patterns.md                   # Common composition patterns (NEW)
├── implementation/
│   ├── integration-guide.md          # Using primitives in roles (MIGRATED)
│   ├── component-breakdown.md        # Technical deep-dive (MIGRATED)
│   └── examples/                     # Working playbooks (LINKED)
├── planning/
│   ├── system-inventory.md           # Current + roadmap (EXISTING, enhanced)
│   └── dependency-map.md             # Visual relationships (MIGRATED)
└── archive/
    └── historical-architecture.md    # Preserve context (CONSOLIDATED)
```

**Key Improvements:**

- **Single entry point** (`docs/primitives/README.md`)
- **Use-case organized** (learning vs reference vs implementation)
- **< 5% duplication** (down from 40-60%)
- **Fast lookup** (< 30 sec for any primitive syntax)
- **Clear learning path** (getting-started → concepts → patterns → integration)

## Technical Approach

### Phase 1: Analysis & Planning ✅ COMPLETE

**Deliverables:**

- [x] Current state assessment (4 analysis documents, 70KB)
- [x] Content inventory (11 files, 4,704 lines catalogued)
- [x] SpecFlow scenarios (7 scenarios with Given/When/Then)
- [x] Unified structure design
- [x] Migration plan

**Status:** Complete (this document is the output)

### Phase 2: Content Migration (Week 2, 20-30 hours)

**Tasks:**

**2.1 Create Navigation Hub**

```markdown
docs/primitives/README.md
├── What are Ansible Primitives?
├── Quick Links (by use case)
│   ├── Learning → getting-started.md
│   ├── Reference → quick-reference.md
│   ├── Implementation → integration-guide.md
│   └── Planning → system-inventory.md
├── All 7 Primitives (summary table)

├── How to Use This Documentation
└── Related Resources
```

**Files to create:**

- `docs/primitives/README.md` (new navigation hub)

**2.2 Build Learning Path**

```markdown
docs/primitives/learning/
├── getting-started.md (NEW)
│   ├── Zero to First Primitive (30 min tutorial)
│   ├── Install packages primitive
│   ├── Deploy SSH config primitive
│   └── Test locally
├── concepts.md (MIGRATED from archive/PRIMITIVES_README.md)
│   ├── Why primitives matter (DRY, composability)
│   ├── Architecture layers (playbooks → roles → primitives → modules)
│   ├── Data/logic separation
│   └── When to use each primitive

└── patterns.md (NEW, extracted from archive/ATOMIC_COMPONENTS_README.md)
    ├── Common compositions (AUR setup, SSH deployment)
    ├── Role integration patterns
    └── Anti-patterns
```

**Files to create:**

- `docs/primitives/learning/getting-started.md` (new tutorial)
- `docs/primitives/learning/concepts.md` (migrate + enhance from archive)
- `docs/primitives/learning/patterns.md` (extract from archive)

**2.3 Enhance Reference Documentation**

```markdown
docs/primitives/reference/
├── quick-reference.md (NEW - cheat sheet)
│   ├── All 7 primitives on one page
│   ├── Syntax tables
│   ├── Common parameters
│   └── Quick examples
├── ansible-core.md (EXISTING - enhance)
│   ├── Add Parameters section per primitive
│   ├── Add Attributes/Capabilities table
│   ├── Add Return Values documentation
│   ├── Add Notes/Gotchas

│   └── Expand examples
└── parameters.md (NEW - comprehensive reference)
    ├── All parameters for each primitive
    ├── Type, default, choices

    ├── Platform compatibility
    └── Version information
```

**Files to create:**

- `docs/primitives/reference/quick-reference.md` (new cheat sheet)
- `docs/primitives/reference/parameters.md` (comprehensive parameter docs)

**Files to enhance:**

- `docs/primitives/reference/ansible-core.md` (add sections per Ansible module docs pattern)

**2.4 Migrate Implementation Guides**

```markdown
docs/primitives/implementation/
├── integration-guide.md (MIGRATED from archive/INTEGRATION_GUIDE.md)
│   ├── Using primitives in roles

│   ├── Step-by-step integration
│   ├── Variable naming conventions
│   └── Best practices
├── component-breakdown.md (MIGRATED from archive/COMPONENT_BREAKDOWN.md)
│   ├── Technical deep-dive

│   ├── Real role examples (bash, nvim, ssh)
│   └── Composition strategies
└── examples/ (SYMLINK to /primitives/examples/)
    └── Link to working playbooks
```

**Files to create:**

- `docs/primitives/implementation/integration-guide.md` (migrate from archive)
- `docs/primitives/implementation/component-breakdown.md` (migrate from archive)
- `docs/primitives/implementation/examples` (symlink to `/primitives/examples/`)

**2.5 Enhance Planning Documentation**

```markdown
docs/primitives/planning/
├── system-inventory.md (EXISTING - enhance)

│   ├── Current implementation (✅ marks)
│   ├── Expansion roadmap (→ marks)
│   ├── Add progress metrics (47/477 packages automated)

│   └── Link to dependency-map.md
└── dependency-map.md (MIGRATED from archive/DEPENDENCY_MAP.md)
    ├── Visual dependency graphs
    ├── Primitive relationships
    └── Integration paths
```

**Files to enhance:**

- `docs/primitives/planning/system-inventory.md` (add metrics, cross-links)

**Files to create:**

- `docs/primitives/planning/dependency-map.md` (migrate from archive)

**2.6 Consolidate Archive**

```markdown
docs/primitives/archive/
└── historical-architecture.md (CONSOLIDATED from 6 archive files)
    ├── Context: Why this was archived
    ├── Original 7-layer architecture
    ├── Scale rationale (100+ components)
    ├── Lessons learned
    └── Links to current implementation
```

**Files to create:**

- `docs/primitives/archive/historical-architecture.md` (consolidate 6 archive files)

**Effort:** 20-30 hours

- Navigation hub: 2-3 hours
- Learning path: 6-8 hours
- Reference enhancement: 6-8 hours
- Implementation migration: 4-6 hours

- Planning enhancement: 2-3 hours
- Archive consolidation: 2-3 hours

### Phase 3: Integration & Linking (Week 3, 15-20 hours)

**Tasks:**

**3.1 Cross-Link All Documents**

- Add navigation breadcrumbs to each doc

- Cross-reference between learning/reference/implementation
- Link examples to primitives they demonstrate
- Link role READMEs to relevant primitive docs

**3.2 Update Implementation README**

- `/primitives/README.md` - Add clear link to `/docs/primitives/`
- Simplify to focus on "how to use primitives" not "what primitives are"
- Reference `/docs/primitives/reference/ansible-core.md` for concepts

**3.3 Create Quick Navigation**

- Add table of contents to all long docs
- Add "Related Reading" sections

- Create cheat sheet (`quick-reference.md`)

**3.4 Update Project Root Documentation**

- `CLAUDE.md` - Update primitives section with new structure
- `FILESTRUCTURE.md` - Document new `/docs/primitives/` organization
- `docs/README.md` - Update primitives documentation section

**Effort:** 15-20 hours

- Cross-linking: 8-10 hours

- Implementation README update: 2-3 hours
- Navigation aids: 3-4 hours
- Root doc updates: 2-3 hours

### Phase 4: Validation & Testing (Week 4, 20-25 hours)

**Tasks:**

**4.1 SpecFlow Scenario Testing**

Test all 7 scenarios from SpecFlow analysis:

**Scenario 1: Learning User Journey**

```gherkin
Given a developer new to Ansible primitives
When they read docs/primitives/learning/getting-started.md
Then they should understand all 7 primitives within 2 hours
  And be able to write their first primitive-based component
  And know where to find reference documentation

```

**Test method:** Have a colleague (or AI agent) follow the tutorial cold

**Scenario 2: Quick Reference Lookup**

```gherkin
Given an experienced developer implementing a new role
When they need syntax for the ensure_content primitive
Then they should find it in < 30 seconds using quick-reference.md

  And the syntax should include parameters and example
```

**Test method:** Time yourself looking up each primitive

**Scenario 3: Dependency Discovery**

```gherkin
Given a developer planning a new component
When they check docs/primitives/planning/dependency-map.md

Then they should see which primitives the component needs
  And understand integration dependencies
```

**Test method:** Pick a component from system-inventory and trace dependencies

**Scenario 4: Documentation Maintenance**

```gherkin
Given a maintainer updating primitive behavior

When they update the implementation in /primitives/
Then they should know which docs to update (< 3 locations)
  And updates should take < 30 minutes
```

**Test method:** Simulate a parameter change and track update locations

**Scenario 5: Discoverability & Navigation**

```gherkin
Given a user landing on docs/primitives/README.md
When they want to learn about [any primitive]
Then they should find the right document in < 2 clicks
  And the document should match their use case (learning vs reference)
```

**Test method:** Test navigation from README to each primitive

**Scenario 6: Edge Cases & Gaps**

```gherkin
Given a developer using primitives on [platform]
When they check platform compatibility in reference/parameters.md
Then they should know if the primitive is supported
  And find any platform-specific gotchas
```

**Test method:** Check parameter docs for platform notes

**Scenario 7: AI Agent Guidance**

```gherkin
Given an AI agent assisting with Ansible automation
When it reads docs/primitives/archive/historical-architecture.md
Then it should understand the architecture evolution
  And know to reference current docs, not archived patterns
```

**Test method:** Have Claude Code agent verify it understands current vs archive

**4.2 Acceptance Criteria Verification**

Verify all 8 acceptance criteria:

| Criterion | Test | Pass/Fail |
|-----------|------|-----------|
| AC1: Single unified reference | Count doc locations (should be 1: `/docs/primitives/`) | ⏳ |

| AC2: Clear learning path | Follow getting-started.md → concepts.md → patterns.md | ⏳ |
| AC3: Fast reference access | Time lookups for all 7 primitives (should be < 30 sec each) | ⏳ |
| AC4: Comprehensive integration guide | Verify integration-guide.md covers all role integration patterns | ⏳ |
| AC5: Dependency mapping | Check dependency-map.md has all primitive relationships | ⏳ |
| AC6: Maintenance reduction | Count update locations for sample change (should be < 3) | ⏳ |
| AC7: Searchability & navigation | Test navigation from README to each primitive (< 2 clicks) | ⏳ |
| AC8: Backward compatibility | Verify old links still work (or redirect) | ⏳ |

**4.3 User Testing**

- **Learning Path Test:** Have someone new follow getting-started.md and measure:
  - Time to complete (should be < 2 hours)
  - Number of confusions/questions
  - Success at writing first primitive

- **Reference Test:** Give experienced user tasks requiring syntax lookup:
  - Measure lookup time (should be < 30 seconds)
  - Check if they found correct information
  - Ask about clarity/completeness

**4.4 Documentation Quality Check**

- [ ] All links work (no 404s)
- [ ] Code examples are valid YAML
- [ ] Inline code uses proper syntax highlighting

- [ ] Cross-references are accurate
- [ ] No duplicate content (< 5%)
- [ ] Breadcrumb navigation on all pages
- [ ] Table of contents on long docs

**Effort:** 20-25 hours

- SpecFlow scenario testing: 10-12 hours
- Acceptance criteria verification: 4-5 hours
- User testing: 4-6 hours
- Quality check: 2-3 hours

### Phase 5: Deployment & Cleanup (Week 5, 10-15 hours)

**Tasks:**

**5.1 Archive Old Documentation**

- Move `/docs/archive/primitives/` contents to `/docs/primitives/archive/historical-architecture.md`
- Add deprecation notice to old archive location
- Keep files for 1 release cycle (then delete)

**5.2 Update All References**

- Search codebase for links to old archive docs
- Update to new structure
- Add redirects where needed

**5.3 Announcement & Communication**

- Update CHANGELOG with documentation improvements
- Create migration guide for users
- Announce in project communication channels

**5.4 Post-Deployment Monitoring**

- Track documentation access patterns (which pages most visited)
- Collect user feedback
- Measure lookup times
- Monitor for broken links

**5.5 Final Cleanup**

- Delete deprecated files after 1 release cycle
- Archive migration plan (this document)
- Update project roadmap

**Effort:** 10-15 hours

- Archive migration: 3-4 hours
- Reference updates: 3-4 hours
- Communication: 2-3 hours
- Monitoring setup: 1-2 hours
- Cleanup: 1-2 hours

## Acceptance Criteria

### Functional Requirements

- [x] **AC1: Single unified reference location** - All primitives docs in `/docs/primitives/`
  - Test: Verify `/docs/primitives/` contains all documentation
  - Test: Verify no duplication in `/docs/archive/primitives/` (moved to single archive file)

- [ ] **AC2: Clear learning path** - Getting started → concepts → patterns → integration
  - Test: New user can follow path and understand primitives in < 2 hours
  - Test: Each step links to next step

- [ ] **AC3: Fast reference access** - Any primitive syntax lookup in < 30 seconds
  - Test: Time 10 random primitive lookups (all should be < 30 sec)
  - Test: `quick-reference.md` has all 7 primitives on one page

- [ ] **AC4: Comprehensive integration guide** - Using primitives in roles documented
  - Test: `integration-guide.md` covers all integration patterns
  - Test: Examples link to working playbooks

- [ ] **AC5: Dependency mapping** - Visual relationships between primitives
  - Test: `dependency-map.md` shows how primitives compose
  - Test: System inventory links to dependency map

- [ ] **AC6: Maintenance reduction** - < 3 locations to update for any change
  - Test: Simulate parameter change and count update locations
  - Test: Each primitive has single source of truth

- [ ] **AC7: Searchability & navigation** - Find any primitive doc in < 2 clicks
  - Test: From README, click to each primitive (max 2 clicks)
  - Test: Breadcrumb navigation works

- [ ] **AC8: Backward compatibility** - Old links still work or redirect
  - Test: Old archive links redirect or show deprecation notice
  - Test: All role READMEs link to correct new locations

### Quality Gates

- [ ] **Zero broken links** - All internal links resolve
- [ ] **< 5% duplication** - Minimal repeated content
- [ ] **All examples valid** - Code examples are runnable YAML
- [ ] **Consistent formatting** - Follow markdown conventions
- [ ] **Accessibility** - Clear headings, alt text for diagrams

## Success Metrics

### Quantitative Metrics

| Metric | Before | Target | Measurement |
|--------|--------|--------|-------------|
| **Doc locations** | 3 (active, archive, impl) | 1 (`/docs/primitives/`) | Count directories |
| **Total lines** | 4,704 | 3,500 (-26%) | Line count |
| **Duplication** | 40-60% | < 5% | Content analysis |
| **Reference lookup time** | 2-5 min | < 30 sec | User timing tests |
| **Learning time** | 2-3 hours | 2 hours | Tutorial completion |
| **Update locations** | 3+ places | < 3 places | Simulate change |

### Qualitative Metrics

- **User satisfaction:** Survey users on documentation clarity
- **Discoverability:** Track which pages users find most helpful
- **Maintenance burden:** Measure time to update docs for changes
- **Onboarding speed:** Track new contributor time to first primitive

## Dependencies & Prerequisites

### Prerequisites

- [x] SpecFlow analysis complete (4 documents, 70KB)
- [x] Current state documented (file inventory)
- [x] Unified structure designed
- [ ] Stakeholder approval on structure

### Dependencies

**Internal:**

- Access to all 3 doc locations (read/write)
- Approval to reorganize `/docs/primitives/` structure
- Time to test with actual users

**External:**

- None (pure documentation work)

### Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Breaking old links** | High | Medium | Keep archive with deprecation notice for 1 release |
| **User confusion during transition** | Medium | High | Clear migration guide + announcement |
| **Incomplete migration** | High | Low | Comprehensive content inventory + checklist |
| **Scope creep** | Medium | Medium | Stick to 5-phase plan, defer enhancements |
| **Time overrun** | Low | Medium | Phased approach allows adjustment |

## Resource Requirements

### Team

- **Documentation lead** (65-90 hours over 5 weeks)
- **Reviewer** (10-15 hours for quality checks)
- **Test user** (2-4 hours for learning path validation)

### Tools

- Git for version control
- Markdown editor
- Link checker tool
- Time tracking for measurements

### Timeline

| Week | Phase | Effort | Deliverables |
|------|-------|--------|--------------|
| **Week 1** | Analysis & Planning | Done | ✅ This plan document |
| **Week 2** | Content Migration | 20-30h | New structure + migrated content |

| **Week 3** | Integration & Linking | 15-20h | Cross-linked, navigable docs |
| **Week 4** | Validation & Testing | 20-25h | All ACs verified, user tested |
| **Week 5** | Deployment & Cleanup | 10-15h | Live, old docs archived |

**Total:** 5 weeks, 65-90 hours

## Future Considerations

### Extensibility

This structure supports future additions:

- `/docs/primitives/advanced/` - Complex composition patterns
- `/docs/primitives/reference/module-comparison.md` - Ansible module vs primitive choice
- `/docs/primitives/troubleshooting/` - Common issues and solutions

### Maintenance

- **Quarterly review** - Check for broken links, outdated examples
- **Release updates** - Update when primitives change
- **User feedback** - Incorporate suggestions for clarity

### Integration

- **Auto-generated docs** - Consider extracting parameter docs from primitive YAML
- **Interactive examples** - Add runnable code snippets with asciinema
- **Search functionality** - Add site search for large doc sets

## MVP

### Minimal Viable Documentation (Week 2 only)

If we need to ship faster, Week 2 alone provides 80% of value:

**Essential Deliverables:**

- `docs/primitives/README.md` (navigation hub)
- `docs/primitives/reference/quick-reference.md` (cheat sheet)
- Enhanced `docs/primitives/reference/ansible-core.md` (parameter docs)
- `docs/primitives/learning/getting-started.md` (tutorial)

**Defer to later:**

- Comprehensive migration (keep archive as-is)
- Extensive testing (basic link checks only)
- Formal deployment (soft launch)

**MVP Benefits:**

- Single entry point (README)
- Fast reference (quick-reference.md)
- Learning path (getting-started.md)
- Enhanced reference (ansible-core.md)

**MVP Effort:** 20-30 hours (Week 2 only)

### Example Files

#### docs/primitives/README.md (navigation hub)

```markdown
# Ansible Primitives Documentation

Complete guide to the 7 fundamental Ansible primitives used throughout this repository.

## What are Ansible Primitives?

Primitives are atomic, reusable Ansible task patterns that form the building blocks of all automation in this project. Every complex operation decomposes into these 7 primitives:

| Primitive | Purpose | Example |
|-----------|---------|---------|
| **ensure_state** | Make resources exist with properties | Install packages, create users, enable services |
| **ensure_content** | Make files contain specific content | Deploy configs, templates, SSH keys |
| **query_state** | Check current state before decisions | File exists check, service status |
| **sync** | Synchronize remote resources | Git clone/pull repositories |
| **execute** | Run arbitrary commands | Build packages, run scripts |
| **compose** | Orchestrate primitives together | Complete AUR setup, SSH deployment |
| **update_cache** | Special package operations | Update pacman cache, system upgrade |

## Quick Links

### 🎓 Learning Primitives
- **[Getting Started](learning/getting-started.md)** - Zero to first primitive (30 min tutorial)
- **[Core Concepts](learning/concepts.md)** - Why primitives matter, architecture layers
- **[Common Patterns](learning/patterns.md)** - Composition strategies, anti-patterns

### 📖 Reference Documentation
- **[Quick Reference](reference/quick-reference.md)** - Cheat sheet (< 30 sec lookup)
- **[Ansible Core Primitives](reference/ansible-core.md)** - Detailed 7 primitives guide
- **[Parameters](reference/parameters.md)** - Complete parameter reference

### 🔧 Implementation Guides
- **[Integration Guide](implementation/integration-guide.md)** - Using primitives in roles
- **[Component Breakdown](implementation/component-breakdown.md)** - Technical deep-dive
- **[Examples](implementation/examples/)** - Working playbooks

### 📋 Planning & Roadmap
- **[System Inventory](planning/system-inventory.md)** - Current automation + expansion roadmap
- **[Dependency Map](planning/dependency-map.md)** - Visual primitive relationships

### 📚 Archive
- **[Historical Architecture](archive/historical-architecture.md)** - Original conceptual design

## How to Use This Documentation

**If you're new to Ansible primitives:**

1. Read [Getting Started](learning/getting-started.md) (30 min)
2. Understand [Core Concepts](learning/concepts.md) (30 min)
3. Study [Common Patterns](learning/patterns.md) (1 hour)
4. Follow [Integration Guide](implementation/integration-guide.md) to build your first component

**If you need quick syntax:**
- Use [Quick Reference](reference/quick-reference.md) cheat sheet (< 30 sec)
- See [Ansible Core Primitives](reference/ansible-core.md) for examples

**If you're implementing a new role:**
- Check [System Inventory](planning/system-inventory.md) for what needs automation
- Review [Dependency Map](planning/dependency-map.md) for primitive relationships
- Follow [Integration Guide](implementation/integration-guide.md) patterns
- Use [Examples](implementation/examples/) as templates

## All 7 Primitives Summary

### 1. ENSURE_STATE (Resource Existence)


**Purpose:** Make resources exist with specific properties

**Use cases:** Packages, users, services, directories

**Location:** `/primitives/ensure_state/`

**Quick example:**
```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_name: git
    package_state: present
```

**Learn more:** [ensure_state reference](reference/ansible-core.md#1-ensure_state)

### 2. ENSURE_CONTENT (File Content Management)

**Purpose:** Make files contain specific content

**Use cases:** Config files, templates, SSH keys, gitignore

**Location:** `/primitives/ensure_content/`

**Quick example:**

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: ssh_config.j2
    template_dest: ~/.ssh/config
    template_mode: '0600'
```

**Learn more:** [ensure_content reference](reference/ansible-core.md#2-ensure_content)

### 3. QUERY_STATE (Check Current State)

**Purpose:** Discover state before making decisions

**Use cases:** File existence checks, conditional execution

**Location:** `/primitives/query_state/`

**Quick example:**

```yaml
- include_tasks: primitives/query_state/path_exists.yml
  vars:
    path_to_check: /usr/bin/yay
    path_register_var: yay_exists

- debug:
    msg: "yay is {{ 'installed' if yay_exists.stat.exists else 'not installed' }}"
```

**Learn more:** [query_state reference](reference/ansible-core.md#3-query_state)

### 4. SYNC (Remote Resource Synchronization)

**Purpose:** Clone/update git repositories

**Use cases:** Git repos, dotfiles, custom scripts

**Location:** `/primitives/sync/`

**Quick example:**

```yaml
- include_tasks: primitives/sync/git_repo.yml
  vars:
    git_repo: https://github.com/user/repo.git
    git_dest: ~/projects/repo
    git_version: main
```

**Learn more:** [sync reference](reference/ansible-core.md#4-sync)

### 5. EXECUTE (Arbitrary Commands)

**Purpose:** Run commands with idempotency

**Use cases:** Build packages, run scripts, complex operations

**Location:** `/primitives/execute/`

**Quick example:**

```yaml
- include_tasks: primitives/execute/command.yml
  vars:
    command_cmd: makepkg -si --noconfirm
    command_chdir: /tmp/build
    command_creates: /usr/bin/mypackage
```

**Learn more:** [execute reference](reference/ansible-core.md#5-execute)

### 6. COMPOSE (Task Orchestration)

**Purpose:** Combine primitives for complex operations

**Use cases:** AUR setup, SSH deployment, multi-step workflows

**Location:** `/primitives/compose/`

**Quick example:**

```yaml
- include_tasks: primitives/compose/aur_setup.yml
  # Orchestrates: user creation + yay install + package installation
```

**Learn more:** [compose reference](reference/ansible-core.md#6-compose)

### 7. UPDATE_CACHE / UPGRADE (Package Operations)

**Purpose:** Update package databases and upgrade systems

**Use cases:** Pacman cache updates, system upgrades

**Location:** Implicit in `ensure_state/package.yml`

**Quick example:**

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_update_cache: true
    package_upgrade: true
```

**Learn more:** [update_cache reference](reference/ansible-core.md#7-update_cache)

## Related Resources

- **[CLAUDE.md](../../CLAUDE.md)** - Project overview and philosophy
- **[FILESTRUCTURE.md](../../FILESTRUCTURE.md)** - Complete file structure
- **[Role READMEs](../../roles/)** - Role-specific documentation
  - [packages](../../roles/packages/README.md) - Package management
  - [ssh](../../roles/ssh/README.md) - SSH configuration
  - [git](../../roles/git/README.md) - Git configuration
  - [chezmoi](../../roles/chezmoi/README.md) - Dotfiles management

## Contributing

When updating primitives:

1. Update primitive implementation in `/primitives/`
2. Update reference docs in `docs/primitives/reference/`
3. Update examples in `docs/primitives/implementation/examples/`
4. Run link checker to verify no broken references

See [Integration Guide](implementation/integration-guide.md) for detailed contribution workflow.

---

**Last Updated:** 2025-12-30
**Version:** 1.0 (Consolidated structure)

```

#### docs/primitives/reference/quick-reference.md (cheat sheet)

```markdown
# Primitives Quick Reference

**Purpose:** Fast syntax lookup for all 7 Ansible primitives (< 30 seconds)

## 1. ENSURE_STATE (Resource Existence)

### Package Management

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_name: git                    # Required: package name or list
    package_state: present               # Optional: present (default), latest, absent
    package_update_cache: true           # Optional: update pacman cache (default: false)
    package_upgrade: false               # Optional: upgrade all packages (default: false)
```

### User Management

```yaml
- include_tasks: primitives/ensure_state/user.yml
  vars:
    user_name: myuser                    # Required: username
    user_group: wheel                    # Optional: primary group
    user_shell: /bin/zsh                 # Optional: default shell
    user_create_home: true               # Optional: create home dir (default: true)
    user_comment: "My User"              # Optional: comment/description
```

### Service Management

```yaml
- include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: sshd                   # Required: service name
    service_enabled: true                # Optional: enable on boot (default: false)
    service_state: started               # Optional: started, stopped, restarted, reloaded
    service_daemon_reload: false         # Optional: reload systemd (default: false)
```

## 2. ENSURE_CONTENT (File Content)

### Template Deployment

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:
    template_src: myconfig.j2            # Required: template file (in role/templates/)
    template_dest: /etc/myapp/config     # Required: destination path
    template_mode: '0644'                # Optional: file permissions
    template_owner: root                 # Optional: file owner
    template_group: root                 # Optional: file group
    template_backup: true                # Optional: backup before replace (default: false)
    template_validate: 'myapp -t %s'     # Optional: validation command
    template_notify: restart myapp       # Optional: handler to notify
    template_become: true                # Optional: run as root (default: false)
```

### Line in File

```yaml
- include_tasks: primitives/ensure_content/ensure_line.yml
  vars:
    line_path: /etc/environment          # Required: file path
    line_content: "EDITOR=nvim"          # Required: line to ensure exists
    line_regexp: '^EDITOR='              # Optional: regex to match existing line
    line_create: true                    # Optional: create file if missing (default: false)
    line_mode: '0644'                    # Optional: file permissions if created
    line_validate: 'source %s'           # Optional: validation command
    line_become: true                    # Optional: run as root (default: false)
```

### Block in File

```yaml
- include_tasks: primitives/ensure_content/ensure_blockinfile.yml
  vars:
    block_path: /etc/hosts               # Required: file path
    block_content: |                     # Required: block content
      192.168.1.10 server1
      192.168.1.11 server2
    block_marker: "# {mark} ANSIBLE MANAGED BLOCK"  # Optional: marker format
    block_create: true                   # Optional: create file if missing
    block_mode: '0644'                   # Optional: file permissions if created
    block_become: true                   # Optional: run as root (default: false)
```

### File Copy

```yaml
- include_tasks: primitives/ensure_content/file_copy.yml
  vars:
    file_src: myfile.conf                # Required: source file (in role/files/)
    file_dest: /etc/myapp/myfile.conf    # Required: destination path
    file_mode: '0644'                    # Optional: file permissions
    file_owner: root                     # Optional: file owner
    file_group: root                     # Optional: file group
    file_backup: true                    # Optional: backup before replace
    file_become: true                    # Optional: run as root (default: false)
```

## 3. QUERY_STATE (Check State)

### Path Exists Check

```yaml

- include_tasks: primitives/query_state/path_exists.yml
  vars:
    path_to_check: /usr/bin/yay          # Required: path to check
    path_register_var: yay_stat          # Required: variable name to register result

# Use result:
- debug:
    msg: "Path exists: {{ yay_stat.stat.exists }}"

- name: Conditional based on path
  command: /usr/bin/yay --version
  when: yay_stat.stat.exists
```

## 4. SYNC (Git Repositories)

```yaml
- include_tasks: primitives/sync/git_repo.yml
  vars:
    git_repo: https://github.com/user/repo.git  # Required: git URL
    git_dest: ~/projects/repo            # Required: local path
    git_version: main                    # Optional: branch/tag/commit (default: HEAD)
    git_update: true                     # Optional: update if exists (default: true)
    git_depth: 0                         # Optional: shallow clone depth (default: full)
    git_key_file: ~/.ssh/id_ed25519      # Optional: SSH key for private repos
    git_accept_hostkey: true             # Optional: auto-accept SSH key
```

## 5. EXECUTE (Commands)

```yaml
- include_tasks: primitives/execute/command.yml
  vars:
    command_cmd: makepkg -si --noconfirm  # Required: command to run
    command_chdir: /tmp/build            # Optional: working directory
    command_creates: /usr/bin/mypackage  # Optional: skip if file exists (idempotency)
    command_removes: /tmp/trigger        # Optional: skip unless file exists
    command_become: false                # Optional: run as root (default: false)
    command_become_user: builder         # Optional: run as specific user
```

## 6. COMPOSE (Orchestration)

### AUR Setup (Complete)

```yaml
- include_tasks: primitives/compose/aur_setup.yml
  # No variables needed - uses defaults from vars/packages.yml
  # Orchestrates: aur_builder user + yay install + AUR packages
```

**Customization:**

```yaml
- include_tasks: primitives/compose/aur_setup.yml
  vars:
    aur_builder_user: custom_builder     # Optional: override builder username
    aur_packages: [yay, google-chrome]   # Optional: override package list
```

## 7. UPDATE_CACHE / UPGRADE

**Note:** These are options in the package primitive, not separate primitives.

### Update Cache Only

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_update_cache: true
```

### Upgrade All Packages

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_upgrade: true
```

### Update Cache + Upgrade + Install

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_name: [git, vim, htop]
    package_update_cache: true
    package_upgrade: true
```

---

## Common Patterns

### Install Package + Enable Service

```yaml
- include_tasks: primitives/ensure_state/package.yml
  vars:
    package_name: sshd

- include_tasks: primitives/ensure_state/service.yml
  vars:
    service_name: sshd
    service_enabled: true
    service_state: started
```

### Deploy Config + Restart Service

```yaml
- include_tasks: primitives/ensure_content/ensure_template.yml
  vars:

    template_src: sshd_config.j2
    template_dest: /etc/ssh/sshd_config
    template_mode: '0600'
    template_validate: 'sshd -t -f %s'
    template_notify: restart sshd
    template_become: true
```

### Check Path + Conditional Command

```yaml
- include_tasks: primitives/query_state/path_exists.yml
  vars:
    path_to_check: /usr/bin/yay
    path_register_var: yay_stat

- include_tasks: primitives/execute/command.yml
  vars:
    command_cmd: yay -S --noconfirm google-chrome
  when: yay_stat.stat.exists
```

---

## Variable Naming Convention

All primitives use **prefixed variables** to prevent conflicts:

| Primitive | Prefix | Examples |
|-----------|--------|----------|
| package | `package_` | `package_name`, `package_state`, `package_update_cache` |
| user | `user_` | `user_name`, `user_group`, `user_shell` |
| service | `service_` | `service_name`, `service_enabled`, `service_state` |
| template | `template_` | `template_src`, `template_dest`, `template_mode` |
| line | `line_` | `line_path`, `line_content`, `line_regexp` |
| block | `block_` | `block_path`, `block_content`, `block_marker` |
| file | `file_` | `file_src`, `file_dest`, `file_mode` |
| git | `git_` | `git_repo`, `git_dest`, `git_version` |
| command | `command_` | `command_cmd`, `command_chdir`, `command_creates` |
| path | `path_` | `path_to_check`, `path_register_var` |

---

## Related Documentation

- **[Ansible Core Primitives](ansible-core.md)** - Detailed guide with notes and gotchas
- **[Parameters Reference](parameters.md)** - Complete parameter documentation
- **[Getting Started](../learning/getting-started.md)** - Tutorial for beginners
- **[Integration Guide](../implementation/integration-guide.md)** - Using in roles

---

**Last Updated:** 2025-12-30

```

## References & Research

### Internal References

**Current Documentation:**
- `/docs/primitives/ansible-core.md:1` - Current primitives reference
- `/docs/primitives/system-inventory-by-primitives.md:1` - System inventory + roadmap
- `/primitives/README.md:1` - Implementation documentation

**Archived Documentation:**
- `/docs/archive/primitives/PRIMITIVES_README.md:1` - Architecture patterns
- `/docs/archive/primitives/ATOMIC_COMPONENTS_README.md:1` - Component integration
- `/docs/archive/primitives/COMPONENT_BREAKDOWN.md:1` - Technical deep-dive
- `/docs/archive/primitives/DEPENDENCY_MAP.md:1` - Visual dependencies
- `/docs/archive/primitives/INTEGRATION_GUIDE.md:1` - Integration planning
- `/docs/archive/primitives/CLAUDE.md:1` - AI agent guidance

**Project Standards:**
- `/RULES.md:1` - Task naming, tags, variable organization
- `/CLAUDE.md:1` - Project overview
- `/FILESTRUCTURE.md:1` - File structure documentation

### External References

**Ansible Documentation Best Practices:**
- [Ansible Best Practices Documentation](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html)
- [Ansible in 2025: Best Practices for Configuration and Provisioning](https://www.gocodeo.com/post/ansible-in-2025-best-practices-for-configuration-and-provisioning)
- [Red Hat Good Practices Guide](https://redhat-cop.github.io/automation-good-practices/)
- [Ansible Module Architecture Documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_program_flow_modules.html)

**Infrastructure as Code Best Practices:**
- [7 Essential Infrastructure as Code Best Practices for 2025](https://blog.mergify.com/infrastructure-as-code-best-practices/)
- [Infrastructure as Code Best Practices - Harness](https://www.harness.io/harness-devops-academy/infrastructure-as-code-best-practices)
- [Infrastructure as Code - Red Hat](https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac)

### Research Findings

**SpecFlow Analysis Documents** (created during planning):
- `PRIMITIVES_CONSOLIDATION_SUMMARY.md` - Executive summary (12KB, 256 lines)
- `PRIMITIVES_CONSOLIDATION_INDEX.md` - Navigation hub (12KB, 386 lines)
- `PRIMITIVES_CONSOLIDATION_SPECFLOW.md` - Complete technical analysis (28KB, 812 lines)
- `ANALYSIS_COMPLETE.md` - Comprehensive findings (15KB)

**Total research output:** 70KB, 1,600+ lines

### Related Work

**Current Implementation:**
- All 7 primitives implemented in `/primitives/` (1,131 lines YAML)
- 6 roles actively using primitives (packages, ssh, git, chezmoi, zsh, cloudflared)
- 6 example playbooks demonstrating usage

**Historical Context:**
- 7-layer architecture designed for 100+ component scale
- Data/logic separation philosophy
- Component-based feature bundles

---

**Plan Created:** 2025-12-30
**Author:** Claude Sonnet 4.5
**Research Basis:** Repository exploration + SpecFlow analysis + Ansible best practices
**Success Probability:** 90%
