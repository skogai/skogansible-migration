# Automation Workflow Files

This directory contains workflow YAML files that can be copied to `.github/workflows/` to enable automation features.

## ⚠️ Important Note

Due to GitHub App permissions, Claude Code cannot directly modify files in `.github/workflows/`. You'll need to manually copy these files to enable the workflows.

## Available Workflows

### 1. `lint-and-test.yml`

Runs linting and testing on PRs and pushes.

**Features:**
- Auto-detects Python and TypeScript projects
- Runs `ruff` for Python linting
- Runs `pytest` for Python tests
- Runs `tsc --noEmit` for TypeScript type checking
- Non-blocking (doesn't prevent merging)
- Comments on PRs when issues are found

**To enable:**
```bash
cp docs/workflows/lint-and-test.yml .github/workflows/
git add .github/workflows/lint-and-test.yml
git commit -m "Add lint-and-test workflow"
git push
```

**Triggers:**
- Pull requests (opened, synchronized, reopened)
- Pushes to master/main
- Pushes to claude/** branches

### 2. `check-mergeable-enhanced.yml`

Enhanced version of the existing check-mergeable workflow that calls @claude to automatically resolve conflicts.

**Features:**
- Checks all open PRs for merge conflicts
- Calls @claude to fast-forward branches behind master
- Calls @claude to resolve merge conflicts automatically
- Creates summary issues for tracking

**To enable:**

Option A - Replace existing workflow:
```bash
cp docs/workflows/check-mergeable-enhanced.yml .github/workflows/check-mergeable.yml
git add .github/workflows/check-mergeable.yml
git commit -m "Enhance check-mergeable to call @claude"
git push
```

Option B - Run alongside existing workflow:
```bash
cp docs/workflows/check-mergeable-enhanced.yml .github/workflows/check-mergeable-enhanced.yml
git add .github/workflows/check-mergeable-enhanced.yml
git commit -m "Add enhanced check-mergeable workflow"
git push
```

**Triggers:**
- Pushes to master/main

## Scripts

Both workflows call scripts in the `scripts/` directory:

- **`scripts/lint-and-test`** - Runs linting and testing
- **`scripts/check-mergeable`** - Checks PR mergeability and calls @claude

These scripts are already in the repository and executable.

## Customization

### Python Dependencies

If your project uses `uv` for dependency management, update the Python setup in `lint-and-test.yml`:

```yaml
- name: Install Python dependencies
  run: |
    pip install uv
    uv sync
    uv pip install ruff pytest
```

### Add More Checks

You can extend `scripts/lint-and-test` to include more checks:
- `mypy` for type checking
- `black` for code formatting
- `isort` for import sorting
- Custom validation scripts

### Make Workflows Blocking

To make the lint-and-test workflow block PRs from merging, remove this line from the script:

```bash
# In scripts/lint-and-test, change:
exit 0  # Always exit 0 to not block

# To:
exit $exit_code  # Exit with actual status
```

## Making Workflows Reusable

To make these workflows reusable across multiple repositories:

1. Create a repository in your organization: `SkogAI/.github`
2. Copy the workflows to `.github/workflows/` in that repo
3. Make them callable workflows by adding `workflow_call` trigger
4. Reference them from individual repos

See the existing `claude.yml` workflow for an example of calling a reusable workflow from `SkogAI/.github`.

## Testing

Test the scripts locally before deploying:

```bash
# Test linting and testing
./scripts/lint-and-test

# Test mergeable checking (requires gh CLI)
./scripts/check-mergeable
```

## Questions?

See the main [CLAUDE.md](../../CLAUDE.md) for repository guidelines and ask @claude if you need help!
