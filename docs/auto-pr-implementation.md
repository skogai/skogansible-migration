# Auto-Create PRs Implementation Guide

## Overview

This document describes how to modify the Claude Code workflow to automatically create PRs when tasks are completed, instead of just providing PR creation links.

## Current Behavior

When Claude completes a task and pushes code to a branch, it provides a manual PR creation link:

```markdown
[Create a PR](https://github.com/SkogAI/github-flow/compare/master...branch-name?quick_pull=1&title=...&body=...)
```

## Desired Behavior

Claude should automatically create the PR using `gh pr create` when:
1. Tasks are completed successfully
2. Code has been pushed to a branch
3. No PR already exists for the branch

## Implementation

### Location

The change must be made in: `SkogAI/.github/.github/workflows/claude-workflow-manager.yml`

This is the centralized reusable workflow that contains the Claude Code prompt/instructions.

### Required Changes

#### 1. Modify the Claude Prompt

In the section that instructs Claude about PR creation, replace:

**OLD:**
```
- Provide a URL to create a PR manually in this format:
  [Create a PR](https://github.com/SkogAI/github-flow/compare/master...<branch-name>?quick_pull=1&title=<url-encoded-title>&body=<url-encoded-body>)
```

**NEW:**
```
- Automatically create a PR using gh pr create:
  - Check if a PR already exists for the branch: `gh pr view` (exit code 1 if none exists)
  - If no PR exists and code was pushed, create one:
    gh pr create \
      --title "Title describing changes" \
      --body "$(cat <<'EOF'
## Summary
- Brief description of changes

## Related Issue
Closes #<issue-number>

---
Generated with [Claude Code](https://claude.ai/code)
EOF
)"
  - If PR creation succeeds, include the PR URL in the final comment
  - If PR already exists, just reference it
```

#### 2. Add PR Detection Logic

Claude should check for existing PRs before creating a new one:

```bash
# Check if PR exists
if gh pr view &>/dev/null; then
  # PR already exists, get URL
  PR_URL=$(gh pr view --json url -q .url)
  echo "PR already exists: $PR_URL"
else
  # Create PR
  gh pr create --title "..." --body "..."
fi
```

#### 3. Error Handling

Handle cases where PR creation might fail:
- Branch not pushed yet
- No commits on the branch
- PR already exists
- Insufficient permissions

### Example Implementation

Here's a complete example of what Claude's final step should look like:

```bash
#!/bin/bash

# After pushing code changes...

# Check if we're on a claude/* branch
BRANCH=$(git branch --show-current)
if [[ ! $BRANCH =~ ^claude/ ]]; then
  echo "Not on a claude branch, skipping PR creation"
  exit 0
fi

# Check if PR already exists
if gh pr view &>/dev/null; then
  PR_URL=$(gh pr view --json url -q .url)
  echo "PR already exists: $PR_URL"
else
  # Extract issue number from branch name (claude/issue-123-timestamp)
  ISSUE_NUM=$(echo "$BRANCH" | sed -n 's/claude\/issue-\([0-9]*\)-.*/\1/p')

  # Get issue title for PR title
  ISSUE_TITLE=$(gh issue view "$ISSUE_NUM" --json title -q .title 2>/dev/null || echo "Updates from Claude")

  # Create PR
  PR_URL=$(gh pr create \
    --title "$ISSUE_TITLE" \
    --body "$(cat <<EOF
## Summary
Changes made by Claude Code to address issue #${ISSUE_NUM}

## Related Issue
Closes #${ISSUE_NUM}

---
Generated with [Claude Code](https://claude.ai/code)
EOF
)" \
    --json url -q .url)

  echo "Created PR: $PR_URL"
fi

# Include PR URL in final comment
echo "PR: $PR_URL" >> $GITHUB_STEP_SUMMARY
```

## Benefits

1. **Streamlined Workflow**: Users don't need to manually click and create PRs
2. **Immediate Review**: PRs are ready for review as soon as Claude finishes
3. **Consistent Format**: All Claude-created PRs follow the same structure
4. **Automatic Linking**: PRs are automatically linked to the triggering issue

## Testing

To test this implementation:

1. Create an issue with `@claude` mention
2. Let Claude make code changes
3. Verify PR is automatically created
4. Check PR title, body, and issue linking
5. Confirm subsequent runs don't create duplicate PRs

## Rollback Plan

If auto-PR creation causes issues:
1. Revert the prompt changes in the centralized workflow
2. Claude will return to providing manual PR creation links
3. Existing PRs are unaffected

## Migration

This change is backward compatible:
- Old behavior: Manual PR creation links
- New behavior: Automatic PR creation
- No breaking changes to existing workflows

## See Also

- [GitHub Flow Documentation](./GITHUB_FLOW.md)
- [Workflow Documentation](./workflows.md)
- [CLAUDE.md](../CLAUDE.md)
