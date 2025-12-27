#!/usr/bin/env bash

claude --setting-sources "project,local" --settings /home/skogix/dev/marketplace/.claude/settings.json --no-chrome --plugin-dir /home/skogix/.ansible/.claude/skills/ansible-core /home/skogix/dev/marketplace/.claude/skills/skogai-docs /home/skogix/dev/marketplace/.claude/skills/skogai-git-worktree /home/skogix/dev/marketplace/.claude/skills/skogai-skill-creator /home/skogix/dev/marketplace/.claude/skills/skogai-skills /home/skogix/dev/marketplace/.claude/skills/skogai-todos /home/skogix/dev/marketplace/.claude/skills/skogai-worktrunk "$@"
