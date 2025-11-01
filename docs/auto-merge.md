# Auto-Merge Feature

## Overview

The auto-merge feature automatically merges pull requests when they meet specific conditions, keeping your development workflow moving without manual intervention.

## How It Works

### Triggers

The auto-merge workflow runs automatically when:
- A pull request receives a review (any type: approved, commented, or changes requested)
- CI check suites complete
- Status checks succeed

See `.github/workflows/auto-merge.yml` for the workflow definition.

### Conditions

A PR will be automatically merged if ALL of the following conditions are met:

1. ✅ **Approved**: The PR has been approved by at least one reviewer
2. ✅ **CI Passed**: All required CI checks have passed (or no checks are configured)
3. ✅ **No Conflicts**: The PR has no merge conflicts with the base branch

### Behavior

When all conditions are met:
- The PR is merged using **squash merge** (all commits squashed into one)
- The source branch is **automatically deleted**
- A comment is posted to the PR documenting the auto-merge
- The workflow logs detail what happened

When conditions are NOT met:
- The workflow logs why the PR wasn't merged
- No action is taken (PR remains open)
- The workflow will check again on the next trigger

## Usage

### Automatic (Recommended)

Once the workflow is enabled, it runs automatically. No manual intervention required!

1. Create a PR
2. Get it reviewed and approved
3. Ensure CI passes
4. The PR will auto-merge within seconds

### Manual Script

You can also run the auto-merge check manually:

```bash
./scripts/auto-merge
```

This is useful for:
- Testing the auto-merge logic
- Manually triggering a merge check
- Running from CI/CD pipelines

## Configuration

### Workflow File Location

`.github/workflows/auto-merge.yml`

### Customizing Merge Method

Currently uses squash merge. To change to regular merge or rebase:

```yaml
# Change this line in the workflow:
gh pr merge "$number" --squash --delete-branch --repo "${{ github.repository }}"

# To one of these:
gh pr merge "$number" --merge --delete-branch --repo "${{ github.repository }}"
gh pr merge "$number" --rebase --delete-branch --repo "${{ github.repository }}"
```

### Disabling Auto-Delete of Branches

Remove the `--delete-branch` flag from the merge command:

```yaml
gh pr merge "$number" --squash --repo "${{ github.repository }}"
```

### Required Approvals

The workflow checks for `reviewDecision = APPROVED`. This means at least one approval is required. If you need multiple approvals, configure branch protection rules in your repository settings.

## Benefits

### Faster Delivery
- PRs merge as soon as they're ready
- No waiting for a human to click the merge button
- Reduced time from approval to production

### Less Context Switching
- Developers don't need to check back to merge
- No need to remember which PRs are waiting
- Focus on coding, not on PR management

### Consistent Process
- Every PR follows the same merge process
- No human error in merging
- Automatic cleanup of branches

### Better for Remote Teams
- Works across time zones
- No delays waiting for someone to be online
- 24/7 automation

## Troubleshooting

### PR Not Auto-Merging

Check the workflow logs in GitHub Actions to see why. Common reasons:

1. **Not Approved**: Request a review and approval
2. **CI Failing**: Fix the failing tests or checks
3. **Merge Conflicts**: Sync your branch with master/main
4. **Workflow Not Triggered**: Check that the workflow triggers are correct

### Viewing Workflow Logs

1. Go to the "Actions" tab in your repository
2. Click on "Auto-Merge Approved PRs" workflow
3. View the latest run to see detailed logs

### Manual Override

If you need to merge a PR manually:

```bash
# View the PR
gh pr view <pr-number>

# Merge manually
gh pr merge <pr-number> --squash --delete-branch
```

## Examples

### Example 1: Standard Flow

```bash
# 1. Create a feature branch
git checkout -b feature/new-api

# 2. Make changes and push
git add .
git commit -m "Add new API endpoint"
git push origin feature/new-api

# 3. Create PR
gh pr create --title "Add new API endpoint" --body "Implements #123"

# 4. Request review
gh pr review <pr-number> --comment "PTAL"

# 5. Reviewer approves
# (Reviewer clicks "Approve" in GitHub UI)

# 6. CI passes
# (Automatic, GitHub Actions runs tests)

# 7. Auto-merge happens!
# (Automatic, workflow detects all conditions met)
```

### Example 2: With claude-pr Tool

```bash
# From your feature branch
git checkout feature/refactor-auth

# Create PR that mentions @claude
./scripts/claude-pr "review this auth refactoring"

# When Claude approves and CI passes, auto-merges!
```

## Security Considerations

### Permissions

The workflow requires these permissions:
- `pull-requests: write` - To merge PRs and add comments
- `contents: write` - To push merge commits
- `checks: read` - To read CI status

### Branch Protection

Consider enabling branch protection rules:
- Require pull request reviews before merging
- Require status checks to pass before merging
- Require branches to be up to date before merging

These rules work alongside auto-merge to ensure code quality.

### Review Requirements

The auto-merge workflow respects your repository's review requirements. If you've configured branch protection to require 2 reviewers, the workflow will only merge when both have approved.

## Disabling Auto-Merge

To disable auto-merge:

1. Delete or rename the workflow file:
   ```bash
   mv .github/workflows/auto-merge.yml .github/workflows/auto-merge.yml.disabled
   ```

2. Or add a condition to skip the job:
   ```yaml
   jobs:
     auto-merge:
       if: false  # Temporarily disable
       runs-on: ubuntu-latest
   ```

## Related Tools

- **check-mergeable**: Checks PR mergeability and reports conflicts
- **auto-create-pr**: Automatically creates PRs for claude/ branches
- **claude-pr**: Creates PRs with @claude mentions

## FAQs

### Q: Will it merge PRs that are in draft?

A: No, draft PRs are not considered for auto-merge.

### Q: What if CI is still running?

A: The workflow will not merge until CI completes. If checks are pending, it waits.

### Q: Can I exclude certain PRs from auto-merge?

A: Yes, use a label-based condition. Add this to the workflow:

```yaml
if: "!contains(github.event.pull_request.labels.*.name, 'no-auto-merge')"
```

### Q: Does it work with external CI systems?

A: Yes, as long as the CI system reports status back to GitHub via status checks or check suites.

### Q: What happens if two PRs are ready at the same time?

A: They will be merged sequentially. The workflow processes one PR at a time to avoid race conditions.

## Summary

The auto-merge feature:
- ✅ Automatically merges approved PRs when CI passes
- ✅ Reduces manual work and context switching
- ✅ Prevents PRs from sitting idle
- ✅ Works 24/7 across time zones
- ✅ Respects branch protection rules
- ✅ Can be run manually or automatically

It's a key part of keeping your GitHub Flow moving smoothly!
