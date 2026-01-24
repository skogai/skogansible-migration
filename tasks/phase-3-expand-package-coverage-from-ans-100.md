---
state: new
created: 2026-01-24
tracking: ["https://github.com/SkogAI/skogansible/issues/100"]
tags: ["extraction", "phase-3", "from:ansible-base", "github"]
---

# Phase 3: Expand package coverage from ansible-base

**Source**: [Github #100](https://github.com/SkogAI/skogansible/issues/100)

## Description

## Overview
Expand package lists from current 61 packages to include valuable packages from ansible-base (477 packages total).

## Current State
- `vars/packages.yml`: 61 packages
- `vars/packages.yml` (aur): 7 AUR packages

## Source Analysis Needed
- `tmp/ansible-base/group_vars/all.yml` - Package lists
- Review and categorize packages
- Identify duplicates and conflicts

## Acceptance Criteria
- [ ] Audit ansible-base package lists
- [ ] Categorize packages (essential, development, optional)


## Notes

*Imported from external tracker. See source link for full context.*
