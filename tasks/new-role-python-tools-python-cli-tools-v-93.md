---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/93"]
tags: ["extraction", "new-role", "from:ansible-base", "phase-1", "github"]
---

# New role: python-tools - Python CLI tools via uv

**Source**: [Github #93](https://github.com/SkogAI/skogansible/issues/93)

## Description

## Summary
Create a new `roles/python-tools/` role extracted from `ansible-base/roles/09-uv-tools/`.

## Source
- `tmp/ansible-base/roles/09-uv-tools/tasks/main.yml`
- `tmp/ansible-base/roles/09-uv-tools/defaults/main.yml`

## Features to Include
- [ ] Check if uv is installed
- [ ] Install uv via official script or pacman
- [ ] Install Python version via uv
- [ ] Install Python CLI tools via `uv tool install`
- [ ] Upgrade existing tools
- [ ] Remove unwanted tools
- [ ] Verify tool installatio

## Notes

*Imported from external tracker. See source link for full context.*
