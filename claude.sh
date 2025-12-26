#!/usr/bin/env bash

claude --setting-sources "project,local" --settings /home/skogix/dev/marketplace/.claude/settings.json --no-chrome --plugin-dir /home/skogix/.ansible/.claude/skills/ansible-core /home/skogix/.ansible/.claude/skills/using-git-worktrees/
