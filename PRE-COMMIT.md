# Pre-commit Hooks Setup Guide

This repository uses [pre-commit](https://pre-commit.com/) to automatically run tests before commits, catching issues early and ensuring code quality.

## Quick Start

Run the setup script to install everything automatically:

```bash
./setup-precommit.sh
```

That's it! The hooks will now run automatically on every commit.

## What Gets Checked

Every commit automatically runs these checks:

### 1. **YAML Linting** (yamllint)
- Validates YAML syntax
- Enforces consistent formatting
- Checks for common YAML mistakes

### 2. **Ansible Linting** (ansible-lint)
- Checks Ansible best practices
- Detects security issues
- Identifies potential bugs
- Enforces Ansible coding standards

### 3. **Ansible Syntax Check**
- Validates playbook syntax
- Ensures playbooks are parseable
- Catches syntax errors before runtime

### 4. **Code Quality Checks**
- **trailing-whitespace**: Removes trailing spaces (auto-fixes)
- **end-of-file-fixer**: Ensures files end with newline (auto-fixes)
- **check-merge-conflict**: Detects merge conflict markers
- **mixed-line-ending**: Normalizes line endings to LF (auto-fixes)

## Manual Setup

If you prefer to set up manually:

```bash
# 1. Install pre-commit
pip install pre-commit

# 2. Install git hooks
pre-commit install

# 3. Install hook environments (this downloads the tools)
pre-commit install-hooks
```

## Usage

### Automatic (Default)

Hooks run automatically when you commit:

```bash
git commit -m "your message"
# Hooks run automatically before commit
```

### Manual Run

Test hooks without committing:

```bash
# Run all hooks on all files
pre-commit run --all-files

# Run all hooks on staged files only
pre-commit run

# Run a specific hook
pre-commit run yamllint
pre-commit run ansible-lint
```

### Bypass Hooks (Use Sparingly)

If you need to commit without running hooks:

```bash
git commit --no-verify -m "your message"
```

**Warning**: Only bypass hooks when absolutely necessary. The CI pipeline will still run the same checks.

## First Run

The first time you commit (or run `pre-commit run`), it will:
1. Download the hook environments
2. Install dependencies (yamllint, ansible-lint, etc.)
3. Cache everything for future runs

This takes a few minutes, but subsequent runs are fast (seconds).

## How It Works

### Official Repositories

The configuration uses official pre-commit hooks from:
- **pre-commit/pre-commit-hooks**: Standard file checks
- **adrienverge/yamllint**: YAML linting
- **ansible/ansible-lint**: Ansible best practices

These hooks automatically manage their own dependencies. You don't need to manually install `yamllint` or `ansible-lint` - pre-commit handles this.

### Hook Environments

Pre-commit creates isolated environments for each hook:
- Stored in `~/.cache/pre-commit/`
- Automatically updated when hook versions change
- Shared across all repositories using pre-commit

## Troubleshooting

### Hooks Not Running

```bash
# Check if hooks are installed
ls -la .git/hooks/pre-commit

# Reinstall if needed
pre-commit install
```

### Hook Failures

If a hook fails:

1. **Read the error message** - it tells you what's wrong and where
2. **Fix the issue** - most issues are in the changed files
3. **Run manually** to test: `pre-commit run --all-files`
4. **Commit again** once fixed

### Update Hooks

Update to the latest hook versions:

```bash
pre-commit autoupdate
```

### Clear Cache

If hooks behave strangely:

```bash
pre-commit clean
pre-commit install-hooks
```

## Integration with CI

These hooks run the same checks as the GitHub Actions CI workflow. The goal is to catch issues locally before pushing, saving CI time and providing faster feedback.

**Local checks (pre-commit)** → Fast, runs in seconds
**CI checks (GitHub Actions)** → Slower, runs in minutes

## Configuration

Hook configuration is in `.pre-commit-config.yaml`. See the [pre-commit documentation](https://pre-commit.com/) for customization options.

### Excluding Files

Some files are automatically excluded:
- `.github/` - GitHub workflow files
- `.direnv/` - direnv cache
- `.cache/` - Ansible cache
- `.collections/` - Ansible collections
- `logs/` - Log files
- `.env` - Environment variables (sensitive data)

## Tips

1. **Run hooks before committing**: `pre-commit run` to check your changes
2. **Keep hooks updated**: `pre-commit autoupdate` occasionally
3. **Don't bypass unnecessarily**: Hooks exist for a reason
4. **Fix root causes**: If you're tempted to bypass, consider fixing the issue instead

## Further Reading

- [pre-commit documentation](https://pre-commit.com/)
- [yamllint documentation](https://yamllint.readthedocs.io/)
- [ansible-lint documentation](https://ansible-lint.readthedocs.io/)
