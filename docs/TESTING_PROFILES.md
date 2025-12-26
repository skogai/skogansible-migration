# Testing Profile Combinations

This guide provides comprehensive testing procedures for the composition layer and profile-based role orchestration.

## Overview

The composition layer supports four machine profiles:
- **workstation** - Full desktop with GUI and development tools
- **laptop** - Portable with battery optimization
- **server** - Headless with service focus
- **wsl** - Windows Subsystem for Linux

Each profile includes different roles and configurations, so thorough testing is essential.

## Prerequisites

Before testing, ensure:

1. **Git worktree** for isolated testing:
   ```bash
   wt switch --create --base master test-profiles
   ```

2. **Inventory file** configured:
   ```bash
   cat .inventory
   # Should show: localhost ansible_connection=local
   ```

3. **Variables configured** in `vars/` directory:
   ```bash
   ls vars/*.yml
   # Verify all required var files exist
   ```

4. **Ansible installed** and venv activated:
   ```bash
   source .venv/bin/activate
   ansible --version
   ```

## Test Categories

### 1. Syntax Validation

Verify all playbooks have valid Ansible syntax:

```bash
# Test site.yml
ansible-playbook playbooks/site.yml --syntax-check

# Test all profile playbooks
for profile in workstation laptop server wsl; do
  echo "Testing $profile..."
  ansible-playbook playbooks/$profile.yml --syntax-check
done

# Test utility playbooks
ansible-playbook playbooks/bootstrap.yml --syntax-check
ansible-playbook playbooks/maintenance.yml --syntax-check
ansible-playbook playbooks/default.yml --syntax-check
```

**Expected:** All should pass without errors.

---

### 2. Dry-Run Tests

Execute playbooks in check mode (no changes applied):

```bash
# Test workstation profile
ansible-playbook playbooks/workstation.yml --check

# Test laptop profile
ansible-playbook playbooks/laptop.yml --check

# Test server profile
ansible-playbook playbooks/server.yml --check

# Test WSL profile
ansible-playbook playbooks/wsl.yml --check

# Test site.yml with different machine types
ansible-playbook playbooks/site.yml --check --extra-vars "machine_type=laptop"
ansible-playbook playbooks/site.yml --check --extra-vars "machine_type=server"
```

**Expected:** All should complete without errors. Review output for:
- Correct roles included/skipped
- Conditional logic working correctly
- No syntax or variable errors

---

### 3. Task Listing

Verify which tasks would run for each profile:

```bash
# List all tasks for workstation
ansible-playbook playbooks/workstation.yml --list-tasks

# List all tasks for laptop
ansible-playbook playbooks/laptop.yml --list-tasks

# List all tasks for server
ansible-playbook playbooks/server.yml --list-tasks

# List all tasks for WSL
ansible-playbook playbooks/wsl.yml --list-tasks
```

**Expected:** Different task lists based on profile. Verify:
- GUI roles appear only on workstation/laptop
- cloudflared appears on workstation/server (not laptop/WSL by default)
- All profiles include base roles (packages, ssh, git)

---

### 4. Tag Testing

Verify hierarchical tag structure works:

```bash
# Test base tag (should include packages + ssh)
ansible-playbook playbooks/site.yml --tags base --list-tasks

# Test profile tags
ansible-playbook playbooks/site.yml --tags workstation --list-tasks
ansible-playbook playbooks/site.yml --tags laptop --list-tasks
ansible-playbook playbooks/site.yml --tags server --list-tasks

# Test category tags
ansible-playbook playbooks/site.yml --tags vcs --list-tasks
ansible-playbook playbooks/site.yml --tags dotfiles --list-tasks
ansible-playbook playbooks/site.yml --tags shell --list-tasks
ansible-playbook playbooks/site.yml --tags services --list-tasks

# Test role-specific tags
ansible-playbook playbooks/site.yml --tags git --list-tasks
ansible-playbook playbooks/site.yml --tags chezmoi --list-tasks
ansible-playbook playbooks/site.yml --tags zsh --list-tasks

# Test tag combinations
ansible-playbook playbooks/site.yml --tags base,shell --list-tasks
ansible-playbook playbooks/site.yml --tags vcs,dotfiles --list-tasks
```

**Expected:** Tag filtering works correctly at all hierarchy levels.

---

### 5. Conditional Inclusion Tests

Verify roles are conditionally included based on machine type:

```bash
# cloudflared should be included on workstation/server
ansible-playbook playbooks/site.yml --extra-vars "machine_type=workstation" --list-tasks | grep cloudflared
ansible-playbook playbooks/site.yml --extra-vars "machine_type=server" --list-tasks | grep cloudflared

# cloudflared should NOT be included on laptop/WSL (by default)
ansible-playbook playbooks/site.yml --extra-vars "machine_type=laptop" --list-tasks | grep cloudflared || echo "Correctly skipped"
ansible-playbook playbooks/site.yml --extra-vars "machine_type=wsl" --list-tasks | grep cloudflared || echo "Correctly skipped"

# filesystems should be conditional on data existence
ansible-playbook playbooks/site.yml --extra-vars "machine_type=workstation" --list-tasks | grep filesystems
ansible-playbook playbooks/site.yml --extra-vars "machine_type=server filesystems_mounts=[]" --check
```

**Expected:** Conditional logic correctly includes/excludes roles.

---

### 6. Dependency Resolution

Verify role dependencies are resolved correctly:

```bash
# chezmoi depends on git - git should run first
ansible-playbook playbooks/site.yml --list-tasks | grep -E "(git|chezmoi)" | head -20

# Verify order: git tasks before chezmoi tasks
ansible-playbook playbooks/site.yml --check -vv 2>&1 | grep -E "TASK.*git|TASK.*chezmoi"
```

**Expected:** Git role executes before chezmoi role due to dependency declaration.

---

### 7. Profile-Specific Variable Overrides

Verify profile-specific variables are applied:

```bash
# Laptop should override machine_type and enable laptop_mode
ansible-playbook playbooks/laptop.yml --check -vv 2>&1 | grep "chezmoi_laptop_mode.*true"

# Server should set headless and disable GUI
ansible-playbook playbooks/server.yml --check -vv 2>&1 | grep "chezmoi_headless.*true"

# WSL should set headless and disable GUI
ansible-playbook playbooks/wsl.yml --check -vv 2>&1 | grep "chezmoi_headless.*true"
```

**Expected:** Profile-specific variables override defaults correctly.

---

## Profile-Specific Test Checklists

### Workstation Profile

Run: `ansible-playbook playbooks/workstation.yml --check`

Verify:
- [ ] All base roles included (packages, ssh)
- [ ] Version control roles included (git)
- [ ] Dotfiles roles included (chezmoi, zsh)
- [ ] Service roles included (cloudflared, filesystems)
- [ ] Machine type set to 'workstation'
- [ ] GUI features enabled
- [ ] Window manager configured (i3/sway)

---

### Laptop Profile

Run: `ansible-playbook playbooks/laptop.yml --check`

Verify:
- [ ] All base roles included (packages, ssh)
- [ ] Version control roles included (git)
- [ ] Dotfiles roles included (chezmoi, zsh)
- [ ] Machine type set to 'laptop'
- [ ] Laptop mode enabled (`chezmoi_laptop_mode: true`)
- [ ] Window manager set to 'sway' for battery optimization
- [ ] cloudflared NOT included by default
- [ ] filesystems NOT included by default

---

### Server Profile

Run: `ansible-playbook playbooks/server.yml --check`

Verify:
- [ ] All base roles included (packages, ssh)
- [ ] Version control roles included (git - minimal)
- [ ] Service roles included (cloudflared, filesystems)
- [ ] Machine type set to 'server'
- [ ] Headless mode enabled (`chezmoi_headless: true`)
- [ ] GUI disabled (`chezmoi_gui: false`)
- [ ] Window manager set to 'none'
- [ ] SSH hardening enabled
- [ ] No GUI packages installed

---

### WSL Profile

Run: `ansible-playbook playbooks/wsl.yml --check`

Verify:
- [ ] All base roles included (packages, ssh)
- [ ] Version control roles included (git)
- [ ] Dotfiles roles included (chezmoi, zsh)
- [ ] Machine type set to 'wsl'
- [ ] Headless mode enabled
- [ ] GUI disabled
- [ ] Window manager set to 'none'
- [ ] CLI-only packages
- [ ] No systemd services configured

---

## Regression Testing

After making changes to composition layer, run full regression test:

```bash
#!/bin/bash
# regression-test.sh

echo "=== Syntax Validation ==="
for playbook in site workstation laptop server wsl bootstrap maintenance default; do
  echo "Testing playbooks/$playbook.yml..."
  ansible-playbook playbooks/$playbook.yml --syntax-check || exit 1
done

echo -e "\n=== Dry-Run Tests ==="
for profile in workstation laptop server wsl; do
  echo "Testing $profile profile..."
  ansible-playbook playbooks/$profile.yml --check || exit 1
done

echo -e "\n=== Tag Tests ==="
for tag in base vcs dotfiles shell services; do
  echo "Testing tag: $tag..."
  ansible-playbook playbooks/site.yml --tags $tag --list-tasks > /dev/null || exit 1
done

echo -e "\n=== Profile Tag Tests ==="
for profile in workstation laptop server wsl; do
  echo "Testing profile tag: $profile..."
  ansible-playbook playbooks/site.yml --tags $profile --list-tasks > /dev/null || exit 1
done

echo -e "\n=== All tests passed! ==="
```

Save as `.github/scripts/test-composition.sh` and run:
```bash
chmod +x .github/scripts/test-composition.sh
.github/scripts/test-composition.sh
```

---

## Integration Testing

For complete integration testing on actual systems:

### Test Environment Setup

1. **Use Docker containers** for isolated testing:
   ```bash
   # Run Arch Linux container
   docker run -it --rm -v $(pwd):/ansible archlinux:latest bash

   # Inside container
   pacman -Sy ansible git python --noconfirm
   cd /ansible
   ansible-playbook playbooks/workstation.yml --check
   ```

2. **Use VM snapshots** for rollback:
   ```bash
   # Take snapshot before testing
   virsh snapshot-create-as myvm test-composition

   # Test playbook
   ansible-playbook playbooks/workstation.yml

   # Revert if needed
   virsh snapshot-revert myvm test-composition
   ```

3. **Use git worktrees** for parallel testing:
   ```bash
   # Create test worktree
   wt switch --create --base master test-laptop-profile

   # Test in isolation
   ansible-playbook playbooks/laptop.yml --check

   # Merge if successful
   wt merge
   ```

---

## Troubleshooting

### Role Not Included

**Symptom:** Expected role doesn't execute

**Debug:**
```bash
# Check conditional logic
ansible-playbook playbooks/site.yml --list-tasks -vv

# Check variable values
ansible-playbook playbooks/site.yml --check -vv 2>&1 | grep machine_type
```

**Fix:** Verify `when` conditions and variable values in playbook.

---

### Dependency Not Resolved

**Symptom:** Role executes before dependency

**Debug:**
```bash
# Check meta/main.yml
cat roles/chezmoi/meta/main.yml

# Verify execution order
ansible-playbook playbooks/site.yml --list-tasks | grep -E "(git|chezmoi)"
```

**Fix:** Add dependency to role's `meta/main.yml`.

---

### Tag Not Working

**Symptom:** Tag filtering doesn't work as expected

**Debug:**
```bash
# List all tags
ansible-playbook playbooks/site.yml --list-tags

# List tasks for specific tag
ansible-playbook playbooks/site.yml --tags your_tag --list-tasks
```

**Fix:** Verify tag is defined in playbook for role. Check tag hierarchy.

---

## Continuous Integration

Add to `.github/workflows/test.yml`:

```yaml
name: Test Composition Layer

on:
  pull_request:
    paths:
      - 'playbooks/**'
      - 'roles/**/meta/main.yml'
      - 'vars/**'

jobs:
  test-composition:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        profile: [workstation, laptop, server, wsl]

    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install Ansible
        run: |
          python -m pip install --upgrade pip
          pip install ansible

      - name: Syntax check
        run: ansible-playbook playbooks/${{ matrix.profile }}.yml --syntax-check

      - name: Dry run
        run: ansible-playbook playbooks/${{ matrix.profile }}.yml --check
```

---

## Test Results Documentation

Document test results:

```markdown
# Test Results - [Date]

## Profile: workstation
- Syntax check: ✅ Passed
- Dry run: ✅ Passed
- Tag tests: ✅ Passed
- Conditional inclusion: ✅ Passed

## Profile: laptop
- Syntax check: ✅ Passed
- Dry run: ✅ Passed
- Tag tests: ✅ Passed
- Conditional inclusion: ✅ Passed

...
```

---

## Next Steps

After successful testing:

1. ✅ All syntax checks pass
2. ✅ All dry-runs complete without errors
3. ✅ Tag filtering works correctly
4. ✅ Conditional inclusion behaves as expected
5. ✅ Profile-specific variables applied correctly
6. → Merge changes to main branch
7. → Update CLAUDE.md with composition layer info
8. → Document any discovered edge cases

---

**Last Updated:** 2025-12-26
**Maintainer:** SkogAI/skogansible
