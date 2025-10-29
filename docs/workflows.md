# GitHub Workflows Documentation

## Overview

This repository uses a centralized GitHub Actions workflow pattern for Claude Code integration. Instead of maintaining complex workflow logic in each repository, we use a reusable workflow stored in the organization's `.github` repository.

## Current Workflow Setup

### File: `.github/workflows/claude.yml`

This workflow triggers Claude Code on `@claude` mentions across issues and pull requests.

**Triggers:**
- `issue_comment` - When someone comments on an issue
- `pull_request_review_comment` - When someone comments on a PR review
- `issues` - When an issue is opened or assigned
- `pull_request_review` - When a PR review is submitted

**Conditional Execution:**
The workflow only runs if the comment/body/title contains `@claude`:
```yaml
if: |
  (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
  (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
  (github.event_name == 'pull_request_review' && contains(github.event.review.body, '@claude')) ||
  (github.event_name == 'issues' && (contains(github.event.issue.body, '@claude') || contains(github.event.issue.title, '@claude')))
```

## Reusable Workflow

**Source:** `SkogAI/.github/.github/workflows/claude-workflow-manager.yml@master`

This is the centralized workflow manager that contains all the Claude Code logic. By using a reusable workflow:
- Logic is maintained in one place
- Updates automatically apply to all repos using it
- Individual repos stay simple and clean
- Consistency across all SkogAI projects

## Secrets

### Required Secrets

**`CLAUDE_CODE_OAUTH_TOKEN`**
- **Type:** Organization secret
- **Purpose:** Authenticates Claude Code with GitHub
- **Set at:** Organization level (SkogAI)
- **Access:** Available to all repositories
- **Usage:** Passed to the reusable workflow

### Secret Management

Secrets are managed at the organization level:
```bash
# View org secrets
gh secret list --org SkogAI
```

**Do NOT use:**
- `GH_TOKEN` - Not required for this workflow
- Repository-level secrets - Use org-level instead

## How It Works

1. **User mentions @claude** in an issue, PR, or comment
2. **GitHub triggers** the workflow based on the event type
3. **Conditional check** verifies `@claude` is present
4. **Reusable workflow called** from `SkogAI/.github`
5. **Claude Code executes** the requested task
6. **Branch created** (if needed) following pattern: `claude/issue-N-YYYYMMDD-HHMM`
7. **Response posted** back to the issue/PR with results

## Expected Behavior

### On Success
- Claude Code responds with a comment on the issue/PR
- Includes task completion status
- Links to created branch (if applicable)
- Links to workflow run

### Example Response
```markdown
**Claude finished @username's task** —— [View job](link)

---
### Task: Say hello world

- [x] Check for repository setup instructions (CLAUDE.md)
- [x] Say hello world

Hello world! 👋

---
[Job run](link) | [Branch](link)
```

## Branches Created by Claude

Claude Code creates branches following this pattern:
- `claude/issue-<number>-<timestamp>`
- Example: `claude/issue-2-20251009-0329`

These branches are automatically created when Claude makes code changes.

## Testing the Workflow

### Test with an Issue
```bash
gh issue create --title "Test" --body "@claude say hello world"
```

### Test with a Comment
```bash
gh issue comment <issue-number> --body "@claude describe what you see"
```

### Test with a PR
```bash
gh pr create --title "Test" --body "@claude review this change"
```

## Monitoring

### View Recent Runs
```bash
gh run list --repo SkogAI/github-flow --limit 10
```

### View Specific Run
```bash
gh run view <run-id>
```

### View Run Logs
```bash
gh run view <run-id> --log
```

## Common Issues

### Workflow doesn't trigger
- Verify `@claude` is mentioned in the body/comment
- Check that the workflow file is on the main/master branch
- Ensure the reusable workflow path is correct

### Authentication failures
- Verify `CLAUDE_CODE_OAUTH_TOKEN` is set at org level
- Check secret is accessible to the repository
- Don't include `GH_TOKEN` (not needed)

### Startup failures
- Usually means a missing or incorrect secret
- Check the workflow logs for specific error
- Verify the reusable workflow exists at the specified path

## Future Enhancements

Planned workflow improvements:
- Auto-sync branches when main changes
- AI coordination for multiple concurrent branches
- Automated conflict detection and resolution
- Branch cleanup automation

## References

- Reusable workflows: `SkogAI/.github`
- Claude Code documentation: https://docs.claude.com/en/docs/claude-code
- GitHub Actions: https://docs.github.com/en/actions
