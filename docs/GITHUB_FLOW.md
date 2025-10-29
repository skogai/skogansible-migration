# GitHub Flow Guide

## What is GitHub Flow?

GitHub Flow is a lightweight, branch-based workflow designed for teams and projects that deploy regularly. It's simple, effective, and perfect for continuous deployment.

## Core Principles

1. **Anything in the `main` branch is deployable**
   - `main` is always stable and production-ready
   - Never commit directly to `main`
   - All changes go through pull requests

2. **Create descriptive branches off `main`**
   - Branch names should be descriptive: `feature/add-oauth`, `fix/memory-leak`
   - Always branch from an up-to-date `main`

3. **Commit to that branch locally and regularly push your work**
   - Commit early and often
   - Push to the remote regularly for backup and collaboration
   - Write clear commit messages

4. **Open a Pull Request at any time**
   - Don't wait until you're done - open early for feedback
   - Use PR as a conversation tool
   - Request reviews from teammates

5. **Merge only after Pull Request review**
   - Get at least one approval
   - All CI checks must pass
   - Address all review comments

6. **Deploy immediately after merge**
   - Automated deployments via GitHub Actions
   - Monitor deployment for issues
   - Quick rollback if needed

## Visual Workflow

```
main    ─────────────●─────────●──────>
                      ↖       ↙
feature/auth           ●─●─●─●
                      (PR & Merge)
```

## Detailed Workflow

### Step 1: Update Main

```bash
git checkout main
git pull origin main
```

### Step 2: Create a Branch

```bash
# For a new feature
git checkout -b feature/user-authentication

# For a bug fix
git checkout -b fix/login-redirect

# For documentation
git checkout -b docs/update-readme
```

### Step 3: Make Changes and Commit

```bash
# Make your changes
vim src/auth.py

# Stage changes
git add src/auth.py

# Commit with clear message
git commit -m "Add JWT token generation for user auth"

# Push to remote
git push -u origin feature/user-authentication
```

### Step 4: Open a Pull Request

1. Go to GitHub
2. Click "Compare & pull request"
3. Fill out the PR template:
   - What changed and why
   - How to test it
   - Any Supabase changes
   - Screenshots if UI changes

### Step 5: Discuss and Review

- Team reviews your code
- CI runs automatically (tests, linting, type checking)
- AI review provides suggestions
- Make changes based on feedback
- Push new commits (they appear in the PR automatically)

```bash
# Make requested changes
vim src/auth.py

# Commit and push
git add src/auth.py
git commit -m "Address review feedback: improve error handling"
git push
```

### Step 6: Deploy from Branch (Optional)

For this project, you can deploy from your branch to test in a staging environment:

```bash
# This can trigger a preview deployment
# (Configure in GitHub Actions as needed)
```

### Step 7: Merge

Once approved and CI passes:

1. Click "Squash and merge" (or "Merge pull request")
2. Confirm the merge
3. Delete the branch

### Step 8: Verify Deployment

- GitHub Actions automatically deploys `main`
- Supabase migrations run automatically
- Monitor logs and metrics
- If issues arise, revert the merge or push a hotfix

## Branch Naming Conventions

| Prefix     | Purpose           | Example                    |
|------------|-------------------|----------------------------|
| `feature/` | New features      | `feature/oauth-login`      |
| `fix/`     | Bug fixes         | `fix/memory-leak`          |
| `docs/`    | Documentation     | `docs/api-guide`           |
| `refactor/`| Code refactoring  | `refactor/database-layer`  |
| `test/`    | Adding tests      | `test/auth-integration`    |
| `chore/`   | Maintenance       | `chore/update-dependencies`|

## Commit Message Best Practices

### Good Examples

```
Add user authentication with JWT

- Implement token generation and validation
- Add login and logout endpoints
- Update Supabase RLS policies for auth
- Add tests for auth flows
```

```
Fix: Prevent memory leak in image processing

The PIL Image objects were not being properly closed after processing,
causing memory to accumulate over time. Added proper context managers
and explicit close() calls.

Fixes #123
```

### Poor Examples

```
fix stuff
```

```
WIP
```

```
Updated files
```

## Pull Request Best Practices

### When to Open a PR

- **Early** - As soon as you have something to show
- Use "Draft PR" if not ready for review
- Get feedback early and often

### PR Description Template

Already provided in `.github/pull_request_template.md`, but key elements:

1. **What** - What changed
2. **Why** - Why it changed
3. **How** - How to test it
4. **Impact** - What systems are affected

### PR Size

- **Prefer small PRs** - Easier to review, faster to merge
- **One logical change per PR** - Don't mix refactoring with features
- **If large, explain why** - Sometimes necessary, but document

## Handling Conflicts

```bash
# Update your branch with latest main
git checkout main
git pull origin main
git checkout feature/your-feature
git merge main

# Resolve conflicts
vim conflicted_file.py

# Mark as resolved and commit
git add conflicted_file.py
git commit -m "Merge main and resolve conflicts"
git push
```

## Emergency Hotfixes

For critical production bugs:

```bash
# Create fix branch from main
git checkout main
git pull origin main
git checkout -b fix/critical-security-issue

# Make minimal changes
# Test thoroughly
# Push and create PR

# Expedited review process
# Merge and deploy ASAP
# Consider creating post-mortem issue
```

## CI/CD Integration

This project's GitHub Actions automatically:

1. **On PR**: Run tests, linting, type checking, AI review
2. **On merge to main**: Deploy to production, run Supabase migrations
3. **On tag**: Create release, run additional deployment steps

## Tips for Success

### DO ✅

- Keep `main` always deployable
- Write descriptive PR descriptions
- Respond to review comments promptly
- Test locally before pushing
- Update documentation with code changes
- Delete branches after merging

### DON'T ❌

- Don't commit directly to `main`
- Don't leave PRs open for weeks
- Don't merge your own PRs without review
- Don't ignore CI failures
- Don't create massive PRs
- Don't force push to shared branches

## Supabase-Specific Flow

### Database Changes

1. Create migration: `./scripts/supabase-migrate.sh add_new_table`
2. Test locally: `supabase db reset`
3. Commit migration file
4. Open PR
5. On merge, GitHub Actions deploys migration

### Edge Functions

1. Develop locally: `supabase functions serve`
2. Test thoroughly
3. Commit function code
4. Open PR
5. On merge, GitHub Actions deploys function

## AI-Assisted Development

This template includes AI code review in the workflow:

- PRs automatically get AI review
- AI suggests improvements, catches bugs
- Still requires human review and approval
- Use AI for generating tests, docs, boilerplate

## Resources

- [GitHub Flow Guide](https://guides.github.com/introduction/flow/)
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [uv Documentation](https://docs.astral.sh/uv/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Questions?

Open an issue or ask in project discussions!
