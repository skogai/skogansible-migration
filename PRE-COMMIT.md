# Pre-commit Hooks Documentation

This document provides comprehensive documentation for the pre-commit hooks configured in the skogansible repository.

---

## Table of Contents

- [Quick Start](#quick-start)
- [What are Pre-commit Hooks?](#what-are-pre-commit-hooks)
- [Configured Hooks](#configured-hooks)
- [Installation](#installation)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Integration with CI](#integration-with-ci)
- [Tips and Best Practices](#tips-and-best-practices)

---

## Quick Start

**One-command setup:**
```bash
./setup-precommit.sh
```

This automated script will:
1. Check prerequisites (Python, pip, git)
2. Install pre-commit if needed
3. Install git hooks into `.git/hooks/`
4. Download and prepare hook environments
5. Display usage instructions

**Manual setup:**
```bash
# Install pre-commit
pip install pre-commit

# Install git hooks
pre-commit install

# Install hook environments (optional, they'll auto-install on first commit)
pre-commit install-hooks
```

---

## What are Pre-commit Hooks?

Pre-commit hooks are automated checks that run **before every commit** to catch issues early:

- **Faster feedback** than waiting for CI (seconds vs minutes)
- **Catch problems before they enter the repository**
- **Automatic fixes** for common issues (whitespace, line endings)
- **Consistent code quality** across the team
- **Can be bypassed** with `--no-verify` if needed

Pre-commit hooks complement (not replace) CI workflows. They provide instant local feedback while CI provides comprehensive integration testing.

---

## Configured Hooks

The repository includes **7 pre-commit hooks** configured in `.pre-commit-config.yaml`:

### 1. YAML Lint (yamllint)

**Purpose:** Validates YAML syntax and style
**Mode:** `--strict` (fails on warnings)
**Files:** All `.yaml` and `.yml` files
**Auto-fix:** No (reports issues only)

**What it checks:**
- YAML syntax errors
- Indentation consistency
- Line length limits
- Trailing spaces
- Document start markers
- Key ordering (where configured)

**Configuration:** See `.yamllint` for rules

**Example error:**
```
playbooks/site.yml
  12:3      error    wrong indentation: expected 4 but found 2  (indentation)
```

### 2. Ansible Lint (ansible-lint)

**Purpose:** Checks Ansible playbooks for best practices and potential issues
**Files:** All `.yaml` and `.yml` files
**Excludes:** `.github/`, `.direnv/`, `.cache/`, `.collections/`, `logs/`
**Auto-fix:** No (reports issues only)

**What it checks:**
- Ansible best practices
- Deprecated module usage
- Security issues (hardcoded passwords, permissions)
- Task naming conventions
- Proper use of `changed_when`, `failed_when`
- Module parameter validation

**Configuration:** See `.ansible-lint` for rules

**Example warning:**
```
playbooks/site.yml:15: [yaml] trailing spaces (trailing-spaces)
roles/01_host_info/tasks/main.yml:5: [no-changed-when] Commands should not change things if nothing needs doing
```

### 3. Ansible Syntax Check (ansible-playbook --syntax-check)

**Purpose:** Validates Ansible playbook syntax
**Target:** `playbooks/all.yml`
**Files:** Changes in `playbooks/`, `roles/`, `vars/` directories
**Auto-fix:** No (reports syntax errors only)

**What it checks:**
- YAML parsing errors in playbooks
- Invalid Ansible directives
- Module syntax errors
- Variable reference issues

**Note:** Filters out common warnings about missing collections (these are installed in CI)

**Example error:**
```
ERROR! Syntax Error while loading YAML.
  expected <block end>, but found '<block mapping start>'
```

### 4. Trailing Whitespace

**Purpose:** Removes trailing spaces from lines
**Files:** All text files
**Excludes:** `.env`
**Auto-fix:** Yes (automatically removes trailing spaces)

**Why it matters:**
- Cleaner diffs
- Prevents accidental whitespace in strings
- Consistent formatting

### 5. End of File Fixer

**Purpose:** Ensures files end with a newline
**Files:** All text files
**Excludes:** `.env`
**Auto-fix:** Yes (adds missing newline at EOF)

**Why it matters:**
- POSIX standard compliance
- Better git diffs
- Prevents issues with some tools

### 6. Check Merge Conflict Markers

**Purpose:** Detects unresolved merge conflict markers
**Files:** All text files
**Auto-fix:** No (fails if found)

**What it detects:**
```
<<<<<<< HEAD
=======
>>>>>>> branch-name
```

**Why it matters:**
- Prevents committing broken merge conflicts
- Catches forgotten conflict resolution

### 7. Mixed Line Ending Fixer

**Purpose:** Normalizes line endings to LF (Unix-style)
**Files:** All text files
**Auto-fix:** Yes (converts CRLF to LF)

**Why it matters:**
- Consistent line endings across platforms
- Prevents Windows/Unix line ending issues
- Cleaner git diffs

---

## Installation

### Prerequisites

- **Python 3.x** - Required for pre-commit framework
- **pip** - Python package manager
- **git** - Version control (initialized repository)

### Automated Installation (Recommended)

Run the setup script from the repository root:

```bash
./setup-precommit.sh
```

The script will:
1. Verify prerequisites
2. Install `pre-commit` tool
3. Install git hooks
4. Prepare hook environments
5. Show usage instructions

### Manual Installation

If you prefer manual setup:

```bash
# 1. Install pre-commit
pip install pre-commit

# 2. Install hooks into .git/hooks/
pre-commit install

# 3. (Optional) Install hook environments ahead of time
pre-commit install-hooks
```

### Verification

To verify installation:

```bash
# Check pre-commit is installed
pre-commit --version

# Check hooks are installed
ls -la .git/hooks/pre-commit

# Run hooks manually
pre-commit run --all-files
```

---

## Usage

### Automatic (Normal Workflow)

Once installed, hooks run **automatically** on every commit:

```bash
git add .
git commit -m "Your commit message"
# Hooks run automatically before commit completes
```

**First commit will be slow** (30-60 seconds) as hooks download dependencies. Subsequent commits are fast (1-5 seconds).

### Manual Runs

Run hooks manually without committing:

```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Run specific hook
pre-commit run yamllint
pre-commit run ansible-lint
pre-commit run ansible-syntax-check

# Run with verbose output
pre-commit run --verbose --all-files
```

### Bypassing Hooks

**Not recommended**, but sometimes necessary:

```bash
# Bypass all hooks
git commit --no-verify -m "Emergency fix"

# Or use the shorthand
git commit -n -m "Emergency fix"
```

**When to bypass:**
- Emergency hotfixes
- WIP commits on feature branches
- Known failing checks that will be fixed later

**Important:** Bypassed commits will still fail in CI if they don't pass checks.

---

## Troubleshooting

### Hook Failed: yamllint

**Problem:** YAML formatting issues

**Solution:**
```bash
# See specific errors
pre-commit run yamllint --all-files

# Fix common issues manually or with yamllint
yamllint --strict playbooks/site.yml
```

**Common yamllint errors:**
- `trailing-spaces` - Remove spaces at end of lines
- `indentation` - Use consistent 2-space indentation
- `line-length` - Break long lines (default: 80 chars)

### Hook Failed: ansible-lint

**Problem:** Ansible best practice violations

**Solution:**
```bash
# See specific issues
ansible-lint playbooks/site.yml

# Common fixes:
# - Add `name:` to all tasks
# - Add `changed_when: false` to read-only commands
# - Use `ansible.builtin.` prefix for core modules
```

**Common ansible-lint rules:**
- `[name]` - All tasks should have names
- `[no-changed-when]` - Commands should set `changed_when`
- `[yaml]` - YAML formatting issues

### Hook Failed: ansible-syntax-check

**Problem:** Ansible syntax errors

**Solution:**
```bash
# Run syntax check manually
ansible-playbook playbooks/all.yml --syntax-check

# Common issues:
# - Invalid YAML syntax
# - Undefined variables
# - Incorrect module parameters
```

### Hooks Not Running

**Problem:** Hooks don't execute on commit

**Solution:**
```bash
# Reinstall hooks
pre-commit uninstall
pre-commit install

# Verify installation
ls -la .git/hooks/pre-commit
```

### Slow First Commit

**Problem:** First commit takes 30-60 seconds

**Explanation:** This is normal! Pre-commit downloads and installs hook environments on first run.

**Solution:**
```bash
# Pre-install environments (optional)
pre-commit install-hooks
```

Subsequent commits will be fast (1-5 seconds).

### "command not found: pre-commit"

**Problem:** `pre-commit` not in PATH

**Solution:**
```bash
# Ensure pip install location is in PATH
export PATH="$HOME/.local/bin:$PATH"

# Or install globally (requires sudo)
sudo pip install pre-commit
```

---

## Integration with CI

Pre-commit hooks **complement** the CI workflow:

### Local (Pre-commit Hooks)
- Runs in seconds
- Catches issues before commit
- Provides instant feedback
- Can be bypassed if needed

### CI (GitHub Actions)
- Runs on every push
- Comprehensive testing
- Cannot be bypassed
- Official validation

**Workflow:**
1. Developer makes changes
2. Pre-commit hooks validate locally (instant)
3. Developer commits and pushes
4. CI runs full validation (comprehensive)
5. CI reports pass/fail status

**Best practice:** Fix issues locally (faster) before pushing to CI.

---

## Tips and Best Practices

### 1. Run Hooks Before Committing

Run hooks manually before committing large changes:

```bash
pre-commit run --all-files
```

This catches issues early before you attempt to commit.

### 2. Update Hooks Regularly

Keep pre-commit and hooks up to date:

```bash
# Update pre-commit tool
pip install --upgrade pre-commit

# Update hook repositories
pre-commit autoupdate

# Clean and reinstall
pre-commit clean
pre-commit install-hooks
```

### 3. Fix Auto-fixable Issues First

Some hooks auto-fix issues (trailing whitespace, line endings). After running hooks:

```bash
git add .  # Stage auto-fixed files
git commit -m "Your message"
```

### 4. Use Specific Hook Runs for Debugging

When debugging failures, run specific hooks:

```bash
# Test just yamllint
pre-commit run yamllint --all-files

# Test just ansible-lint on one file
ansible-lint playbooks/site.yml
```

### 5. Configure Your Editor

Configure your editor to match hook rules:
- 2-space indentation for YAML
- LF line endings
- Trim trailing whitespace on save
- Add newline at EOF

**VSCode example (`.vscode/settings.json`):**
```json
{
  "[yaml]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.eol": "\n"
  }
}
```

### 6. Understand Hook Output

Hooks show clear status:
- `Passed` ✓ - Hook succeeded
- `Failed` ✗ - Issues found
- `Skipped` - No matching files
- `Fixed` - Auto-fixed issues

### 7. Commit Message Hygiene

Even though hooks don't check commit messages, follow best practices:
- Use imperative mood ("Add feature" not "Added feature")
- Keep first line under 50 chars
- Add detailed description if needed
- Reference issue numbers

### 8. Team Consistency

Ensure all team members install hooks:

```bash
# Add to onboarding checklist
./setup-precommit.sh
```

Consider adding to README.md as required setup step.

---

## Additional Resources

- **Pre-commit framework:** https://pre-commit.com/
- **yamllint:** https://yamllint.readthedocs.io/
- **ansible-lint:** https://ansible-lint.readthedocs.io/
- **Repository CI:** `.github/workflows/test.yml`
- **Testing locally:** `./test.sh`

---

## Summary

Pre-commit hooks provide **instant feedback** on code quality:

✓ Catches issues in seconds (not minutes)
✓ Auto-fixes common problems
✓ Prevents broken commits
✓ Complements CI workflow
✓ Easy to install and use

**Get started:**
```bash
./setup-precommit.sh
```

For questions or issues, see the [Troubleshooting](#troubleshooting) section or consult the team.
