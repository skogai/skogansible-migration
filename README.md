# GitHub Flow Template

A template repository for Python projects using GitHub Flow with Claude Code integration.

## Features

- **Claude Code Integration** - AI-powered workflow automation via @claude mentions
- **Auto-Merge** - Automatically merge approved PRs when CI passes
- **Python + uv** - Fast dependency management
- **Supabase Ready** - Cloud and self-hosted support
- **CLI Tools** - Command-line tools for working with Claude
- **Centralized Workflows** - Reusable workflows from SkogAI/.github

## Quick Start

### Clone and Setup

```bash
git clone <your-repo-url>
cd github-flow

# Install dependencies
uv sync --all-extras --dev

# Set up pre-commit hooks
uv run pre-commit install
```

### Using Claude

Trigger Claude Code by mentioning @claude in:
- Issues
- Pull requests
- Comments on issues/PRs

Claude will create branches, implement changes, and respond automatically.

## CLI Tools

This repository includes tools for working with Claude. See [scripts/README.md](scripts/README.md) for details.

Quick reference:
```bash
# Create issue with @claude
./scripts/claude-issue "fix the auth bug"

# Comment on existing issue
./scripts/claude-on-issue 123 "analyze this bug"

# Create PR with @claude
./scripts/claude-pr "review this refactoring"

# Comment on existing PR
./scripts/claude-on-pr 42 "check edge cases"

# View Claude activity
./scripts/claude-status

# Auto-merge approved PRs
./scripts/auto-merge
```

## Documentation

- [CLAUDE.md](CLAUDE.md) - Instructions for Claude Code sessions
- [docs/workflows.md](docs/workflows.md) - Technical workflow documentation
- [scripts/README.md](scripts/README.md) - CLI tools documentation

## How It Works

### Claude Workflow

1. Mention @claude in an issue, PR, or comment
2. `.github/workflows/claude.yml` triggers
3. Calls centralized workflow from `SkogAI/.github`
4. Claude Code executes the task
5. Creates branch `claude/issue-N-YYYYMMDD-HHMM` if needed
6. Posts results back to the issue/PR

### Auto-Merge

The repository includes an auto-merge workflow that keeps your development moving:

1. **Automatic Detection** - Runs when PRs are reviewed or CI completes
2. **Smart Checks** - Verifies:
   - ✅ PR has been approved by reviewers
   - ✅ All CI checks pass
   - ✅ No merge conflicts exist
3. **Automatic Merge** - Merges approved PRs immediately using squash merge
4. **Clean Up** - Automatically deletes merged branches

**Benefits:**
- No more idle PRs waiting for manual merge
- Reduced context switching for developers
- Faster delivery of approved changes
- Automatic cleanup of merged branches

See `.github/workflows/auto-merge.yml` for the workflow configuration.

## Repository Structure

```
.
├── .github/workflows/    # GitHub Actions workflows
├── docs/                 # Documentation
├── scripts/              # CLI tools for Claude integration
├── CLAUDE.md             # Instructions for Claude Code
└── README.md             # This file
```

## License

MIT
